---@diagnostic disable: lowercase-global, unbalanced-assignments, deprecated, need-check-nil, undefined-global, undefined-field
---@sentinel cs2 ◣_◢
local accent = color_t(0.8, 1, 0.2588235294117647,1)
local m_sSanitizedPlayerName = engine.get_netvar_offset("client.dll", "CCSPlayerController", "m_sSanitizedPlayerName");
local m_hOriginalController = engine.get_netvar_offset("client.dll", "C_CSPlayerPawnBase", "m_hOriginalController");
local m_nTickBase = engine.get_netvar_offset("client.dll", "CBasePlayerController", "m_nTickBase");
local Verdana = render.setup_font("C:/Windows/Fonts/verdanab.ttf", 12, 16);
local logs = {};

local Lerp = function(a, b, t)
    return a + (b - a) * t
end

local _LOG = function(str)
    print("[nixware] \0", accent);print(str);
end;

local GetHitgroupName = function(nHitgroup)
    if nHitgroup == 1 then 
        return "head";
    elseif nHitgroup == 2 then 
        return "chest";
    elseif nHitgroup == 0 then
        return "generic";
    elseif nHitgroup == 4 or nHitgroup == 5 then 
        return "arms";
    elseif nHitgroup == 8 then
        return "neck";
    elseif nHitgroup == 6 or nHitgroup == 7 then 
        return "legs";
    elseif nHitgroup == 3 then
        return "stomach";
    else
        return "unknown";
    end;
end;

local fnOnPlayerHurt = function(event)
    local pLocalPawn = event:get_pawn("attacker");
    if pLocalPawn ~= entitylist.get_local_player_pawn() then return; end;
    local pLocalController = entitylist.get_local_player_controller();
    if not pLocalController then return; end;
    local pLocalTickBase = ffi.cast("int*", pLocalController[m_nTickBase])[0];
    local pTargetController = event:get_controller("userid");
    if not pTargetController then return end;
    local szName = ffi.string(ffi.cast("char**", pTargetController[m_sSanitizedPlayerName])[0]); -- todo транслит добавить 
    local nHealth = event:get_int("health");
    local nDamage = event:get_int("dmg_health");
    local nHitgroup = event:get_int("hitgroup");
    local szHitgroup = GetHitgroupName(nHitgroup);
    local Text = string.format("Hit %s in the %s for %d damage (%d health remaining)", szName, szHitgroup, nDamage, nHealth);
    _LOG(Text);
    table.insert(logs, {szText = Text, nTickBase = pLocalTickBase + (4 / 0.015625), flAlpha = 0});
end;

local fnOnPaint = function()
    local pLocalController = entitylist.get_local_player_controller();
    if not pLocalController then logs = {}; return; end;
    local pLocalTickBase = ffi.cast("int*", pLocalController[m_nTickBase])[0];
    if not pLocalTickBase then return; end;
    local nOffset = 0;
    for i, v in ipairs(logs) do
        local vecRenderPos = vec2_t(5,5 + nOffset);
        local colAccent = accent;
        v.flAlpha = Lerp(v.flAlpha, pLocalTickBase > v.nTickBase and 0 or 1, 20 * render.frame_time()); --62
        colAccent.a = v.flAlpha;
        render.text("[nixware]", Verdana, vecRenderPos + 1, color_t(0, 0, 0, v.flAlpha * 0.25));
        render.text("[nixware]", Verdana, vecRenderPos, colAccent);
        vecRenderPos.x = vecRenderPos.x + 60;
        render.text(v.szText, Verdana, vecRenderPos + 1, color_t(0, 0, 0, v.flAlpha * 0.25));
        render.text(v.szText, Verdana, vecRenderPos, color_t(1,1,1,v.flAlpha));

        nOffset = nOffset + 16 * v.flAlpha;
        if (v.flAlpha < 0.0001) then table.remove(logs, i) end;
    end;
end;

register_callback("paint", fnOnPaint);
register_callback("player_hurt", fnOnPlayerHurt);
