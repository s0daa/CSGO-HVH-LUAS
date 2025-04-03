-- SOLAR.TECH [STABLE BUILD]

local animation, aa_init, crosshair, feature, localplayer_info, renders, cfg, corner, dynamic, logs, ents, buff, vmt_hook, hooked_function, ground_ticks, end_time, lagcomp = { data = {} }, {}, {}, {}, { real_yaw = 0, fps_saver = false, side = 0, inverter = false, viewmodel_x, viewmodel_y, viewmodel_z, viewmodel_fov }, {}, {}, { Data = {} }, {}, {}, {}, { free = {} }, { hooks = {} }, nil, 1, 0, { r = 142, g = 165, b = 255, a = 0, positions = {}, lc = false}

local requires = { ffi.load 'UrlMon', ffi.load 'WinInet', require('neverlose/clipboard'), require('neverlose/base64'), require('neverlose/gradient') }
local var = { 
    in_air = 0, 
    plr_state = 1, 
    player_states = {'AEROBIC+', 'AEROBIC', 'SLOWING', 'CROUCHING', 'STANDING', 'MOVING'},
    shots = 0,
    aa_dir = 0,
    textsize = 0
}

local lua = { 
    username = common.get_username(),
    version = 'source',
    debug = false
}

ffi.cdef[[
   
    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;
 
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    typedef struct
    {
        char    pad0[0x60];
        void* pEntity;
        void* pActiveWeapon;
        void* pLastActiveWeapon;
        float        flLastUpdateTime;
        int            iLastUpdateFrame;
        float        flLastUpdateIncrement;
        float        flEyeYaw;
        float        flEyePitch;
        float        flGoalFeetYaw;
        float        flLastFeetYaw;
        float        flMoveYaw;
        float        flLastMoveYaw;
        float        flLeanAmount;
        char         pad1[0x4];
        float        flFeetCycle;
        float        flMoveWeight;
        float        flMoveWeightSmoothed;
        float        flDuckAmount;
        float        flHitGroundCycle;
        float        flRecrouchWeight;
        Vector_t        vecOrigin;
        Vector_t        vecLastOrigin;
        Vector_t        vecVelocity;
        Vector_t        vecVelocityNormalized;
        Vector_t        vecVelocityNormalizedNonZero;
        float        flVelocityLenght2D;
        float        flJumpFallVelocity;
        float        flSpeedNormalized;
        float        flRunningSpeed;
        float        flDuckingSpeed;
        float        flDurationMoving;
        float        flDurationStill;
        bool        bOnGround;
        bool        bHitGroundAnimation;
        char    pad2[0x2];
        float        flNextLowerBodyYawUpdateTime;
        float        flDurationInAir;
        float        flLeftGroundHeight;
        float        flHitGroundWeight;
        float        flWalkToRunTransition;
        char    pad3[0x4];
        float        flAffectedFraction;
        char    pad4[0x208];
        float        flMinBodyYaw;
        float        flMaxBodyYaw;
        float        flMinPitch;
        float        flMaxPitch;
        int            iAnimsetVersion;
    } CCSGOPlayerAnimationState_534535_t;
]]

local combo = { menu_states = {'CA', 'A', 'SW', 'C', 'S', 'R', 'U'}, menu_states_full = { 'Crouching Air', 'Airing', 'Slowwalking', 'Crouching', 'Standing', 'Running'} }
local funcs = {

    fonts = {
        feature = render.load_font('Calibri', vector(24, 24, 0), 'ba'),
        legacy = render.load_font('Verdana', 25, 'bad'),
        --skeet_bold = render.load_font('Verdana', vector(10.6, 11), 'bad'),
        skeet_bold = render.load_font('Verdana', 10, 'abd'),
        arrows = render.load_font('Verdana', 24, 'ba'),
        arrowssecond = render.load_font('Verdana', 19, 'bad'),
        teamskeetarrows = render.load_font('Verdana', 21, 'a')
    },

    allowed_wpns = {
        [38] = true,
        [11] = true
    },

    hitgroups = {
        [0] = 'generic',
        'head', 'chest', 'stomach',
        'left arm', 'right arm',
        'left leg', 'right leg',
        'neck', 'generic', 'gear'
    },

    reasons = {
        ['correction'] = 'resolver',
        ['misprediction'] = 'resolver',
        ['spread'] = 'spread',
        ['prediction error'] = 'prediction error',
        ['lagcomp failure'] = 'prediction error',
        ['unregistered shot'] = 'unregistered shot',
        ['player death'] = 'player death',
        ['death'] = 'death'
    },

    reason_index = {
        ['correction'] = 1,
        ['misprediction'] = 1,
        ['spread'] = 2,
        ['prediction error'] = 4,
        ['lagcomp failure'] = 4,
        ['unregistered shot'] = 3,
        ['player death'] = 1,
        ['death'] = 1
    },

    killsays = {
        "resolver overclocker ++ (bassn method :muscle:)", "��CFG by KuCJloTa��", "C͜͡n͜͡u͜͡ H͜͡a͜͡x͜͡y͜͡u͜͡", "с⃞п⃞и⃞ ш⃞л⃞ю⃞х⃞а⃞", "спи шлюха", "ебу тебя по крайней мере", "найс упал хуесос",
        "1 спи долбаеб", "в ебыч хуйсос", "beta.unmatched.gg/user/88979 - teddy", "на взлет ты пошел да сыншлюхи", "хахах просто легкий пидорас", "мозг жок?", "спи хуеглот без скита",
        "sirgayz0rhack.pw", "ирина салтыкова нижняя елда", "allah headshot", "SOLAR.LUA Loading… █▒▒▒▒▒▒▒▒▒ 10% ███▒▒▒▒▒▒▒ 30% █████▒▒▒▒▒ 50% ███████▒▒▒ 100%", "на завод иди", "ХАХАХАХАХХАХАХХАХАХА",
        "сорри что трешкал у меня сгорело просто :D", "| Welcome to SOLARTECH |", "beta.unmatched.gg/user/88046 - rose", "▄ ▀▄ ▀▄ ▀▄ НА ТАКСИ ТЕБЯ СБИЛ ЕПТА ХАХА", "f[etnm rfr ns clj[ nfr", "ахуеть как ты сдох так",
        "€6@L TBO|-O ᛖ@Ťѣ √ թΘТ", "new round = old mistake.", "МАТУХУ ТВОЮ НА ТАКСИ СБИЛ АХАХАХАХ", "пончик ебаный я твоей маме колени выбил битой", "глотни коки яки хуйсоска", "не заебало в лоутабе сидеть?", "отдыхай долбаеб",
        "спи хуйсоска)", "спи нахуй пидораска", "АХХАХА МАТЬ ЕБАЛ ТВОЮ СЫН ШЛЮХИ", "+rep 🅻 🅴 🅶 🅸 🆃 💥", "хахах ебать ты тупой", "спи сосешь", "ты из-за квадратного монитора меня не увидел или просто слепой долбае?",
        "ALLAH DİYEN ŞOK POŞETİ | KEYDROP", "ты че пидорас в светлое будущее попрыгал что-ли?", "ХАХАХА ЧЕ ТЫ ТАМ ВРЕДИТЕЛЬ АХАХАХ СПОТИФАЙ ХАХА Х", "клавиша залипла?", "тебе на комп скинуться?", "кфг исуе?", 
        "ээ итын бала жок котакбасын бл ***. Туры эн магды салтыды", "СПОТЛАЙТ СПОТЛАЙТ АХАХА СПИНОЙ ПИДОРАСА УБИВАЮ ХАХА", "АХХАХА ПИДОРАС ТЫ ЧЕ ТУПОЙ ТО ТАКОЙ", "най чит чел..", "моросняк ебаный", "ээ котакбас сука", 
        "Ам сатып жатырсын ба", "я бы на твоем месте после этой хуйни вышел бы", "у тебя аксидтеч? тогда понятно почему ты такой хуевый", "Бунын аты котакбас", "cпи хуесос тупой", "спи хуеглот", "OPERHVH $ SOLARCORD TEAM", 
        "Ｌｉｎｋ ｍａｉｎ ｂｅｆｏｒｅ ｓｐｅａｋｉｎｇ ♛", "тебе кабель там грызут?", "мама чай пить зовет", "как же жаль что мне играть 10 минут осталось", "нормас после сотрясухи реабилитируюсь", "моё кд больше твоего роста пидорас",
        "иди на хуй бот ебанный спи нахуй", "куда ты нахуй там пошла", "тупой долбоёб иди на хуй отсюда мать ебал", "ТЫ ЧЕ ТАМ НА ХУЙ НА ВАНВЕЕ СДОХ ТО СУЧКА ЕБАННАЯ БЛЯТЬ", "nice dead dog", "что делаешь хуесос?",
        "изи", "ммовский хуесос ты для чего на паблик зашел, заблудился чтоли?", "спи нахуй пидораска)", "▼- стрелочка вниз - ДАДАДА ИМЕННО В ТОМ МЕСТЕ ТВОЯ МАТЬ У МЕНЯ ОТРАБАТЫВАЕТ", "XAXAXAX WEAK RAT DONT TRY KILL 𝐁𝐎𝐒𝐒",
        "-𝚛𝚎𝚙 0 𝚒𝚚", "๑۩۞۩๑√ОТЛЕТАЙ НУБЯРА√๑۩۞۩๑", "ЗНẪЙ СВОЁ ḾḜḈТО НИЧТОЖḜСТВØ", "†ПоКоЙсЯ(ٿ)с(ٿ)Миром†", "я играю с конфигом от pytbylev (◣_◢)", "weAK RATS CANT KILL BO$$ ♛♛♛♛♛♛♛♛♛♛", "тапочек хвх это ты?",
        "₽вȁл гȫρтăнь Ŧвȫей ʍа₮еᎵน", "Аллах бабах чурки", "memesense --> раздача аккаунтов", "ало пидорас ебаный молчишь потому что ебу твой рот", "АХМАТ СИЛА Алла́ху А́кбар ЛЕТИ", "SOLAR TECH。 技术多功能LUA脚本", "SOLAR.LUA Loading… █▒▒▒▒▒▒▒▒▒ 10% ███▒▒▒▒▒▒▒ 30% █████▒▒▒▒▒ 50% ███████▒▒▒ 100%", "| Welcome to SOLARTECH |", "сасешь без соляры мне ору",
        "OPERHVH $ SOLARCORD TEAM", "SOLAR TECH。 技术多功能LUA脚本", "епу тебя с солярой рял", "а это солар луа так бустит сорь", "на на на сука солар луа дает по СЧАМ =D",
        "отсасываешь щас мне без солар луа", "XD ЕТОЛ Я ТАК С СОЛЯРОЙ ЕBASHY)", "поной щас долбаеб, не я же с пастами играю", "хуянгелвигс или как там? так знай они за мной дожрали",
        "твой хуеси смог мне отсосать, впрочем ты от него не отличаешься", "ну да ну да в хуй поной мне с луашкой легитерской", "у тебя семирейдж настройка и ты поэтому такой хуевый"
    },
    
    deathsays = {
        "Ты как убил меня?", "?", "да каааааак", "БЛЯ КАК", "cerf t,fyfz", "ну везет же", "найс везет хуесос", "ХАХАХАХА ДАУН КАК ТЫ УБИВАЕШЬ МЕНЯ В ЛОУДЕЛЬТУ", "пидор дырявый", 
        "залупой зубы бы тебе выбил гандон", "ПИДОАРС БЛЯЯЯЯ", "ахах чел ты меня убиваешь онли по ногам и то когда я лоу хп", "LUCKBOOST.CFG <-- UR CFG RN ",
        "ASDJASDHUIASOGHDAIHaIHSDIOADHAIDHASDIHIuh--[oDAHSDOIasD", "ты такой конченый блять", "cerf", "нахера ты летишь на меня тупой фывфыгвпфнвфнгвпфыгнвпфыгшнвпфнгв", 
        "у меня же десинк 40 градусов каааааак", "как ты своим вейви мой скит убил", "тупой хуесос без скита", "почему тебе можно просто лететь на меня и делать хуйню а мне нельззщя",
        "ААААААААААААААААААААААААААААААААААААААААА", "что ты делаешь даун", "миндамаг не выбил", "найс с дамагом хуесос", "даблтап забыл отжать бля", "КАК В ХАЙДШОТСЫ СУКА", 
        "ну зачем с фейклагами то", "глянь что долбаёб с никсваром делает", "Я СКОРО КОМП НАХУЙ СЛОМАЮ СУКА", "мышка лагает пиздец", "клавиша отпала", "да как с этим говном играть", "что за чит у тебя?", 
        "ljk,ft, t,fysq cerf", "сука пробел залип", "cerf ghj,tk pfkbg", "блять у меня ошибка вылезла", "что за хуйня у меня просто монитор погас", "СУКА Я ЧАЙ ПРОЛИЛ НА КЛАВУ"
    },

    upper_to_lower = function(str)
        str1 = string.sub(str, 2, #str)
        str2 = string.sub(str, 1, 1)
        return str2:upper() .. str1:lower()
    end,

    text_gr = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
        local len = #text - 1
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
        for i = 1, len + 1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
        return output
    end,

    calcdist = function(pos1, pos2)
        local lx = pos1.x
        local ly = pos1.y
        local lz = pos1.z
        local tx = pos2.x
        local ty = pos2.y
        local tz = pos2.z
        local dx = lx - tx
        local dy = ly - ty
        local dz = lz - tz
        return math.sqrt(dx * dx + dy * dy + dz * dz);
    end,

    lerp = function(time, a, b)
        return a * (1 - time) + b * time
    end,

    getbinds = function()
        local binds = {}
        local cheatbinds = ui.get_binds()
        
        for i = 1, #cheatbinds do
            table.insert(binds, 1, cheatbinds[i])
        end
        
        return binds
    end,

    get_spectators = function(player)
        local buffer = {}
        
        local players = player:get_spectators()
        for tbl_idx, player_pointer in pairs(players) do
            if player_pointer:get_index() ~= player:get_index() then
                if not player_pointer:is_alive() then
                    local player_info = player_pointer:get_player_info()

                    table.insert(buffer, 1, {
                        ['id'] = player_info.steamid,
                        ['id64'] = player_info.steamid64,
                        ['name'] = player_pointer:get_name(),
                        ['avatar'] = player_pointer:get_steam_avatar()
                    })
                end
            end
        end


        return buffer
    end,

    rgb_health_based = function(percentage)
        local r = 124*2 - 124 * percentage
        local g = 195 * percentage
        local b = 13
        return r, g, b
    end,

    remap = function(val, newmin, newmax, min, max, clamp)
        min = min or 0
        max = max or 1

        local pct = (val-min)/(max-min)

        if clamp ~= false then
            pct = math.min(1, math.max(0, pct))
        end

        return newmin+(newmax-newmin)*pct
    end,

    roundedrect = function(x, y, w, h, radius, r, g, b, a) 
        render.rect(vector(x, y), vector(x + w, y + h), color(r, g, b, a), radius, true)
    end,
    
    fadedroundedrect = function(x, y, w, h, radius, r, g, b, a, glow) 
        local n = a/255*45;
        render.rect(vector(x + radius, y), vector(x + radius + w-radius*2, y + 1), color(r, g, b, a), 0, true)
        render.circle_outline(vector(x + radius, y + radius), color(r, g, b, a), radius, 180, 0.25)
        render.circle_outline(vector(x + w - radius, y + radius), color(r, g, b, a), radius, 270, 0.25)
        render.gradient(vector(x, y + radius), vector(x + 1, y + radius + h - radius * 2), color(r, g, b, a), color(r, g, b, a), color(r, g, b, n), color(r, g, b, n), 0)
        render.gradient(vector(x + w - 1, y + radius), vector(x + w, y + radius + h - radius * 2), color(r, g, b, a), color(r, g, b, a), color(r, g, b, n), color(r, g, b, n), 0)
        render.circle_outline(vector(x + radius, y + h - radius), color(r, g, b, n), radius, 90, 0.25)
        render.circle_outline(vector(x + w - radius, y + h - radius), color(r, g, b, n), radius, 0, 0.25)
        render.rect(vector(x + radius, y + h - 1), vector(x + radius + w - radius * 2, y + h), color(r, g, b, n), 0, true)
    end 

}

funcs.entity_list_pointer = ffi.cast('void***', utils.create_interface('client.dll', 'VClientEntityList003'))
funcs.get_client_entity_fn = ffi.cast('GetClientEntity_4242425_t', funcs.entity_list_pointer[0][3])

funcs.get_entity_address = function(ent_index)
    local addr = funcs.get_client_entity_fn(funcs.entity_list_pointer, ent_index)
    return addr
end

local ffi_helpers = {
    _pct = function(_, __, ___, ____)
        return ffi.C.VirtualProtect(ffi.cast('void*', _), __, ___, ____)
    end,
    _c = function(_, __, ___)
        return ffi.copy(ffi.cast('void*', _), ffi.cast('const void*', __), ___)
    end,
    _alc = function(lpAddress, dwSize, flAllocationType, flProtect, blFree)
    local _all = ffi.C.VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    if blFree then
        table.insert(buff.free, function()
        ffi.C.VirtualFree(_all, 0, 0x8000)
        end)
    end
    return ffi.cast('intptr_t', _all)
end
}

function vmt_hook.new(vt)
    local override_hook = {}
    local org_func = {}
    local old_prot = ffi.new('unsigned long[1]')
    local virtual_table = ffi.cast('intptr_t**', vt)[0]
    override_hook.this = virtual_table
    override_hook.hookMethod = function(cast, func, method)
    org_func[method] = virtual_table[method]
    ffi_helpers._pct(virtual_table + method, 4, 0x4, old_prot)
    virtual_table[method] = ffi.cast('intptr_t', ffi.cast(cast, func))
    ffi_helpers._pct(virtual_table + method, 4, old_prot[0], old_prot)
    return ffi.cast(cast, org_func[method])
end

override_hook.unHookMethod = function(method)
    ffi_helpers._pct(virtual_table + method, 4, 0x4, old_prot)
    local alloc_addr = ffi_helpers._alc(nil, 5, 0x1000, 0x40, false)
    local trampoline_bytes = ffi.new('uint8_t[?]', 5, 0x90)
    trampoline_bytes[0] = 0xE9
    ffi.cast('int32_t*', trampoline_bytes + 1)[0] = org_func[method] - tonumber(alloc_addr) - 5
    ffi_helpers._c(alloc_addr, trampoline_bytes, 5)
    virtual_table[method] = ffi.cast('intptr_t', alloc_addr)
    ffi_helpers._pct(virtual_table + method, 4, old_prot[0], old_prot)
    org_func[method] = nil
end

override_hook.unHookAll = function()
    for method, func in pairs(org_func) do
        override_hook.unHookMethod(method)
    end
end

table.insert(vmt_hook.hooks, override_hook.unHookAll)
    return override_hook
end

funcs.container = function(x, y, w, h, r, g, b, a, alpha, fn) 
    if not localplayer_info.fps_saver then
        render.blur(vector(x, y), vector(x + w, y + h), 0, 0.5, 0)
    end

    funcs.roundedrect(x, y, w, h, 4, 17, 17, 17, a)
    funcs.fadedroundedrect(x, y, w, h, 4, r, g, b, alpha*255, alpha*20)

    --render.rect_outline(vector(x, y), vector(x + w, y + h), color(r, g, b, alpha*255), 0, 3, true)


    --render.rect(vector(x, y), vector(x + w, y + (h - 1)), color(42, 42, 42, 255), 4, true)

end

funcs.container2 = function(x, y, w, h, r, g, b, a, alpha, fn) 



    local _rnd = { 1, 0 }
    render.rect(vector(x , y), vector(x + w, y + h), color(17, 17, 17, 150), _rnd[1], true)
    funcs.fadedroundedrect(x, y, w, h, _rnd[2], r, g, b, alpha*255, alpha*20)
    render.shadow(vector(x, y), vector(x + w, y + h), color(r, g, b, alpha*150), 20, 0, _rnd[1])

end

funcs.info_spectators = function()
    if not globals.is_connected or entity.get_local_player() == nil or entity.get_local_player() == nil then return end
    local localplayer = entity.get_local_player()
    if localplayer == nil then return end

    if localplayer:is_alive() then
        return funcs.get_spectators(entity.get(localplayer))
    else
        local m_iObserverMode = localplayer['m_iObserverMode']
        local m_hObserverTarget = localplayer['m_hObserverTarget']
        if m_hObserverTarget ~= nil then
            if localplayer['m_iObserverMode'] == 6 then 
                return 
            end
            if m_hObserverTarget and m_hObserverTarget:is_player() then
                return funcs.get_spectators(m_hObserverTarget)
            end
        end
    end
end

funcs.log = function(string)
    --print_raw('\aACDC04[solar] \aD5D5D5' .. string)
    --print_dev(string)
    --print_chat('\x08[solar] ' .. string)

    print_raw('\a8EA5E5[solar.tech] \a868686» \aD5D5D5' .. string)
    print_dev(string)
end

funcs.log_hit = function(entity, hitbox, wanted_hitbox, damage, wanted_damage, remaining, hitchance, history)
    local _type = remaining == 0 and 'Killed' or 'Hurt'
    local _type2 = _type == 'Killed' and 'in the ' or '' -- nvm
    local remaining_info = _type == 'Killed' and '' or string.format(' (\a8EA5E5%s \aD5D5D5hp remaining)', remaining)
    local hitbox_info = hitbox == wanted_hitbox and string.format('\a8EA5E5%s\aD5D5D5', hitbox) or string.format('\a8EA5E5%s\aD5D5D5(\a8EA5E5%s\aD5D5D5)', hitbox, wanted_hitbox)
    local damage_info = damage == wanted_damage and string.format('\a8EA5E5%s\aD5D5D5', damage) or string.format('\a8EA5E5%s\aD5D5D5(\a8EA5E5%s\aD5D5D5)', damage, wanted_damage)
    local _damage_info = damage == wanted_damage and string.format('%s', damage) or string.format('%s(%s)', damage, wanted_damage)
    local _remaining_info = _type == 'Killed' and '' or string.format(' (%s hp remaining)', remaining)
    local _hitbox_info = hitbox == wanted_hitbox and string.format('%s', hitbox) or string.format('%s(%s)', hitbox, wanted_hitbox)
    print_raw(string.format('\a8EA5E5[solar.tech]\a868686 » \a8EA5E5%s\aD5D5D5 %s\'s %s%s for %s \aD5D5D5damage%s [hitchance: \a8EA5E5%s \aD5D5D5| history(Δ): \a8EA5E5%s\aD5D5D5]', _type, entity, _type2, hitbox_info, damage_info, remaining_info, hitchance, history))
    print_dev(string.format('%s %s\'s %s%s for %s damage%s [hitchance: %s | history(Δ): %s]', _type, entity, _type2, _hitbox_info, _damage_info, _remaining_info, hitchance, history))
end

funcs.log_miss = function(entity, hitbox, reason, angle, hitchance, damage, history)
    local info = reason == 'resolver' and string.format('\aD5D5D5[angle: \aFF7373%s° \aD5D5D5| hitchance: \aFF7373%s \aD5D5D5| history(Δ): \aFF7373%s\aD5D5D5]', angle, hitchance, history) or string.format('\aD5D5D5[hitchance: \aFF7373%s \aD5D5D5| damage: \aFF7373%s \aD5D5D5| history(Δ): \aFF7373%s\aD5D5D5]', hitchance, damage, history)
    local _info = reason == 'resolver' and string.format('[angle: %s° | hitchance: %s | history(Δ): %s]', angle, hitchance, history) or string.format('[hitchance: %s | damage: %s | history(Δ): %s]', hitchance, damage, history)
    print_raw(string.format('\a8EA5E5[solar.tech]\a868686 » \aFF7373Missed \aD5D5D5%s\'s \aFF7373%s \aD5D5D5due to \aFF7373%s %s', entity, hitbox, reason, info))
    print_dev(string.format('Missed %s\'s %s due to %s %s', entity, hitbox, reason, _info))
end

funcs.log_debug = function(string)
    if not lua.debug then return end
    print_raw('\aACDC04[ solar_debug ] \aD5D5D5' .. string)
    print_dev('[ LOGGED DEBUG ] ' .. string)
end

local tabs = {
    global = {
        --a = ui.create(funcs.text_gr(142, 165, 255, 255, 204, 204, 255, 255, 'Global'), ui.get_icon('wave-square') .. funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, '  Welcome, ' .. common.get_username())),
        --b = ui.create(funcs.text_gr(142, 165, 255, 255, 204, 204, 255, 255, 'Global'), ui.get_icon('keyboard') .. funcs.text_gr(255, 255, 255, 255, 200, 200, 200, 255, '  Config system'))
        a = ui.create('\aFFFFFFF5Global', ui.get_icon('wave-square') .. funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, lua.version == 'source' and '  Welcome, ' .. common.get_username() .. ' [source]' or '  Welcome, ' .. common.get_username())),
        b = ui.create('\aFFFFFFF5Global', ui.get_icon('keyboard') .. funcs.text_gr(255, 255, 255, 255, 200, 200, 200, 255, '  Config system'))
    },

    ragebot = {
        --a = ui.create(funcs.text_gr(204, 204, 255, 255, 142, 165, 255, 255, 'Ragebot'), ui.get_icon('globe-europe') .. funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, '  Global')),
        --b = ui.create(funcs.text_gr(204, 204, 255, 255, 142, 165, 255, 255, 'Ragebot'), ui.get_icon('user-shield') .. funcs.text_gr(255, 255, 255, 255, 200, 200, 200, 255, '  Anti-aims'))
        a = ui.create('\aFFFFFFF5Ragebot', ui.get_icon('globe-europe') .. funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, '  Global')),
        b = ui.create('\aFFFFFFF5Ragebot', ui.get_icon('user-shield') .. funcs.text_gr(255, 255, 255, 255, 200, 200, 200, 255, '  Anti-aims'))
    },

    visuals = {
        a = ui.create('\aFFFFFFF5Visuals', ui.get_icon('globe-europe') .. funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, '  Global')),
        b = ui.create('\aFFFFFFF5Visuals', ui.get_icon('sliders-h') .. funcs.text_gr(255, 255, 255, 255, 200, 200, 200, 255, '  Settings'))
    },

    misc = {
        a = ui.create('\aFFFFFFF5Misc', ui.get_icon('globe-europe') .. funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, '  Global')),
        b = ui.create('\aFFFFFFF5Misc', ui.get_icon('cogs') .. funcs.text_gr(255, 255, 255, 255, 200, 200, 200, 255, '  Other'))
    }
}

local menu = {

    ui.sidebar(funcs.text_gr(142, 165, 255, 255, 204, 204, 255, 255, lua.version == 'source' and 'solar.tech [source]' or 'solar.tech'), 'expand'),
    
    global = {
        tabs.global.a:label(funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, 'Don\'t forget to join our discord server!')),
        tabs.global.a:button(ui.get_icon('expand-arrows-alt') .. '  How to get a role'),

        tabs.global.a:label(funcs.text_gr(200, 200, 200, 255, 255, 255, 255, 255, '1. Click the button below \n2. Create a ticket \n3. Proof your purchase (upload ss and username)')),
        tabs.global.a:button(ui.get_icon('server') .. ' Solar.tech Discord'),

        tabs.global.b:label(funcs.text_gr(255, 255, 255, 255, 200, 200, 200, 255, 'You can find user\'s configs in our discord')),

        import = tabs.global.b:button(ui.get_icon('file-import') .. ' Import'),
        export = tabs.global.b:button(ui.get_icon('file-export') .. ' Export'),
        default = tabs.global.b:button(ui.get_icon('user-cog') .. ' Default')
    },

    ragebot = {
        tweakers = tabs.ragebot.a:selectable(ui.get_icon('layer-group') .. '  Tweakers', { 'In-air hitchance', 'Noscope hitchance' }),
        inair = tabs.ragebot.a:switch('Modify hitchance in air'),
        noscope = tabs.ragebot.a:switch('Modify noscope hitchance'),
        builder = tabs.ragebot.a:switch('\aB6B665FF'..ui.get_icon('user-shield')..'  Anti-aims builder'),
        pitch = tabs.ragebot.a:combo('» Pitch', { 'Disabled' , 'Down', 'Fake Down', 'Fake Up' }),
        base = tabs.ragebot.a:combo('» Yaw base', 'At Target', 'Backward', 'Left', 'Right'),
        condition = tabs.ragebot.b:combo('\a9ED8FFFF» Condition', combo.menu_states_full)
    },

    visuals = {
        realtweakers = tabs.visuals.a:selectable(ui.get_icon('layer-group') .. '  Tweakers', { 'Corner logs', 'Simple spectators', 'Slowed down ind.', 'Simple watermark' }),
        tweakers = tabs.visuals.a:selectable(ui.get_icon('eye') .. '  Indicators', { 'Crosshair', 'Feature' }),
        elements = tabs.visuals.a:selectable(ui.get_icon('eject') .. '   Solus UI', { 'Watermark', 'Spectators', 'Keybinds' }),
        crosshair = tabs.visuals.b:selectable('» Crosshair', { 'Lua name', 'Desync line', 'Player state', 'Doubletap', 'Onshot', 'Duck peek assist', 'Force body aim', 'Force safe point' }),
        feature = tabs.visuals.b:selectable('» Feature', { 'Force safe point', 'Force body aim', 'Ping spike', 'Double tap', 'Duck peek assist', 'Freestanding', 'Bomb info', 'Min. damage', 'Onshot', 'Dormant aimbot', 'Hitchance', 'Lag comp', 'Fake angle' })
    },

    misc = {
        tweakers = tabs.misc.a:selectable(ui.get_icon('reply') .. '  Reply', { 'On kill' , 'On death' }),
        logs = tabs.misc.a:selectable(ui.get_icon('marker') .. '  Logging', { 'Aimbot shots', 'Purchases' }),
        stealname = tabs.misc.a:button('Steal player name'),

        viewmodel = tabs.misc.b:switch(ui.get_icon('lock-open') .. '  Override viewmodel'),
        untrusted = tabs.misc.b:switch('\aD98d00FF'..ui.get_icon('exclamation-triangle')..'  Untrusted functions')
    }
}

menu.misc.untrusted:tooltip('\aD93600FFThis functions can broke your cheat!') 

menu.corner_sttings = menu.visuals.realtweakers:create()
menu.inair_settings = menu.ragebot.inair:create()
menu.noscope_settings = menu.ragebot.noscope:create()
menu.crosshair_settings = menu.visuals.crosshair:create()
menu.feature_settings = menu.visuals.feature:create()
menu.solus_settings = menu.visuals.elements:create()
menu.viewmodel_settings = menu.misc.viewmodel:create()
menu.arrows_settings = menu.ragebot.base:create()
menu.indicator_settings = menu.visuals.tweakers:create()
menu.untrusted_settings = menu.misc.untrusted:create()

menu.animlayers = menu.untrusted_settings:selectable('Animlayers', { 'In-air static legs', 'Backward slide', 'Pitch on land' })
menu.animlayers:tooltip('\aD93600FFOverriding your animlayers\n\n\aFFFFFFFF[1] - Make your legs static in air\n[2] - Broke your sliding legs\n[3] - Make your pitch zero on land')

menu.indicators_theme = menu.indicator_settings:combo('Crosshair theme', { 'Original', 'Technology' })
menu.feature_theme = menu.indicator_settings:combo('Feature theme', { 'Default', 'Legacy' })
menu.static_manuals = menu.arrows_settings:switch('Static on manuals')
menu.arrows_enable = menu.arrows_settings:switch('Manual arrows')
menu.arrows_theme = menu.arrows_settings:combo('Arrows theme', { 'Default', 'Getze.us', 'Teamskeet' })
menu.arrows_color_default = menu.arrows_settings:color_picker('Arrows color', color(255, 255, 255, 255))
menu.arrows_color_getzeus = { 
    menu.arrows_settings:color_picker('Arrows color ', color(255, 255, 255, 255)),
    menu.arrows_settings:color_picker('Arrows color selected', color(111, 111, 220, 255)) }
menu.arrows_color_teamskeet = { 
    menu.arrows_settings:color_picker('Selected arrow', color(175, 255, 0, 255)),
    menu.arrows_settings:color_picker('Desync line', color(0, 200, 255, 255)) }
menu.viewmodel_fov = menu.viewmodel_settings:slider('Viewmodel FOV', -100, 100, 0, 1)
menu.viewmodel_x = menu.viewmodel_settings:slider('Viewmodel X', -100, 100, 0, 1)
menu.viewmodel_y = menu.viewmodel_settings:slider('Viewmodel Y', -100, 100, 0, 1)
menu.viewmodel_z = menu.viewmodel_settings:slider('Viewmodel Z', -100, 100, 0, 1)
menu.ui_cheattext = menu.solus_settings:input('Cheat name', 'solar')
menu.ui_usertext = menu.solus_settings:input('Username', '')
menu.solus_theme = menu.solus_settings:combo('Theme', { 'v1', 'v2', 'solar.tech' })
menu.fps_saver = menu.solus_settings:switch('Fps saver')
menu.ui_accent_color = menu.solus_settings:color_picker('Global color', color(142, 165, 229, 85))
menu.solus_settings:label('Note: v2 theme can drops your fps')
menu.ui_keybinds_x = menu.solus_settings:slider('[debug] keybinds_x', 1, render.screen_size().x, render.screen_size().x / 2 - 250, '', '')
menu.ui_keybinds_y = menu.solus_settings:slider('[debug] keybinds_y', 1, render.screen_size().y, render.screen_size().y / 2 - 50, '', '')
menu.ui_spectators_x = menu.solus_settings:slider('[debug] spectators_x', 1, render.screen_size().x, render.screen_size().x / 2 - 550, '', '')
menu.ui_spectators_y = menu.solus_settings:slider('[debug] spectators_y', 1, render.screen_size().y, render.screen_size().y / 2 - 50, '', '')
menu.ind_color = menu.crosshair_settings:color_picker('Main color', color(142, 165, 255, 255))
menu.y_move = menu.crosshair_settings:slider('Y move', 0, 50, 0)
menu.crosshair_settings:label('Note: desync line rendering only with lua name')
menu.hctype = menu.feature_settings:combo('Hitchance mode', { 'On hotkey' , 'Always on' })
menu.hctext = menu.feature_settings:input('Hitchance type', 'Hitchance: ')
menu.hccolor = menu.feature_settings:color_picker('Hitchance color', color(255, 255, 255, 255))
menu.hcempty = menu.feature_settings:label(' ')
menu.dmgtype = menu.feature_settings:combo('Damage mode', { 'On hotkey' , 'Always on' })
menu.dmgtext = menu.feature_settings:input('Damage type', '')
menu.dmgcolor = menu.feature_settings:color_picker('Damage color', color(255, 255, 255, 255))
menu.inair_hc = menu.inair_settings:slider('Hitchance ', 0, 100, 0)
menu.noscope_hc = menu.noscope_settings:slider('Hitchance  ', 0, 100, 0)

for i = 1, 6 do
    aa_init[i] = {
        enable = tabs.ragebot.b:switch('Override ' .. string.lower(combo.menu_states_full[i])),
        yaw_left = tabs.ragebot.b:slider('[' .. combo.menu_states[i] .. '] Yaw add L°', -180, 180, 0, '', ''),
        yaw_right = tabs.ragebot.b:slider('[' .. combo.menu_states[i] .. '] Yaw add R°', -180, 180, 0, '', ''),
        yaw_modifier = tabs.ragebot.b:combo('[' .. combo.menu_states[i] .. '] Yaw modifier', { 'Disabled', 'Center', 'Offset', 'Random', 'Spin' }),
        yaw_degree = tabs.ragebot.b:slider('[' .. combo.menu_states[i] .. '] Modifier degree°', -180, 180, 0, '', ''),
        yaw_fakeopt = tabs.ragebot.b:selectable('[' .. combo.menu_states[i] .. '] Fake options', {'Avoid Overlap', 'Jitter', 'Randomize Jitter', 'Anti Bruteforce'}),
        yaw_freestand = tabs.ragebot.b:combo('[' .. combo.menu_states[i] .. '] Desync FS', { 'Off', 'Peek Fake', 'Peek Real' }), 
        yaw_desync_left = tabs.ragebot.b:slider('[' .. combo.menu_states[i] .. '] Desync L°', 0, 60, 0, '', ''),
        yaw_desync_right = tabs.ragebot.b:slider('[' .. combo.menu_states[i] .. '] Desync R°', 0, 60, 0, '', '')
    }
end

local cheat = {
    dormantaim = ui.find('Aimbot', 'Ragebot', 'Main', 'Enabled', 'Dormant Aimbot'),
    doubletap = ui.find('aimbot', 'ragebot', 'main', 'double tap'),
    fakeduck = ui.find('aimbot', 'anti aim', 'misc', 'fake duck'),
    hideshots = ui.find('aimbot', 'ragebot', 'main', 'hide shots'),
    hitchance = ui.find('Aimbot', 'Ragebot', 'Selection', 'Hit Chance'),
    bodyyaw = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Body Yaw'),
    slowwalk = ui.find('aimbot', 'anti aim', 'misc', 'slow walk'),
    safepoint = ui.find('aimbot', 'ragebot', 'safety', 'safe points'),
    bodyaim = ui.find('aimbot', 'ragebot', 'safety', 'body aim'),
    aa_pitch = ui.find('aimbot', 'anti aim', 'angles', 'pitch'),
    pingspike = ui.find('miscellaneous', 'main', 'other', 'fake latency'),
    mindamage = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    freestand = ui.find('aimbot', 'anti aim', 'angles', 'freestanding'),
    yaw = ui.find('aimbot', 'anti aim', 'angles', 'yaw', 'offset'),
    yaw_base = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw', 'Base'),
    yaw_set = ui.find('Aimbot', 'Anti Aim', 'Angles', 'Yaw'),
    yaw_modifier = ui.find('aimbot', 'anti aim', 'angles', 'yaw modifier'),
    yaw_degree = ui.find('aimbot', 'anti aim', 'angles', 'yaw modifier', 'offset'),
    yaw_fakeopt = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'options'),
    yaw_freestand = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'freestanding'),
    yaw_desync_left = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'left limit'),
    yaw_desync_right = ui.find('aimbot', 'anti aim', 'angles', 'body yaw', 'right limit'),
    legmovement = ui.find('Aimbot', 'Anti Aim', 'Misc', 'Leg Movement')
}

cfg.data = {

    bools = {
        menu.ragebot.tweakers,
        menu.ragebot.inair,
        menu.ragebot.noscope,
        menu.ragebot.builder,
        menu.ragebot.pitch,
        menu.ragebot.base,
        menu.ragebot.condition,

        menu.visuals.realtweakers,
        menu.visuals.tweakers,
        menu.visuals.elements,
        menu.visuals.crosshair,
        menu.visuals.feature,

        menu.misc.tweakers,
        menu.misc.logs,
        menu.misc.viewmodel,
        
        menu.solus_theme,
        menu.hctype,
        menu.dmgtype,
        menu.inair_hc,
        menu.noscope_hc,

        menu.indicators_theme,
        menu.feature_theme,
        menu.arrows_enable,
        menu.arrows_theme,

        menu.static_manuals,

        menu.fps_saver,
    },

    ints = {
        aa_init[1].enable, aa_init[2].enable, aa_init[3].enable, aa_init[4].enable, aa_init[5].enable, aa_init[6].enable,
        aa_init[1].yaw_left, aa_init[2].yaw_left, aa_init[3].yaw_left, aa_init[4].yaw_left, aa_init[5].yaw_left, aa_init[6].yaw_left,
        aa_init[1].yaw_right, aa_init[2].yaw_right, aa_init[3].yaw_right, aa_init[4].yaw_right, aa_init[5].yaw_right, aa_init[6].yaw_right,
        aa_init[1].yaw_modifier, aa_init[2].yaw_modifier, aa_init[3].yaw_modifier, aa_init[4].yaw_modifier, aa_init[5].yaw_modifier, aa_init[6].yaw_modifier,
        aa_init[1].yaw_degree, aa_init[2].yaw_degree, aa_init[3].yaw_degree, aa_init[4].yaw_degree, aa_init[5].yaw_degree, aa_init[6].yaw_degree,
        aa_init[1].yaw_fakeopt, aa_init[2].yaw_fakeopt, aa_init[3].yaw_fakeopt, aa_init[4].yaw_fakeopt, aa_init[5].yaw_fakeopt, aa_init[6].yaw_fakeopt,
        aa_init[1].yaw_freestand, aa_init[2].yaw_freestand, aa_init[3].yaw_freestand, aa_init[4].yaw_freestand, aa_init[5].yaw_freestand, aa_init[6].yaw_freestand,
        aa_init[1].yaw_desync_left, aa_init[2].yaw_desync_left, aa_init[3].yaw_desync_left, aa_init[4].yaw_desync_left, aa_init[5].yaw_desync_left, aa_init[6].yaw_desync_left,
        aa_init[1].yaw_desync_right, aa_init[2].yaw_desync_right, aa_init[3].yaw_desync_right, aa_init[4].yaw_desync_right, aa_init[5].yaw_desync_right, aa_init[6].yaw_desync_right,
    },

    floats = {
        menu.viewmodel_fov,
        menu.viewmodel_x,
        menu.viewmodel_y,
        menu.viewmodel_z,

        menu.ui_keybinds_x,
        menu.ui_keybinds_y,
        menu.ui_spectators_x,
        menu.ui_spectators_y,

        menu.y_move
    },

    strings = {
        menu.ui_cheattext,
        menu.ui_usertext,

        menu.hctext,
        menu.dmgtext
    },

    colors = {
        menu.ui_accent_color,
        menu.ind_color,
        
        menu.hccolor,
        menu.dmgcolor,
        
        menu.arrows_color_default,
        menu.arrows_color_getzeus[1],
        menu.arrows_color_getzeus[2],
        menu.arrows_color_teamskeet[1],
        menu.arrows_color_teamskeet[2],
    }
}

cfg.load = function(text)
    local decode_cfg = json.parse(requires[4].decode(text))
    if decode_cfg == nil then
        funcs.log('[~] Failed to import config')
    else
        for k, v in pairs(decode_cfg) do
            k = ({[1] = 'bools', [2] = 'ints', [3] = 'floats', [4] = 'strings', [5] = 'colors'})[k]

            for k2, v2 in pairs(v) do
                if (k == 'bools') then
                    cfg.data[k][k2]:set(v2)
                end

                if (k == 'ints') then
                    cfg.data[k][k2]:set(v2)
                end

                if (k == 'floats') then
                    cfg.data[k][k2]:set(v2)
                end

                if (k == 'strings') then
                    cfg.data[k][k2]:set(v2)
                end

                if (k == 'colors') then
                    cfg.data[k][k2]:set(color(tonumber('0x'..v2:sub(1, 2)), tonumber('0x'..v2:sub(3, 4)), tonumber('0x'..v2:sub(5, 6)), tonumber('0x'..v2:sub(7, 8))))
                end
            end
        end
    end
end

funcs.updatecsa = function(thisptr, edx)

    --if not menu.misc.untrusted:get() then return end
    if entity.get_local_player() == nil or ffi.cast('uintptr_t', thisptr) == nil then return end
    local localplayer = entity.get_local_player()
    local lp_ptr = funcs.get_entity_address(localplayer:get_index())

    if menu.animlayers:get('Backward slide') and menu.misc.untrusted:get() then
        ffi.cast('float*', lp_ptr+10104)[0] = 1
        cheat.legmovement:override('Sliding')
    else
        cheat.legmovement:override()
    end

    if menu.animlayers:get('Pitch on land') and menu.misc.untrusted:get() then
        ffi.cast('float*', lp_ptr+10104)[12] = 0
    end

    hooked_function(thisptr, edx)

    if menu.animlayers:get('In-air static legs') and menu.misc.untrusted:get() then
        ffi.cast('float*', lp_ptr+10104)[6] = 1
    end

    if menu.animlayers:get('Pitch on land') and menu.misc.untrusted:get() then

        if bit.band(entity.get_local_player()["m_fFlags"], 1) == 1 then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = globals.curtime  + 1
        end

        if not var.in_air == 1 and ground_ticks > 1 and end_time > globals.curtime then
            ffi.cast('float*', lp_ptr+10104)[12] = 0.5
        end
    end
end

animation.lerp = function(start, end_pos, time)
    if type(start) == 'userdata' then
        local color_data = {0, 0, 0, 0}
        for i, color_key in ipairs({'r', 'g', 'b', 'a'}) do
            color_data[i] = animation.lerp(start[color_key], end_pos[color_key], time)
        end
        return color(unpack(color_data))
    end
    return (end_pos - start) * (globals.frametime * time * 175) + start
end

animation.new = function(name, value, time)
    if animation.data[name] == nil then
        animation.data[name] = value
    end
    animation.data[name] = animation.lerp(animation.data[name], value, time)
    return animation.data[name]
end


local gradient_antiaim = requires[5].text_animate('anti-aim', 1, {
    color(100, 100, 100), 
    color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255)
})

local gradient_status = requires[5].text_animate('['..lua.version..']', 1, {
    color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255), 
    color(100, 100, 100)
})


local crosshair = {
    indicator = function(string, r, g, b, a, add_x, add_y, centered)
        render.text(2, vector((render.screen_size().x / 2) + 1 + add_x, (render.screen_size().y / 2) + 10 + menu.y_move:get() + add_y), color(r, g, b, a), 'c', string)
    end,

    indicator2 = function(string, r, g, b, a, index, centered)
        render.text(1, vector((render.screen_size().x / 2), (render.screen_size().y / 2) + 10 + menu.y_move:get() + index * 10), color(r, g, b, a), centered, string)
    end,

    line = function(length, length2, add_x, add_y, centered, alpha)
        if length < length2 - 1 then length2 = length - 1 end
        render.rect(vector((render.screen_size().x / 2) - (length / 2 - 1) + add_x, render.screen_size().y / 2 + menu.y_move:get() + 25), vector((render.screen_size().x / 2) + add_x + length / 2, render.screen_size().y / 2 + 4 + menu.y_move:get() + 25), color(0, 0, 0, 150*alpha), 0, true)
        --render.rect(vector((render.screen_size().x / 2) - (length / 2 - 2) + add_x, (render.screen_size().y / 2) + 1 + menu.y_move:get() + 25), vector((render.screen_size().x / 2) + add_x - (length / 2) + length2, render.screen_size().y / 2 + 3 + menu.y_move:get() + 25), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, alpha), 0, true)
        render.gradient(vector((render.screen_size().x / 2) - (length / 2 - 2) + add_x, (render.screen_size().y / 2) + 1 + menu.y_move:get() + 25), vector((render.screen_size().x / 2) + add_x - (length / 2) + length2, render.screen_size().y / 2 + 3 + menu.y_move:get() + 25), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255*alpha), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 10*alpha), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255*alpha), color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 10*alpha), 0)
    end
}

local feature = {
    indicator = function(r, g, b, a, string, xtazst)
        if (string == nil or string == '' or string == ' ') then return end
        render.gradient(vector(13, render.screen_size().y - 350 - xtazst * 37), vector(13 + (render.measure_text(funcs.fonts.feature, '', string).x / 2), (render.screen_size().y - 345 - xtazst * 37) + 28), color(0, 0, 0, 0), color(0, 0, 0, 60), color(0, 0, 0, 0), color(0, 0, 0, 60), 0)
        render.gradient(vector(13 + (render.measure_text(funcs.fonts.feature, '', string).x), render.screen_size().y - 350 - xtazst * 37), vector(13 + (render.measure_text(funcs.fonts.feature, '', string).x / 2), (render.screen_size().y - 345 - xtazst * 37) + 28), color(0, 0, 0, 0), color(0, 0, 0, 60), color(0, 0, 0, 0), color(0, 0, 0, 60), 0)

        render.text(funcs.fonts.feature, vector(20, (render.screen_size().y - 343) - xtazst * 37), color(0, 0, 0, 150), '', string)
        render.text(funcs.fonts.feature, vector(19, (render.screen_size().y - 344) - xtazst * 37), color(r, g, b, a), '', string)
    end
}

local legacy = {
    indicator = function(r, g, b, a, string, xtazst)
        if (string == nil or string == '' or string == ' ') then return end
        render.text(funcs.fonts.legacy, vector(10, (render.screen_size().y - 69) - xtazst * 30), color(r, g, b, a), '', string)
    end
}

local renders = {
    conteiner = function(x, y, w, h, name, font_size, font)
        local name_size = render.measure_text(font, '', name)
        if menu.solus_theme:get() == 'v1' then
            render.rect(vector(x, y), vector(x + w + 2, y - 2), color(menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, 255), 0, true)
            render.rect(vector(x, y), vector(x + w + 2, y + h), color(18, 18, 18, menu.ui_accent_color:get().a), 0, true)  
            render.text(font, vector(x+1 + w / 2 + 1 - name_size.x / 2, y + 3), color(255, 255, 255, 255), '', name)
        elseif menu.solus_theme:get() == 'v2' then
            funcs.container(x, y, w + 3, h, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
       
            --render.text(font, vector(x+2 + w / 2 + 1 - name_size.x / 2, y + 3), color(142, 165, 255, 255), '', name)
            render.text(font, vector(x+1 + w / 2 + 1 - name_size.x / 2, y + 2), color(255, 255, 255, 255), '', name)
        
        elseif menu.solus_theme:get() == 'solar.tech' then
            funcs.container2(x, y, w + 3, h, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
            
            --render.text(font, vector(x+2 + w / 2 + 1 - name_size.x / 2, y + 3), color(142, 165, 255, 255), '', name)

            render.text(font, vector(x+1 + w / 2 + 1 - name_size.x / 2, y + 2), color(255, 255, 255, 255), '', name)
        
        end
    end,

    rectangle = function(x, y, w, h, r, g, b, a) -- sorry @Zabolotny
	    return render.rect(vector(x, y), vector(x + w, y + h), color(r, g, b, a), 0, true)
    end,

    MultiColorString = function(table, x, y, size, font, centered, shadow)
        outline = outline or false
        centered = centered or false
        shadow = shadow or false
      
        if #table == 0 then return end
    
        local text = ""
        for i = 1, #table do
            text = text .. tostring(table[i][1])
        end
      
        local text_size = centered and -(render.measure_text(font, '', text).x / 2)
    
        for i = 1, #table do
            if type(table[i][1]) ~= "string" then table[i][1] = tostring(table[i][1]) end
    
            render.text(font, vector(x + text_size, y), table[i][2], '', table[i][1])
    
            text_size = text_size + render.measure_text(font, '', table[i][1]).x
        end
    end
}

renders.rectangle_outline = function(x, y, w, h, r, g, b, a, s)
	s = s or 1
	renders.rectangle(x, y, w, s, r, g, b, a) -- top
	renders.rectangle(x, y+h-s, w, s, r, g, b, a) -- bottom
	renders.rectangle(x, y+s, s, h-s*2, r, g, b, a) -- left
	renders.rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a) -- right
end

local warning = render.load_image('<?xml version="1.0" encoding="utf-8"?><!-- Generator: Adobe Illustrator 16.0.3, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"><svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="32px"	 height="32px" viewBox="0 0 32 32" enable-background="new 0 0 32 32" xml:space="preserve"><symbol  id="dude-transit" viewBox="0 -25.1 21.25 25.118">	<path fill-rule="evenodd" clip-rule="evenodd" fill="#FFFFFF" d="M15.5-4.2l0.75-1.05l1-3.1l3.9-2.65v-0.05		c0.067-0.1,0.1-0.233,0.1-0.4c0-0.2-0.05-0.383-0.15-0.55c-0.167-0.233-0.383-0.35-0.65-0.35l-4.3,1.8l-1.2,1.65l-1.5-3.95		l2.25-5.05l-3.25-6.9c-0.267-0.2-0.633-0.3-1.1-0.3c-0.3,0-0.55,0.15-0.75,0.45c-0.1,0.133-0.15,0.25-0.15,0.35		c0,0.067,0.017,0.15,0.05,0.25c0.033,0.1,0.067,0.184,0.1,0.25l2.55,5.6L10.7-14l-3.05-4.9L0.8-18.7		c-0.367,0.033-0.6,0.184-0.7,0.45c-0.067,0.3-0.1,0.467-0.1,0.5c0,0.5,0.2,0.767,0.6,0.8l5.7,0.15l2.15,5.4l3.1,5.65L9.4-5.6		c-1.367-2-2.1-3.033-2.2-3.1C7.1-8.8,6.95-8.85,6.75-8.85C6.35-8.85,6.1-8.667,6-8.3C5.9-8,5.9-7.8,6-7.7H5.95l2.5,4.4l3.7,0.3		L14-3.5L15.5-4.2z M14.55-2.9c-0.333,0.4-0.45,0.85-0.35,1.35c0.033,0.5,0.25,0.9,0.65,1.2S15.7,0.066,16.2,0		c0.5-0.067,0.9-0.3,1.2-0.7c0.333-0.4,0.467-0.85,0.4-1.35c-0.066-0.5-0.3-0.9-0.7-1.2c-0.4-0.333-0.85-0.45-1.35-0.35		C15.25-3.533,14.85-3.3,14.55-2.9z"/></symbol><g id="Layer_1">	<path fill="#FFFFFF" d="M16.041,3.33L1.081,30.039H31L16.041,3.33z M17.5,27.059h-3v-2.288h3V27.059z M14.5,22.473v-10.17h3v10.17		H14.5z"/></g><g id="Layer_2"></g></svg>', vector(35, 35))
local interval = 0

local function drawBar(modifier, r, g, b, a, text)
	interval = interval + (1-modifier) * 0.7 + 0.3
	local warningAlpha = math.abs(interval*0.01 % 2 - 1) * 255
	
	local text_width = 95
	local sw, sh = render.screen_size().x, render.screen_size().y
	local x, y = sw/2-text_width, sh*0.35
	local iw, ih = warning.width, warning.height

	-- icon
	render.texture(warning, vector(x - 3, y - 4), vector(iw + 6, ih + 6), color(16, 16, 16, 255*a), 'f', 0)
	if a > 0.7 then
		renders.rectangle(x+13, y+11, 8, 20, 16, 16, 16, 255*a)
	end
    render.texture(warning, vector(x, y), vector(35, 35), color(r, g, b, warningAlpha*a), 'f', 0)

	-- text
    render.text(funcs.fonts.skeet_bold, vector(x + iw + 8, y + 3), color(255, 255, 255, 255*a), '', string.format('%s %d%%', text, modifier * 100))

	-- bar
	local rx, ry, rw, rh = x + iw + 8, y + 3 + 17, text_width, 12
	renders.rectangle_outline(rx, ry, rw, rh, 0, 0, 0, 255*a, 1)
	renders.rectangle(rx+1, ry+1, rw-2, rh-2, 16, 16, 16, 180*a)
	renders.rectangle(rx+1, ry+1, math.floor((rw-2)*modifier), rh-2, r, g, b, 180*a)
end

-- Solus regs 

local drag = false
local drag_s = false
local g_players = { }
local alpha_k = 1
local data_k = {
    [''] = {alpha_k = 0}
}

local drag_s = false
local width_k = 0
local width_ka = 0
local alpha_s = 1
local width_sa = 0
local width_s = 0
local dick = 0
local data_s = {
    [''] = {alpha_s = 0}
}

local keybind_names = {
    ['Double Tap'] = 'Double tap',
    ['Hide Shots'] = 'On shot anti-aim',
    ['Slow Walk'] = 'Slow motion',
    ['Edge Jump'] = 'Jump at edge',
    ['Fake Latency'] = 'Ping spike',
    ['Fake Duck'] = 'Duck peek assist',
    ['Minimum Damage'] = 'Damage override',
    ['Peek Assist'] = 'Quick peek assist',
    ['Body Aim'] = 'Force body aim',
    ['Safe Points'] = 'Safe points',
    ['Yaw Base'] = 'Yaw base',
    ['Force Thirdperson'] = 'Thirdperson',
    ['» Yaw base'] = 'Yaw base',
}

-- Solus regs 

local pi, max = math.pi, math.max

dynamic.__index = dynamic

function dynamic.new(f, z, r, xi)
   f = max(f, 0.001)
   z = max(z, 0)

   local pif = pi * f
   local twopif = 2 * pif

   local a = z / pif
   local b = 1 / ( twopif * twopif )
   local c = r * z / twopif

   return setmetatable({
      a = a,
      b = b,
      c = c,

      px = xi,
      y = xi,
      dy = 0
   }, dynamic)
end

function dynamic:update(dt, x, dx)
   if dx == nil then
      dx = ( x - self.px ) / dt
      self.px = x
   end

   self.y  = self.y + dt * self.dy
   self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
   return self
end

function dynamic:getval()
   return self.y
end

local register = {

    hook_animstate = function()

        if not menu.misc.untrusted:get() then return end

        local localplayer = entity.get_local_player()
        if not localplayer then return end
    
        local local_player_ptr = funcs.get_entity_address(localplayer:get_index())
        if not local_player_ptr or hooked_function then return end
    
        local C_CSPLAYER = vmt_hook.new(local_player_ptr)
        hooked_function = C_CSPLAYER.hookMethod('void(__fastcall*)(void*, void*)', funcs.updatecsa, 224)
        
    end,

    inair_hitchance = function()
        if not menu.ragebot.tweakers:get(1) and not menu.ragebot.inair:get() then 
            return
        end  
        local GetLocalPlayer = entity.get_local_player()  
        if GetLocalPlayer == nil then 
            return
        end
        local fFlags = GetLocalPlayer['m_fFlags']
        local on_ground = bit.band(fFlags, bit.lshift(1, 0)) == 0
        if on_ground then
            cheat.hitchance:override(menu.inair_hc:get())
        else
            cheat.hitchance:override()
        end
    end,

    noscope_hitchance = function()
        if not menu.ragebot.tweakers:get(2) and not menu.ragebot.noscope:get() then 
            return 
        end
        local GetLocalPlayer = entity.get_local_player()
        if GetLocalPlayer == nil then 
            return 
        end
        local m_bIsScoped = GetLocalPlayer['m_bIsScoped']
        local GetActiveWeapon = GetLocalPlayer:get_player_weapon()
        if GetActiveWeapon ~= nil then
            if funcs.allowed_wpns[GetActiveWeapon:get_weapon_index()] then
                if not m_bIsScoped then
                    cheat.hitchance:override(menu.noscope_hc:get())
                end
            end
        else
            cheat.hitchance:override()
        end
    end,

    localplayer_state = function()
        local localplayer = entity.get_local_player()
        local p_duck = localplayer['m_flDuckAmount']
        local std1, std2, std3 = localplayer['m_vecVelocity'].x, localplayer['m_vecVelocity'].y, localplayer['m_vecVelocity'].z
        local p_still = math.sqrt(std1 ^ 2 + std2 ^ 2) < 2
        localplayer_info.side = localplayer_info.real_yaw > 0 and 1 or -1
        localplayer_info.inverter = localplayer_info.real_yaw > 0 and true or false
    
        if bit.band(localplayer['m_fFlags'], 1) == 1 and not common.is_button_down(0x20) then var.in_air = 0 else var.in_air = 1 end
        if p_duck >= 0.7 and var.in_air == 1 then var.plr_state = 1 elseif var.in_air == 1 then var.plr_state = 2 elseif cheat.slowwalk:get() then var.plr_state = 3 elseif p_duck >= 0.7 or cheat.fakeduck:get() then var.plr_state = 4 elseif p_still then var.plr_state = 5 else var.plr_state = 6 end    
    end, 

    manual_arrows = function()

        if not menu.arrows_enable:get() then return end
        local localplayer = entity.get_local_player()
        if not localplayer then return end
        if not localplayer:is_alive() then return end

        local is_manual_left = menu.ragebot.base:get() == 'Left'
        local is_manual_right = menu.ragebot.base:get() == 'Right'
        local x, y = render.screen_size().x, render.screen_size().y

        if menu.arrows_theme:get() == 'Default' then
            local default = { menu.arrows_color_default:get().r, menu.arrows_color_default:get().g, menu.arrows_color_default:get().b, menu.arrows_color_default:get().a }

            local manual_left = string.format('%.0f', animation.new('manual_left', is_manual_left and 60 or 16, 0.1))
            local manual_right = string.format('%.0f', animation.new('manual_right', is_manual_right and 44 or 0, 0.1))
            local manual_left_a = string.format('%.0f', animation.new('manual_left_a', is_manual_left and 1 or 0, 0.1))
            local manual_right_a = string.format('%.0f', animation.new('manual_right_a', is_manual_right and 1 or 0, 0.1))
            
            render.text(funcs.fonts.arrows, vector(render.screen_size().x / 2 + manual_right, render.screen_size().y / 2 - 15), color(default[1], default[2], default[3], default[4]*manual_right_a), '', '»')
            render.text(funcs.fonts.arrows, vector(render.screen_size().x / 2 - manual_left, render.screen_size().y / 2 - 15), color(default[1], default[2], default[3], default[4]*manual_left_a), '', '«')
        end

        if menu.arrows_theme:get() == 'Getze.us' then
            local selected = { menu.arrows_color_getzeus[2]:get().r, menu.arrows_color_getzeus[2]:get().g, menu.arrows_color_getzeus[2]:get().b, menu.arrows_color_getzeus[2]:get().a }
            local unselected = { menu.arrows_color_getzeus[1]:get().r, menu.arrows_color_getzeus[1]:get().g, menu.arrows_color_getzeus[1]:get().b, menu.arrows_color_getzeus[1]:get().a }
            if is_manual_right then
                render.text(funcs.fonts.arrowssecond, vector(render.screen_size().x / 2 + 44, render.screen_size().y / 2 - 11), color(selected[1], selected[2], selected[3], selected[4]), '', '>')
                render.text(funcs.fonts.arrowssecond, vector(render.screen_size().x / 2 - 60, render.screen_size().y / 2 - 11), color(unselected[1], unselected[2], unselected[3], unselected[4]), '', '<')
            elseif is_manual_left then
                render.text(funcs.fonts.arrowssecond, vector(render.screen_size().x / 2 + 44, render.screen_size().y / 2 - 11), color(unselected[1], unselected[2], unselected[3], unselected[4]), '', '>')
                render.text(funcs.fonts.arrowssecond, vector(render.screen_size().x / 2 - 60, render.screen_size().y / 2 - 11), color(selected[1], selected[2], selected[3], selected[4]), '', '<')
            else
                render.text(funcs.fonts.arrowssecond, vector(render.screen_size().x / 2 + 44, render.screen_size().y / 2 - 11), color(unselected[1], unselected[2], unselected[3], unselected[4]), '', '>')
                render.text(funcs.fonts.arrowssecond, vector(render.screen_size().x / 2 - 60, render.screen_size().y / 2 - 11), color(unselected[1], unselected[2], unselected[3], unselected[4]), '', '<')
            end
        end

        if menu.arrows_theme:get() == 'Teamskeet' then
            local colors_desync = { menu.arrows_color_teamskeet[2]:get().r, menu.arrows_color_teamskeet[2]:get().g, menu.arrows_color_teamskeet[2]:get().b }
        
            if not localplayer_info.inverter then
                render.text(funcs.fonts.teamskeetarrows, vector(x / 2 - 43, y / 2 - 12), color(colors_desync[1], colors_desync[2], colors_desync[3], 255), '', '|')
                render.text(funcs.fonts.teamskeetarrows, vector(x / 2 + 35, y / 2 - 12), color(35, 35, 35, 150), '', '|')
            else 
                render.text(funcs.fonts.teamskeetarrows, vector(x / 2 - 43, y / 2 - 12), color(35, 35, 35, 150), '', '|')
                render.text(funcs.fonts.teamskeetarrows, vector(x / 2 + 35, y / 2 - 12), color(colors_desync[1], colors_desync[2], colors_desync[3], 255), '', '|')
            end
        
            selectedmanualcolor = color(menu.arrows_color_teamskeet[1]:get().r, menu.arrows_color_teamskeet[1]:get().g, menu.arrows_color_teamskeet[1]:get().b, 255)
            
            render.poly(color(35, 35, 35, 150), vector(x / 2 - 55, y / 2), vector(x / 2 - 42, y / 2 - 8), vector(x / 2 - 42, y / 2 + 10))
            render.poly(color(35, 35, 35, 150), vector(x / 2 + 55, y / 2), vector(x / 2 + 42, y / 2 - 8), vector(x / 2 + 42, y / 2 + 10))

            if is_manual_left then
                render.poly(selectedmanualcolor, vector(x / 2 - 55, y / 2), vector(x / 2 - 42, y / 2 - 8), vector(x / 2 - 42, y / 2 + 10))
            end
            
            if is_manual_right then
                render.poly(selectedmanualcolor, vector(x / 2 + 55, y / 2), vector(x / 2 + 42, y / 2 - 8), vector(x / 2 + 42, y / 2 + 10))
            end
        end
    end,

    crosshair = function()
        if not menu.visuals.tweakers:get(1) then return end

        local localplayer = entity.get_local_player()
        if not localplayer then return end
        if not localplayer:is_alive() then return end

        if menu.indicators_theme:get() == 'Technology' then
            
            local maincolor = { menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b }
            local index = 10
            local is_scoped = localplayer['m_bIsScoped']
            local scope_val = 34
            local scoped_anim = string.format('%.0f', animation.new('scoped_anim', is_scoped and scope_val or 0, 0.1))
            --'solar.tech°'
            local alphaname = animation.new('alphaname', menu.visuals.crosshair:get(1) and 1 or 0, 0.1)
            local colsolar = animation.new('colsolar', (localplayer_info.inverter == true) and color(maincolor[1], maincolor[2], maincolor[3], 255) or color(255, 255, 255, 255), 0.1)
            local coltech = animation.new('coltech', (localplayer_info.inverter == false) and color(maincolor[1], maincolor[2], maincolor[3], 255) or color(255, 255, 255, 255), 0.1)
            render.text(funcs.fonts.skeet_bold, vector(render.screen_size().x / 2 - (render.measure_text(funcs.fonts.skeet_bold, '', 'tech°').x / 2 - scoped_anim), (render.screen_size().y / 2) + 10 + menu.y_move:get() + index), color(colsolar.r, colsolar.g, colsolar.b, 255*alphaname), 'c', 'solar.')
            render.text(funcs.fonts.skeet_bold, vector(render.screen_size().x / 2 + (render.measure_text(funcs.fonts.skeet_bold, '', 'solar.').x / 2 + scoped_anim), (render.screen_size().y / 2) + 10 + menu.y_move:get() + index), color(coltech.r, coltech.g, coltech.b, 255*alphaname), 'c', 'tech°')
            local index = index + 10

            local alphastate = animation.new('alphastate', menu.visuals.crosshair:get(3) and 1 or 0, 0.1)
            crosshair.indicator('·  ' .. var.player_states[var.plr_state] .. '  ·', 255, 255, 255, 255*alphastate, scoped_anim, index, true)
            if menu.visuals.crosshair:get(3) then index = index + 9 end

            local alphadt = animation.new('alphadt', (menu.visuals.crosshair:get(4) and cheat.doubletap:get()) and 1 or 0, 0.15)
            local coldt = animation.new('coldt', (rage.exploit:get() == 1) and color(255, 255, 255, 255) or color(255, 0, 50, 255), 0.1)
            crosshair.indicator('RAPID', coldt.r, coldt.g, coldt.b, 255*alphadt, scoped_anim, index, true)
            if menu.visuals.crosshair:get(4) and cheat.doubletap:get() then index = index + 9 end

            local alphahs = animation.new('alphahs', (menu.visuals.crosshair:get(5) and cheat.hideshots:get()) and 1 or 0, 0.08)
            local colhs = animation.new('colhs', (cheat.doubletap:get() or cheat.fakeduck:get()) and color(255, 0, 50, 255) or color(255, 255, 255, 255), 0.1)
            crosshair.indicator('ONSHOT', colhs.r, colhs.g, colhs.b, 255*alphahs, scoped_anim, index, true)
            if menu.visuals.crosshair:get(5) and cheat.hideshots:get() then index = index + 9 end

            local alphafd = animation.new('alphafd', (menu.visuals.crosshair:get(6) and cheat.fakeduck:get()) and 1 or 0, 0.1)
            crosshair.indicator('DUCK', 255, 255, 255, 255*alphafd, scoped_anim, index, true)
            if menu.visuals.crosshair:get(6) and cheat.fakeduck:get() then index = index + 9 end

            local alphabaim = animation.new('alphabaim', (menu.visuals.crosshair:get(7) and cheat.bodyaim:get() == 'Force') and 1 or 0, 0.1)
            crosshair.indicator('BAIM', 255, 255, 255, 255*alphabaim, scoped_anim, index, true)
            if menu.visuals.crosshair:get(7) and cheat.bodyaim:get() == 'Force' then index = index + 9 end

            local alphasafe = animation.new('alphasafe', (menu.visuals.crosshair:get(8) and cheat.safepoint:get() == 'Force') and 1 or 0, 0.1)
            crosshair.indicator('SAFE', 255, 255, 255, 255*alphasafe, scoped_anim, index, true)
            if menu.visuals.crosshair:get(8) and cheat.safepoint:get() == 'Force' then index = index + 9 end
            
        end

        if menu.indicators_theme:get() == 'Original' then
        
            local index = 0
            local animate_scope = 5
            local y_speed = 0.1
            local is_scoped = localplayer['m_bIsScoped']
            local yaw_line = string.format('%.0f', math.min(60, math.abs(localplayer_info.real_yaw))) + 2

            local alphaname = animation.new('alphaname', menu.visuals.crosshair:get(1) and 1 or 0, 0.1)
            local animname = string.format('%.0f', animation.new('animname', (menu.visuals.crosshair:get(1)) and 9 or 0, y_speed))
            local scopeanim = string.format('%.0f', animation.new('scopeanim', is_scoped and (render.measure_text(2, 'c', 'SOLAR.TECH').x / 2) + animate_scope or 0, 0.1))
            local index = index + animname
            crosshair.indicator('SOLAR.TECH', 255, 255, 255, 255*alphaname, scopeanim, index, true)

            local alphaline = animation.new('alphaline', (menu.visuals.crosshair:get(2) and menu.visuals.crosshair:get(1)) and 1 or 0, 0.1)
            local animline = string.format('%.0f', animation.new('animline', (menu.visuals.crosshair:get(2)) and 6 or 0, y_speed))
            local scopeline = string.format('%.0f', animation.new('scopeline', is_scoped and (render.measure_text(2, 'c', 'SOLAR.TECH').x / 2) + animate_scope or 0, 0.1))
            local index = index + animline
            crosshair.line(render.measure_text(2, 'c', 'SOLAR.TECH').x, yaw_line, scopeline, index, true, alphaline)

            --render.text(2, vector(render.screen_size().x / 2 + (yaw_line / 4) + scopeline, render.screen_size().y / 2 + index + 5), color(255, 255, 255, 255), '', string.format('%.0f', math.min(60, math.abs(localplayer_info.real_yaw))))

            local alphastate = animation.new('alphastate', menu.visuals.crosshair:get(3) and 1 or 0, 0.1)
            local animstate = string.format('%.0f', animation.new('animstate', (menu.visuals.crosshair:get(3)) and 9 or 0, y_speed))
            local scopestate = string.format('%.0f', animation.new('scopestate', is_scoped and (render.measure_text(2, 'c', var.player_states[var.plr_state]).x / 2) + animate_scope or 0, 0.1))
            local index = index + animstate
            crosshair.indicator(var.player_states[var.plr_state], 255, 255, 255, 255*alphastate, scopestate, index, true)

            local alphadt = animation.new('alphadt', (menu.visuals.crosshair:get(4) and cheat.doubletap:get()) and 1 or 0, 0.08)
            local animdt = string.format('%.0f', animation.new('animdt', (cheat.doubletap:get() and menu.visuals.crosshair:get(4)) and 9 or 0, y_speed)) 
            local scopedt = string.format('%.0f', animation.new('scopedt', is_scoped and (6) + animate_scope or 0, 0.1))
            local coldt = animation.new('coldt', (rage.exploit:get() == 1) and color(147, 195, 13, 255) or color(255, 0, 50, 255), 0.1)
            local index = index + animdt 
            crosshair.indicator('DT', coldt.r, coldt.g, coldt.b, 255*alphadt, scopedt, index, true)
            
            local alphahs = animation.new('alphahs', (menu.visuals.crosshair:get(5) and cheat.hideshots:get()) and 1 or 0, 0.08)
            local animhs = string.format('%.0f', animation.new('animhs', (menu.visuals.crosshair:get(5) and cheat.hideshots:get()) and 9 or 0, y_speed)) 
            local scopehs = string.format('%.0f', animation.new('scopehs', is_scoped and (6) + animate_scope or 0, 0.1))
            local colhs = animation.new('colhs', (cheat.doubletap:get() or cheat.fakeduck:get()) and color(255, 0, 50, 255) or color(255, 255, 255, 255), 0.1)
            local index = index + animhs 
            crosshair.indicator('HS', colhs.r, colhs.g, colhs.b, 255*alphahs, scopehs, index, true)

            local alphafd = animation.new('alphafd', (menu.visuals.crosshair:get(6) and cheat.fakeduck:get()) and 1 or 0, 0.1)
            local animfd = string.format('%.0f', animation.new('animfd', (menu.visuals.crosshair:get(6) and cheat.fakeduck:get()) and 9 or 0, y_speed))
            local scopefd = string.format('%.0f', animation.new('scopefd', is_scoped and (render.measure_text(2, 'c', 'DUCK').x / 2) + animate_scope or 0, 0.1))
            local index = index + animfd
            crosshair.indicator('DUCK', 255, 255, 255, 255*alphafd, scopefd, index, true)

            local alphabaim = animation.new('alphabaim', (menu.visuals.crosshair:get(7) and cheat.bodyaim:get() == 'Force') and 1 or 0, 0.1)
            local animbaim = string.format('%.0f', animation.new('animbaim', (menu.visuals.crosshair:get(7) and cheat.bodyaim:get() == 'Force') and 9 or 0, y_speed))
            local scopebaim = string.format('%.0f', animation.new('scopebaim', is_scoped and (render.measure_text(2, 'c', 'BAIM').x / 2) + animate_scope or 0, 0.1))
            local index = index + animbaim
            crosshair.indicator('BAIM', 255, 255, 255, 255*alphabaim, scopebaim, index, true)

            local alphasafe = animation.new('alphasafe', (menu.visuals.crosshair:get(8) and cheat.safepoint:get() == 'Force') and 1 or 0, 0.1)
            local animsafe = string.format('%.0f', animation.new('animsafe', (menu.visuals.crosshair:get(8) and cheat.safepoint:get() == 'Force') and 9 or 0, y_speed))
            local scopesafe = string.format('%.0f', animation.new('scopesafe', is_scoped and (render.measure_text(2, 'c', 'SAFE').x / 2) + animate_scope or 0, 0.1))
            local index = index + animsafe
            crosshair.indicator('SAFE', 255, 255, 255, 255*alphasafe, scopesafe, index, true)
        end
        
    end,

    feature = function()
        if not menu.visuals.tweakers:get(2) then return end

        if menu.feature_theme:get() == 'Default' then

            local xtazst = 0
            local localplayer = entity.get_local_player()
            if not localplayer then return end
            local dmgcol = { menu.dmgcolor:get().r, menu.dmgcolor:get().g, menu.dmgcolor:get().b, menu.dmgcolor:get().a }
            local hccol = { menu.hccolor:get().r, menu.hccolor:get().g, menu.hccolor:get().b, menu.hccolor:get().a }
            local player_resource = localplayer:get_resource()
            local ping = player_resource['m_iPing']
            local delta = (math.abs(ping % 360)) / (cheat.pingspike:get() / 4)
            if delta > 1 then delta = 1 end
            local dsy_delta = string.format('%.0f', math.min(60, math.abs(localplayer_info.real_yaw))) / 58
            local fr, fg, fb = (132 * dsy_delta) + (250 * (1 - dsy_delta)), (196 * dsy_delta) + (15 * (1 - dsy_delta)), (20 * dsy_delta) + (15 * (1 - dsy_delta))
            local pr, pg, pb = (132 * delta) + (255 * (1 - delta)), (196 * delta) + (255 * (1 - delta)), (20 * delta) + (255 * (1 - delta))

            if (menu.visuals.feature:get(10) and localplayer:is_alive()) then
                if cheat.dormantaim:get() then
                    feature.indicator(132, 196, 20, 255, 'DA', xtazst)
                    xtazst = xtazst + 1
                end
            end

            if (menu.visuals.feature:get(12) and localplayer:is_alive()) then
                lagcomp.r, lagcomp.g, lagcomp.b, lagcomp.a = 240, 15, 15, 240

                if lagcomp.lc then
                    lagcomp.r, lagcomp.g, lagcomp.b = 132, 196, 20
                end

                if var.in_air == 1 and math.sqrt(localplayer.m_vecVelocity.x ^ 2 + localplayer.m_vecVelocity.y ^ 2) > 240 then
                    feature.indicator(lagcomp.r, lagcomp.g, lagcomp.b, lagcomp.a, 'LC', xtazst) 
                    xtazst = xtazst + 1
                end
            end

            if (menu.visuals.feature:get(13) and localplayer:is_alive()) then
                feature.indicator(fr, fg, fb, 255, 'FAKE', xtazst) 
                xtazst = xtazst + 1
            end

            if menu.visuals.feature:get(9) and cheat.hideshots:get() and localplayer:is_alive() then
                if cheat.doubletap:get() or cheat.fakeduck:get() then
                    feature.indicator(255, 0, 50, 255, 'ONSHOT', xtazst)
                else
                    feature.indicator(132, 196, 20, 255, 'ONSHOT', xtazst)
                end
                xtazst = xtazst + 1
            end

            if (menu.visuals.feature:get(8) and localplayer:is_alive()) then
                local overridingdamage = false
                local binds = ui.get_binds()
                for table_index, i in ipairs(binds) do
                    if (i.name == 'Minimum Damage') then
                        if (i.active) then
                            overridingdamage = true
                        end
                    end
                end

                if menu.dmgtype:get() == 'On hotkey' and overridingdamage then 
                    feature.indicator(dmgcol[1], dmgcol[2], dmgcol[3], dmgcol[4], menu.dmgtext:get() .. cheat.mindamage:get(), xtazst)
                    xtazst = xtazst + 1
                elseif menu.dmgtype:get() == 'Always on' then
                    feature.indicator(dmgcol[1], dmgcol[2], dmgcol[3], dmgcol[4], menu.dmgtext:get() .. cheat.mindamage:get(), xtazst)
                    xtazst = xtazst + 1
                end
            end

            if (menu.visuals.feature:get(11) and localplayer:is_alive()) then
                local overridinghitchance = false
                local binds = ui.get_binds()
                for table_index, i in ipairs(binds) do
                    if (i.name == 'Hit Chance') then
                        if (i.active) then
                            overridinghitchance = true
                        end
                    end
                end

                if menu.hctype:get() == 'On hotkey' and overridinghitchance then 
                    feature.indicator(hccol[1], hccol[2], hccol[3], hccol[4], menu.hctext:get() .. cheat.hitchance:get(), xtazst)
                    xtazst = xtazst + 1
                elseif menu.hctype:get() == 'Always on' then
                    feature.indicator(hccol[1], hccol[2], hccol[3], hccol[4], menu.hctext:get() .. cheat.hitchance:get(), xtazst)
                    xtazst = xtazst + 1
                end
            end

            if (cheat.pingspike:get() > 0 and menu.visuals.feature:get(3) and localplayer:is_alive()) then
                feature.indicator(pr, pg, pb, 255, 'PING', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.fakeduck:get() and menu.visuals.feature:get(5) and localplayer:is_alive()) then
                feature.indicator(255, 255, 255, 200, 'DUCK', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.safepoint:get() == 'Force' and menu.visuals.feature:get(1) and localplayer:is_alive()) then
                feature.indicator(225, 225, 225, 255, 'SAFE', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.bodyaim:get() == 'Force' and menu.visuals.feature:get(2) and localplayer:is_alive()) then
                feature.indicator(225, 225, 225, 255, 'BODY', xtazst)
                xtazst = xtazst + 1
            end

            if (cheat.freestand:get() and menu.visuals.feature:get(6) and localplayer:is_alive()) then
                feature.indicator(225, 225, 225, 255, 'FS', xtazst)
                xtazst = xtazst + 1
            end

            if menu.visuals.feature:get(7) then
                local c4 = entity.get_entities(129, true)[1]
                if c4 ~= nil then
                    local time = ((c4['m_flC4Blow'] - globals.curtime)*10) / 10
                    local timer = string.format('%.1f', time)
                    local defused = c4['m_bBombDefused'] 
                    if math.floor(timer) > 0 and not defused then
                        if localplayer:is_alive() then
                            local bombsite = c4['m_nBombSite'] == 0 and 'A' or 'B'
                            local health = localplayer['m_iHealth']
                            local armor = localplayer['m_ArmorValue']
                            local willKill = false
                            local eLoc = c4['m_vecOrigin']
                            local lLoc = localplayer['m_vecOrigin']
                            local distance = funcs.calcdist(eLoc, lLoc)
                            local a = 450.7
                            local b = 75.68
                            local c = 789.2
                            local d = (distance - b) / c;
                            local damage = a * math.exp(-d * d)
                            if armor > 0 then
                                local newDmg = damage * 0.5;

                                local armorDmg = (damage - newDmg) * 0.5
                                if armorDmg > armor then
                                    armor = armor * (1 / .5)
                                    newDmg = damage - armorDmg
                                end
                                damage = newDmg;
                            end
                            local dmg = math.ceil(damage)
                            if dmg >= health then
                                willKill = true
                            else
                                willKill = false
                            end
                            feature.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                            xtazst = xtazst + 1
                            if localplayer then
                                if willKill == true then
                                    feature.indicator(225, 0, 50, 255, 'FATAL', xtazst)
                                    xtazst = xtazst + 1
                                elseif damage > 0.5 then
                                    feature.indicator(210, 216, 112, 255, '-' ..dmg.. ' HP', xtazst)
                                    xtazst = xtazst + 1
                                end
                            end
                        else
                            local bombsite = c4['m_nBombSite'] == 0 and 'A' or 'B'
                            local spec_mode = localplayer['m_iObserverMode']
                            local spec_target = localplayer['m_hObserverTarget']
                            local allow_draw_bomb = true
                            if spec_mode == 6 then allow_draw_bomb = false else allow_draw_bomb = true end
                            if spec_target ~= nil then
                                if spec_target and spec_target:is_player() and allow_draw_bomb then
                                    local health = spec_target['m_iHealth']
                                    local armor = spec_target['m_ArmorValue']
                                    local willKill = false
                                    local eLoc = c4['m_vecOrigin']
                                    local lLoc = spec_target['m_vecOrigin']
                                    local distance = funcs.calcdist(eLoc, lLoc)
                                    local a = 450.7
                                    local b = 75.68
                                    local c = 789.2
                                    local d = (distance - b) / c;
                                    local damage = a * math.exp(-d * d)
                                    if armor > 0 then
                                        local newDmg = damage * 0.5;
                                        local armorDmg = (damage - newDmg) * 0.5
                                        if armorDmg > armor then
                                            armor = armor * (1 / .5)
                                            newDmg = damage - armorDmg
                                        end
                                        damage = newDmg;
                                    end
                                    local dmg = math.ceil(damage)
                                    if dmg >= health then
                                        willKill = true
                                    else
                                        willKill = false
                                    end
                                    feature.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                                    xtazst = xtazst + 1
                                    if localplayer then
                                        if willKill == true then
                                            feature.indicator(225, 0, 50, 255, 'FATAL', xtazst)
                                            xtazst = xtazst + 1
                                        elseif damage > 0.5 then
                                            feature.indicator(210, 216, 112, 255, '-' ..dmg.. ' HP', xtazst)
                                            xtazst = xtazst + 1
                                        end
                                    end
                                elseif not allow_draw_bomb then
                                    feature.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                                    xtazst = xtazst + 1
                                end
                            end
                        end
                    end
                end

                if planting then
                    feature.indicator(210, 216, 112, 255, planting_site, xtazst)
                    fill = 3.125 - (3.125 + on_plant_time - globals.curtime)
                    if(fill > 3.125) then
                        fill = 3.125
                    end

                    ts = render.measure_text(funcs.fonts.feature, '', planting_site).x
                    render.circle_outline(vector(19 + ts + 17, render.screen_size().y - 333 - xtazst * 37), color(0, 0, 0, 255), 10, 0, 1, 5)
                    render.circle_outline(vector(19 + ts + 17, render.screen_size().y - 333 - xtazst * 37), color(235, 235, 235, 255), 9, 0, (fill / 3.3), 3)
                    xtazst = xtazst + 1
                end
            end

            if menu.visuals.feature:get(4) and cheat.doubletap:get() and localplayer:is_alive() then
                if (rage.exploit:get() == 1) then
                    feature.indicator(225, 225, 225, 255, 'DT', xtazst)
                else
                    feature.indicator(255, 0, 50, 255, 'DT', xtazst)
                end
                xtazst = xtazst + 1
            end

        elseif menu.feature_theme:get() == 'Legacy' then
            
        local xtazst = 0
        local localplayer = entity.get_local_player()
        if not localplayer then return end
        local dmgcol = { menu.dmgcolor:get().r, menu.dmgcolor:get().g, menu.dmgcolor:get().b, menu.dmgcolor:get().a }
        local hccol = { menu.hccolor:get().r, menu.hccolor:get().g, menu.hccolor:get().b, menu.hccolor:get().a }
        local player_resource = localplayer:get_resource()
        local ping = player_resource['m_iPing']
        local delta = (math.abs(ping % 360)) / (cheat.pingspike:get() / 4)
        if delta > 1 then delta = 1 end
        local dsy_delta = string.format('%.0f', math.min(60, math.abs(localplayer_info.real_yaw))) / 58
        local pr, pg, pb = (132 * delta) + (250 * (1 - delta)), (196 * delta) + (15 * (1 - delta)), (20 * delta) + (15 * (1 - delta))
        local fr, fg, fb = (132 * dsy_delta) + (250 * (1 - dsy_delta)), (196 * dsy_delta) + (15 * (1 - dsy_delta)), (20 * dsy_delta) + (15 * (1 - dsy_delta))

        if (menu.visuals.feature:get(10) and localplayer:is_alive()) then
            if cheat.dormantaim:get() then
                legacy.indicator(132, 196, 20, 255, 'DA', xtazst)
                xtazst = xtazst + 1
            end
        end

        if menu.visuals.feature:get(9) and cheat.hideshots:get() and localplayer:is_alive() then
            if cheat.doubletap:get() or cheat.fakeduck:get() then
                legacy.indicator(240, 15, 15, 255, 'ONSHOT', xtazst)
            else
                legacy.indicator(132, 196, 20, 255, 'ONSHOT', xtazst)
            end
            xtazst = xtazst + 1
        end

        if (menu.visuals.feature:get(8) and localplayer:is_alive()) then
            local overridingdamage = false
            local binds = ui.get_binds()
            for table_index, i in ipairs(binds) do
                if (i.name == 'Minimum Damage') then
                    if (i.active) then
                        overridingdamage = true
                    end
                end
            end

            if menu.dmgtype:get() == 'On hotkey' and overridingdamage then 
                legacy.indicator(dmgcol[1], dmgcol[2], dmgcol[3], dmgcol[4], menu.dmgtext:get() .. cheat.mindamage:get(), xtazst)
                xtazst = xtazst + 1
            elseif menu.dmgtype:get() == 'Always on' then
                legacy.indicator(dmgcol[1], dmgcol[2], dmgcol[3], dmgcol[4], menu.dmgtext:get() .. cheat.mindamage:get(), xtazst)
                xtazst = xtazst + 1
            end
        end

        if (menu.visuals.feature:get(11) and localplayer:is_alive()) then
            local overridinghitchance = false
            local binds = ui.get_binds()
            for table_index, i in ipairs(binds) do
                if (i.name == 'Hit Chance') then
                    if (i.active) then
                        overridinghitchance = true
                    end
                end
            end

            if menu.hctype:get() == 'On hotkey' and overridinghitchance then 
                legacy.indicator(hccol[1], hccol[2], hccol[3], hccol[4], menu.hctext:get() .. cheat.hitchance:get(), xtazst)
                xtazst = xtazst + 1
            elseif menu.hctype:get() == 'Always on' then
                legacy.indicator(hccol[1], hccol[2], hccol[3], hccol[4], menu.hctext:get() .. cheat.hitchance:get(), xtazst)
                xtazst = xtazst + 1
            end
        end

        if (cheat.pingspike:get() > 0 and menu.visuals.feature:get(3) and localplayer:is_alive()) then
            legacy.indicator(pr, pg, pb, 255, 'PING', xtazst)
            xtazst = xtazst + 1
        end

        if (cheat.fakeduck:get() and menu.visuals.feature:get(5) and localplayer:is_alive()) then
            legacy.indicator(255, 255, 255, 200, 'DUCK', xtazst)
            xtazst = xtazst + 1
        end

        if (cheat.safepoint:get() == 'Force' and menu.visuals.feature:get(1) and localplayer:is_alive()) then
            legacy.indicator(225, 225, 225, 255, 'SAFE', xtazst)
            xtazst = xtazst + 1
        end

        if (cheat.bodyaim:get() == 'Force' and menu.visuals.feature:get(2) and localplayer:is_alive()) then
            legacy.indicator(225, 225, 225, 255, 'BODY', xtazst)
            xtazst = xtazst + 1
        end

        if (cheat.freestand:get() and menu.visuals.feature:get(6) and localplayer:is_alive()) then
            legacy.indicator(225, 225, 225, 255, 'FS', xtazst)
            xtazst = xtazst + 1
        end

        if menu.visuals.feature:get(7) then
            local c4 = entity.get_entities(129, true)[1]
            if c4 ~= nil then
                local time = ((c4['m_flC4Blow'] - globals.curtime)*10) / 10
                local timer = string.format('%.1f', time)
                local defused = c4['m_bBombDefused'] 
                if math.floor(timer) > 0 and not defused then
                    if localplayer:is_alive() then
                        local bombsite = c4['m_nBombSite'] == 0 and 'A' or 'B'
                        local health = localplayer['m_iHealth']
                        local armor = localplayer['m_ArmorValue']
                        local willKill = false
                        local eLoc = c4['m_vecOrigin']
                        local lLoc = localplayer['m_vecOrigin']
                        local distance = funcs.calcdist(eLoc, lLoc)
                        local a = 450.7
                        local b = 75.68
                        local c = 789.2
                        local d = (distance - b) / c;
                        local damage = a * math.exp(-d * d)
                        if armor > 0 then
                            local newDmg = damage * 0.5;

                            local armorDmg = (damage - newDmg) * 0.5
                            if armorDmg > armor then
                                armor = armor * (1 / .5)
                                newDmg = damage - armorDmg
                            end
                            damage = newDmg;
                        end
                        local dmg = math.ceil(damage)
                        if dmg >= health then
                            willKill = true
                        else
                            willKill = false
                        end
                        legacy.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                        xtazst = xtazst + 1
                        if localplayer then
                            if willKill == true then
                                legacy.indicator(225, 0, 50, 255, 'FATAL', xtazst)
                                xtazst = xtazst + 1
                            elseif damage > 0.5 then
                                legacy.indicator(210, 216, 112, 255, '-' ..dmg.. ' HP', xtazst)
                                xtazst = xtazst + 1
                            end
                        end
                    else
                        local bombsite = c4['m_nBombSite'] == 0 and 'A' or 'B'
                        local spec_mode = localplayer['m_iObserverMode']
                        local spec_target = localplayer['m_hObserverTarget']
                        local allow_draw_bomb = true
                        if spec_mode == 6 then allow_draw_bomb = false else allow_draw_bomb = true end
                        if spec_target ~= nil then
                            if spec_target and spec_target:is_player() and allow_draw_bomb then
                                local health = spec_target['m_iHealth']
                                local armor = spec_target['m_ArmorValue']
                                local willKill = false
                                local eLoc = c4['m_vecOrigin']
                                local lLoc = spec_target['m_vecOrigin']
                                local distance = funcs.calcdist(eLoc, lLoc)
                                local a = 450.7
                                local b = 75.68
                                local c = 789.2
                                local d = (distance - b) / c;
                                local damage = a * math.exp(-d * d)
                                if armor > 0 then
                                    local newDmg = damage * 0.5;
                                    local armorDmg = (damage - newDmg) * 0.5
                                    if armorDmg > armor then
                                        armor = armor * (1 / .5)
                                        newDmg = damage - armorDmg
                                    end
                                    damage = newDmg;
                                end
                                local dmg = math.ceil(damage)
                                if dmg >= health then
                                    willKill = true
                                else
                                    willKill = false
                                end
                                legacy.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                                xtazst = xtazst + 1
                                if localplayer then
                                    if willKill == true then
                                        legacy.indicator(225, 0, 50, 255, 'FATAL', xtazst)
                                        xtazst = xtazst + 1
                                    elseif damage > 0.5 then
                                        legacy.indicator(210, 216, 112, 255, '-' ..dmg.. ' HP', xtazst)
                                        xtazst = xtazst + 1
                                    end
                                end
                            elseif not allow_draw_bomb then
                                legacy.indicator(225, 225, 225, 255, bombsite .. ' - '..string.format('%.1f', timer) .. 's', xtazst)
                                xtazst = xtazst + 1
                            end
                        end
                    end
                end
            end

            if planting then
                legacy.indicator(210, 216, 112, 255, planting_site, xtazst)
                fill = 3.125 - (3.125 + on_plant_time - globals.curtime)
                if(fill > 3.125) then
                    fill = 3.125
                end

                ts = render.measure_text(funcs.fonts.legacy, '', planting_site).x
                render.circle_outline(vector(10 + ts + 17, render.screen_size().y - 55 - xtazst * 30), color(0, 0, 0, 255), 10, 0, 1, 5)
                render.circle_outline(vector(10 + ts + 17, render.screen_size().y - 55 - xtazst * 30), color(235, 235, 235, 255), 9, 0, (fill / 3.3), 3)
                xtazst = xtazst + 1
            end
        end

        if (menu.visuals.feature:get(12) and localplayer:is_alive()) then
            lagcomp.r, lagcomp.g, lagcomp.b, lagcomp.a = 240, 15, 15, 240

            if lagcomp.lc then
                lagcomp.r, lagcomp.g, lagcomp.b = 132, 196, 20
            end

            if var.in_air == 1 and math.sqrt(localplayer.m_vecVelocity.x ^ 2 + localplayer.m_vecVelocity.y ^ 2) > 240 then
                legacy.indicator(lagcomp.r, lagcomp.g, lagcomp.b, lagcomp.a, 'LC', xtazst) 
                xtazst = xtazst + 1
            end
        end
        
        if (menu.visuals.feature:get(13) and localplayer:is_alive()) then
            legacy.indicator(fr, fg, fb, 255, 'FAKE', xtazst)
            xtazst = xtazst + 1
        end

        if menu.visuals.feature:get(4) and cheat.doubletap:get() and localplayer:is_alive() then
            if (rage.exploit:get() == 1) then
                legacy.indicator(132, 196, 20, 255, 'DT', xtazst)
            else
                legacy.indicator(240, 15, 15, 240, 'DT', xtazst)
            end
            xtazst = xtazst + 1
        end
        end
    end,

    solus_watermark = function()

        if not menu.visuals.elements:get(1) then return end
        local time = common.get_system_time()
        if time.hours < 10 then time.hours = '0' .. time.hours end
        if time.minutes < 10 then time.minutes = '0' .. time.minutes end
        if time.seconds < 10 then time.seconds = '0' .. time.seconds end
    
        local rightpadding = 12
        local vara = render.screen_size().x - var.textsize - rightpadding
        local x = vara - 18
        local y = 7
        local smth = 1
        local w = var.textsize + 20
        local h = y + 9    
        local start_position = x - 22
        local localplayer = entity.get_local_player()
        local actual_time = ("%02d:%02d:%02d"):format(time.hours, time.minutes, time.seconds) -- EngineClient.GetNetChannelInfo():GetLatency(0)
        if entity.get_local_player() == nil then latency = 0 else latency = string.format("%1.f", math.max(0.0, utils.net_channel():get_packet_response_latency(0, 0))) end
        if latency == nil then latency = 0 end
    
        local cheattext = 'solar.tech'
        local usertext = lua.username
    
        if menu.ui_usertext:get() == '' then usertext = lua.username else usertext = menu.ui_usertext:get() end
        if menu.ui_cheattext:get() == '' then cheattext = 'neverlose' else cheattext = menu.ui_cheattext:get() end
    
        local cheatsize = render.measure_text(1, 'r', cheattext).x - 2

        if menu.solus_theme:get() == 'v1' then
            nexttext = (cheattext .. " | %s | delay: %sms | %s "):format(usertext, latency, actual_time)
        elseif menu.solus_theme:get() == 'v2' then 
            nexttext = (cheattext .. "  %s  delay: %sms  %s "):format(usertext, latency, actual_time)
        elseif menu.solus_theme:get() == 'solar.tech' then 
            nexttext = (cheattext .. " | %s | delay: %sms | %s "):format(usertext, latency, actual_time)
        end
        
        if menu.solus_theme:get() == 'v1' then
            render.rect(vector(x + 10, y + 1), vector(x + var.textsize + 20, h - 6), color(menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, 255), 0, true)
            render.rect(vector(x + 10, y + 2 + 1), vector(x + var.textsize + 20, h + 12), color(18, 18, 18, menu.ui_accent_color:get().a), 0, true)
            render.text(1, vector(vara / smth - 3, y + 5), color(255, 255, 255, 255), '', nexttext)
        elseif menu.solus_theme:get() == 'v2' then 
            funcs.container(x + 10, y + 3, var.textsize + 7, 19, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
            render.text(1, vector(vara / smth - 3, y + 6), color(255, 255, 255, 255), '', nexttext)
        elseif menu.solus_theme:get() == 'solar.tech' then 
            funcs.container2(x + 10, y + 3, var.textsize + 7, 19, menu.ui_accent_color:get().r, menu.ui_accent_color:get().g, menu.ui_accent_color:get().b, menu.ui_accent_color:get().a, 1)
            render.text(1, vector(vara / smth - 3, y + 6), color(255, 255, 255, 255), '', nexttext)
        
        end
    
        local wide = render.measure_text(1, 'r', nexttext) - 2
        vara = vara + wide.x
        var.textsize = vara - (render.screen_size().x - var.textsize - rightpadding)
    end,

    solus_keybinds = function()
        if not menu.visuals.elements:get(3) then return end

        local x_k, y_k = menu.ui_keybinds_x:get(), menu.ui_keybinds_y:get()
        local max_width = 0
        local frametime = globals.frametime * 16
        local add_y = 0
        local total_width = 66
        local active_binds = {}
        local bind = funcs.getbinds()
    
        for i = 1, #bind do
            local binds = bind[i]
            local bind_name = keybind_names[binds.name] == nil and funcs.upper_to_lower(binds.name) or keybind_names[binds.name]
            local bind_state = binds.mode

            if bind_state == 2 then
                bind_state = "toggled"
            elseif bind_state == 1 then
                bind_state = "holding"
            end
        
            if data_k[bind_name] == nil then
                data_k[bind_name] = {alpha_k = 0}
            end
    
            local bind_state_size = render.measure_text(1, '', bind_state)
            local bind_name_size = render.measure_text(1, '', bind_name)
    
            data_k[bind_name].alpha_k = funcs.lerp(frametime, data_k[bind_name].alpha_k, binds.active and 1 or 0)
    
            render.text(1, vector(x_k+3, y_k + 20 + string.format('%.0f', add_y)), color(255, 255, 255, data_k[bind_name].alpha_k*255), '', bind_name)
            render.text(1, vector(x_k + (string.format('%.0f', width_ka) - bind_state_size.x - 8), y_k + 20 + string.format('%.0f', add_y)) , color(255, 255, 255, data_k[bind_name].alpha_k*255), '', '['..bind_state..']')
    
            add_y = add_y + 14 * data_k[bind_name].alpha_k
    
            local width_k = bind_state_size.x + bind_name_size.x + 23
            if width_k > 123 then
                if width_k > max_width then
                    max_width = width_k
                end
            end
    
            if binds.active then
                table.insert(active_binds, binds)
            end
        end
    
        alpha_k = funcs.lerp(frametime, alpha_k, (ui.get_alpha() > 0 or #active_binds > 0) and 1 or 0)
        width_ka = funcs.lerp(frametime, width_ka, math.max(max_width, 123))
    
        if ui.get_alpha() > 0 or #active_binds > 0 then
        renders.conteiner(x_k, y_k, string.format('%.0f', width_ka), 19, 'keybinds', 11, 1)
            local mouse = ui.get_mouse_position()
            if common.is_button_down(1) and drag_s == false then
                if mouse.x >= x_k and mouse.y >= y_k and mouse.x <= x_k + width_ka and mouse.y <= y_k + 18 or drag then
                    if not drag then
                        drag = true
                    else
                        menu.ui_keybinds_x:set(mouse.x - math.floor(width_ka / 2))
                        menu.ui_keybinds_y:set(mouse.y - 8)
                    end
                end
            else
                drag = false
            end
        end
    end,

    solus_spectators = function()
        if not menu.visuals.elements:get(2) then return end

        local spectators = funcs.info_spectators()
        local local_player = entity.get_local_player()
        
        if not globals.is_connected or spectators == nil or entity.get_local_player() == nil then return end
        local add_y = 0
        local max_width = 0
        local active_spec = {}
        local frametime = globals.frametime * 16
        
        if spectators ~= nil then
            local currentIndex = 1
            if spectators ~= nil then
                for i = 1, #spectators do
                    v = spectators[i]
                    local name_size = render.measure_text(1, '', v.name)
                    if data_s[v.name] == nil then
                        data_s[v.name] = {alpha_s = 0}
                    end
                        
                    data_s[v.name].alpha_s = funcs.lerp(frametime, data_s[v.name].alpha_s, dick < 1 and 1 or 0)
                    render.text(1, vector(menu.ui_spectators_x:get() + 22, menu.ui_spectators_y:get() + 21 + string.format('%.0f', add_y)), color(255, 255, 255, data_s[v.name].alpha_s*255), '', v.name)
                    render.texture(v.avatar, vector(menu.ui_spectators_x:get() + 4, menu.ui_spectators_y:get() + 21 + string.format('%.0f', add_y)), vector(12, 12), color(255, 255, 255, 255), 'f', 0)
    
                    add_y = add_y + 14 * data_s[v.name].alpha_s
                    width_s = name_size.x + 21
                    if width_s > 123 then
                        if width_s > max_width then
                            max_width = width_s
                        end
                    end
                    if dick then
                        table.insert(active_spec, dick)
                    end
                    currentIndex = currentIndex + 1
                end
            end
            local dick = #spectators
        end
        
        alpha_s = funcs.lerp(frametime, alpha_s, (ui.get_alpha() > 0 or #active_spec > 0) and 1 or 0)
        width_sa = funcs.lerp(frametime, width_sa, math.max(max_width, 123))
    
        if #active_spec > 0 or ui.get_alpha() > 0 then
            renders.conteiner(menu.ui_spectators_x:get(), menu.ui_spectators_y:get(), string.format('%.0f', width_sa), 19, 'spectators', 11, 1)
            local mouse = ui.get_mouse_position()
            if common.is_button_down(1) and ui.get_alpha() > 0 and drag == false then
                if mouse.x >= menu.ui_spectators_x:get() and mouse.y >= menu.ui_spectators_y:get() and mouse.x <= menu.ui_spectators_x:get() + 134 and mouse.y <= menu.ui_spectators_y:get() + 18 or drag_s then
                    if not drag_s then
                        drag_s = true
                    else
                        menu.ui_spectators_x:set(mouse.x - math.floor(width_sa / 2))
                        menu.ui_spectators_y:set(mouse.y - 8)
                    end
                end
            else
                drag_s = false
            end
        end
    end,

    simple_spectators = function()
        if not menu.visuals.realtweakers:get(2) then return end

        local spectators = funcs.info_spectators()
        local local_player = entity.get_local_player()
        
        if not globals.is_connected or spectators == nil or entity.get_local_player() == nil then return end
        local add_y = 0
        local max_width = 0
        local active_spec = {}
        local frametime = globals.frametime * 16
        
        if spectators ~= nil then
            local currentIndex = 1
            if spectators ~= nil then
                for i = 1, #spectators do
                    v = spectators[i]
                    
                    render.text(1, vector(render.screen_size().x - (render.measure_text(1, '', v.name).x + 10), 5 + add_y), color(255, 255, 255, 200), '', v.name)
                    
                    add_y = add_y + 18
                    if dick then
                        table.insert(active_spec, dick)
                    end
                    currentIndex = currentIndex + 1
                end
            end
            local dick = #spectators
        end
    end,

    sloweddown = function()
        if not menu.visuals.realtweakers:get(3) then return end
        local lp = entity.get_local_player()
        if not lp then return end
        if not lp:is_alive() then return end
    
        local modifier = lp.m_flVelocityModifier
        if modifier == 1 then return end
    
        local r, g, b = funcs.rgb_health_based(modifier)
        local a = funcs.remap(modifier, 1, 0, 0.85, 1)
    
        drawBar(modifier, r, g, b, a, 'Slowed down')
    end,

    viewmodel_override = function()
        if menu.misc.viewmodel:get() then
            local x1, x2, x3, x4 = menu.viewmodel_x:get(), menu.viewmodel_y:get(), menu.viewmodel_z:get(), menu.viewmodel_fov:get()
            cvar.viewmodel_offset_x:float(x1, true)
            cvar.viewmodel_offset_y:float(x2, true)
            cvar.viewmodel_offset_z:float(x3, true)
            cvar.viewmodel_fov:float(x4, true)
        else
            cvar.viewmodel_offset_x:float(localplayer_info.viewmodel_x, true)
            cvar.viewmodel_offset_y:float(localplayer_info.viewmodel_y, true)
            cvar.viewmodel_offset_z:float(localplayer_info.viewmodel_z, true)
            cvar.viewmodel_fov:float(localplayer_info.viewmodel_fov, true)
        end
    end,

    corner_logs = function()
        local screen = {render.screen_size().x, render.screen_size().y}
        for i = 1, #logs do
            if not logs[i] then return end
            if not logs[i].init then
                logs[i].y = dynamic.new(2, 1, 1, -30)
                logs[i].time = globals.tickcount + 256
                logs[i].init = true
            end


            local string_size = render.measure_text(1, '', logs[i].text_size).x
            local y_anim = string.format('%.0f', screen[2]-logs[i].y:getval()) + 8
    
            render.rect(vector(screen[1]/2-string_size/2-27, y_anim - 10), vector(screen[1]/2-string_size/2-25 + string_size+30, y_anim + 12), color(40, 40, 40, 255), 4, true)
            --render.rect_outline(vector(screen[1]/2-string_size/2-27, y_anim - 10), vector(screen[1]/2-string_size/2-25 + string_size+30, y_anim + 12), color(r, g, b, 100), 0, 4, true)
            --funcs.container(screen[1]/2-string_size/2-27, y_anim - 10, string_size+30, 24   aw, r, g, b, 85, 1)
            renders.MultiColorString(logs[i].text, screen[1]/2-20, y_anim - 6, 11, 1, true, true)
            --render.text(1, vector(screen[1]/2-20, y_anim), color(255, 255, 255, 255), 'c', logs[i].text)
            render.circle_outline(vector(screen[1]/2+string_size/2-9, y_anim + 1), color(13, 13, 13, 255), 7, 0, 1, 4)
            render.circle_outline(vector(screen[1]/2+string_size/2-9, y_anim + 1), logs[i].color, 6, 0, (logs[i].time-globals.tickcount)/256, 2)
            
            if tonumber(logs[i].time) < globals.tickcount then
                if logs[i].y:getval() < -10 then
                    table.remove(logs, i)
                else
                    logs[i].y:update(globals.frametime, -50, nil)
                end
            else
                logs[i].y:update(globals.frametime, 20+(i*28), nil)
            end
        end
    end,

    antiaim = function()
        if not menu.ragebot.builder:get() then return end

        cheat.aa_pitch:set(menu.ragebot.pitch:get())
        cheat.bodyyaw:override()
        cheat.yaw:override()
        cheat.yaw_modifier:override()
        cheat.yaw_degree:override()
        cheat.yaw_fakeopt:override()
        cheat.yaw_freestand:override()
        cheat.yaw_desync_left:override()
        cheat.yaw_desync_right:override()
        cheat.freestand:override(); 
    
        if menu.ragebot.base:get() == 'Left' then 
            aa_allowed = false; 
            cheat.yaw:set(-90); 
            if menu.static_manuals:get() then
                cheat.bodyyaw:set(true)
                cheat.yaw_degree:set(0)
                cheat.yaw_fakeopt:set('')
                cheat.yaw_freestand:set('Peek Fake')
            end
        elseif menu.ragebot.base:get() == 'Right' then 
            aa_allowed = false; 
            cheat.yaw:set(90)
            if menu.static_manuals:get() then
                cheat.bodyyaw:set(true)
                cheat.yaw_degree:set(0)
                cheat.yaw_fakeopt:set('')
                cheat.yaw_freestand:set('Peek Real')
            end
        else
            if menu.ragebot.base:get() == 'At Target' then
                cheat.yaw_set:set('Backward');
                cheat.yaw_base:set('At Target')
            elseif menu.ragebot.base:get() == 'Backward' then
                cheat.yaw_set:set('Backward');
                cheat.yaw_base:set('Local View')
            end
            aa_allowed = true 
        end
    
        if aa_allowed then
            if aa_init[var.plr_state].enable:get() then
                cheat.bodyyaw:set(true)
                cheat.yaw:set(localplayer_info.side == 1 and aa_init[var.plr_state].yaw_left:get() or aa_init[var.plr_state].yaw_right:get())
                cheat.yaw_modifier:set(aa_init[var.plr_state].yaw_modifier:get())
                cheat.yaw_degree:set(aa_init[var.plr_state].yaw_degree:get())
                cheat.yaw_fakeopt:set(aa_init[var.plr_state].yaw_fakeopt:get())
                cheat.yaw_freestand:set(aa_init[var.plr_state].yaw_freestand:get())
                cheat.yaw_desync_left:set(aa_init[var.plr_state].yaw_desync_left:get())
                cheat.yaw_desync_right:set(aa_init[var.plr_state].yaw_desync_right:get())
            end
        end
    end,

    sidewatermark = function()

        if not menu.visuals.realtweakers:get(4) then return end

        local localplayer = entity.get_local_player()
        if not localplayer then return end


        render.text(1, vector(19, 500), color(255, 255, 255, 255), '', '- solar.tech ' .. gradient_antiaim:get_animated_text() .. '\aDEFAULT technology ' .. gradient_status:get_animated_text())
        render.text(1, vector(19, 512), color(255, 255, 255, 255), '', '- user: ' .. lua.username)

        gradient_antiaim:animate()
        gradient_status:animate()
        
        --local threat = entity.get_threat()


        --render.text(1, vector(400, 400), color(255, 255, 255, 255), '', 'current threat: ' .. threat:get_name() .. ' / ' .. string.format('%0.1f', threat['m_flPoseParameter'][11] * 120 - 60))        

        --render.text(1, vector(50, 400), color(255, 255, 255, 255), '', string.format('current threat: %s | m_flPoseParameter: %s', ))

    end,

    onload = function()
        localplayer_info.viewmodel_x, localplayer_info.viewmodel_y, localplayer_info.viewmodel_z, localplayer_info.viewmodel_fov = cvar.viewmodel_offset_x:float(), cvar.viewmodel_offset_y:float(), cvar.viewmodel_offset_z:float(), cvar.viewmodel_fov:float()
       
        funcs.log('[~] Welcome back, ' .. lua.username)

        local string1 = { 
            { "Welcome back, ", color(255, 255, 255, 255) },
            { lua.username, color(142, 165, 255, 255) },
            { " ["..lua.version.."]", color(142, 165, 255, 255) },
            { "", color(0, 0, 0, 255) },
            { "", color(0, 0, 0, 255) },
            { "", color(0, 0, 0, 255) },
            { "", color(0, 0, 0, 255) },
            { "", color(0, 0, 0, 255) },
            { "", color(0, 0, 0, 255) }
        }

        table.insert(logs, {
            text = string1,
            text_size = 'Welcome back, ' .. lua.username .. ' [' .. lua.version .. ']',
            color = color(142, 165, 255, 255)
        }) 
    end

}

events.bomb_abortplant:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)

events.bomb_defused:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)

events.bomb_planted:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)

events.round_prestart:set(function(e)
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ''
end)

events.bomb_beginplant:set(function(e)
    local localplayer = entity.get_local_player()
    local player_resource = localplayer:get_resource()
    on_plant_time = globals.curtime
    planting = true
    local m_bombsiteCenterA = player_resource['m_bombsiteCenterA']
    local m_bombsiteCenterB = player_resource['m_bombsiteCenterB']
    
    local player = entity.get(e.userid, true)
    local localPos = player:get_origin()
    local dist_to_a = localPos:dist(m_bombsiteCenterA)
    local dist_to_b = localPos:dist(m_bombsiteCenterB)
    
    planting_site = dist_to_a < dist_to_b and 'Bombsite A' or 'Bombsite B'
end)

--[[events.player_death:set(function(e)
    local me = entity.get_local_player()
    local victim = entity.get(e.userid, true)
    local attacker = entity.get(e.attacker, true)

    local dead_yaw = victim['m_flPoseParameter'][11] * 120 - 60

    funcs.log_debug('[player_death] entity = <' .. victim:get_name() .. '> / m_flPoseParameter[11] = <' .. string.format('%.0f', dead_yaw) .. '>')
  
end)--]]

events.player_death:set(function(e)

    local me = entity.get_local_player()
    local victim = entity.get(e.userid, true)
    local attacker = entity.get(e.attacker, true)

    if menu.misc.tweakers:get(1) and attacker == me then
        utils.execute_after(utils.random_int(5, 8), function()
            if me:is_alive() then
                if not me then return end
                utils.console_exec('say '.. funcs.killsays[utils.random_int(1, #funcs.killsays)])
            end
        end)
    end

    if menu.misc.tweakers:get(2) and victim == me then
        utils.execute_after(utils.random_int(7, 10), function()
            if not me then return end
            utils.console_exec('say '.. funcs.deathsays[utils.random_int(1, #funcs.deathsays)])
        end)
    end

end)

events.item_purchase:set(function(e)

    if not menu.misc.logs:get(2) then return end

    local name = entity.get(e.userid, true)
    local item = e.weapon

    if not name:is_enemy() then return end
    if item == 'weapon_unknown' then return end

    funcs.log(name:get_name() .. ' bought ' .. item)
    
end)

events.aim_fire:set(function(e)
    var.shots = var.shots + 1
    aim_hitchance = math.floor(e.hitchance + 0.5) 
    damage_shot = string.format('%.0f', e.damage)
    aimed_hgroup = funcs.hitgroups[e.hitgroup]
end)

events.aim_ack:set(function(e)

    if not menu.misc.logs:get(1) then return end 
    local health = e.target['m_iHealth']
    local bodyyaw = e.target['m_flPoseParameter'][11] * 120 - 60
    
    if e.state == nil then
        local hgroup = funcs.hitgroups[e.hitgroup]
        local damage_hit = string.format('%.0f', e.damage)

        if damage_shot == damage_hit then
            dmg_info = '| '
        else
            dmg_info = '| damage: ' .. damage_shot .. ' | ' 
        end

        if aimed_hgroup == hgroup then
            aimed_info = '| '
        else
            aimed_info = '| aimed: ' .. aimed_hgroup .. ' | '
        end

        --[[funcs.log(string.format('Registered shot in %s\'s %s for %d damage [spread: %.2f° | 1:%d°] ( hitchance: %d %shistory(Δ): %d %shealth: %s )', 
            e.target:get_name(), hgroup, e.damage, e.spread, bodyyaw, e.hitchance, dmg_info, e.backtrack or 0, aimed_info, health
        ))--]]

        funcs.log_hit(e.target:get_name(), hgroup, aimed_hgroup, string.format('%.0f', e.damage), damage_shot, health, e.hitchance, e.backtrack or 0)

        if menu.visuals.realtweakers:get(1) then
            local string1 = string.format('Hit %s in the %s for %s damage (%s health remaining)', string.lower(e.target:get_name()), hgroup, e.damage, health)

            local hit_color = color(0.58 * 255, 0.78 * 255, 0.23 * 255, 255)

            local string = {
                { "Hit ", color(255, 255, 255, 255) },
                { string.lower(e.target:get_name()) .. " ", hit_color },
                { "in the ", color(255, 255, 255, 255) },
                { hgroup .." ", hit_color },
                { "for ", color(255, 255, 255, 255) },
                { e.damage .. " ", hit_color },
                { "damage ", color(255, 255, 255, 255) },
                { "(", color(255, 255, 255, 255) },
                { health .. " ", hit_color },
                { "health remaining)", color(255, 255, 255, 255) }
            }

            table.insert(logs, {
                text = string,
                text_size = string1,
                color = hit_color
            }) 

        end
    else
        funcs.log_debug(string.format('ent [%s] | hitbox [%s] | reason [%s]', e.target:get_name(), aimed_hgroup, e.state))

        --[[if e.state == 'player death' or e.state == 'death' or e.state == 'unregistered shot' then
            funcs.log(string.format('Missed shot in %s\'s %s due to %s ( hitchance: %d | history(Δ): %d )', 
                e.target:get_name(), aimed_hgroup, e.state, aim_hitchance, e.backtrack or 0
            ))
        else--]]
            
            if menu.visuals.realtweakers:get(1) then
            
                local nvmthis = { e.hitchance, '% hitchance' }
                local miss = color(255, 50, 50, 255)
                local string1 = string.format('Missed %s\'s %s due to %s (%s%s)', string.lower(e.target:get_name()), aimed_hgroup, funcs.reasons[e.state], nvmthis[1], nvmthis[2])

                local string = {
                    { "Missed ", color(255, 255, 255, 255) },
                    { string.lower(e.target:get_name()), miss },
                    { "'s ", color(255, 255, 255, 255) },
                    { aimed_hgroup.." ", miss },
                    { "due to ", color(255, 255, 255, 255) },
                    { funcs.reasons[e.state] .." ", miss },
                    { "(", color(255, 255, 255, 255) },
                    { e.hitchance, miss },
                    { "% hitchance)", color(255, 255, 255, 255) }
                }
                
                table.insert(logs, {
                    text = string,
                    text_size = string1,
                    color = miss
                }) 
            end

            --[[funcs.log(string.format('Missed shot in %s\'s %s due to %s [spread: %.2f° | angle: %d°] ( hitchance: %d | history(Δ): %d )', 
                e.target:get_name(), aimed_hgroup, funcs.reasons[e.state], e.spread, bodyyaw, aim_hitchance, e.backtrack or 0
            ))--]]

            funcs.log_miss(e.target:get_name(), aimed_hgroup, funcs.reasons[e.state], string.format('%.1f', bodyyaw), aim_hitchance, damage_shot, e.backtrack or 0) -- (entity, hitbox, reason, damage, hitchance, history)
        --end

    end
end)

events.createmove:set(function(cmd)
    local plocal = entity.get_local_player()
    local origin = plocal:get_origin()
    local time = 1 / globals.tickinterval

    if cmd.choked_commands == 0 then
        lagcomp.positions[#lagcomp.positions + 1] = origin

        if #lagcomp.positions >= time then
            local record = lagcomp.positions[time]
            lagcomp.lc = (origin - record):lengthsqr() > 4096
        end
    end

    if #lagcomp.positions > time then
        table.remove(lagcomp.positions, 1)
    end
end)

events.createmove:set(function(cmd)
    local me = entity.get_local_player()

    if cmd.choked_commands > 0 then
        return
    end

    localplayer_info.real_yaw = me['m_flPoseParameter'][11] * 120 - 60
end)

local function ragebot(cmd)

    register.antiaim()
    register.viewmodel_override()
    register.inair_hitchance()
    register.noscope_hitchance()
    register.localplayer_state()

end

local function visuals()

    register.crosshair()
    register.feature()
    register.simple_spectators()
    register.solus_watermark()
    register.solus_keybinds()
    register.solus_spectators()
    register.sloweddown()
    register.manual_arrows()
    register.corner_logs()
    register.sidewatermark()

end

register.onload()

events.shutdown:set(function()
    for _, reset_function in ipairs(vmt_hook.hooks) do
        reset_function()
    end
end)

menu.misc.stealname:set_callback(function()
    if not globals.is_connected then 
        funcs.log('You must be connected on server!')
    else
        local random_player = entity.get(utils.random_int(1, #entity.get_players()), false) 
        common.set_name(random_player:get_name() .. '   ')
    end
end)

menu.global[3]:visibility(false)
menu.global[4]:visibility(false)

menu.ui_keybinds_x:visibility(false)
menu.ui_keybinds_y:visibility(false)
menu.ui_spectators_x:visibility(false)
menu.ui_spectators_y:visibility(false)

menu.global[2]:set_callback(function()
    menu.global[1]:visibility(false)
    menu.global[2]:visibility(false)
    menu.global[3]:visibility(true)
    menu.global[4]:visibility(true)
end)

menu.global.export:set_callback(function()
    local code = {{}, {}, {}, {}, {}}

    for _, bools in pairs(cfg.data.bools) do
        table.insert(code[1], bools:get())
    end

    for _, ints in pairs(cfg.data.ints) do
        table.insert(code[2], ints:get())
    end

    for _, floats in pairs(cfg.data.floats) do
        table.insert(code[3], floats:get())
    end

    for _, strings in pairs(cfg.data.strings) do
        table.insert(code[4], strings:get())
    end

    for _, colors in pairs(cfg.data.colors) do
        local clr = colors:get()
        table.insert(code[5], string.format('%02X%02X%02X%02X', math.floor(clr.r), math.floor(clr.g), math.floor(clr.b), math.floor(clr.a)))
    end
   
    requires[3].set(requires[4].encode(json.stringify(code)))
    funcs.log('[~] Config successfully exported')
    
    local string1 = { 
        { "Config successfully ", color(255, 255, 255, 255) },
        { "exported", color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) }
    }

    table.insert(logs, {
        text = string1,
        text_size = 'Config successfully exported',
        color = color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255)
    }) 

end)

menu.global.import:set_callback(function()
    cfg.load(requires[3].get())
    funcs.log('[~] Config successfully imported')

    local string1 = { 
        { "Config successfully ", color(255, 255, 255, 255) },
        { "imported", color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) }
    }

    table.insert(logs, {
        text = string1,
        text_size = 'Config successfully imported',
        color = color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255)
    }) 
end)

menu.global.default:set_callback(function()
    cfg.load(network.get('http://pluggcord.space/neverlose/config_beta.solar'))
    funcs.log('[~] Cloud config sucessfuly imported')

    local string1 = { 
        { "Cloud config successfully ", color(255, 255, 255, 255) },
        { "imported", color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) },
        { "", color(0, 0, 0, 255) }
    }

    table.insert(logs, {
        text = string1,
        text_size = 'Cloud config successfully imported',
        color = color(menu.ind_color:get().r, menu.ind_color:get().g, menu.ind_color:get().b, 255)
    }) 
end)

menu.global[4]:set_callback(function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL('https://discord.gg/XPKPt58QSC')
end)

local function hide_menu_elements()
    
    localplayer_info.fps_saver = menu.fps_saver:get() and true or false
    menu.fps_saver:visibility(menu.solus_theme:get() == 'v2')
    menu.arrows_color_default:visibility(menu.arrows_enable:get() and menu.arrows_theme:get() == 'Default')
    menu.arrows_color_getzeus[1]:visibility(menu.arrows_enable:get() and menu.arrows_theme:get() == 'Getze.us')
    menu.arrows_color_getzeus[2]:visibility(menu.arrows_enable:get() and menu.arrows_theme:get() == 'Getze.us')
    menu.arrows_color_teamskeet[1]:visibility(menu.arrows_enable:get() and menu.arrows_theme:get() == 'Teamskeet')
    menu.arrows_color_teamskeet[2]:visibility(menu.arrows_enable:get() and menu.arrows_theme:get() == 'Teamskeet')
    menu.arrows_theme:visibility(menu.arrows_enable:get())
    menu.dmgtext:visibility(menu.visuals.tweakers:get(2) and menu.visuals.feature:get(8))
    menu.dmgcolor:visibility(menu.visuals.tweakers:get(2) and menu.visuals.feature:get(8))
    menu.dmgtype:visibility(menu.visuals.tweakers:get(2) and menu.visuals.feature:get(8))
    menu.hctext:visibility(menu.visuals.tweakers:get(2) and menu.visuals.feature:get(11))
    menu.hccolor:visibility(menu.visuals.tweakers:get(2) and menu.visuals.feature:get(11))
    menu.hctype:visibility(menu.visuals.tweakers:get(2) and menu.visuals.feature:get(11))
    menu.hcempty:visibility(menu.visuals.tweakers:get(2) and menu.visuals.feature:get(11) and menu.visuals.tweakers:get(2) and menu.visuals.feature:get(8))
    menu.visuals.crosshair:visibility(menu.visuals.tweakers:get(1))
    menu.visuals.feature:visibility(menu.visuals.tweakers:get(2))
    menu.ragebot.condition:visibility(menu.ragebot.builder:get())
    menu.ragebot.inair:visibility(menu.ragebot.tweakers:get(1))
    menu.ragebot.noscope:visibility(menu.ragebot.tweakers:get(2))
    menu.ragebot.base:visibility(menu.ragebot.builder:get())
    menu.ragebot.pitch:visibility(menu.ragebot.builder:get())
    menu.inair_hc:visibility(menu.ragebot.tweakers:get(1) and menu.ragebot.inair:get())
    menu.noscope_hc:visibility(menu.ragebot.tweakers:get(2) and menu.ragebot.noscope:get())

    if menu.ragebot.condition:get() == 'Crouching Air' then 
        aa_choosed = 1
    elseif menu.ragebot.condition:get() == 'Airing' then
        aa_choosed = 2
    elseif menu.ragebot.condition:get() == 'Slowwalking' then
        aa_choosed = 3
    elseif menu.ragebot.condition:get() == 'Crouching' then
        aa_choosed = 4
    elseif menu.ragebot.condition:get() == 'Standing' then
        aa_choosed = 5
    elseif menu.ragebot.condition:get() == 'Running' then
        aa_choosed = 6
    end

    for i = 1, 6 do
        aa_init[i].enable:visibility(menu.ragebot.builder:get() and i == aa_choosed)
        aa_init[i].yaw_left:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
        aa_init[i].yaw_right:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
        aa_init[i].yaw_modifier:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
        aa_init[i].yaw_degree:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
        aa_init[i].yaw_fakeopt:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
        aa_init[i].yaw_freestand:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
        aa_init[i].yaw_desync_left:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
        aa_init[i].yaw_desync_right:visibility(menu.ragebot.builder:get() and i == aa_choosed and aa_init[i].enable:get())
    end
end

events.render:set(visuals)
events.createmove:set(ragebot)
events.createmove_run:set(register.hook_animstate)
events.render:set(hide_menu_elements)