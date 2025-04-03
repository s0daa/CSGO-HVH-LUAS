local ref = ui.create("Infopanel")
    local switch1 = ref:switch("Enable", true)
    local theme_sel = ref:combo("Selection Theme", {"Default","Modern","Wraith"})
    local vers_sel = ref:combo("Selection build name", {"Beta","Stable"})
    local name_sel = ref:combo("Selection Name", {"In game","In cheat","Custom"})
    local script_sel = ref:combo("Selection script name", {"Exscord","Custom","Wraith"})
    local avatr_sel = ref:combo("Selection avatar type", {"Steam","Primordial meme","Ukraine","Bear"})
    local cstm_nm = ref:input("Custom Name")
    local cht_nm = ref:input("Custom Name")
    local clr2 = ref:color_picker("Theme")
    local is_avatar = ref:switch("Enable Picture", false)
    common.add_notify("Welcome!", "Hi, "..common.get_username())
    print_dev("Last update \n[+] Added Modern Theme\n[+] Added Offset panel\n[+] Added pictures\n====================\nBy OG Leaks\n\n")
    print_raw("\n-----Info panel-----\nLast update \n====================\n[+] Added Modern Theme\n[+] Added Offset panel\n====================\nBy OG LEAKS\n")   
    cstm_nm:set_visible(false)
    local vec = vector(1, 2, 3)

-- There are 3 fields you can access: "x", "y", and "z"
print(string.format("x: %.2f, y: %.2f, z: %.2f", vec.x, vec.y, vec.z))
local closest_distance
local closest_enemy
-- You can also set them
vec.x, vec.y, vec.z = 0, 0, 0

events.render:set(function()
	-- All vectors are 3D, even the ones you'd expect to be 2D
	local screen_center = render.screen_size() * 0.5

	local local_player = entity.get_local_player()
	if not local_player or not local_player:is_alive() then
		return
	end

	local camera_position = render.camera_position()

	-- Even angles are 3D vectors
	-- x is pitch, y is yaw, z is roll
	local camera_angles = render.camera_angles()

	-- Let's convert it to a forward vector though
	local direction = vector():angles(camera_angles)

    closest_distance, closest_enemy = math.huge
	for _, enemy in ipairs(entity.get_players(true)) do
		local head_position = enemy:get_hitbox_position(1)

		local ray_distance = head_position:dist_to_ray(
			camera_position, direction
		)
		
		if ray_distance < closest_distance then
			closest_distance = ray_distance
			closest_enemy = enemy
		end
	end

	if not closest_enemy then
		return
	end
end)
    cht_nm:set_visible(false)
    local offst_sld = ref:slider("Offset panel", 0, 20)
    local function vsbl()
        if switch1:get() then
            avatr_sel:set_visible(true)
            is_avatar:set_visible(true)
            clr2:set_visible(false)
            theme_sel:set_visible(true)
            vers_sel:set_visible(true)
            name_sel:set_visible(true)
            script_sel:set_visible(true)
            avatr_sel:set_visible(true)
            cstm_nm:set_visible(true)
            cht_nm:set_visible(true)
            clr2:set_visible(true)
            is_avatar:set_visible(true)
            offst_sld:set_visible(true)
            if theme_sel:get() == "Default" then
                offst_sld:set_visible(false)
            elseif theme_sel:get() == "Modern" then
                is_avatar:set_visible(true)
                offst_sld:set_visible(true)
            end
            if script_sel:get() == "Custom" then
                cht_nm:set_visible(true)
            else
                cht_nm:set_visible(false)
            end
            if name_sel:get() == "Custom" then
                cstm_nm:set_visible(true)
            else
                cstm_nm:set_visible(false)
            end
            if theme_sel:get() == "Wraith" then
                avatr_sel:set_visible(false)
                is_avatar:set_visible(false)
                offst_sld:set_visible(true)
                clr2:set_visible(true)
            end
        else
            theme_sel:set_visible(false)
            vers_sel:set_visible(false)
            name_sel:set_visible(false)
            script_sel:set_visible(false)
            avatr_sel:set_visible(false)
            cstm_nm:set_visible(false)
            cht_nm:set_visible(false)
            clr2:set_visible(false)
            is_avatar:set_visible(false)
            offst_sld:set_visible(false)
        end
        
    end
    events.render:set(vsbl)
    local clrvrs = {    
        ["Alpha"] = color(154,163,190),
        ["Beta"] = color(120,127,144),
        ["Stable"] = color(120,127,144),
    }
    local vers = {
        ["Beta"] = "[beta]",
        ["Stable"] = "[stable]",
    }
    local vers2 = {
        ["Beta"] = "debug",
        ["Stable"] = "stable",
    }
    local clrs = {
        ["Beta"] = color(145,174,226),
        ["Stable"] = color(164,240,126),
    }
    local url = network.get("https://media.discordapp.net/attachments/928964752108052490/1011531989897203792/6hd5uf.gif")
    local url2 = network.get("https://media.discordapp.net/attachments/570340123036745739/818875723988598794/778260883809763378.gif")
    local url3 = network.get("https://cdn.discordapp.com/attachments/871384724864643103/1018102441872474182/beya-beyabear.gif")
    local prm = render.load_image(url)
    local ukr = render.load_image(url2)
    local br = render.load_image(url3)
    local function bebra()
        local lp = entity.get_local_player()
        if lp == nil then return end
        local angles = lp:get_anim_state()
        local avatar = lp:get_steam_avatar()
        local lplayer_name = entity.get_local_player():get_name()
        local avtr = {
            ["Primordial meme"] = prm,
            ["Steam"] = lp:get_steam_avatar(),
            ["Ukraine"] = ukr,
            ["Bear"] = br,
        }
        if lplayer_name == nil then return end
        local namevar = {
            ["In cheat"] = common.get_username(),   
            ["Custom"] = cstm_nm:get(),
            ["In game"] = lplayer_name
        }
        local scriptname = {
            ["Exscord"] = "exscord.technologies",
            ["Custom"] = cht_nm:get(),
            ["Wraith"] = "wraith.lua"
        }
        if not switch1:get() then return end
        local scrsize = render.screen_size()
        local systime = common.get_system_time()
        local textwtr = ("> "..scriptname[script_sel:get()])
        local textwtr2 = ("> user: "..namevar[name_sel:get()])
        local txtsize = render.measure_text(1,"с", textwtr2).x
    if theme_sel:get() == "Default" then
        render.texture(avtr[avatr_sel:get()],vector(1,scrsize.y/2-10), vector(25,25))
        render.text(1, vector(1+27,scrsize.y/2-10+10), color(255,255,255), "с", textwtr2)
        render.text(1, vector(1+27,scrsize.y/2-10), color(255,255,255), "с", textwtr)
        render.text(1, vector(1+txtsize+28,scrsize.y/2-10+10), clrs[vers_sel:get()], "с", vers[vers_sel:get()])
    elseif theme_sel:get() == "Modern" then
        if is_avatar:get() then
            local txtsize33 = render.measure_text(1,"с", "> "..scriptname[script_sel:get()]..", version: ")
            local txtsize44 = render.measure_text(1,"с", "> user: ")
            local txtsize55 = render.measure_text(1,"с", "> desync angle: ")
            local txtsize66 = render.measure_text(1,"с", "> anti-aim state: ")
            if lp.m_fFlags == 263 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "crouching")
            elseif lp.m_vecVelocity:length2d() < 5 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "standing")
            elseif lp.m_fFlags == 256 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "air")
            elseif lp.m_fFlags == 262 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "c-air")
            elseif lp.m_vecVelocity:length2d() <= 90 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "slowwalk")
            elseif lp.m_vecVelocity:length2d() >= 100 then
                render.text(1, vector(offst_sld:get()+txtsize66.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "moving")
            end
            render.texture(avtr[avatr_sel:get()],vector(offst_sld:get(),scrsize.y/2),vector(50,50))
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2), color(255,255,255), "с",  "> "..scriptname[script_sel:get()]..", version: ")
            render.text(1, vector(offst_sld:get()+txtsize33.x+53,scrsize.y/2), clrs[vers_sel:get()], "с",  vers[vers_sel:get()])
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2+txtsize33.y+1), color(255,255,255), "с",  "> user: ")
            render.text(1, vector(offst_sld:get()+txtsize44.x+53,scrsize.y/2+txtsize33.y+1), clrs[vers_sel:get()], "с",  namevar[name_sel:get()])
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2+txtsize33.y+1+txtsize44.y), color(255,255,255), "с",  "> desync angle: ")
            render.text(1, vector(offst_sld:get()+txtsize55.x+53,scrsize.y/2+txtsize33.y+1+txtsize44.y), clrs[vers_sel:get()], "с",  math.floor(rage.antiaim:get_max_desync()).."°")
            render.text(1, vector(offst_sld:get()+53,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), color(255,255,255), "с",  "> anti-aim state: ")
        else
            local txtsize33 = render.measure_text(1,"с", "> "..scriptname[script_sel:get()]..", version: ")
            local txtsize44 = render.measure_text(1,"с", "> user: ")
            local txtsize55 = render.measure_text(1,"с", "> desync angle: ")
            local txtsize66 = render.measure_text(1,"с", "> anti-aim state: ")
            if lp.m_fFlags == 263 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "crouching")
            elseif lp.m_vecVelocity:length2d() < 5 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "standing")
            elseif lp.m_fFlags == 256 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "air")
            elseif lp.m_fFlags == 262 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "c-air")
            elseif lp.m_vecVelocity:length2d() <= 90 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "slowwalk")
            elseif lp.m_vecVelocity:length2d() >= 100 then
                render.text(1, vector(offst_sld:get()+txtsize66.x,scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), clrs[vers_sel:get()], "с",  "moving")
            end
            render.text(1, vector(offst_sld:get(),scrsize.y/2), color(255,255,255), "с",  "> "..scriptname[script_sel:get()]..", version: ")
            render.text(1, vector(offst_sld:get()+txtsize33.x,scrsize.y/2), clrs[vers_sel:get()], "с",  vers[vers_sel:get()])
            render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize33.y+1), color(255,255,255), "с",  "> user: ")
            render.text(1, vector(offst_sld:get()+txtsize44.x,scrsize.y/2+txtsize33.y+1), clrs[vers_sel:get()], "с",  namevar[name_sel:get()])
            render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize33.y+1+txtsize44.y), color(255,255,255), "с",  "> desync angle: ")
            render.text(1, vector(offst_sld:get()+txtsize55.x,scrsize.y/2+txtsize33.y+1+txtsize44.y), clrs[vers_sel:get()], "с",  math.floor(rage.antiaim:get_max_desync()).."°")
            render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize33.y+1+txtsize44.y+txtsize55.y), color(255,255,255), "с",  "> anti-aim state: ")
        end
    elseif theme_sel:get() == "Wraith" then
        local txtsize9 = render.measure_text(1,"",scriptname[script_sel:get()].." - "..namevar[name_sel:get()])
        local txtsize10 = render.measure_text(1,"","version: ")
        local txtsize11 = render.measure_text(1,"","exploit charge: ")
        local txtsize12 = render.measure_text(1,"","desync amount: ")  
        local txtsize13 = render.measure_text(1,"","target: ")
        render.text(1, vector(offst_sld:get(),scrsize.y/2), color(255,255,255), "с",  scriptname[script_sel:get()].." - "..namevar[name_sel:get()])
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y), color(255,255,255), "с",  "version: ")
        render.text(1, vector(offst_sld:get()+txtsize10.x-2,scrsize.y/2+txtsize9.y), clr2:get(), "с",  vers2[vers_sel:get()])
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "exploit charge: ")
        if rage.exploit:get() > 0 and rage.exploit:get() < 1 then
            render.text(1, vector(offst_sld:get()+txtsize11.x,scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "charging")
        elseif rage.exploit:get() == 0 then
            render.text(1, vector(offst_sld:get()+txtsize11.x-2,scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "false")
        elseif rage.exploit:get() == 1 then
            render.text(1, vector(offst_sld:get()+txtsize11.x-2,scrsize.y/2+txtsize9.y*2), color(255,255,255), "с",  "true")
        end
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y*3), color(255,255,255), "с",  "desync amount: ")
        render.text(1, vector(offst_sld:get(),scrsize.y/2+txtsize9.y*4), color(255,255,255), "с",  "target: ")
        if not closest_enemy then
            render.text(1, vector(offst_sld:get()+txtsize13.x-2,scrsize.y/2+txtsize9.y*4), color(255,255,255), "с", "none")
        else
            render.text(1, vector(offst_sld:get()+txtsize13.x-2,scrsize.y/2+txtsize9.y*4), color(255,255,255), "с",  closest_enemy:get_name())
        end
        render.text(1, vector(offst_sld:get()+txtsize12.x,scrsize.y/2+txtsize9.y*3), color(255,255,255), "с",  math.floor(rage.antiaim:get_max_desync()).."° ("..math.floor(rage.antiaim:get_max_desync()+math.random(-3,-  2)).."°)") 
    end
    end
    events.render:set(bebra)