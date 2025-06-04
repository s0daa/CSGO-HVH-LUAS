-- Init Global -- https://nixware.cc/threads/2326/
local MaxSpeed = 300
local font = render.setup_font("C:/windows/fonts/arial.ttf", 30, 1024)
local m_vecVelocity = engine.get_netvar_offset("client.dll", "C_BaseEntity", "m_vecVelocity")
local size = render.screen_size()
local x,y = size.x, size.y

-- Graph
local SpeedArrayStep = 0
local Mnoj = 5
local SpeedArray = { }
local SpeedArraySize = 300
for i = 1, SpeedArraySize do
    SpeedArray[i] = MaxSpeed / Mnoj
end

-- Customize Pos
local SpeedPos = vec3_t(x / 2, y - y / 4 + 125, 0)
local GraphPos = vec3_t(x / 2 - SpeedArraySize / 2, y - y / 4 + 50, 0)

-- Func
register_callback("paint", function()
    --render.rect_filled(vec2_t(200, 200), vec2_t(400, 400), color_t(1, 0, 0, 1):lerp(color_t(1, 0, 0.01, 1), math.fmod(os.clock(), 1.0)))

    local pawn = entitylist.get_local_player_pawn()

    local velocity = vec3_t(ffi.cast("float*", pawn[m_vecVelocity])[0], ffi.cast("float*", pawn[m_vecVelocity])[1], ffi.cast("float*", pawn[m_vecVelocity])[2])
    local fSpeed = velocity:length_2d()
    local iSpeed = math.floor(fSpeed)

    local str = tostring(iSpeed)
    local text_size = render.calc_text_size(str, font)
    render.text(str, font, vec2_t(SpeedPos.x - text_size.x / 2, SpeedPos.y), 0, color_t(1, 1, 1, 1))

    -- Show Grapth
    for i = 2, SpeedArraySize do
        SpeedArray[i - 1] = SpeedArray[i]
    end
    SpeedArray[SpeedArraySize] = MaxSpeed / Mnoj - iSpeed / Mnoj

    for i = 2, SpeedArraySize do
        if (SpeedArray[i]) then
            render.line(vec2_t(GraphPos.x + i - 1, GraphPos.y + SpeedArray[i - 1]), vec2_t(GraphPos.x + i, GraphPos.y + SpeedArray[i]), color_t(1, 1, 1, 1))
        else
            break
        end
    end

    SpeedArrayStep = SpeedArrayStep + 1
    if (SpeedArrayStep >= SpeedArraySize) then
        SpeedArrayStep = 0
    end
end)