local ffi = require 'ffi'
ffi.cdef[[
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
        char pad_0038[4];
    };
]]

local classptr = ffi.typeof('void***')
local rawientitylist = client.create_interface('client_panorama.dll', 'VClientEntityList003') or error('VClientEntityList003 wasnt found', 2)
local ientitylist = ffi.cast(classptr, rawientitylist) or error('rawientitylist is nil', 2)
local get_client_entity = ffi.cast('void*(__thiscall*)(void*, int)', ientitylist[0][3]) or error('get_client_entity is nil', 2)

local function get_anim_layer(b, c)
    c = c or 1
    b = ffi.cast(classptr, b)
    return ffi.cast('struct animation_layer_t**', ffi.cast('char*', b) + 0x2990)[0][c]
end

local Desync = {}
for i = 1, 64, 1 do
    Desync[i] = 25
end

local miss_counter = {}

local function handle_player(current_threat)
    if current_threat == nil or not entity.is_alive(current_threat) or entity.is_dormant(current_threat) then
        return
    end
    local yaw_values_normal = { 0, 0, 60, -60 }
    local yaw_values_desync = { 45, -60, 0 }
    local counter = miss_counter[current_threat] or 0
    plist.set(current_threat, "Force body yaw", true)
    plist.set(current_threat, "Correction active", true)
    if Desync[current_threat] ~= nil and Desync[current_threat] < 64 then
        plist.set(current_threat, "Force body yaw value", yaw_values_desync[(counter % 3) + 1] or 0)
    else
        plist.set(current_threat, "Force body yaw value", yaw_values_normal[(counter % 3) + 1] or 0)
    end
end

local function update_players()
    local lp = entity.get_local_player()
    if not lp or not entity.is_alive(lp) then
        return
    end
    local Players = entity.get_players(true)
    if not Players then
        return
    end
    for i, Player in pairs(Players) do
        local PlayerP = get_client_entity(ientitylist, Player)
        if PlayerP == nil then goto continue_loop end
        local Animlayers = {}
        Animlayers[6] = {}
        Animlayers[6]["Main"] = get_anim_layer(PlayerP, 6)
        if Animlayers[6]["Main"] == nil then goto continue_loop end
        Animlayers[6]["m_flPlaybackRate"] = Animlayers[6]["Main"].m_flPlaybackRate
        local RSideR = math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^4) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^5) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^6) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^7) % 10
        local RSideS = math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^6) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^7) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^8) % 10 + math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^9) % 10
        local Tmp
        if math.floor(Animlayers[6]["m_flPlaybackRate"] * 10^3) % 10 == 0 then
            Tmp = -3.4117 * RSideS + 98.9393
        else
            Tmp = -3.4117 * RSideR + 98.9393
        end
        Desync[Player] = Tmp
        handle_player(Player)
        ::continue_loop::
    end
end

client.set_event_callback("setup_command", function(cmd)
    update_players()
end)

local function on_aim_miss(e)
    miss_counter[e.target] = (miss_counter[e.target] or 0) + 1 
end

client.set_event_callback('aim_miss', on_aim_miss)