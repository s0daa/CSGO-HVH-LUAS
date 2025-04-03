--[[
    made by esrie#6666 , Credits: dhdj -> jmp hooks 
    Stop selling pasted and useless bullshit for a quick buck
    Your shit will eventually get released open source and for free anyway 
    go and hang yourselfs, ty 
]]

ffi.cdef[[
    typedef uintptr_t (__thiscall* get_client_entity_t)(void*, int); // define get_client_entity_t function


    struct c_animlayer {
        bool m_bClientBlend;				 //0x0000
        float m_flBlendIn;					 //0x0004
        void* m_pStudioHdr;					 //0x0008
        int m_nDispatchSequence;     //0x000C
        int m_nDispatchSequence_2;   //0x0010
        int m_nOrder;           //0x0014
        int m_nSequence;        //0x0018
        float m_flPrevCycle;       //0x001C
        float m_flWeight;          //0x0020
        float m_flWeightDeltaRate; //0x0024
        float m_flPlaybackRate;    //0x0028
        float m_flCycle;           //0x002C
        void* m_pOwner;              //0x0030 // player's thisptr
        char pad_0038[ 4 ];            //0x0034
    };                             //Size: 0x0038
        
]]

local pGetModuleHandle_sig = utils.opcode_scan("engine.dll", " FF 15 ? ? ? ? 85 C0 74 0B")
local pGetProcAddress_sig  = utils.opcode_scan("engine.dll", " FF 15 ? ? ? ? A3 ? ? ? ? EB 05")

local pGetProcAddress = ffi.cast("uint32_t**", ffi.cast("uint32_t", pGetProcAddress_sig) + 2)[0][0]
local fnGetProcAddress = ffi.cast("uint32_t(__stdcall*)(uint32_t, const char*)", pGetProcAddress)

local pGetModuleHandle = ffi.cast("uint32_t**", ffi.cast("uint32_t", pGetModuleHandle_sig) + 2)[0][0]
local fnGetModuleHandle = ffi.cast("uint32_t(__stdcall*)(const char*)", pGetModuleHandle)

local function proc_bind(module_name, function_name, typedef)
    local ctype = ffi.typeof(typedef)
    local module_handle = fnGetModuleHandle(module_name)
    local proc_address = fnGetProcAddress(module_handle, function_name)
    local call_fn = ffi.cast(ctype, proc_address)

    return call_fn
end

local nativeVirtualProtect =
    proc_bind(
    "kernel32.dll",
    "VirtualProtect",
    "int(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect)"
)
local nativeVirtualAlloc =
    proc_bind(
    "kernel32.dll",
    "VirtualAlloc",
    "void*(__stdcall*)(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect)"
)

local function copy(dst, src, len)
    return ffi.copy(ffi.cast("void*", dst), ffi.cast("const void*", src), len)
end

local buff = {free = {}}

local function VirtualProtect(lpAddress, dwSize, flNewProtect, lpflOldProtect)
    return nativeVirtualProtect(ffi.cast("void*", lpAddress), dwSize, flNewProtect, lpflOldProtect)
end

local function VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect, blFree)
    local alloc = nativeVirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    if blFree then
        table.insert(buff.free, alloc)
    end
    return ffi.cast("intptr_t", alloc)
end

local detour = {hooks = {}}
function detour.new(cast, callback, hook_addr, size, trampoline, org_bytes_tramp)
    local size = size or 5
    local trampoline = trampoline or false
    local new_hook, mt = {}, {}
    local detour_addr
    local old_prot = ffi.new("unsigned long[1]")
    local org_bytes = ffi.new("uint8_t[?]", size)
    copy(org_bytes, hook_addr, size)
    if trampoline then
        local alloc_addr = VirtualAlloc(nil, size + 5, 0x3000, 0x40, true)
        detour_addr = tonumber(ffi.cast("intptr_t", ffi.cast(cast, callback(ffi.cast(cast,alloc_addr)))))
        local trampoline_bytes = ffi.new("uint8_t[?]", size + 5, 0x90)
        if org_bytes_tramp then
            local i = 0
            for byte in string.gmatch(org_bytes_tramp,"(%x%x)") do
                trampoline_bytes[i] = tonumber(byte, 16)
                i = i + 1
            end
        else
            copy(trampoline_bytes, org_bytes, size)
        end
        trampoline_bytes[size] = 0xE9
        ffi.cast("int32_t*", trampoline_bytes + size + 1)[0] = hook_addr - tonumber(alloc_addr) - size + (size - 5)
        copy(alloc_addr, trampoline_bytes, size + 5)
        new_hook.call = ffi.cast(cast, alloc_addr)
        mt = {
            __call = function(self, ...)
                return self.call(...)
            end
        }
    else
        detour_addr = tonumber(ffi.cast('intptr_t', ffi.cast('void*', ffi.cast(cast, callback))))

        new_hook.call = ffi.cast(cast, hook_addr)
        mt = {
            __call = function(self, ...)
                self.stop()
                local res = self.call(...)
                self.start()
                return res
            end
        }
    end
    local hook_bytes = ffi.new("uint8_t[?]", size, 0x90)
    hook_bytes[0] = 0xE9
    ffi.cast("int32_t*", hook_bytes + 1)[0] = (detour_addr-hook_addr - 5)
    new_hook.status = false
    local function set_status(bool)
        new_hook.status = bool
        VirtualProtect(hook_addr, size, 0x40, old_prot)
        copy(hook_addr, bool and hook_bytes or org_bytes, size)
        VirtualProtect(hook_addr, size, old_prot[0], old_prot)
    end
    new_hook.stop = function()
        set_status(false)
    end
    new_hook.start = function()
        set_status(true)
    end
   
    new_hook.start()
    
    table.insert(detour.hooks, new_hook)
    return setmetatable(new_hook, mt)
end

local entity_list_pointer = ffi.cast("void***", utils.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("get_client_entity_t", entity_list_pointer[0][3])

local get_entity_address = function(entity)
    entity = type(entity) == "number" and entity or entity:get_index()
    return get_client_entity_fn(entity_list_pointer, entity) -- return the entity of our pointer
end

local function inAirCheck(entity)
    local flags = entity.m_fFlags
    if not entity or not entity:is_alive() then return false end
    return bit.band(flags, 1) == 0
end

function getAnimLayer(entity , layer)

    if not entity or not layer then return end

    local address = get_entity_address(entity)
    
    local player_ptr = ffi.cast( "void***", address)
    local animlayer_ptr = ffi.cast( "char*" , player_ptr ) + 0x2990
    local animlayer = ffi.cast("struct c_animlayer**" , animlayer_ptr )[0]

    return animlayer[layer]
end

local tab = ui.create("TransAnims")
local options = tab:listable("Options" , {"T-Pose in air" , "Surrender on freezetime"})

function handleLocal(lp)

    if not lp:is_alive() or not inAirCheck(lp) then return end

    local layer0 = getAnimLayer(lp , 0) --> which layers to use is explained later
    local layer4 = getAnimLayer(lp , 4)
				
    layer0.m_nSequence = 11 -- Changes the animation being played -> different number = different animation 
    layer0.m_flCycle = 0.8  -- dont change this and the animation will be fully played, change it and the anim wont be fully played

    layer4.m_nSequence = 11
    layer4.m_flCycle = 0.8
end

function handleAll(thisptr)

    local gamerules = entity.get_game_rules()
    local isFreeze = gamerules.m_bFreezePeriod

    if not isFreeze then return end

    local animlayer_ptr = ffi.cast( "char*" , thisptr ) + 0x2990
    local animlayer = ffi.cast("struct c_animlayer**" , animlayer_ptr )[0][11]

    animlayer.m_nSequence = 262
end

function CSA(thisptr, edx)
    
    CSA(thisptr , edx)

    local player = ffi.cast("uintptr_t" , thisptr)
    local idx = ffi.cast("int*" , player + 0x64)[0]
   
    local lp = entity.get_local_player()
    local lpIdx = lp:get_index()

    if options:get(2) then 
        handleAll(player)
    end
  
    if options:get(1) and idx == lpIdx then 
        handleLocal(lp)
    end

end

--[[ To change when the anims are played, change the layer you are editing
    enum animstate_layer_t {
        ANIMATION_LAYER_AIMMATRIX = 0,
        ANIMATION_LAYER_WEAPON_ACTION,
        ANIMATION_LAYER_WEAPON_ACTION_RECROUCH,
        ANIMATION_LAYER_ADJUST,
        ANIMATION_LAYER_MOVEMENT_JUMP_OR_FALL, 
        ANIMATION_LAYER_MOVEMENT_LAND_OR_CLIMB, 
        ANIMATION_LAYER_MOVEMENT_MOVE,
        ANIMATION_LAYER_MOVEMENT_STRAFECHANGE,
        ANIMATION_LAYER_WHOLE_BODY,
        ANIMATION_LAYER_FLASHED,
        ANIMATION_LAYER_FLINCH,
        ANIMATION_LAYER_ALIVELOOP,
        ANIMATION_LAYER_LEAN,
        ANIMATION_LAYER_COUNT,
    };
]]

local updateCSA = utils.opcode_scan("client.dll", "8B F1 80 BE ? ? ? ? ? 74 36", -5)

function starthooks()
    CSA = detour.new('void(__fastcall*)(void*, void*)', CSA, ffi.cast("uintptr_t", updateCSA))
end
starthooks()

function detour.unhookAll()
    for idx , hook in pairs(detour.hooks) do
        hook.stop()
    end
end

events.shutdown:set(detour.unhookAll)