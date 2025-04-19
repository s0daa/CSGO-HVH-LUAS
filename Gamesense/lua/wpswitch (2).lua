local ffi = require('ffi')
local bit = require('bit')
local csgo_weapons = require('gamesense/csgo_weapons')

local refs = {
    fake_duck = ui.reference("RAGE","Other","Duck peek assist"),
}

local vars = {
    switch_tick = 0,
    weapon_switched = 0,
    weaponselect = false,
    air_ticks = 0,
    shot_tick = 0,
}

local function in_air(player)
    if player == nil then return end
    local flags = entity.get_prop(player, "m_fFlags")
    if flags == nil then return end
    
    if bit.band(flags, 1) == 0 then
        return true
    end
    
    return false
end

local angle3d_struct = ffi.typeof("struct { float pitch; float yaw; float roll; }")
local vec_struct = ffi.typeof("struct { float x; float y; float z; }")

local cUserCmd =
    ffi.typeof(
    [[
    struct
    {
        uintptr_t vfptr;
        int command_number;
        int tick_count;
        $ viewangles;
        $ aimdirection;
        float forwardmove;
        float sidemove;
        float upmove;
        int buttons;
        uint8_t impulse;
        int weaponselect;
        int weaponsubtype;
        int random_seed;
        short mousedx;
        short mousedy;
        bool hasbeenpredicted;
        $ headangles;
        $ headoffset;
        bool send_packet; 
    }
    ]],
    angle3d_struct,
    vec_struct,
    angle3d_struct,
    vec_struct
)

local client_sig = client.find_signature("client.dll", "\xB9\xCC\xCC\xCC\xCC\x8B\x40\x38\xFF\xD0\x84\xC0\x0F\x85") or error("client.dll!:input not found.")
local get_cUserCmd = ffi.typeof("$* (__thiscall*)(uintptr_t ecx, int nSlot, int sequence_number)", cUserCmd)
local input_vtbl = ffi.typeof([[struct{uintptr_t padding[8];$ GetUserCmd;}]],get_cUserCmd)
local input = ffi.typeof([[struct{$* vfptr;}*]], input_vtbl)
local get_input = ffi.cast(input,ffi.cast("uintptr_t**",tonumber(ffi.cast("uintptr_t", client_sig)) + 1)[0])

local function apply_tickbase(cmd, ticks_to_shift)
    local usrcmd = get_input.vfptr.GetUserCmd(ffi.cast("uintptr_t", get_input), 0, cmd.command_number)

    if cmd.chokedcommands == 0 then return end

    cmd.no_choke = true
    cmd.allow_send_packet = true
    usrcmd.send_packet = true
    usrcmd.tick_count = globals.tickcount() + ticks_to_shift
    return
end

client.set_event_callback('aim_fire', function()
    vars.shot_tick = globals.tickcount()
end)

client.set_event_callback('setup_command', function(cmd)

    if (globals.tickcount() - vars.switch_tick) < 0 then
        vars.switch_tick = 0
    end
    if (globals.tickcount() - vars.air_ticks) < 0 then
        vars.air_ticks = 0
    end

    if in_air(entity.get_local_player()) then 
        vars.air_ticks = globals.tickcount()
    end

    if (globals.tickcount() - vars.air_ticks) < 5 then return end

    if ui.get(refs.fake_duck) then return end

    local client_delay_ticks = math.floor( client.latency() / globals.tickinterval() ) + 1
    local disabler = ((globals.tickcount() - vars.shot_tick) <= client_delay_ticks)
    local active_weapon = entity.get_player_weapon(entity.get_local_player())
    if active_weapon == nil then return end
    local LastShot = entity.get_prop(active_weapon, "m_fLastShotTime")
    local NextAttack = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
    if LastShot == nil or NextAttack == nil then return end
    local in_attack = globals.curtime() - LastShot <= 0.35 
    local in_swap = globals.curtime() - NextAttack <= -0.50

    if cmd.weaponselect ~= 0 and (globals.tickcount() - vars.switch_tick) > 20 then
        cmd.allow_send_packet = true
        vars.weapon_switched = cmd.weaponselect
        local weapon_idx = entity.get_prop(vars.weapon_switched, "m_iItemDefinitionIndex")
        if weapon_idx == nil then return end
        local weapon = csgo_weapons[weapon_idx]
        if weapon == nil then return end
        if weapon.type == "knife" or weapon.type == "grenade" or weapon.type == "c4" then
            return
        end
        vars.switch_tick = globals.tickcount()
        vars.weaponselect = true
    end

    local weapon_idx = entity.get_prop(vars.weapon_switched, "m_iItemDefinitionIndex")
    if weapon_idx == nil then return end
    local weapon = csgo_weapons[weapon_idx]
    if weapon == nil then return end

    if in_swap then
        cmd.force_defensive = true
    end

    if disabler then 
        cmd.force_defensive = false
    end

    if weapon.type == "knife" or weapon.type == "grenade" or weapon.type == "c4" then
        vars.switch_tick = 0
        return
    end

    if vars.weaponselect and cmd.allow_send_packet and not in_attack then
        local nextcmdnummber = globals.lastoutgoingcommand() + globals.chokedcommands() + 1
        apply_tickbase(cmd, nextcmdnummber, true)
        vars.weaponselect = false
    end

    if (globals.tickcount() - vars.switch_tick) > 0 and (globals.tickcount() - vars.switch_tick) < 25 and active_weapon ~= vars.weapon_switched and not in_attack then
        if weapon.type == "taser" then
            client.exec('slot11')
        elseif weapon.type == "pistol" then
            client.exec('slot2')
        else
            client.exec('slot1')
        end
    end
end)