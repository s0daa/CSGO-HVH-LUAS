-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

---@diagnostic disable: lowercase-global, unbalanced-assignments, deprecated, need-check-nil, undefined-global, undefined-field
---@description: sentinel cs2 ◣_◢

local FOV = 110;
local m_iDesiredFOV = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_iDesiredFOV");
local fnOnPaint = function()
    local pLocalController = entitylist.get_local_player_controller();
    if not pLocalController then return end;
    ffi.cast("int*", pLocalController[m_iDesiredFOV])[0] = FOV;
end;
register_callback("paint", fnOnPaint);