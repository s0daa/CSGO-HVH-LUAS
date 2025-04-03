--variables used to calculate hitrate information
totalshots = 0
hits = 0

--font
main_font = render.create_font("Tahoma", 28, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
percentage_font = render.create_font("Tahoma", 14, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

--buttons
local indicator_checkbox = menu.add_checkbox("Hit rate percentage", "Enable Indicator (in-game)")
local consoleprint_checkbox = menu.add_checkbox("Hit rate percentage", "Print hitrate & shots to console")

local xaxis = menu.add_slider("Hit rate percentage", "x", 0, 1890, 1, 0)
local yaxis = menu.add_slider("Hit rate percentage", "y", 0, 1051, 1, 0)

--set default
xaxis:set(210)
yaxis:set(455)
indicator_checkbox:set(true)


function on_aimbot_hit(hit)
    print("hit", hit.player:get_name(), "for", hit.damage, "hp")

    hits = hits + 1
    totalshots = totalshots + 1

    --calculate hitrate in function (calling it elsewhere seems to have delay?)
    hitratelocal = math.ceil(hits / totalshots * 100)

    if (consoleprint_checkbox:get() == true) then
        print("( hits / total shots / hitrate ) | [ "..hits.. " / "..totalshots.." / "..hitratelocal.."% ]")
    end

end

function on_aimbot_miss(miss)
    print("missed", miss.player:get_name(), "due to", miss.reason_string)

    totalshots = totalshots + 1
    --calculate hitrate in function (calling it elsewhere seems to have delay?)
    hitratelocal = math.ceil(hits / totalshots * 100)

    if (consoleprint_checkbox:get() == true) then
        print("( hits / total shots / hitrate ) | [ "..hits.. " / "..totalshots.." / "..hitratelocal.."% ]")
    end

end

function on_paint()

    --check if in game
    if (engine.is_in_game() == false) then
        totalshots = 0
        hits = 0
        return
    end
    
    --calculate hitrate
    hitrate = math.ceil(hits / totalshots * 100)
    if (totalshots == 0)
    then
        hitrate = 0
    end

    --apply different color based on hitrate
    if (hitrate > 66) then
        progresscolor = color_t.new(100, 255, 79)
    elseif (hitrate > 33 and hitrate < 66) then
        progresscolor = color_t.new(203, 214, 84)
    elseif (hitrate > 0 and hitrate < 33) then
        progresscolor = color_t.new(186, 58, 58)
    elseif (totalshots == 0) then
        progresscolor = color_t.new(255, 255, 255)
    end


    --calculate progress in float
    progress = hitrate / 100

    --if 0 bullets hit then...
    if (hitrate == 0) then
        progress = 1.0
    end

    --draw indicator
    if (indicator_checkbox:get() == true) then

        local xaxis = xaxis:get()
        local yaxis = yaxis:get()

        local numberxaxis = xaxis
        local numberyaxis = yaxis

        --dynamicly adjust number position based of amount of zeros
        if (hitrate > 10 and hitrate < 99) then
            numberxaxis = numberxaxis - 6
        elseif (hitrate > 99) then
            numberxaxis = numberxaxis - 13
        end

        --fading color stuff
        SPEED = 0.35
        col1 = color_t(0, 0, 0)
        col2 = color_t(0, 0, 0)

        if (hitrate > 66) then
            col1 = color_t(100, 255, 79)
            col2 = color_t(0, 0, 0)
        elseif (hitrate > 33 and hitrate < 66) then
            col1 = color_t(203, 214, 84)
            col2 = color_t(0, 0, 0)
        elseif (hitrate > 0 and hitrate < 33) then
            col1 = color_t(186, 58, 58)
            col2 = color_t(0, 0, 0)
        elseif (totalshots == 0) then
            col1 = color_t(186, 58, 58)
            col2 = color_t(255, 255, 255)
        end
    
        local fade_factor = (math.sin(math.pi * 2.0 * (global_vars.real_time() * SPEED % 100)) + 1.0) / 2.0
        local faded_color = col1:fade(col2, fade_factor)
        
        render.circle_filled(vec2_t.new(xaxis, yaxis), 28, color_t.new(0, 0, 0))
        render.progress_circle(vec2_t.new(xaxis, yaxis), 26, faded_color, 3, progress)

        render.text(main_font, tostring(hitrate), vec2_t(numberxaxis - 6, yaxis - 19), color_t(240, 240, 240, 240))
        render.text(percentage_font, "%", vec2_t(xaxis - 5 , yaxis + 8), color_t(240, 240, 240, 240))
    end

end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)