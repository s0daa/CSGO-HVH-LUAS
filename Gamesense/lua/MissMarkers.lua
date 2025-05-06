-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_set_event_callback, globals_frametime, globals_tickcount, math_floor, renderer_measure_text, renderer_text, renderer_world_to_screen, string_upper, pairs, ui_get, ui_new_checkbox, ui_new_color_picker, ui_reference, require = client.set_event_callback, globals.frametime, globals.tickcount, math.floor, renderer.measure_text, renderer.text, renderer.world_to_screen, string.upper, pairs, ui.get, ui.new_checkbox, ui.new_color_picker, ui.reference, require

local Vector    = require("vector")

local MasterSwitch  = ui_new_checkbox("VISUALS", "Effects", "Miss marker")
local IconCol       = ui_new_color_picker("VISUALS", "Effects", "Miss marker", 238, 147, 147, 255)
local ExtraSwitch   = ui_new_checkbox("VISUALS", "Effects", "Extra info")
local ExtraCol      = ui_new_color_picker("VISUALS", "Effects", "Miss marker reason", 255, 255, 255, 255)
local DpiCombo      = ui_reference("MISC", "Settings", "DPI scale")

-- How long it stays before beginning to fade out
local _WaitTime = 2
-- How long it takes to fade out in seconds
local _FadeTime = 0.5

local Shots = {}

local Hitgroups = 
{
    [0] = "GENERIC",
    "HEAD",
    "CHEST",
    "STOMACH",
    "ARMS",
    "ARMS",
    "LEGS",
    "LEGS",
}

local MissReasonFmt = 
{
    ["prediction error"]    = "PREDICTION",
    ["unregistered shot"]   = "UNREGISTERED",
    ["?"]                   = "UNKNOWN",
}

local MissValues = 
{
    ["UNKNOWN"]     = function(Shot) return Hitgroups[Shot.hitgroup] or nil end,
    ["SPREAD"]      = function(Shot) return math_floor(Shot.hit_chance + 0.5) .. "%" end,
    ["PREDICTION"]  = function(Shot) return Shots[Shot.id] and (globals_tickcount() - Shots[Shot.id].Tick .. "T") or "" end
}

local function OnPaint()
    local bMaster, bExtra   = ui_get(MasterSwitch), ui_get(ExtraSwitch)
    local IconColor = {ui_get(IconCol)}
    local TextColor = {ui_get(ExtraCol)}
    local Dpi       = ui_get(DpiCombo):gsub('%%', '') / 100

    for i, Miss in pairs(Shots) do
        if not bMaster or Miss.FadeTime <= 0 then
            Shots[i] = nil
        else
            Miss.WaitTime      = Miss.WaitTime - globals_frametime()
            if Miss.WaitTime <= 0 then
                Miss.FadeTime  = Miss.FadeTime - ((1 / _FadeTime) * globals_frametime())
            end

            local x, y = renderer_world_to_screen(Miss.Pos.x, Miss.Pos.y, Miss.Pos.z)
            if x and Miss.Reason and Miss.FadeTime > 0.05 then
                local IconSize = Vector(renderer_measure_text("d", "❌"))
                local IconPos = Vector(x - (IconSize.x / 2), y - (IconSize.y / 2))

                renderer_text(IconPos.x, IconPos.y, IconColor[1], IconColor[2], IconColor[3], IconColor[4] * Miss.FadeTime, "d", 0, "❌")
                renderer_text(IconPos.x + IconSize.x, IconPos.y - ((10 * Dpi) * (1 - Miss.FadeTime)), TextColor[1], TextColor[2], TextColor[3], TextColor[4] * Miss.FadeTime, "d-", 0, Miss.Reason)

                if bExtra and Miss.Value then
                    local ReasonSize = Vector(renderer_measure_text("d-", Miss.Reason))
                    renderer_text(IconPos.x + IconSize.x, IconPos.y + (ReasonSize.y * 0.85) - ((10 * Dpi) * (1 - Miss.FadeTime)), TextColor[1], TextColor[2], TextColor[3], TextColor[4] * Miss.FadeTime, "d-", 0, Miss.Value)
                end
            end
        end
    end
end

local function OnShotFired(Shot)
    if not ui_get(MasterSwitch) then
        return end

    Shots[Shot.id] = 
    {
        Pos         = Vector(Shot.x, Shot.y, Shot.z),
        Tick        = Shot.tick,
        WaitTime    = _WaitTime,
        FadeTime    = 1,
    }
end

local function OnShotMiss(Shot)
    if not ui_get(MasterSwitch) then
        return end

    local Reason            = string_upper(MissReasonFmt[Shot.reason] or Shot.reason)
    Shots[Shot.id].Reason   = Reason
    Shots[Shot.id].Value    = MissValues[Reason] and MissValues[Reason](Shot) or nil
end

client_set_event_callback('paint',          OnPaint)
client_set_event_callback('aim_fire',       OnShotFired)
client_set_event_callback('aim_miss',       OnShotMiss)
