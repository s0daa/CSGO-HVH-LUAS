local ffi = require('ffi')


ffi.cdef[[ 
    typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);


    struct animation_layer_t
    {
	    char pad20[24];
	    uint32_t m_nSequence;
	    float m_flPrevCycle;
	    float m_flWeight;
	    float m_flWeightDeltaRate;
	    float m_flPlaybackRate;
	    float m_flCycle;
	    uintptr_t m_pOwner;
	    char pad_0038[ 4 ];
    };


    struct CAnimstate {
        char pad[ 3 ];
        char m_bForceWeaponUpdate; //0x4
        char pad1[ 91 ];
        void* m_pBaseEntity; //0x60
        void* m_pActiveWeapon; //0x64
        void* m_pLastActiveWeapon; //0x68
        float m_flLastClientSideAnimationUpdateTime; //0x6C
        int m_iLastClientSideAnimationUpdateFramecount; //0x70
        float m_flAnimUpdateDelta; //0x74
        float m_flEyeYaw; //0x78
        float m_flPitch; //0x7C
        float m_flGoalFeetYaw; //0x80
        float m_flCurrentFeetYaw; //0x84
        float m_flCurrentTorsoYaw; //0x88
        float m_flUnknownVelocityLean; //0x8C
        float m_flLeanAmount; //0x90
        char pad2[ 4 ];
        float m_flFeetCycle; //0x98
        float m_flFeetYawRate; //0x9C
        char pad3[ 4 ];
        float m_fDuckAmount; //0xA4
        float m_fLandingDuckAdditiveSomething; //0xA8
        char pad4[ 4 ];
        float m_vOriginX; //0xB0
        float m_vOriginY; //0xB4
        float m_vOriginZ; //0xB8
        float m_vLastOriginX; //0xBC
        float m_vLastOriginY; //0xC0
        float m_vLastOriginZ; //0xC4
        float m_vVelocityX; //0xC8
        float m_vVelocityY; //0xCC
        char pad5[ 4 ];
        float m_flUnknownFloat1; //0xD4
        char pad6[ 8 ];
        float m_flUnknownFloat2; //0xE0
        float m_flUnknownFloat3; //0xE4
        float m_flUnknown; //0xE8
        float m_flSpeed2D; //0xEC
        float m_flUpVelocity; //0xF0
        float m_flSpeedNormalized; //0xF4
        float m_flFeetSpeedForwardsOrSideWays; //0xF8
        float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
        float m_flTimeSinceStartedMoving; //0x100
        float m_flTimeSinceStoppedMoving; //0x104
        bool m_bOnGround; //0x108
        bool m_bInHitGroundAnimation; //0x109
        float m_flTimeSinceInAir; //0x10A
        float m_flLastOriginZ; //0x10E
        float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
        float m_flStopToFullRunningFraction; //0x116
        char pad7[ 4 ]; //0x11A
        float m_flMagicFraction; //0x11E
        char pad8[ 60 ]; //0x122
        float m_flWorldForce; //0x15E
        char pad9[ 458 ]; //0x162
        float m_flMinYaw; //0x330
        float m_flMaxYaw; //0x334
    };
    typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);
]]

local ffi = require('ffi')
local classptr = ffi.typeof('void***')
local RawIEntityList = ffi.cast("void***", memory.create_interface("client.dll","VClientEntityList003"))
local IEntityList = ffi.cast("GetClientEntity_123123_t", RawIEntityList[0][3])
local function get_anim_layer(b,c)c=c or 1;b=ffi.cast(classptr,b)return ffi.cast('struct animation_layer_t**',ffi.cast('char*',b)+0x2990)[0][c]end

local GetEntityPattern = function(Index)
    local Pattern = IEntityList(RawIEntityList, Index)
    return Pattern
end


local function Clamp(value, min_val, max_val)
    return math.min(math.max(value, min_val), max_val)
end

local function YawNormalizer(yaw)
    if yaw > 360 then
        return yaw - 360;
    elseif yaw < 0 then
        return 360 + yaw
    end

    return yaw;
end


local Anim = {};
local Side = {};
local Desync = {};
local should_change_side = {}

for i = 1, 64, 1 do
    Side[i] = 1;
    Desync[i] = 0;
    Anim[i] = 0;
    should_change_side[i] = 0;
end

local method  = menu.add_selection("Resolver", "Method", {"Default","Custom"})
local hitlogs =  menu.add_checkbox("Other","Hitlogs")

local angle = menu.add_slider('Desync',"Value", -60, 60)
menu.set_group_visibility("Desync", false)


local val = 0;

function get_state(player,speed)
    if not engine.is_connected() or not engine.is_in_game() or not entity_list.get_local_player():is_alive() then return end

    local flags = player:get_prop("m_fFlags")


        if flags == 263 then 
            return 6 -- crouching
        end

        if flags == 256 or flags == 262 then
            return 4 -- air
        end

        if flags ~= 263 and flags ~= 256 and flags ~= 262 then
            if speed <= 3  then
                return 2 -- standing
            else
                if speed > 3 and speed < 101 then
                    return 7 -- slowwalk
                else
                    return 3 -- moving
                end
            end
        end

   
end

local function normalize(value, min, max)
    return (value - min) / (max - min)
end


local average = function( t )
	t = t or { }

	local sum = 0
	for _,v in pairs(t) do
		sum = sum + v
	end
	return sum / #t
end

local function insert_first_index(tbl, value, maxSize)
    if #tbl >= maxSize then
        table.remove(tbl)
    end

    table.insert(tbl, 1, value)
end


local function set_desync()
    menu.set_group_visibility("Desync", false)
    if method:get() == 2 then
        menu.set_group_visibility("Desync", true)
        val = angle:get()
    end
end

callbacks.add(e_callbacks.NET_UPDATE,set_desync)

local function opposite(player)
    if should_change_side[player] == 1 then
        return 0
    end

    return 1
end

local function get_side(playback_rate,ent)
    if playback_rate == nil then
        return
    end

    if playback_rate > Anim[ent] then
        Anim[ent] = playback_rate
        Side[ent] = 2
    elseif playback_rate < Anim[ent] then
        Anim[ent] = playback_rate
        Side[ent] = 1
    end
end
    
function rounded(number, decimal_places)
    local multiplier = 10^(decimal_places or 0)
    return math.floor(number * multiplier + 0.5) / multiplier
end




local animlayer_average_t = {}
local animlayer_rec_t = {}


local function GetPitch(player)
    if player == nil then
        return 0 -- Возвращаем 0 или другое безопасное значение, если player не определен
    end
    return player:get_prop("m_angEyeAngles[0]")
end

-- Функция для получения угла поворота
local function GetYaw(player)
    if player == nil then
        return 0 -- Возвращаем 0 или другое безопасное значение, если player не определен
    end
    return player:get_prop("m_angEyeAngles[1]")
end

-- Функция для получения скорости
local function GetSpeed(player)
    if player == nil then
        return 0 -- Возвращаем 0 или другое безопасное значение, если player не определен
    end
    local velocity_x, velocity_y = player:get_prop("m_vecVelocity[0]"), player:get_prop("m_vecVelocity[1]")
    return math.sqrt(velocity_x^2 + velocity_y^2)
end

function Resolver()
    local find_lock_layout = menu.find("aimbot", "general", "aimbot", "resolve antiaim")
    find_lock_layout:set(false)

    if not method:get() then 
        return
    end

    local Lp = entity_list.get_local_player()
    local Players = entity_list.get_players(true)

    if Lp == nil then
        return
    end

    for i, Player in pairs(Players) do
        if Player ~= Lp and Player:is_alive() then
            local pitch = GetPitch(Player)
            local yaw = GetYaw(Player)
            local speed = GetSpeed(Player)
        end
    end
    
    for i, Player in pairs(Players) do
        if Player ~= Lp then
            local P = Player

            if P:is_alive() == false then
                return
            end

            cvars.cl_interpolate:set_int(1)
       
            Player = Player:get_index()
            local PlayerP = GetEntityPattern(Player)
            local Resolve = ffi.cast("struct CAnimstate**", GetEntityPattern(Player) + 0x9960)[0]
            local Animlayers = get_anim_layer(PlayerP, 6)

            local yaw = YawNormalizer(P:get_prop("m_flPoseParameter", 11) or 1) * 120
            local num = 1000000000

            if method:get() == 1 then 
                local first_velocity, second_velocity = P:get_prop("m_vecVelocity[0]"), P:get_prop("m_vecVelocity[1]")
                local speed = math.floor((first_velocity^2 + second_velocity^2)^0.5)    

                local m_flPlaybackRate = Animlayers.m_flPlaybackRate*num
                animlayer_average_t[Player] = animlayer_average_t[Player] or {m_flPlaybackRate}
                insert_first_index(animlayer_average_t[Player], m_flPlaybackRate, 18)
                local pbr = normalize(average(animlayer_average_t[Player]), 0, 21973819.471897)
                animlayer_rec_t = pbr
                animlayer_rec_t = rounded(animlayer_rec_t,4)           
    
                if get_state(P,speed) == 2 then
                    get_side(animlayer_rec_t,Player)
                    Desync[Player] = (yaw * 7800) * (Animlayers.m_flPlaybackRate);
                    Desync[Player] = math.floor(Clamp(Desync[Player],-58,58))
                end

                if get_state(P,speed) == 7 then
                    Desync[Player] =   (yaw * 100) * (Animlayers.m_flPlaybackRate);
                    Desync[Player] = math.floor(Clamp(Desync[Player],-58,58))
                end

                if get_state(P,speed) == 3 then
                    Desync[Player] =  (yaw * 27) * (Animlayers.m_flPlaybackRate);
                    Desync[Player] = math.floor(Clamp(Desync[Player],-28,28))
                end

                if get_state(P,speed) == 4 then
                    Desync[Player] =  (yaw * 27) * (Animlayers.m_flPlaybackRate);
                    Desync[Player] = math.floor(Clamp(Desync[Player],-28,28))
                end

                if get_state(P,speed) == 6 then
                    get_side(animlayer_rec_t,Player)

                    if Side[Player] == 2 then
                        Desync[Player] = (yaw * 4600) * (Animlayers.m_flPlaybackRate);
                    else 
                        Desync[Player] = yaw * 1.75;
                    end

                    Desync[Player] = math.floor(Clamp(Desync[Player],-58,58))
                end
    
                if should_change_side[Player] == 1 then
                    Desync[Player] = (Desync[Player] * -1)
                end

                if Side[Player] == 1  then
                    Resolve.m_flGoalFeetYaw = Resolve.m_flEyeYaw + Desync[Player] 
                else 
                    Resolve.m_flGoalFeetYaw = Resolve.m_flEyeYaw - Desync[Player] 
                end
            elseif method:get() == 2 then 
                Side[Player] = 1
                Desync[Player] = val
                if Desync[Player] >= 0 then 
                    Side[Player] = 2
                end
                Resolve.m_flGoalFeetYaw = Resolve.m_flEyeYaw + Desync[Player]
            end
        end
    end
end

callbacks.add(e_callbacks.NET_UPDATE, Resolver)

local VMT = {
    setup = function(self)
        self.bind = function(vmt_table, func, index)
            local result = ffi.cast(ffi.typeof(func), vmt_table[0][index])
            return function(...)
                return result(vmt_table, ...)
            end
        end
    end
} VMT:setup()

local FFI = {
    ffi.cdef[[
        // Render region
        typedef struct {
            uint8_t r;
            uint8_t g;
            uint8_t b;
            uint8_t a;
        } color_struct_t;


        // end
    ]],
    render = {
        setup = function(self)
            self.interfaces = {
                new_intptr = ffi.typeof('int[1]'),
                charbuffer = ffi.typeof('char[?]'),
                new_widebuffer = ffi.typeof('wchar_t[?]'),
            }

            self.RawLocalize = memory.create_interface('localize.dll', 'Localize_001')
            self.Localize    = ffi.cast(ffi.typeof('void***'), self.RawLocalize)

            self.FindSafe =             VMT.bind(self.Localize, 'wchar_t*(__thiscall*)(void*, const char*)', 12)
            self.ConvertAnsiToUnicode = VMT.bind(self.Localize, 'int(__thiscall*)(void*, const char*, wchar_t*, int)', 15)
            self.ConvertUnicodeToAnsi = VMT.bind(self.Localize, 'int(__thiscall*)(void*, wchar_t*, char*, int)', 16)

            -- GUI Surface
            self.VGUI_Surface031 = memory.create_interface('vguimatsurface.dll', 'VGUI_Surface031')
            self.g_VGuiSurface = ffi.cast(ffi.typeof('void***'), self.VGUI_Surface031)

            self.native_Surface = {}
            self.native_Surface.FontCreate =           VMT.bind(self.g_VGuiSurface, 'unsigned long(__thiscall*)(void*)', 71)
            self.native_Surface.SetFontGlyphSet =      VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const char*, int, int, int, int, unsigned long, int, int)', 72)
            self.native_Surface.GetTextSize =          VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long, const wchar_t*, int&, int&)', 79)
            self.native_Surface.DrawSetTextColor =     VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int, int, int)', 25)
            self.native_Surface.DrawSetTextFont =      VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, unsigned long)', 23)
            self.native_Surface.DrawSetTextPos =       VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, int, int)', 26)
            self.native_Surface.DrawPrintText =        VMT.bind(self.g_VGuiSurface, 'void(__thiscall*)(void*, const wchar_t*, int, int)', 28)

            self.EFontFlags = ffi.typeof([[
                enum {
                    NONE,
                    ITALIC		 = 0x001,
                    UNDERLINE	 = 0x002,
                    STRIKEOUT	 = 0x004,
                    SYMBOL		 = 0x008,
                    ANTIALIAS	 = 0x010,
                    GAUSSIANBLUR = 0x020,
                    ROTARY		 = 0x040,
                    DROPSHADOW	 = 0x080,
                    ADDITIVE	 = 0x100,
                    OUTLINE		 = 0x200,
                    CUSTOM		 = 0x400,
                }
            ]])

            self.PrintText = function(text, localized)
                local size = 1024.0
                if localized then
                    local char_buffer = self.interfaces.charbuffer(size)
                    self.ConvertUnicodeToAnsi(text, char_buffer, size)

                    return self.native_Surface.DrawPrintText(text, #ffi.string(char_buffer), 0)
                else
                    local wide_buffer = self.interfaces.new_widebuffer(size)

                    self.ConvertAnsiToUnicode(text, wide_buffer, size)
                    return self.native_Surface.DrawPrintText(wide_buffer, #text, 0)
                end
            end

            self.font_cache = {}
        end
    },
    setup = function(self)
        self.render:setup()
    end
} FFI:setup()

local c_render = {}
local color = {}
local assistant = {
    global = function()
        math.clamp = function(num, min, max)
            return math.min(math.max(num, min), max)
        end
        math.round = function(value, decimals)
            local multiplier = 10 ^ (decimals or 0)
            return math.floor(value * multiplier + 0.5) / multiplier
        end
        math.lerp = function(start, _end, time, do_extraanim)
            if (not do_extraanim and math.floor(start) == _end) then
                return
                _end
            end
            time = globals.frame_time() * (time * 175)
            if time < 0 then
                time = 0.01
            elseif time > 1 then
                time = 1
            end
            return (_end - start) * time + start
        end
        color.new = function(r, g, b, a)
            return color_t(math.round(r), math.round(g), math.round(b), math.round(a or 255))
        end
    end,
    render = function()
        c_render.create_font = function(name, size, flags, glow, weight)
            local flags_t = {}
            for _, Flag in pairs(flags or {'NONE'}) do
                table.insert(flags_t, FFI.render.EFontFlags(Flag))
            end

            local flags_i = 0
            local t = type(flags_t)
            if t == 'number' then
                flags_i = flags_t
            elseif t == 'table' then
                for i = 1, #flags_t do
                    flags_i = flags_i + flags_t[i]
                end
            else
                flags_i = 0x0
            end

            -- local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, flags_i)
            local cache_key = string.format('%s\0%d\0%d\0%d', name, size, weight or 0, glow or 0)
            if FFI.render.font_cache[cache_key] == nil then
                FFI.render.font_cache[cache_key] = FFI.render.native_Surface.FontCreate()
                FFI.render.native_Surface.SetFontGlyphSet(FFI.render.font_cache[cache_key], name, size, weight or 0, glow or 0, 0, flags_i, 0, 0)
            end

            return FFI.render.font_cache[cache_key]
        end
        c_render.get_text_size = function(font, text)
            local wide_buffer = FFI.render.interfaces.new_widebuffer(1024)
            local w_ptr = FFI.render.interfaces.new_intptr()
            local h_ptr = FFI.render.interfaces.new_intptr()

            FFI.render.ConvertAnsiToUnicode(text, wide_buffer, 1024)
            FFI.render.native_Surface.GetTextSize(font, wide_buffer, w_ptr, h_ptr)

            return vec2_t(tonumber(w_ptr[0]), tonumber(h_ptr[0]))
        end
        c_render.draw_text = function(font, x, y, clr, text, center)
            local x, y = x, y
            if center then
                local text_size = render.get_text_size(font, text)
                if center[1] then
                    x = x - text_size.x / 2
                end
                if center[2] then
                    y = y - text_size.y / 2
                end
            end
            FFI.render.native_Surface.DrawSetTextPos(x, y)
            FFI.render.native_Surface.DrawSetTextFont(font)
            FFI.render.native_Surface.DrawSetTextColor(clr.r, clr.g, clr.b, clr.a)
            return FFI.render.PrintText(text, false)
        end
        c_render.draw_multi_text = function(font, x, y, text_t, alpha, center)
            local centered = { x = 0, y = 0 }
            if center then
                for _, Table in pairs(text_t) do
                    local text_size = c_render.get_text_size(font, Table[1])
                    if center[1] then
                        centered.x = centered.x + text_size.x
                    end
                    if center[2] then
                        centered.y = text_size.y
                    end
                end
            end
            for _, Table in pairs(text_t) do
                Table[2] = Table[2] or color.new(255, 255, 255, alpha)
                c_render.draw_text(font, x - centered.x / 2, y - centered.y / 2, color.new(Table[2].r, Table[2].g, Table[2].b, alpha), Table[1])
                x = x + c_render.get_text_size(font, Table[1]).x
            end
        end
    end,
    setup = function(self)
        self:global()
        self:render()

    end
} assistant:setup()

local logs = {
    data = {},
    font = {
        def = c_render.create_font('Tahoma', 11),
        glow = c_render.create_font('Tahoma', 11, {'NONE'}, 2)
    },
    screen = render.get_screen_size(),
    hitboxes = {
        [1] = 'head',
        [2] = 'chest',
        [3] = 'stomach',
        [5] = 'arm',
        [6] = 'leg',
        [7] = 'feet',
    },
    input = function(self, data, duration)
        duration = duration or 4
        table.insert(self.data, {
            text = data.text,
            stamp = globals.cur_time() + duration,
            speed = data.speed or 0.05,
            anim = 0
        })
    end,
    setup = function(self)
        callbacks.add(e_callbacks.PAINT, function()
         

            local y_offset = 0
            for i, v in pairs(self.data) do
                v.anim = math.lerp(v.anim, globals.cur_time() < v.stamp and 1 or 0, v.speed, true)
                if v.anim < 0.01 then
                    table.remove(self.data, i)
                    goto next
                end

                local pos = {
                    x = self.screen.x / 2,
                    y = (self.screen.y / 2 + 80),
                }

                c_render.draw_multi_text(self.font.glow, pos.x, math.round(pos.y + y_offset * v.anim), v.text, 80 * v.anim, {true})
                c_render.draw_multi_text(self.font.def, pos.x, math.round(pos.y + y_offset * v.anim), v.text, 255 * v.anim, {true})

                y_offset = (y_offset + 15) * v.anim
                ::next::
            end
        end)
        callbacks.add(e_callbacks.AIMBOT_HIT, function(log)
            if not hitlogs:get() then 
                return
            end


            local Lp = entity_list.get_local_player()
        
            if Lp == nil then
                return
            end



            local name = log.player:get_name()
            local P = log.player:get_index()
            local side = tostring(Side[P])
            local desync = tostring(Desync[P])
            local bt_ticks = tostring(log.backtrack_ticks)
            local hitbox = tostring(self.hitboxes[log.hitgroup])
            local sp = tostring(log.aim_safepoint)
            local damage = tostring(log.damage)
            local hitchance = tostring(log.aim_hitchance)



            self:input({
                text = {
                    {'Hit ',color.new(180,240,40)},
                    {name, color.new(255,255,255)},
                    {' in ',color.new(180,240,40)},
                    {hitbox, color.new(255,255,255)},
                    {' damage ',color.new(180,240,40)},
                    {damage, color.new(255,255,255)},
                    {' backtrack ',color.new(180,240,40)},
                    {bt_ticks, color.new(255, 255, 255)},
                    {' side ',color.new(180,240,40)},
                    {side, color.new(255, 255, 255)},
                    {' angle ', color.new(180,240,40)},
                    { desync .."°", color.new(255, 255,255)}

           
                    
                }
            })
            client.log(color.new(255,255,255), '>>', color.new(180,240,40), 'Hit', color.new(255,255,255), name,color.new(180,240,40), 'in', color.new(255,255,255),hitbox.." |" ,color.new(180,240,40), 'for:', color.new(255,255,255),damage..' damage |' ,color.new(180,240,40), 'hitchance:', color.new(255,255,255),hitchance..' |' ,color.new(180,240,40), 'safe:', color.new(255,255,255),sp..' |' ,color.new(180,240,40), 'backtrack:', color.new(255,255,255),bt_ticks.." ticks |" , color.new(180,240,40), 'side:', color.new(255,255,255), side..' |', color.new(180,240,40), "resolved angle:",color.new(255,255,255),desync..' |', color.new(180,240,40))
        end)
        callbacks.add(e_callbacks.AIMBOT_MISS, function(log)

            if not hitlogs:get() then 
                return
            end

            local Lp = entity_list.get_local_player()
        
            if Lp == nil then
                return
            end


            local name = log.player:get_name()
            local e_reason = log.reason_string
            local reason = tostring(log.reason_string)
            local bt_ticks = tostring(log.backtrack_ticks)
            local hitbox = tostring(self.hitboxes[log.aim_hitgroup])
            local sp = tostring(log.aim_safepoint)
            local damage = tostring(log.aim_damage)
            local hitchance = tostring(log.aim_hitchance)
            local P = log.player:get_index()

            if e_reason == "jitter" then
                reason = "resolver"
            end


            if e_reason == "jitter" or e_reason == "resolver" then
                should_change_side[P] = opposite(P);
            end
            

            local side = tostring(Side[P])
            local desync = tostring(Desync[P])
         

            self:input({
                text = {
                    {'Missed ', color.new(240, 154, 40)},
                    {name, color.new(255, 255, 255)},
                    {" due to ", color.new(240, 154, 40)},
                    {reason, color.new(255, 255,255)},
                    {' side ', color.new(240, 154, 40)},
                    {side, color.new(255, 255,255)},
                    {' angle ', color.new(240, 154, 40)},
                    {desync .."°", color.new(255, 255,255)}
                   
           
                }
            })
            client.log(color.new(255, 128, 0), '>>', color.new(255, 128, 0), 'Missed', color.new(255,255,255), name,color.new(255, 128, 0), 'due to', color.new(255,255,255), reason.." |",color.new(255, 128, 0), 'in', color.new(255,255,255),hitbox.." |" ,color.new(255, 128, 0), 'for:', color.new(255,255,255),damage..' damage |' ,color.new(255, 128, 0), 'hitchance:', color.new(255,255,255),hitchance..' |' ,color.new(255, 128, 0), 'safe:', color.new(255,255,255),sp..' |' ,color.new(255, 128, 0), 'backtrack:', color.new(255,255,255),bt_ticks.." ticks |" , color.new(255, 128, 0), 'side:', color.new(255,255,255), side..' |', color.new(255, 128, 0), "resolved angle:",color.new(255,255,255),desync..' |', color.new(255, 128, 0))
        end)
    end,

} logs:setup()