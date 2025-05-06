local SVGData = [[
    <svg width="24" height="24" viewBox="0 0 24 24">
    <path stroke-width="1" stroke="#000" fill="#fff" d="M20 6.91 17.09 4 12 9.09 6.91 4 4 6.91 9.09 12 4 17.09 6.91 20 12 14.91 17.09 20 20 17.09 14.91 12 20 6.91Z"/>
    </svg>
]]

local Texture = render.create_texture_svg(SVGData, 17)
local Width, Height = render.get_texture_size(Texture)

local Checkbox      = gui.add_checkbox("Miss markers", "visuals>esp>world")
local ColorPicker   = gui.add_colorpicker("visuals>esp>world>miss markers", true, render.color(255, 0, 50))

local function OnTickMiss(Shot)
    return string.format("%it", Shot.backtrack)
end

local ValueFuncs = 
{
    spread = function (Shot)
        return string.format("%i%%", Shot.hitchance)
    end,

    resolve = function (Shot)
        return string.format("SP: %s", Shot.secure)
    end,
    extrapolation       = OnTickMiss,
    ["anti-exploit"]    = OnTickMiss,
}

local ShotReasonFmt = 
{
    resolve = "resolver",
}

local Shots = {}
function on_shot_registered(Shot)
    if Shot.manual or Shot.result == "hit" then
        return 
    end

    table.insert(Shots, 
    {
        Position    = Shot.client_impacts[#Shot.client_impacts],
        FadeTime    = 1,
        WaitTime    = 1,
        Reason      = ShotReasonFmt[Shot.result] or Shot.result,
        Value       = ValueFuncs[Shot.result] and ValueFuncs[Shot.result](Shot) or nil
    })
end


function on_paint()
    if not Checkbox:get_bool() or not engine.is_in_game() then
        Shots = {}
        return
    end

    local Color = ColorPicker:get_color()

    for i, Shot in pairs(Shots) do
        local x, y = utils.world_to_screen(Shot.Position:unpack())
        if x then
            render.push_texture(Texture)
            render.rect_filled(x - Width / 2, y - Height / 2, x + Width / 2, y + Height / 2, render.color(Color.r, Color.g, Color.b, Color.a * Shot.FadeTime))
            render.pop_texture()

            local MoveOffset = (10 * (1 - Shot.FadeTime))
            render.text(render.font_esp, x + Width / 2, y - 7 - MoveOffset, Shot.Reason, render.color(255, 255, 255, Color.a * Shot.FadeTime))
            if Shot.Value then
                render.text(render.font_esp, x + Width / 2, y + 1 - MoveOffset, Shot.Value, render.color(255, 255, 255, Color.a * Shot.FadeTime))
            end
        end

        Shot.WaitTime = Shot.WaitTime - (1 / 3) * global_vars.frametime
        if Shot.WaitTime <= 0 then  
            Shot.FadeTime = Shot.FadeTime - (1 / 0.25) * global_vars.frametime
        end

        if Shot.FadeTime <= 0 then
            table.remove(Shots, i)
        end
    end
end

function on_level_init()
    Shots = {}
end