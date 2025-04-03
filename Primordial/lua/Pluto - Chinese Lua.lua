require("primordial/UI Callbacks.198")
local notifications = require("primordial/notification pop-up library.58")
local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)
local weaponselection = menu.add_selection("AimBot","武器库配置",{"awp","auto","scout","deagle","revolver","pistols","other"})
local version = "v2.6"
menu.add_text("版本信息",version)
menu.add_text("版本信息","--------------------------------------------------------")
menu.add_text("版本信息","重新上线武器上色")
menu.add_text("版本信息","删除忘记删掉的sb killsay")

local arsenal = {
    ["awp"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "awp 击打部位", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "awp 多点", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "awp 命中率", 1, 100),
        ["DmgAccuracy"]= menu.add_slider("AimBot", "awp 伤害准确率", 1, 100),
        ["Jump"] = menu.find("aimbot", "awp", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "awp 最低伤害", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "awp 自动处理"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "awp 自动处理模式", {"覆盖部位","安全点"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "awp 自动处理关闭覆盖条件", {"击中玩家","击杀玩家"}),
        ["maxMiss"] = menu.add_slider("AimBot", "awp 最大空枪数", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "awp 击打部位自动覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitbox"] = menu.add_multi_selection("AimBot", "awp 安全点部位覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitboxMenu"] =  menu.find("aimbot", "awp", "hitbox selection", "safe hitboxes"),
        ["AdaptiveDmg"] = menu.add_checkbox("AimBot", "awp 自适应伤害"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "awp", "targeting", "min. damage"),
        ["AdaptiveAutoWallDmgMenu"] =  menu.find("aimbot", "awp", "targeting", "autowall"),
        ["hitboxes"] = menu.find("aimbot", "awp", "hitbox selection", "hitboxes"),
        ["multipoints"] = menu.find("aimbot", "awp", "hitbox selection", "multipoints")
    },
    ["auto"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "auto 击打部位", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "auto 多点", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "auto 命中率", 1, 100),
        ["Jump"] = menu.find("aimbot", "auto", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "auto 最低伤害", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "auto 自动处理"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "auto 自动处理模式", {"覆盖部位","安全点"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "auto 自动处理关闭覆盖条件", {"击中玩家","击杀玩家"}),
        ["maxMiss"] = menu.add_slider("AimBot", "auto 最大空枪数", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "auto 击打部位自动覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitbox"] = menu.add_multi_selection("AimBot", "auto 安全点部位覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitboxMenu"] =  menu.find("aimbot", "auto", "hitbox selection", "safe hitboxes"),
        ["AdaptiveDmg"] = menu.add_checkbox("AimBot", "auto 自适应伤害"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "auto", "targeting", "min. damage"),
        ["AdaptiveAutoWallDmgMenu"] =  menu.find("aimbot", "auto", "targeting", "autowall"),
        ["hitboxes"] = menu.find("aimbot", "auto", "hitbox selection", "hitboxes"),
        ["multipoints"] = menu.find("aimbot", "auto", "hitbox selection", "multipoints")
    },
    ["scout"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "scout 击打部位", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "scout 多点", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "scout 命中率", 1, 100),
        ["DmgAccuracy"]= menu.add_slider("AimBot", "scout 伤害准确率", 1, 100),
        ["Jump"] = menu.find("aimbot", "scout", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "scout 最低伤害", 1, 100),
        ["JumpBox"] = menu.add_checkbox("AimBot", "scout 跳狙"),
        ["Airhitrate"] = menu.add_slider("AimBot", "scout 空中命中率", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "scout 自动处理"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "scout 自动处理模式", {"覆盖部位","安全点"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "scout 自动处理关闭覆盖条件", {"击中玩家","击杀玩家"}),
        ["maxMiss"] = menu.add_slider("AimBot", "scout 最大空枪数", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "scout 击打部位自动覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["hitboxes"] = menu.find("aimbot", "scout", "hitbox selection", "hitboxes"),
        ["multipoints"] = menu.find("aimbot", "scout", "hitbox selection", "multipoints"),
        ["safehitbox"] = menu.add_multi_selection("AimBot", "scout 安全点部位覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitboxMenu"] =  menu.find("aimbot", "scout", "hitbox selection", "safe hitboxes"),
        ["AdaptiveDmg"] = menu.add_checkbox("AimBot", "scout 自适应伤害"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "scout", "targeting", "min. damage"),
        ["AdaptiveAutoWallDmgMenu"] =  menu.find("aimbot", "scout", "targeting", "autowall")
    },
    ["revolver"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "revolver 击打部位", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "revolver 多点", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "revolver 命中率", 1, 100),
        ["Jump"] = menu.find("aimbot", "revolver", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "revolver 最低伤害", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "revolver 自动处理"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "revolver 自动处理模式", {"覆盖部位","安全点"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "revolver 自动处理关闭覆盖条件", {"击中玩家","击杀玩家"}),
        ["maxMiss"] = menu.add_slider("AimBot", "revolver 最大空枪数", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "revolver 击打部位自动覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["hitboxes"] = menu.find("aimbot", "revolver", "hitbox selection", "hitboxes"),
        ["safehitbox"] = menu.add_multi_selection("AimBot", "revolver 安全点部位覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitboxMenu"] =  menu.find("aimbot", "revolver", "hitbox selection", "safe hitboxes"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "revolver", "targeting", "min. damage"),
        ["multipoints"] = menu.find("aimbot", "revolver", "hitbox selection", "multipoints")
    },
    ["deagle"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "deagle 击打部位", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "deagle 多点", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "deagle 命中率", 1, 100),
        ["Jump"] = menu.find("aimbot", "deagle", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "deagle 最低伤害", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "deagle 自动处理"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "deagle 自动处理模式", {"覆盖部位","安全点"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "deagle 自动处理关闭覆盖条件", {"击中玩家","击杀玩家"}),
        ["maxMiss"] = menu.add_slider("AimBot", "deagle 最大空枪数", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "deagle 击打部位自动覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitbox"] = menu.add_multi_selection("AimBot", "deagle 安全点部位覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitboxMenu"] =  menu.find("aimbot", "deagle", "hitbox selection", "safe hitboxes"),
        ["hitboxes"] = menu.find("aimbot", "deagle", "hitbox selection", "hitboxes"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "deagle", "targeting", "min. damage"),
        ["multipoints"] = menu.find("aimbot", "deagle", "hitbox selection", "multipoints")
    },
    ["pistols"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "pistols 击打部位", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "pistols 多点", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "pistols 命中率", 1, 100),
        ["Jump"] = menu.find("aimbot", "pistols", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "pistols 最低伤害", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "pistols 自动处理"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "pistols 自动处理模式", {"覆盖部位","安全点"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "pistols 自动处理关闭覆盖条件", {"击中玩家","击杀玩家"}),
        ["maxMiss"] = menu.add_slider("AimBot", "pistols 最大空枪数", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "pistols 击打部位自动覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitbox"] = menu.add_multi_selection("AimBot", "pistols 安全点部位覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitboxMenu"] =  menu.find("aimbot", "pistols", "hitbox selection", "safe hitboxes"),
        ["hitboxes"] = menu.find("aimbot", "pistols", "hitbox selection", "hitboxes"),
        ["AdaptiveDmgMenu"] =  menu.find("aimbot", "pistols", "targeting", "min. damage"),
        ["multipoints"] = menu.find("aimbot", "pistols", "hitbox selection", "multipoints")
    },
    ["other"]={
        ["Strikebox"] = menu.add_multi_selection("AimBot", "other 击打部位", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["Multipoint"] = menu.add_multi_selection("AimBot", "other 多点", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["JumpOld"] = menu.add_slider("AimBot", "other 命中率", 1, 100),
        ["Jump"] = menu.find("aimbot", "other", "targeting", "hitchance"),
        ["dmg"] = menu.add_slider("AimBot", "other 最低伤害", 1, 100),
        ["checkbox"] = menu.add_checkbox("AimBot", "other 自动处理"),
        ["Treatmentmethod"] = menu.add_multi_selection("AimBot", "other 自动处理模式", {"覆盖部位","安全点"}),
        ["closecheckbox"] = menu.add_selection("AimBot", "other 自动处理关闭覆盖条件", {"击中玩家","击杀玩家"}),
        ["maxMiss"] = menu.add_slider("AimBot", "other 最大空枪数", 1, 10),
        ["current"] = 0,
        ["iscover"]=false,
        ["Autooverwrite"] = menu.add_multi_selection("AimBot", "other 击打部位自动覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitbox"] = menu.add_multi_selection("AimBot", "other 安全点部位覆盖", {"head", "chest", "arms", "stomach", "legs", "feet"}),
        ["safehitboxMenu"] =  menu.find("aimbot", "other", "hitbox selection", "safe hitboxes"),
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


--杂项
local ScreenSize = render.get_screen_size()
local ScreenCenterX = ScreenSize.x / 2
local ScreenCenterY = ScreenSize.y / 2
local cheat_color = menu.find("misc", "main", "config", "accent color")[2]


--组名板块 start

local plutoTag = {
    'Pluto',
    'Pluto.Y',
    'Pluto.Yo',
    'Pluto.You',
    'Pluto.YouR',
    'Pluto.YouRa',
    'Pluto.YouRan',
    'Pluto.YouRan',
    'Pluto.YouRan',
    'Pluto.YouRa',
    'Pluto.YouR',
    'Pluto.You',
    'Pluto.Yo',
    'Pluto.Y',
    'Pluto.',
    'Pluto'
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

ui.is_enabled = menu.add_checkbox("杂项","组名",false)
ui.type =  menu.add_selection("杂项","组名",{"Pluto.Lua","野猪组","Gamesense","Fatality"})
ui.speed = menu.add_slider("杂项", "速度", 1, 5)
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

local dynamicfakewalkenb = menu.add_checkbox("杂项","动态假走开关")
local dynamicfakewalkmode = menu.add_selection("杂项","动态模式",{"单向循环","范围随机"})
local dynamicfakewalkMin = menu.add_slider("杂项","动态假走最小值",1,100)
local dynamicfakewalkMax = menu.add_slider("杂项","动态假走最大值",1,100)
local Dynamicinterval = menu.add_slider("杂项","动态间隔(s)",1,10)
local dynamicfakewalkIncremental = menu.add_slider("杂项","动态假走递增值",1,20)
local multi_selection = menu.add_multi_selection("杂项", "动画破坏", {"反滑", "落地抬头", "空中静态腿"})
local ground_tick = 1
local end_time = 0
local fakewalk = menu.find("misc","main","movement","speed")
local fakewalknumer = 0
local fakewalknumertick = 0
local fakelagenb = menu.add_checkbox("杂项", "fakelag增强选项[服务器可用]")
local fakelag = menu.add_slider("杂项", "Fakelag 最大值", 0, 61)
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

--视觉
local Killeffect = menu.add_checkbox("视觉", "击杀屏幕特效")
local FatalESP = menu.add_checkbox("视觉", "重写ESP")
local indicatorEnb = menu.add_checkbox("指示器","指示器")


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


local Weaponcoloring = menu.add_multi_selection('视觉', '武器上色',{'发光','网格'})
local material_comboboxW = menu.add_selection('视觉','武器网格类型',getMenuItems(materials))
local Primitiveweapon = menu.add_checkbox('视觉', '绘制武器原始模型')
local WeaponcoloringP1 = Weaponcoloring:add_color_picker('武器发光上色')
local WeaponcoloringP = Weaponcoloring:add_color_picker('武器网格上色')
local Armcoloring = menu.add_multi_selection('视觉', '人物上色',{'发光','网格'})
local material_comboboxA = menu.add_selection('视觉','人物网格类型',getMenuItems(materials))
local Primitivearm = menu.add_checkbox('视觉', '绘制人物原始模型')
local Thirdperspective = menu.add_checkbox('视觉', '覆盖第三视角人物模型')
local ArmcoloringP1 = Armcoloring:add_color_picker('人物发光上色')
local ArmcoloringP = Armcoloring:add_color_picker('人物网格上色')
local Breathinglamp=menu.add_checkbox('视觉', '自适应透明度')


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

local textcoro = indicatorEnb:add_color_picker("文字颜色")
textcoro:set(cheat_color:get())
local backcoro = indicatorEnb:add_color_picker("背景颜色")
backcoro:set(color_t(7,7,7))
local Height = menu.add_slider("指示器", "Y坐标", -ScreenCenterY, ScreenCenterY)
local Width = menu.add_slider("指示器", "X坐标", -ScreenCenterX, ScreenCenterX)
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
        for i = 1, 6 do
            currentWeapon["safehitboxMenu"]:set(i,currentWeapon["safehitbox"]:get(i))
        end
        currentWeapon["safehitboxMenu"]:set_visible(true)
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
            if v["Treatmentmethod"]:get(1) and v["Treatmentmethod"]:get(2) then
                v["Autooverwrite"]:set_visible(true)
                v["safehitbox"]:set_visible(true)
            elseif v["Treatmentmethod"]:get(1) then
                v["Autooverwrite"]:set_visible(true)
                v["safehitbox"]:set_visible(false)
            elseif v["Treatmentmethod"]:get(2) then
                v["Autooverwrite"]:set_visible(false)
                v["safehitbox"]:set_visible(true)
            else
                v["Autooverwrite"]:set_visible(false)
                v["safehitbox"]:set_visible(false)
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
                    notifications:add_notification("自动处理通知", weaponName.."击打部位覆盖已启动", 4)
                elseif currentWeapon["Treatmentmethod"]:get(2) then
                    notifications:add_notification("自动处理通知", weaponName.."安全点部位覆盖已启动", 4)
                else
                    notifications:add_notification("自动处理通知", weaponName.."安全点与击打部位覆盖已启动", 4)
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
                    notifications:add_notification("自动处理击中通知", weaponName.."击打部位覆盖已关闭", 4)
                elseif currentWeapon["Treatmentmethod"]:get(2) then
                    notifications:add_notification("自动处理通知", weaponName.."安全点部位覆盖已关闭", 4)
                else
                    notifications:add_notification("自动处理通知", weaponName.."安全点与击打部位覆盖已关闭", 4)
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
    notifications:add_notification("自动处理通知", "回合结束 关闭所有武器自动覆盖", 4)
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
                            notifications:add_notification("自动处理击中通知", weaponName.."击打部位覆盖已关闭", 4)
                        elseif currentWeapon["Treatmentmethod"]:get(2) then
                            notifications:add_notification("自动处理通知", weaponName.."安全点部位覆盖已关闭", 4)
                        else
                            notifications:add_notification("自动处理通知", weaponName.."安全点与击打部位覆盖已关闭", 4)
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
    notifications:add_notification("Pluto", "欢迎使用Pluto.Lua 当前版本:"..version.." 作者:YouRan01 欢迎您:"..user.name , 8)
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