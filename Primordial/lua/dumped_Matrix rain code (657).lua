local RAIN_CHARACTERS ={"ぼ","ほ","カ","サ","ザ","ガ","キ","ポ","ホ","ボ","ぁ","ナ","ド","ト","デ","テ"}
local font_size = 50
local width, height = render.get_screen_size().x, render.get_screen_size().y
local columns = width/font_size
local drops = {}
local tail_length = 17

local fonts = {
    agency = render.create_font("terminal.ttf", 50,20,e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
}
for i = 1, columns do
    drops[i] = height
end

local color_table = {}

for i = 1, height do
    local alpha = 255 - math.floor((i-1) * (255 / height))
    table.insert(color_table, color_t(11, 133, 0, alpha))
end
local function update_drops()
    for i = 1, #drops do
        if drops[i]*font_size > height then
            drops[i] = 1
        else
            drops[i] = drops[i] + 1
        end
    end
end
local speed = 0.1 -- change the speed to 0.5 font sizes per frame
local function newdaw()
    local rain_characters = {}
    local char = RAIN_CHARACTERS[math.random(1, #RAIN_CHARACTERS)]
    render.rect_filled(vec2_t(width - width, height - height),vec2_t(width, height), color_t(0,0,0))


    for i = 1, #drops do
        local char = RAIN_CHARACTERS[math.random(#RAIN_CHARACTERS)]
        local x = (i - 1) * font_size
        local y = (drops[i] - 1) * font_size
        local color_index = math.min(math.floor(drops[i]/20)+1, #color_table)
        local jax = 0
        for j = 1, tail_length do
            local y = (drops[i] - tail_length + j - 1) * font_size
            jax = j
            render.rect_fade(vec2_t(x, y-650), vec2_t(34, 600), color_t(0,0,0,190), color_t(0,0,0,0))
            if jax == tail_length then
                render.text(fonts.agency, RAIN_CHARACTERS[math.random(1, #RAIN_CHARACTERS)],vec2_t(x, y), color_t(255, 255, 255, 255))
            else
                render.text(fonts.agency,RAIN_CHARACTERS[math.random(1, #RAIN_CHARACTERS)], vec2_t(x, y), color_table[color_index])
            end
        end

        if drops[i]*font_size > height and math.random(0,100) == 1 then
            drops[i] = 1
        end
        
        drops[i] = drops[i] + speed -- change the speed to 0.5 font sizes per frame
    end
end

local function draw()
    newdaw()
    client.delay_call(draw, 2000) -- decrease delay time for faster movement
end

callbacks.add(e_callbacks.PAINT, draw)