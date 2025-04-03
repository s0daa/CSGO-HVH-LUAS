local img = render.load_image("image1.png")
local img2 = render.load_image("image2.png")
local img3 = render.load_image("image3.png")
--main
local selectimg = menu.add_multi_selection("main", "Images", {"Image-I", "Image-II", "Image-III"})
local mousedrag = menu.add_multi_selection("main", "dragable image?", {"Image-I", "Image-II", "Image-III"})
--1
local xslider = menu.add_slider("Image-I", "size: x", 1, 5000)
local yslider = menu.add_slider("Image-I", "size: y", 1, 5000)
local xpos = menu.add_slider("Image-I", "pos: x", -2000, 2000)
local ypos = menu.add_slider("Image-I", "pos: y", -2000, 2000)
xslider:set_visible(false)
yslider:set_visible(false)
xpos:set_visible(false)
ypos:set_visible(false)

xslider:set(img.size.x)
yslider:set(img.size.y)
xpos:set(100)
ypos:set(100)
--2
local TWxslider = menu.add_slider("Image-II", "size: x", -2000, 5000)
local TWyslider = menu.add_slider("Image-II", "size: y", -2000, 5000)
local TWxpos = menu.add_slider("Image-II", "pos: x", -2000, 2000)
local TWypos = menu.add_slider("Image-II", "pos: y", -2000, 2000)
TWxslider:set_visible(false)
TWyslider:set_visible(false)
TWxpos:set_visible(false)
TWypos:set_visible(false)


TWxslider:set(img2.size.x)
TWyslider:set(img2.size.y)
TWxpos:set(100)
TWypos:set(100)
--3
local THxslider = menu.add_slider("Image-III", "size: x", -2000, 5000)
local THyslider = menu.add_slider("Image-III", "size: y", -2000, 5000)
local THxpos = menu.add_slider("Image-III", "pos: x", -2000, 2000)
local THypos = menu.add_slider("Image-III", "pos: y", -2000, 2000)
THxslider:set_visible(false)
THyslider:set_visible(false)
THxpos:set_visible(false)
THypos:set_visible(false)

THxslider:set(img3.size.x)
THyslider:set(img3.size.y)
THxpos:set(100)
THypos:set(100)
--image data/reset
local defx = img.size.x
local defy = img.size.y
local function img_reset()
    xslider:set(defx)
    yslider:set(defy)
end

local TWdefx = img2.size.x
local TWdefy = img2.size.y
local function img2_reset()
    TWxslider:set(TWdefx)
    TWyslider:set(TWdefy)
end

local THdefx = img3.size.x
local THdefy = img3.size.y
local function img3_reset()
    THxslider:set(THdefx)
    THyslider:set(THdefy)
end

print("Image-I: ", "x", defx, "y", defy)
print("Image-II: ", "X", TWdefx, "y", TWdefy)
print("Image-III: ", "x", THdefx, "y", THdefy)

local resbutton = menu.add_button("Image-I", "reset size to default", img_reset)
local TWresbutton = menu.add_button("Image-II", "reset size to default", img2_reset)
local THresbutton = menu.add_button("Image-III", "reset size to default", img3_reset)
resbutton:set_visible(false)
TWresbutton:set_visible(false)
THresbutton:set_visible(false)
--callbacks
--img1
callbacks.add(e_callbacks.PAINT, function()
    local mousepos = input.get_mouse_pos()
    if selectimg:get(1) then
        render.texture(img.id, vec2_t(xpos:get(), ypos:get()), vec2_t(xslider:get(),yslider:get()))
        if mousedrag:get(1) and input.is_key_held(e_keys.MOUSE_LEFT) and menu.is_open() and  input.is_mouse_in_bounds(vec2_t(xpos:get()-15, ypos:get()-15), vec2_t(xslider:get(), yslider:get())) then
            xpos:set(mousepos.x)
            ypos:set(mousepos.y)
        end
    end
end)

--img2
callbacks.add(e_callbacks.PAINT,function()
    local mousepos2 = input.get_mouse_pos()
    if selectimg:get(2) then
        render.texture(img2.id, vec2_t(TWxpos:get(), TWypos:get()), vec2_t(TWxslider:get(),TWyslider:get()))
        if mousedrag:get(2) and input.is_key_held(e_keys.MOUSE_LEFT) and menu.is_open() and  input.is_mouse_in_bounds(vec2_t(TWxpos:get()-15, TWypos:get()-15), vec2_t(TWxslider:get(), TWyslider:get())) then
            TWxpos:set(mousepos2.x)
            TWypos:set(mousepos2.y)
        end
    end
end)

--img3
callbacks.add(e_callbacks.PAINT,function()
    local mousepos3 = input.get_mouse_pos()
    if selectimg:get(3) then
        render.texture(img3.id, vec2_t(THxpos:get(), THypos:get()), vec2_t(THxslider:get(),THyslider:get()))
        if mousedrag:get(3) and input.is_key_held(e_keys.MOUSE_LEFT) and menu.is_open() and  input.is_mouse_in_bounds(vec2_t(THxpos:get()-15, THypos:get()-15), vec2_t(THxslider:get(), THyslider:get())) then
            THxpos:set(mousepos3.x)
            THypos:set(mousepos3.y)
        end
    end
end)

--visibility
--img1
callbacks.add(e_callbacks.PAINT,function()
    if selectimg:get(1) then
        xslider:set_visible(true)
        yslider:set_visible(true)
        xpos:set_visible(true)
        ypos:set_visible(true)
        resbutton:set_visible(true)
    else
        xslider:set_visible(false)
        yslider:set_visible(false)
        xpos:set_visible(false)
        ypos:set_visible(false)
        resbutton:set_visible(false)
    end
end)

--img2
callbacks.add(e_callbacks.PAINT,function()
    if selectimg:get(2) then
        TWxslider:set_visible(true)
        TWyslider:set_visible(true)
        TWxpos:set_visible(true)
        TWypos:set_visible(true)
        TWresbutton:set_visible(true)
    else
        TWxslider:set_visible(false)
        TWyslider:set_visible(false)
        TWxpos:set_visible(false)
        TWypos:set_visible(false)
        TWresbutton:set_visible(false)
    end
end)

--img3
callbacks.add(e_callbacks.PAINT,function()
    if selectimg:get(3) then
        THxslider:set_visible(true)
        THyslider:set_visible(true)
        THxpos:set_visible(true)
        THypos:set_visible(true)
        THresbutton:set_visible(true)
    else
        THxslider:set_visible(false)
        THyslider:set_visible(false)
        THxpos:set_visible(false)
        THypos:set_visible(false)
        THresbutton:set_visible(false)
    end
end)