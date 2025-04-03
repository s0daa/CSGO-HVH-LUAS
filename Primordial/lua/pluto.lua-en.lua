require("primordial/UI Callbacks.198")
local notifications = require("primordial/notification pop-up library.58")
local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)
local weaponselection = menu.add_selection("AimBot","arms",{"awp","auto","scout","deagle","revolver","pistols","other"})
local version = "v2.6"
menu.add_text("Version information",version)
menu.add_text("Version information","--------------------------------------------------------")

local arsenal = {
    ["awp"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "awp Hitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "awp MultipointHitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "awp Hitchance", 1, 100),
        ["DmgAccuracy"]= menu.add_slider("AimBot", "awp DMG accuracy ", 1, 100),
        ["Jump"] = menu.find("aimbot", "awp", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "awp min DMG", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "awp Automatic processing"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "awp Automatic processing mode", {"override HitBox","Open safety point"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "awp Auto process off override condition", {"Hit the player","Kill players"}),
        ["maxMiss"] = menu.add_slider("AimBot", "awp maxMiss", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "awp overrides HitBox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["AdaptiveDmg"] = menu.add_checkbox("AimBot", "awp Adaptive damage"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "awp", "targeting", "min. damage"),
        ["AdaptiveAutoWallDmgMenu"] =  menu.find("aimbot", "awp", "targeting", "autowall"),
        ["hitboxes"] = menu.find("aimbot", "awp", "hitbox selection", "hitboxes"),
        ["multipoints"] = menu.find("aimbot", "awp", "hitbox selection", "multipoints")
    },
    ["auto"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "auto Hitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "auto MultipointHitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "auto Hitchance", 1, 100),
        ["Jump"] = menu.find("aimbot", "auto", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "auto min DMG", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "auto Automatic processing"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "auto Automatic processing mode", {"override HitBox","Open safety point"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "auto Auto process off override condition", {"Hit the player","Kill players"}),
        ["maxMiss"] = menu.add_slider("AimBot", "auto maxMiss", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "auto overrides HitBox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["AdaptiveDmg"] = menu.add_checkbox("AimBot", "auto Adaptive damage"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "auto", "targeting", "min. damage"),
        ["AdaptiveAutoWallDmgMenu"] =  menu.find("aimbot", "auto", "targeting", "autowall"),
        ["hitboxes"] = menu.find("aimbot", "auto", "hitbox selection", "hitboxes"),
        ["multipoints"] = menu.find("aimbot", "auto", "hitbox selection", "multipoints")
    },
    ["scout"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "scout Hitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "scout MultipointHitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "scout Hitchance", 1, 100),
        ["DmgAccuracy"]= menu.add_slider("AimBot", "scout DMG accuracy ", 1, 100),
        ["Jump"] = menu.find("aimbot", "scout", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "scout min DMG", 1, 100),
        ["JumpBox"] = menu.add_checkbox("AimBot", "scout 跳狙"),
        ["Airhitrate"] = menu.add_slider("AimBot", "scout 空中命中率", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "scout Automatic processing"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "scout Automatic processing mode", {"override HitBox","Open safety point"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "scout Auto process off override condition", {"Hit the player","Kill players"}),
        ["maxMiss"] = menu.add_slider("AimBot", "scout maxMiss", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "scout overrides HitBox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["hitboxes"] = menu.find("aimbot", "scout", "hitbox selection", "hitboxes"),
        ["multipoints"] = menu.find("aimbot", "scout", "hitbox selection", "multipoints"),
        ["AdaptiveDmg"] = menu.add_checkbox("AimBot", "scout Adaptive damage"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "scout", "targeting", "min. damage"),
        ["AdaptiveAutoWallDmgMenu"] =  menu.find("aimbot", "scout", "targeting", "autowall")
    },
    ["revolver"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "revolver Hitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "revolver MultipointHitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "revolver Hitchance", 1, 100),
        ["Jump"] = menu.find("aimbot", "revolver", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "revolver min DMG", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "revolver Automatic processing"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "revolver Automatic processing mode", {"override HitBox","Open safety point"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "revolver Auto process off override condition", {"Hit the player","Kill players"}),
        ["maxMiss"] = menu.add_slider("AimBot", "revolver maxMiss", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "revolver overrides HitBox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["hitboxes"] = menu.find("aimbot", "revolver", "hitbox selection", "hitboxes"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "revolver", "targeting", "min. damage"),
        ["multipoints"] = menu.find("aimbot", "revolver", "hitbox selection", "multipoints")
    },
    ["deagle"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "deagle Hitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "deagle MultipointHitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "deagle Hitchance", 1, 100),
        ["Jump"] = menu.find("aimbot", "deagle", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "deagle min DMG", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "deagle Automatic processing"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "deagle Automatic processing mode", {"override HitBox","Open safety point"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "deagle Auto process off override condition", {"Hit the player","Kill players"}),
        ["maxMiss"] = menu.add_slider("AimBot", "deagle maxMiss", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "deagle overrides HitBox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["hitboxes"] = menu.find("aimbot", "deagle", "hitbox selection", "hitboxes"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "deagle", "targeting", "min. damage"),
        ["multipoints"] = menu.find("aimbot", "deagle", "hitbox selection", "multipoints")
    },
    ["pistols"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "pistols Hitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "pistols MultipointHitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "pistols Hitchance", 1, 100),
        ["Jump"] = menu.find("aimbot", "pistols", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "pistols min DMG", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "pistols Automatic processing"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "pistols Automatic processing mode", {"override HitBox","Open safety point"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "pistols Auto process off override condition", {"Hit the player","Kill players"}),
        ["maxMiss"] = menu.add_slider("AimBot", "pistols maxMiss", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "pistols overrides HitBox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["hitboxes"] = menu.find("aimbot", "pistols", "hitbox selection", "hitboxes"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "pistols", "targeting", "min. damage"),
        ["multipoints"] = menu.find("aimbot", "pistols", "hitbox selection", "multipoints")
    },
    ["other"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "other Hitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "other MultipointHitbox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "other Hitchance", 1, 100),
        ["Jump"] = menu.find("aimbot", "other", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "other min DMG", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "other Automatic processing"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "other Automatic processing mode", {"override HitBox","Open safety point"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "other Auto process off override condition", {"Hit the player","Kill players"}),
        ["maxMiss"] = menu.add_slider("AimBot", "other maxMiss", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "other overrides HitBox", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["hitboxes"] = menu.find("aimbot", "other", "hitbox selection", "hitboxes"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "other", "targeting", "min. damage"),
        ["multipoints"] = menu.find("aimbot", "other", "hitbox selection", "multipoints")
    }
}

menu.add_callback(weaponselection, function()
    local selectNam = weaponselection:get_item_name(weaponselection:get())
    for k,v in pairs(arsenal) do
        if k~= selectNam then
            local Selectedweapon = v
            for k1,v1 in pairs(Selectedweapon) do
                if v1~=nil and type(v1)=="userdata" then
                    local selectfun = v1
                    selectfun:set_visible(false)
                end
            end
        else
            local Selectedweapon = v
            for k1,v1 in pairs(Selectedweapon) do
                if v1~=nil and type(v1)=="userdata" then
                    local selectfun = v1
                    selectfun:set_visible(true)
                end
            end
        end
    end
end)


--misc
local ScreenSize = render.get_screen_size()
local ScreenCenterX = ScreenSize.x / 2
local ScreenCenterY = ScreenSize.y / 2
local cheat_color = menu.find("misc", "main", "config", "accent color")[2]


--组名板块 start

local plutoTag = {
    '☘',
    '☘P',
    '☘Pl',
    '☘Plu',
    '☘Plut',
    '☘Pluto',
    '☘Pluto.',
    '☘Pluto.l',
    '☘Pluto.lu',
    '☘Pluto.lua',
    '☘Pluto.lu',
    '☘Pluto.l',
    '☘Pluto.',
    '☘Pluto',
    '☘Plut',
    '☘Plu',
    '☘Pl',
    '☘P',
    '☘',
    '',
    '',
    '☘'
}
local qiushui = {
    "野猪组",
    "野猪",
    "野",
    " "
}

local sk = {
    "ga",
    "gam",
    "game",
    "games",
    "gamese",
    "gamesen",
    "gamesens",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "amesense",
    "mesense",
    "esense",
    "sense",
    "ense",
    "nse",
    "se",
    "e",
    "",
    "",
    "",
    "",
    "",
    "",
    "ga",
    "gam",
    "game",
    "games",
    "gamese",
    "gamesen",
    "gamesens",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "amesense",
    "mesense",
    "esense",
    "sense",
    "ense",
    "nse",
    "se",
    "e",
    "",
    "",
    "",
    "",
    "",
    "",
}

local fa = {
    "f",
    "fa",
    "fat",
    "fata",
    "fatal",
    "fatali",
    "fatalit",
    "fatality",
    "fatality.",
    "fatality.w",
    "fatality.wi",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.wi",
    "fatality.w",
    "fatality.",
    "fatality",
    "fatalit",
    "fatali",
    "fatal",
    "fata",
    "fat",
    "fa",
    "f",
    "",
    "",
    "",
    "",
    "",
    "",
    "f",
    "fa",
    "fat",
    "fata",
    "fatal",
    "fatali",
    "fatalit",
    "fatality",
    "fatality.",
    "fatality.w",
    "fatality.wi",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.win",
    "fatality.wi",
    "fatality.w",
    "fatality.",
    "fatality",
    "fatalit",
    "fatali",
    "fatal",
    "fata",
    "fat",
    "fa",
    "f",
    "",
    "",
    "",
    "",
    "",
    "",
  }

local ffi_handler = {}
local tag_changer = {}
local ui = {}


local string_mul = function(text, mul)

    mul = math.floor(mul)

    local to_add = text

    for i = 1, mul-1 do
        text = text .. to_add
    end

    return text
end

ffi_handler.sigs = {}
ffi_handler.sigs.clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
ffi_handler.change_tag_fn = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern(unpack(ffi_handler.sigs.clantag)))

tag_changer.last_time_update = -1
tag_changer.update = function(tag)
    local current_tick = global_vars.tick_count()

    if current_tick > tag_changer.last_time_update then
        tag = tostring(tag)
        ffi_handler.change_tag_fn(tag, tag)
        tag_changer.last_time_update = current_tick + 16
    end
end

tag_changer.build_second = function(text)
    local builded = {}

    for i = 1, #text do

        local tmp = text:sub(i, #text) .. text:sub(1, i-1)

        if tmp:sub(#tmp) == " " then
            tmp = tmp:sub(1, #tmp-1) .. "\t"
        end
        table.insert(builded, tmp)
    end

    return builded
end

ui.is_enabled = menu.add_checkbox("misc","Clantag",false)
ui.type =  menu.add_selection("misc","Clantag",{"Pluto.Lua","野猪组","Gamesense","Fatality"})
ui.speed = menu.add_slider("misc", "Speed", 1, 5)
tag_changer.disabled = true
tag_changer.on_paint = function()
    local is_enabled = ui.is_enabled:get()
    if not engine.is_in_game() or not is_enabled then

        if not is_enabled and not tag_changer.disabled then
            ffi_handler.change_tag_fn("", "")
            tag_changer.disabled = true
        end

        tag_changer.last_time_update = -1
        return
    end
    local tag_type = ui.type:get()
    if tag_type == 1 then
        tag_changer.current_build = plutoTag
    elseif tag_type == 2 then
        tag_changer.current_build = qiushui
    elseif tag_type == 3 then
        tag_changer.current_build = sk
    elseif tag_type == 4 then
        tag_changer.current_build = fa
    end
    local tag_speed = ui.speed:get()
    if tag_type == 3 then
        tag_speed = math.max(1, tag_speed)
    end

    local current_tag = math.floor(global_vars.cur_time() * tag_speed % #tag_changer.current_build) + 1
    current_tag = tag_changer.current_build[current_tag]
    tag_changer.disabled = false
    tag_changer.update(current_tag)
end
--组名板块 end

local dynamicfakewalkenb = menu.add_checkbox("misc","Dynamic false running switch")
local dynamicfakewalkmode = menu.add_selection("misc","Mode",{"loop","Range: random"})
local dynamicfakewalkMin = menu.add_slider("misc","min",1,100)
local dynamicfakewalkMax = menu.add_slider("misc","max",1,100)
local Dynamicinterval = menu.add_slider("misc","Dynamic interval(s)",1,10)
local dynamicfakewalkIncremental = menu.add_slider("misc","Dynamic false incremental value",1,20)
local multi_selection = menu.add_multi_selection("misc", "Animation destruction", {"Slide", "land 0 pitch", "Aerial static leg"})
local ground_tick = 1
local end_time = 0
local fakewalk = menu.find("misc","main","movement","speed")
local fakewalknumer = 0
local fakewalknumertick = 0
local fakelagenb = menu.add_checkbox("misc", "fakelag enhance option")
local fakelag = menu.add_slider("misc", "Fakelag Max", 0, 61)
local backupmaxusr = cvars.sv_maxusrcmdprocessticks:get_int()
local fakelagFun = function(ctx)
    local bRunOnce = false
    if fakelagenb:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(fakelag:get() + 2)

        if engine.get_choked_commands() < fakelag:get() then
            ctx:set_fakelag(true)
        else
            ctx:set_fakelag(false)
        end
        bRunOnce = true
    else
        if bRunOnce then
            cvars.sv_maxusrcmdprocessticks:set_int(backupmaxusr)
            ctx:set_fakelag(true)
            bRunOnce = false
        end
    end
end
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

--vision
local Killeffect = menu.add_checkbox("vision", "Kill screen effects")
local FatalESP = menu.add_checkbox("vision", "Override ESP")
local indicatorEnb = menu.add_checkbox("indicator","indicator")


local thirdperson = menu.find('visuals', 'other', 'thirdperson', 'enable')
local is_attachment_entity = function(e, o)
    if e == nil then return end
    if o == nil then return end
    if not e:is_valid() or not e:is_valid() then
        return
    end
    if e:get_prop('moveparent') ~= nil and entity_list.get_entity(e:get_prop('moveparent')) ~= nil then
        if entity_list.get_entity(e:get_prop('moveparent')):get_index() ~= nil and o:get_index() ~= nil then
            return entity_list.get_entity(e:get_prop('moveparent')):get_index() == o:get_index()
        end
    end
end
local Glow = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "sprites/light_glow04"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local DogtagLight = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/inventory_items/dogtags/dogtags_lightray"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local MP3detail = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/inventory_items/music_kit/darude_01/mp3_detail"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local Speechinfo = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/extras/speech_info"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local Branches = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/props_foliage/urban_tree03_branches"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local Dogstags = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/inventory_items/dogtags/dogtags"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local Dreamhackstar = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/inventory_items/dreamhack_trophies/dreamhack_star_blur"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local Fishnet = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "models/props_shacks/fishing_net01"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local Lightglow = materials.create( "glow_material", [[
      "VertexLitGeneric"
    {
      "$basetexture" "sprites/light_glow04"
      "$additive" "1"
      "$wireframe" "1"
      "Proxies"
      {
              "TextureScroll"
              {
                      "texturescrollvar" "$basetexturetransform"
                      "texturescrollrate" "0.5"
                      "texturescrollangle" "40"
              }
      }
    }
   ]]
)

local glow_materialA = materials.create( "glow_material", [[
      "VertexLitGeneric" {
         "$additive" "1"
         "$envmap" "models/effects/cube_white"
         "$envmaptint" "[1 1 1]"
         "$envmapfresnel" "1"
         "$envmapfresnelminmaxexp" "[0 1 2]"
         "$alpha" "1.0"
      }
   ]]
)

local glow_materialW = materials.create( "glow_material", [[
      "VertexLitGeneric" {
         "$additive" "1"
         "$envmap" "models/effects/cube_white"
         "$envmaptint" "[1 1 1]"
         "$envmapfresnel" "1"
         "$envmapfresnelminmaxexp" "[0 1 2]"
         "$alpha" "1.0"
      }
   ]]
)

local materials =  {
    ["Glow"] = Glow,
    ["Dogtag light"] = DogtagLight,
    ["MP3 detail"] = MP3detail,
    ["Speech info"] = Speechinfo,
    ["Branches"] = Branches,
    ["Dogstags"] = Dogstags,
    ["Dreamhack star"] = Dreamhackstar,
    ["Fishnet"] = Fishnet,
    ["Light glow"] = Lightglow
}

local function getMenuItems(table)
    local names = {}
    for k, v in pairs(table) do
        names[#names + 1] = k
    end
    return names
end


local Weaponcoloring = menu.add_multi_selection('vision', 'Weapon coloring',{'glow','grid'})
local material_comboboxW = menu.add_selection('vision','Weapon grid type',getMenuItems(materials))
local Primitiveweapon = menu.add_checkbox('vision', 'Draw the original model of the weapon')
local WeaponcoloringP1 = Weaponcoloring:add_color_picker('Weapons glow and color')
local WeaponcoloringP = Weaponcoloring:add_color_picker('Weapon grid coloring')
local Armcoloring = menu.add_multi_selection('vision', 'Character coloring',{'glow','grid'})
local material_comboboxA = menu.add_selection('vision','People grid type',getMenuItems(materials))
local Primitivearm = menu.add_checkbox('vision', 'Draw the original model of the character')
local Thirdperspective = menu.add_checkbox('vision', 'Cover the third perspective character model')
local ArmcoloringP1 = Armcoloring:add_color_picker('Character lighting and coloring')
local ArmcoloringP = Armcoloring:add_color_picker('Character grid coloring')
local Breathinglamp=menu.add_checkbox('vision', 'Adaptive transparency')


local on_draw_model = function (ctx)

    if Primitivearm:get() and ctx.model_name:find('models/player')~=nil and ctx.entity~=nil and ctx.entity:is_valid() and ctx.entity:is_player() and ctx.entity:is_alive() and ctx.entity:get_index() == entity_list.get_local_player():get_index() then
        ctx:draw_original(true)
    end

    if Primitivearm:get() and not ctx.model_name:lower():find('w_models') and (ctx.model_name:lower():find('arms') or ctx.model_name:lower():find('sleeve')) then
        ctx:draw_original(true)
    end

    if Primitiveweapon:get() and (ctx.model_name:lower():find('_dropped.mdl') and thirdperson[2]:get() and ctx.model_name:lower():find('weapons/w') and not ctx.model_name:lower():find('ied_dropped')) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        ctx:draw_original(true)
    end

    if Primitiveweapon:get() and ctx.model_name:find('weapons/v_') ~= nil and not ctx.model_name:lower():find('arms') then
        ctx:draw_original(true)
    end

    if Weaponcoloring:get(1) and ctx.model_name:find('weapons/v_') ~= nil and not ctx.model_name:lower():find('arms') then
        local col = WeaponcoloringP1:get()
        local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)
        ctx.override_original = true
        glow_materialW:set_shader_param('$envmaptint', vec3_t(col.r / 255, col.g / 255, col.b / 255))
        glow_materialW:set_shader_param('$alpha', col.a / 255)
        if Breathinglamp:get() then
            glow_materialW:set_shader_param('$envmapfresnelminmaxexp', vec3_t(0.0, 1.0,strength_pulse))
        end
        ctx:draw_material(glow_materialW)
    end
    if (ctx.model_name:lower():find('_dropped.mdl') and thirdperson[2]:get() and ctx.model_name:lower():find('weapons/w') and not ctx.model_name:lower():find('ied_dropped')) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        if Weaponcoloring:get(1) then
            local col = WeaponcoloringP1:get()
            local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)
            ctx.override_original = true
            glow_materialW:set_shader_param('$envmaptint', vec3_t(col.r / 255, col.g / 255, col.b / 255))
            glow_materialW:set_shader_param('$alpha', col.a / 255)
            if Breathinglamp:get() then
                glow_materialW:set_shader_param('$envmapfresnelminmaxexp', vec3_t(0.0, 1.0,strength_pulse))
            end
            ctx:draw_material(glow_materialW)
        end
    end

    if Weaponcoloring:get(2) and ctx.model_name:find('weapons/v_') ~= nil and not ctx.model_name:lower():find('arms') then
        ctx.override_original = true
        local gridW = materials[material_comboboxW:get_item_name(material_comboboxW:get())]
        gridW:color_modulate(WeaponcoloringP:get().r / 255, WeaponcoloringP:get().g / 255, WeaponcoloringP:get().b / 255)
        gridW:alpha_modulate(WeaponcoloringP:get().a / 255)
        ctx:draw_material(gridW)
    end
    if (ctx.model_name:lower():find('_dropped.mdl') and thirdperson[2]:get() and ctx.model_name:lower():find('weapons/w') and not ctx.model_name:lower():find('ied_dropped')) or (ctx.entity ~= nil and thirdperson[2]:get() and is_attachment_entity(ctx.entity, entity_list.get_local_player())) then
        if Weaponcoloring:get(2) then
            ctx.override_original = true
            local gridW = materials[material_comboboxW:get_item_name(material_comboboxW:get())]
            gridW:color_modulate(WeaponcoloringP:get().r / 255, WeaponcoloringP:get().g / 255, WeaponcoloringP:get().b / 255)
            gridW:alpha_modulate(WeaponcoloringP:get().a / 255)
            ctx:draw_material(gridW)
        end
    end


    if Armcoloring:get(2) and not ctx.model_name:lower():find('w_models') and (ctx.model_name:lower():find('arms') or ctx.model_name:lower():find('sleeve')) then
        ctx.override_original = true
        local gridA = materials[material_comboboxA:get_item_name(material_comboboxA:get())]
        gridA:color_modulate(ArmcoloringP:get().r / 255, ArmcoloringP:get().g / 255, ArmcoloringP:get().b / 255)
        gridA:alpha_modulate(ArmcoloringP:get().a / 255)
        ctx:draw_material(gridA)
     end
     if Armcoloring:get(2) and Thirdperspective:get() and ctx.model_name:find('models/player')~=nil then
        if ctx.entity~=nil and ctx.entity:is_valid()and ctx.entity:is_player() and ctx.entity:is_alive() and ctx.entity:get_index() == entity_list.get_local_player():get_index() then
            ctx.override_original = true
            local gridA = materials[material_comboboxA:get_item_name(material_comboboxA:get())]
            gridA:color_modulate(ArmcoloringP:get().r / 255, ArmcoloringP:get().g / 255, ArmcoloringP:get().b / 255)
            gridA:alpha_modulate(ArmcoloringP:get().a / 255)
            ctx:draw_material(gridA)
         end
     end

     if Armcoloring:get(1) and not ctx.model_name:lower():find('w_models') and (ctx.model_name:lower():find('arms') or ctx.model_name:lower():find('sleeve')) then
        local col = ArmcoloringP1:get()
        local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)
        ctx.override_original = true
        glow_materialA:set_shader_param('$envmaptint', vec3_t(col.r / 255, col.g / 255, col.b / 255))
        glow_materialA:set_shader_param('$alpha', col.a / 255)
        if Breathinglamp:get() then
            glow_materialA:set_shader_param('$envmapfresnelminmaxexp', vec3_t(0.0, 1.0,strength_pulse))
        end
        ctx:draw_material(glow_materialA)
     end

     if Armcoloring:get(1) and Thirdperspective:get() and ctx.model_name:find('models/player')~=nil then
        if ctx.entity~=nil and ctx.entity:is_valid() and ctx.entity:is_player() and ctx.entity:is_alive() and ctx.entity:get_index() == entity_list.get_local_player():get_index() then
            local col = ArmcoloringP1:get()
            local strength_pulse = math.floor(math.sin(global_vars.real_time() * 2) * 50 + 50)
            ctx.override_original = true
            glow_materialA:set_shader_param('$envmaptint', vec3_t(col.r / 255, col.g / 255, col.b / 255))
            glow_materialA:set_shader_param('$alpha', col.a / 255)
            if Breathinglamp:get() then
                glow_materialA:set_shader_param('$envmapfresnelminmaxexp', vec3_t(0.0, 1.0,strength_pulse))
            end
            ctx:draw_material(glow_materialA)
         end
     end

end

local textcoro = indicatorEnb:add_color_picker("Text color:")
textcoro:set(cheat_color:get())
local backcoro = indicatorEnb:add_color_picker("background color")
backcoro:set(color_t(7,7,7))
local Height = menu.add_slider("indicator", "Y Pos", -ScreenCenterY, ScreenCenterY)
local Width = menu.add_slider("indicator", "X Pos", -ScreenCenterX, ScreenCenterX)
local awpMinDmg = menu.find("aimbot","awp","targeting","min. damage")
local awpMinDmgForce = unpack(menu.find("aimbot","awp","target overrides","force min. damage"))

local autoMinDmg = menu.find("aimbot","auto","targeting","min. damage")
local autoMinDmgForce = unpack(menu.find("aimbot","auto","target overrides","force min. damage"))

local scoutMinDmg = menu.find("aimbot","scout","targeting","min. damage")
local scoutMinDmgForce = unpack(menu.find("aimbot","scout","target overrides","force min. damage"))

local deagleMinDmg = menu.find("aimbot","deagle","targeting","min. damage")
local deagleMinDmgForce = unpack(menu.find("aimbot","deagle","target overrides","force min. damage"))

local revolverDmg = menu.find("aimbot","revolver","targeting","min. damage")
local revolverDmgForce = unpack(menu.find("aimbot","revolver","target overrides","force min. damage"))

local pistolsDmg = menu.find("aimbot","pistols","targeting","min. damage")
local pistolsDmgForce = unpack(menu.find("aimbot","pistols","target overrides","force min. damage"))

local otherDmg = menu.find("aimbot","other","targeting","min. damage")
local otherDmgForce = unpack(menu.find("aimbot","other","target overrides","force min. damage"))

local min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage")
local min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage")
local min_damage_r = menu.find("aimbot", "revolver", "target overrides", "force min. damage")
local min_damage_d = menu.find("aimbot", "deagle", "target overrides", "force min. damage")
local min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage")
local min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage")
local min_damage_o = menu.find("aimbot","other","target overrides","force min. damage")
local PixelMax = render.create_font("Smallest Pixel-7", 25, 600)

local Drawindicator = function()

    if not indicatorEnb:get() then
        return
    end

    local weaponName = getweapon()
    if weaponName == nil then return end
    local minDmg = 0
    if weaponName == "ssg08" then
        minDmg=scoutMinDmg:get()
        if min_damage_s[2]:get() then
            minDmg=scoutMinDmgForce:get()
        end
    elseif weaponName == "deagle" then
        minDmg=deagleMinDmg:get()
        if min_damage_d[2]:get() then
            minDmg=deagleMinDmgForce:get()
        end
    elseif  weaponName == "revolver"  then
        minDmg=revolverDmg:get()
        if min_damage_r[2]:get() then
            minDmg=revolverDmgForce:get()
        end
    elseif weaponName == "awp" then
        minDmg=awpMinDmg:get()
        if min_damage_awp[2]:get() then
            minDmg=awpMinDmgForce:get()
        end
    elseif weaponName == "scar20" or weaponName == "g3sg1" then
        minDmg=autoMinDmg:get()
        if min_damage_a[2]:get() then
            minDmg=autoMinDmgForce:get()
        end
    elseif weaponName == "glock" or weaponName == "p250" or weaponName == "cz75a" or weaponName == "usp-s" or weaponName == "tec9" or weaponName == "p2000" or weaponName == "fiveseven" or weaponName == "elite" then
        minDmg=pistolsDmg:get()
        if min_damage_p[2]:get() then
            minDmg=pistolsDmgForce:get()
        end
    else
        minDmg=otherDmg:get()
        if min_damage_o[2]:get() then
            minDmg=otherDmgForce:get()
        end
    end
    local Localplayer = entity_list.get_local_player()
    if not Localplayer then return end
    local Weapon = entity_list.get_entity(Localplayer:get_prop("m_hActiveWeapon"))
    if not Weapon then return end
    if not Weapon:is_weapon()then return end
    local weapon_name = Weapon:get_name()
    if weapon_name == "knife" then return end
    local text = "Dmg:"..tostring(minDmg)
    local pos = render.get_text_size(PixelMax, text)
    render.text(PixelMax,text, vec2_t(ScreenCenterX + Width:get(),ScreenCenterY -Height:get()+60), textcoro:get())
    render.push_alpha_modifier(0.35)
    render.rect_filled(vec2_t(ScreenCenterX + Width:get()-10, ScreenCenterY-Height:get()+60), vec2_t(pos.x+15,pos.y+5), backcoro:get(),true)
    render.pop_alpha_modifier()
end

local getActiveWeapon = function()
    local currentWeapon = nil
    local weaponName = getweapon()
    if weaponName == nil then return end
    if weaponName == nil then return end
    if weaponName == "ssg08" then
        currentWeapon = arsenal["scout"]
    elseif weaponName == "deagle" then
        currentWeapon = arsenal["deagle"]
    elseif  weaponName == "revolver"  then
        currentWeapon = arsenal["revolver"]
    elseif weaponName == "awp" then
        currentWeapon = arsenal["awp"]
    elseif weaponName == "scar20" or weaponName == "g3sg1" then
        currentWeapon = arsenal["auto"]
    elseif weaponName == "glock" or weaponName == "p250" or weaponName == "cz75a" or weaponName == "usp-s" or weaponName == "tec9" or weaponName == "p2000" or weaponName == "fiveseven" or weaponName == "elite" then
        currentWeapon = arsenal["pistols"]
    else
        currentWeapon = arsenal["other"]
    end
    return currentWeapon
end

local openMenu = false
local UiUpdate = function()
    local selectNam = weaponselection:get_item_name(weaponselection:get())
    fakelag:set_visible(fakelagenb:get())
    dynamicfakewalkmode:set_visible(dynamicfakewalkenb:get())
    dynamicfakewalkMin:set_visible(dynamicfakewalkenb:get())
    dynamicfakewalkMax:set_visible(dynamicfakewalkenb:get())
    Dynamicinterval:set_visible(dynamicfakewalkenb:get())
    dynamicfakewalkIncremental:set_visible(dynamicfakewalkenb:get())
    textcoro:set_visible(indicatorEnb:get())
    backcoro:set_visible(indicatorEnb:get())
    Height:set_visible(indicatorEnb:get())
    Width:set_visible(indicatorEnb:get())
    ui.type:set_visible(ui.is_enabled:get())
    ui.speed:set_visible(ui.is_enabled:get())
    if (menu.is_open()) then
        if not (openMenu) then
            local currentWeapon = nil
            local weaponName = getweapon()
            if weaponName ~= nil then
                if weaponName == "ssg08" then
                    currentWeapon = "scout"
                elseif weaponName == "deagle" then
                    currentWeapon = "deagle"
                elseif  weaponName == "revolver"  then
                    currentWeapon = "revolver"
                elseif weaponName == "awp" then
                    currentWeapon = "awp"
                elseif weaponName == "scar20" or weaponName == "g3sg1" then
                    currentWeapon = "auto"
                elseif weaponName == "glock" or weaponName == "p250" or weaponName == "cz75a" or weaponName == "usp-s" or weaponName == "tec9" or weaponName == "p2000" or weaponName == "fiveseven" or weaponName == "elite" then
                    currentWeapon = "pistols"
                else
                    currentWeapon = "other"
                end
                local items = weaponselection:get_items()
                for i = 1, #items do
                    if items[i]==currentWeapon then
                        weaponselection:set(i)
                    end
                end
            end
            openMenu = true
        end
    else
        openMenu = false
    end
    for k,v in pairs(arsenal) do
        local currentWeapon = v
        if currentWeapon["Treatmentmethod"]:get(1) or currentWeapon["Treatmentmethod"]:get(2) then
            currentWeapon["checkbox"]:set(true)
        else
            currentWeapon["checkbox"]:set(false)
        end

        if currentWeapon["iscover"] and currentWeapon["Treatmentmethod"]:get(1)  then
            for i = 1, 6 do
                currentWeapon["multipoints"]:set(i,currentWeapon["Autooverwrite"]:get(i))
                currentWeapon["hitboxes"]:set(i,currentWeapon["Autooverwrite"]:get(i))
            end
        else
            for i = 1, 6 do
                currentWeapon["multipoints"]:set(i,currentWeapon["Multipoint"]:get(i))
                currentWeapon["hitboxes"]:set(i,currentWeapon["Strikebox"]:get(i))
            end
        end
        if currentWeapon["AdaptiveDmg"]==nil then
            currentWeapon["AdaptiveDmgMenu"]:set(currentWeapon["dmg"]:get())
        else
            if not currentWeapon["AdaptiveDmg"]:get()  then
                currentWeapon["AdaptiveDmgMenu"]:set(currentWeapon["dmg"]:get())
                currentWeapon["AdaptiveAutoWallDmgMenu"]:set(currentWeapon["dmg"]:get())
            end
        end

        if currentWeapon["JumpBox"]==nil then
            currentWeapon["Jump"]:set( currentWeapon["JumpOld"]:get())
        end
        currentWeapon["multipoints"]:set_visible(true)
        currentWeapon["hitboxes"]:set_visible(true)
        currentWeapon["AdaptiveDmgMenu"]:set_visible(true)
        currentWeapon["Jump"]:set_visible(true)
        if currentWeapon["AdaptiveAutoWallDmgMenu"]~=nil then
            currentWeapon["AdaptiveAutoWallDmgMenu"]:set_visible(true)
        end
        if k==selectNam then
            v["checkbox"]:set_visible(false)
            v["maxMiss"]:set_visible(v["checkbox"]:get())
            v["closecheckbox"]:set_visible(v["checkbox"]:get())
            if v["Treatmentmethod"]:get(1) then
                v["Autooverwrite"]:set_visible(true)
            else
                v["Autooverwrite"]:set_visible(false)
            end
        end
    end
    local jump_key = input.find_key_bound_to_binding("jump")
    if input.is_key_held(jump_key) then
        if arsenal["scout"]["JumpBox"]:get() then
            arsenal["scout"]["Jump"]:set( arsenal["scout"]["Airhitrate"]:get())
        end
    else
        arsenal["scout"]["Jump"]:set( arsenal["scout"]["JumpOld"]:get())
    end
end

local missMaxSettings = function(ctx, cmd, unpredicted_data)
    local currentWeapon = getActiveWeapon()
    if currentWeapon==nil then
        return
    end
    local hp = ctx.player:get_prop("m_iHealth")
    local weaponName = getweapon()

    --安全点处理
    if currentWeapon["iscover"] and currentWeapon["Treatmentmethod"]:get(2) then
        ctx:set_safepoint_state(true)
    else
        ctx:set_safepoint_state(false)
    end

    if currentWeapon["DmgAccuracy"]~=nil then
        ctx:set_damage_accuracy(currentWeapon["DmgAccuracy"]:get())
    end

    -- 大狙跟鸟狙的自适应伤害
    if currentWeapon["AdaptiveDmg"]~=nil then
        if weaponName=="awp" then
            if currentWeapon["AdaptiveDmg"]:get() then
                currentWeapon["AdaptiveDmgMenu"]:set(hp+1)
            else
                currentWeapon["AdaptiveDmgMenu"]:set(currentWeapon["dmg"]:get())
            end
        elseif weaponName=="ssg08" then
            if currentWeapon["AdaptiveDmg"]:get() then
                if hp>81 then
                    if currentWeapon["iscover"] and currentWeapon["Autooverwrite"]:get(1)==false and currentWeapon["Treatmentmethod"]:get(1) then
                        currentWeapon["AdaptiveDmgMenu"]:set(81)
                        currentWeapon["AdaptiveAutoWallDmgMenu"]:set(81)
                    elseif currentWeapon["dmg"]:get()>=90 then
                        currentWeapon["AdaptiveDmgMenu"]:set(hp+1)
                        currentWeapon["AdaptiveAutoWallDmgMenu"]:set(hp+1)
                    end
                else
                    currentWeapon["AdaptiveDmgMenu"]:set(hp+1)
                    currentWeapon["AdaptiveAutoWallDmgMenu"]:set(hp+1)
                end
            else
                currentWeapon["AdaptiveDmgMenu"]:set(currentWeapon["dmg"]:get())
                currentWeapon["AdaptiveAutoWallDmgMenu"]:set(currentWeapon["dmg"]:get())
            end
        elseif weaponName == "scar20" or weaponName == "g3sg1" then
            if currentWeapon["AdaptiveDmg"]:get() then
                if hp>41 then
                    if currentWeapon["iscover"] and currentWeapon["Autooverwrite"]:get(1)==false then
                        currentWeapon["AdaptiveDmgMenu"]:set(41)
                        currentWeapon["AdaptiveAutoWallDmgMenu"]:set(41)
                    end
                else
                    currentWeapon["AdaptiveDmgMenu"]:set(hp+1)
                    currentWeapon["AdaptiveAutoWallDmgMenu"]:set(hp+1)
                end
            else
                currentWeapon["AdaptiveDmgMenu"]:set(currentWeapon["dmg"]:get())
                currentWeapon["AdaptiveAutoWallDmgMenu"]:set(currentWeapon["dmg"]:get())
            end
        end
    end
end


local on_aimbot_miss = function()
    local weaponName = getweapon()
    local currentWeapon = getActiveWeapon()
    if currentWeapon~=nil then
        if currentWeapon["checkbox"]:get() then
            currentWeapon["current"] = currentWeapon["current"]+1
            if currentWeapon["current"]>= currentWeapon["maxMiss"]:get()then
                if currentWeapon["Treatmentmethod"]:get(1) then
                    notifications:add_notification("Automatically process notifications", weaponName.."Hit site coverage started", 4)
                elseif currentWeapon["Treatmentmethod"]:get(2) then
                    notifications:add_notification("Automatically process notifications", weaponName.."Coverage of safety points has been started", 4)
                else
                    notifications:add_notification("Automatically process notifications", weaponName.."Coverage of safety points and striking parts has been started", 4)
                end
                currentWeapon["iscover"] = true
            end
        end
    end
end

local on_aimbot_shot = function()
    local weaponName = getweapon()
    local currentWeapon = getActiveWeapon()
    if currentWeapon~=nil then
        if currentWeapon["iscover"] then
            if currentWeapon["closecheckbox"]:get() ==1 then
                if currentWeapon["Treatmentmethod"]:get(1) then
                    notifications:add_notification("Automatically process notifications", weaponName.."Hit site coverage is closed", 4)
                elseif currentWeapon["Treatmentmethod"]:get(2) then
                    notifications:add_notification("Automatically process notifications", weaponName.."Coverage of safety points has been closed", 4)
                else
                    notifications:add_notification("Automatically process notifications", weaponName.."The coverage of safety points and striking parts has been closed", 4)
                end
                currentWeapon["current"] = 0
                currentWeapon["iscover"] = false
            end
        end
    end
end

local dynamicfakewalkfun = function()

    local selectIndex = dynamicfakewalkmode:get()
    local min = dynamicfakewalkMin:get()
    local max = dynamicfakewalkMax:get()
    if selectIndex==1 then
        dynamicfakewalkIncremental:set_visible(true)
    else
        dynamicfakewalkIncremental:set_visible(false)
    end

    if min>max then
        dynamicfakewalkMin:set(max-1)
    end

    if not dynamicfakewalkenb:get() then
        return
    end

    fakewalknumertick = fakewalknumertick+1
    if client.time_to_ticks(Dynamicinterval:get())<=fakewalknumertick then
        if selectIndex==1 then
            fakewalknumer = fakewalknumer+dynamicfakewalkIncremental:get()
            if fakewalknumer < min or fakewalknumer >= max then
                fakewalknumer=min
            end
        else
            fakewalknumer = math.random(min,max)
        end
        fakewalk:set(fakewalknumer)
        fakewalknumertick=0
    end
end

local function on_draw_watermark(watermark_text)
    -- returning any string will override the watermark text
    return "Welcome to Pluto-YouRan01"
end

local function on_player_esp(ctx)
    if not FatalESP:get() then
        return
    end
    local minDmg = 0
    local weaponName = getweapon()
    if weaponName == "ssg08" then
        minDmg=scoutMinDmg:get()
        if min_damage_s[2]:get() then
            minDmg=scoutMinDmgForce:get()
        end
    elseif weaponName == "deagle" then
        minDmg=deagleMinDmg:get()
        if min_damage_d[2]:get() then
            minDmg=deagleMinDmgForce:get()
        end
    elseif  weaponName == "revolver"  then
        minDmg=revolverDmg:get()
        if min_damage_r[2]:get() then
            minDmg=revolverDmgForce:get()
        end
    elseif weaponName == "awp" then
        minDmg=awpMinDmg:get()
        if min_damage_awp[2]:get() then
            minDmg=awpMinDmgForce:get()
        end
    elseif weaponName == "scar20" or weaponName == "g3sg1" then
        minDmg=autoMinDmg:get()
        if min_damage_a[2]:get() then
            minDmg=autoMinDmgForce:get()
        end
    elseif weaponName == "glock" or weaponName == "p250" or weaponName == "cz75a" or weaponName == "usp-s" or weaponName == "tec9" or weaponName == "p2000" or weaponName == "fiveseven" or weaponName == "elite" then
        minDmg=pistolsDmg:get()
        if min_damage_p[2]:get() then
            minDmg=pistolsDmgForce:get()
        end
    else
        minDmg=otherDmg:get()
        if min_damage_o[2]:get() then
            minDmg=otherDmgForce:get()
        end
    end
    ctx:set_font(pixel)
    ctx:set_small_font(pixel)
    local health = ctx.player:get_prop("m_iHealth")
    if health <= minDmg then
        ctx:add_flag("Kill",color_t(251,77,40))
    end
end

local function reset()
    for k,v in pairs(arsenal) do
        v["current"] = 0
        v["iscover"] = false
    end
    notifications:add_notification("Automatically process notifications", "Round ended", 4)
end

local Killeffectfun = function(event)
    if event.userid==nil or event.attacker==nil then
        return
    end
    local  me =  entity_list.get_local_player():get_index()
    local index_victim = entity_list.get_player_from_userid(event.userid)
    local index_attacker = entity_list.get_player_from_userid(event.attacker)
    if index_attacker~= nil then
        index_attacker=index_attacker:get_index()
    end
    if index_victim~=nil then
        index_victim=index_victim:get_index()
    end
    if  index_attacker == me  then
        if index_victim ~= me  then
            if Killeffect:get() then
                entity_list.get_local_player():set_prop("m_flHealthShotBoostExpirationTime", global_vars.cur_time() + 1)
                engine.execute_cmd("playvol physics\\glass\\glass_pottery_break2 .5");
            end
            local weaponName = getweapon()
            local currentWeapon = getActiveWeapon()
            if currentWeapon~=nil then
                if currentWeapon["iscover"] then
                    if currentWeapon["closecheckbox"]:get() ==2 then
                        if currentWeapon["Treatmentmethod"]:get(1) then
                            notifications:add_notification("Automatically process notifications", weaponName.."Hit site coverage is closed", 4)
                        elseif currentWeapon["Treatmentmethod"]:get(2) then
                            notifications:add_notification("Automatically process notifications", weaponName.."Coverage of safety points has been closed", 4)
                        else
                            notifications:add_notification("Automatically process notifications", weaponName.."The coverage of safety points and striking parts has been closed", 4)
                        end
                        currentWeapon["current"] = 0
                        currentWeapon["iscover"] = false
                    end
                end
            end
        end
    end
end

local Animationdestruction = function(ctx)
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local curtime = global_vars.cur_time()
        if multi_selection:get(1) then
            ctx:set_render_pose(e_poses.RUN, 0)
        end
        if multi_selection:get(2) then
            if on_land == true then
                ground_tick = ground_tick + 1
            else
                ground_tick = 0
                end_time = curtime + 1
            end
            if ground_tick > 1 and end_time > curtime then
                ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
            end
        end
        if multi_selection:get(3) then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
        end
end
local Loadtips = function()
    print(" ██    ██                  ███████                      ")
    print("░░██  ██                  ░██░░░░██                     ")
    print(" ░░████    ██████  ██   ██░██   ░██   ██████   ███████  ")
    print("  ░░██    ██░░░░██░██  ░██░███████   ░░░░░░██ ░░██░░░██ ")
    print("   ░██   ░██   ░██░██  ░██░██░░░██    ███████  ░██  ░██ ")
    print("   ░██   ░██   ░██░██  ░██░██  ░░██  ██░░░░██  ░██  ░██ ")
    print("   ░██   ░░██████ ░░██████░██   ░░██░░████████ ███  ░██ ")
    print("   ░░     ░░░░░░   ░░░░░░ ░░     ░░  ░░░░░░░░ ░░░   ░░  ")
    print("---------------------------------------------------------")
    print("███████  ██       ██     ██ ██████████   ███████  ")
    print("░██░░░░██░██      ░██    ░██░░░░░██░░░   ██░░░░░██")
    print("░██   ░██░██      ░██    ░██    ░██     ██     ░░█")
    print("░███████ ░██      ░██    ░██    ░██    ░██      ░█")
    print("░██░░░░  ░██      ░██    ░██    ░██    ░██      ░█")
    print("░██      ░██      ░██    ░██    ░██    ░░██     ██")
    print("░██      ░████████░░███████     ░██     ░░███████ ")
    print("░░       ░░░░░░░░  ░░░░░░░      ░░       ░░░░░░░  ")
    print("Pluto loaded successfully "..version)
    notifications:add_notification("Pluto", "Welcome to Pluto Lua current version:"..version.." Author: youran01 welcome:"..user.name , 8)
    ffi_handler.change_tag_fn("", "")
    tag_changer.disabled = true
    weaponselection:set(7)
end
firstLoad = function()
    engine.execute_cmd("clear ")
    client.delay_call(Loadtips, 0.05)
    callbacks.add(e_callbacks.ANTIAIM,Animationdestruction)
    callbacks.add(e_callbacks.HITSCAN,missMaxSettings)
    callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_shot)
    callbacks.add(e_callbacks.PAINT, dynamicfakewalkfun)
    callbacks.add(e_callbacks.PAINT, Drawindicator)
    callbacks.add(e_callbacks.PAINT, UiUpdate)
    callbacks.add(e_callbacks.PAINT, tag_changer.on_paint)
    callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)
    callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)
    callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
    callbacks.add(e_callbacks.ANTIAIM, fakelagFun)
    callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)
    callbacks.add(e_callbacks.SHUTDOWN, function()
        ffi_handler.change_tag_fn("", "")
        tag_changer.disabled = true
    end)
    callbacks.add(e_callbacks.EVENT, function(event)
        isConn = engine.is_connected()
        if event.name == "round_end" then
            reset()
        end
        if event.name == "player_death" then
            pcall(Killeffectfun,event)
        end
    end)
end

firstLoad()