local enabled = true

local screen_size = render.get_screen_size()
local x = screen_size.x / 1.98
local y = screen_size.y / 2.01

local main_font = render.create_font("Verdana", 12, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

local Enable = menu.add_checkbox("General", "Show Normal Damage", on_paint)

local AutoO = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local ScoutO = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local DeagleO = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local RevolverO = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local PistolO = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local AwpO = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local Auto = menu.find("aimbot", "auto", "targeting","min. damage")
local Scout = menu.find("aimbot", "scout", "targeting","min. damage")
local Deagle = menu.find("aimbot", "deagle", "targeting","min. damage")
local Revolver = menu.find("aimbot", "revolver", "targeting","min. damage")
local Pistol = menu.find("aimbot", "pistols", "targeting","min. damage")
local Awp = menu.find("aimbot", "awp", "targeting","min. damage")

local AutoFO = unpack(menu.find("aimbot", "auto", "target overrides", "force min. damage"))
local ScoutFO = unpack(menu.find("aimbot", "scout", "target overrides", "force min. damage"))
local DeagleFO = unpack(menu.find("aimbot", "deagle", "target overrides", "force min. damage"))
local RevolverFO = unpack(menu.find("aimbot", "revolver", "target overrides", "force min. damage"))
local PistolFO = unpack(menu.find("aimbot", "pistols", "target overrides", "force min. damage"))
local AwpFO = unpack(menu.find("aimbot", "awp", "target overrides", "force min. damage"))

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

local function on_paint()
    if enabled then

      --  if menu.is_open() then return end
        if Enable:get() then

            if getweapon() == "ssg08" then
                if ScoutO[2]:get() then
                    render.text(main_font, tostring(ScoutFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else Enable:get()
                    render.text(main_font, tostring(Scout:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "deagle" then
                if DeagleO[2]:get() then
                    render.text(main_font, tostring(DeagleFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else Enable:get() 
                    render.text(main_font, tostring(Deagle:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "revolver" then
                if RevolverO[2]:get() then
                    render.text(main_font, tostring(RevolverFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else Enable:get() 
                    render.text(main_font, tostring(Revolver:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "awp" then
                if AwpO[2]:get() then
                    render.text(main_font, tostring(AwpFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else Enable:get() 
                    render.text(main_font, tostring(Awp:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
                if AutoO[2]:get() then
                    render.text(main_font, tostring(AutoFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else Enable:get() 
                    render.text(main_font, tostring(Auto:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
                if PistolO[2]:get() then
                    render.text(main_font, tostring(PistolFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                else Enable:get() 
                    render.text(main_font, tostring(Pistol:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            end
        else
            if getweapon() == "ssg08" then
                if ScoutO[2]:get() then
                    render.text(main_font, tostring(ScoutFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "deagle" then
                if DeagleO[2]:get() then
                    render.text(main_font, tostring(DeagleFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "revolver" then
                if RevolverO[2]:get() then
                    render.text(main_font, tostring(RevolverFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "awp" then
                if AwpO[2]:get() then
                    render.text(main_font, tostring(AwpFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
                if AutoO[2]:get() then
                    render.text(main_font, tostring(AutoFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
                if PistolO[2]:get() then
                    render.text(main_font, tostring(PistolFO:get()), vec2_t(x, y - 16), color_t(255, 255, 255))
                end
            end
        end

    end
end

callbacks.add(e_callbacks.PAINT, on_paint)