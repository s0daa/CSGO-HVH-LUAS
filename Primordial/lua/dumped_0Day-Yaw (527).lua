local definedList={}
definedList.playerStaus = {
    "Global",
    "Stand",
    "Movine",
    "Slowwalking",
    "Air",
    "Crouching",
    "OnPeek"
}
definedList.playerStausFl = {
    "Stand",
    "Movine",
    "Slowwalking",
    "Air",
    "Crouching",
    "OnPeek"
}
definedList.lor = {
    "Right",
    "Left"
}
definedList.initArrayName = {
    "yawAdd",
    "yawAddMode",
    "jitter",
    "roTate",
    "roTateRange",
    "roTateSpeed",
    "jitterMode",
    "jitterType",
    "jitterAdd"
}
definedList.ShowOrHideDomArray = function (domObj,isShow)
    for key, v in pairs(domObj) do
        if key~=isOv then
            v:set_visible(isShow)
        end
    end
end
definedList.UserCMDChoke = function (ctx)
    ctx:set_fakelag(true)
end

definedList.UserCMDSend = function (ctx)
    ctx:set_fakelag(false)
end


local aimantin = menu.add_selection('AntiAim','Current Condition',definedList.playerStaus,#definedList.playerStaus)
local AimAntinCore ={}
local menuRef = {}
menuRef.fakeLag=menu.find('antiaim','main','fakelag','amount')
menuRef.BreakLC = menu.find("antiaim", "main", "fakelag", "break lag compensation")
menuRef.pitch=menu.find('antiaim','main','angles','pitch')
menuRef.yawBase=menu.find('antiaim','main','angles','yaw base')
menuRef.yawAdd=menu.find('antiaim','main','angles','yaw add')
menuRef.roTate=menu.find('antiaim','main','angles','rotate')
menuRef.roTateRange=menu.find('antiaim','main','angles','rotate range')
menuRef.roTateSpeed=menu.find('antiaim','main','angles','rotate speed')
menuRef.jitterMode=menu.find('antiaim','main','angles','jitter mode')
menuRef.jitterType=menu.find('antiaim','main','angles','jitter type')
menuRef.jitterAdd=menu.find('antiaim','main','angles','jitter add')
menuRef.bodyLean=menu.find('antiaim','main','angles','body lean')
menuRef.bodyLeanValue=menu.find('antiaim','main','angles','body lean value')
menuRef.desync=menu.find('antiaim','main','desync','side#stand')
menuRef.desyncm=menu.find('antiaim','main','desync','override stand#move')
menuRef.desyncs=menu.find('antiaim','main','desync','override stand#slow walk')
menuRef.maxRoll=menu.find('misc', 'main', 'server settings', 'max body lean')
menuRef.thirdperson = menu.find('visuals', 'other', 'thirdperson', 'enable')
menuRef.slowWalk =menu.find('misc','main','movement','slow walk')[2]
menuRef.autoPeek =menu.find('aimbot','general','misc','autopeek')[2]
menuRef.hideshot =menu.find('aimbot','general','exploits','hideshots','enable')[2]
menuRef.doubletap=menu.find('aimbot','general','exploits','doubletap','enable')[2]
for k, v in pairs(definedList.playerStaus) do
    if v== "Global" then
        AimAntinCore[v]={
            yawBase = menu.add_selection('AntiAim',v..' Yaw Base',{'None','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),
            pitch = menu.add_selection('AntiAim',v..' Pitch',{'None','Down','Up','Zero','Jitter'}),
            desync = menu.add_selection('AntiAim',v..' Desync',{'None','Left','Right','Jitter','Peek Fake','Peek Real'})
        }
    else
        AimAntinCore[v]={
            isOv = menu.add_checkbox("AntiAim","override " ..v .." AntiAim"),
            yawBase = menu.add_selection('AntiAim',v..' Yaw Base',{'None','viewangles','At Target(crosshair)','At Target(distdance)','velocity'}),
            pitch = menu.add_selection('AntiAim',v..' Pitch',{'None','Down','Up','Zero','Jitter'}),
            desync = menu.add_selection('AntiAim',v..' Desync',{'None','Left','Right','Jitter','Peek Fake','Peek Real'})
        }
    end
end
for k, v in pairs(definedList.initArrayName) do
    AimAntinCore[v]={
        ["Right"]={},
        ["Left"]={}
    }
end
for k, v in pairs(definedList.playerStaus) do
    for index,value in pairs(definedList.lor) do
        AimAntinCore["yawAdd"][value][v] = menu.add_slider('AntiAim',v..' Yaw Add '..value,-180,180,1,0,'°')
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["yawAddMode"][value][v] = menu.add_selection('AntiAim',v..' Yaw Jitter Mode '..value,{"none","static","random"})
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["jitter"][value][v] = menu.add_slider('AntiAim',v..' Yaw Jitter Value '..value,-180,180,1,0,'°')
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["jitterMode"][value][v] = menu.add_selection('AntiAim',v..' jitter Mode '..value,{'None','Static','Random'})
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["jitterType"][value][v] = menu.add_selection('AntiAim',v..' jitter Type '..value,{'Offset','Center'})
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["jitterAdd"][value][v] = menu.add_slider('AntiAim',v..' Jitter Add '..value,-180,180,1,0,'°')
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["roTate"][value][v] = menu.add_checkbox('AntiAim',v..' RoTate '..value,false)
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["roTateRange"][value][v] = menu.add_slider('AntiAim',v..' rotate range '..value,0,360,1,0,'°')
    end
    for index,value in pairs(definedList.lor) do
        AimAntinCore["roTateSpeed"][value][v] = menu.add_slider('AntiAim',v..' rotate Speed '..value,0,100,1,0,'%')
    end
end

AimAntinCore.uiUpdate=function()
    if not menu.is_open() then
        return
    end

    local selectA = aimantin:get_item_name(aimantin:get())
    for index, value in ipairs(definedList.playerStaus) do
        if AimAntinCore[selectA].isOv~=nil then
            if selectA==value and AimAntinCore[selectA].isOv:get() then
                definedList.ShowOrHideDomArray(AimAntinCore[value],true)
            else
                definedList.ShowOrHideDomArray(AimAntinCore[value],false)
            end
            AimAntinCore[selectA].isOv:set_visible(true)
        else
            if selectA==value then
                definedList.ShowOrHideDomArray(AimAntinCore[value],true)
            else
                definedList.ShowOrHideDomArray(AimAntinCore[value],false)
            end
        end
    end
    for index, value in ipairs(definedList.lor) do
        for k, v in ipairs(definedList.playerStaus) do
            for kk, vv in ipairs(definedList.initArrayName) do
                if v=="Global" then
                    if v== selectA then
                        AimAntinCore[vv][value][v]:set_visible(true)
                        local isRot = AimAntinCore["roTate"][value][v]:get()
                        AimAntinCore["roTateRange"][value][v]:set_visible(isRot)
                        AimAntinCore["roTateSpeed"][value][v]:set_visible(isRot)
                        local isYawJitter = AimAntinCore["yawAddMode"][value][v]:get()==2
                        AimAntinCore["jitter"][value][v]:set_visible(isYawJitter)
                        local isJitter = AimAntinCore["jitterMode"][value][v]:get()~=1
                        AimAntinCore["jitterType"][value][v]:set_visible(isJitter)
                        AimAntinCore["jitterAdd"][value][v]:set_visible(isJitter)
                    else
                        AimAntinCore[vv][value][v]:set_visible(false)
                    end
                else
                    if v== selectA and AimAntinCore[selectA].isOv:get() then
                        AimAntinCore[vv][value][v]:set_visible(true)
                        local isRot = AimAntinCore["roTate"][value][v]:get()
                        AimAntinCore["roTateRange"][value][v]:set_visible(isRot)
                        AimAntinCore["roTateSpeed"][value][v]:set_visible(isRot)
                        local isYawJitter = AimAntinCore["yawAddMode"][value][v]:get()==2
                        AimAntinCore["jitter"][value][v]:set_visible(isYawJitter)
                        local isJitter = AimAntinCore["jitterMode"][value][v]:get()~=1
                        AimAntinCore["jitterType"][value][v]:set_visible(isJitter)
                        AimAntinCore["jitterAdd"][value][v]:set_visible(isJitter)
                    else
                        AimAntinCore[vv][value][v]:set_visible(false)
                    end
                end
            end
        end
    end
end

local invert = false
local is_valve=false
AimAntinCore.Core = function(ctx)
    local state = 'Global'
    local lp = entity_list.get_local_player()
    if lp==nil then
        return
    end
    local velocity = lp:get_prop('m_vecVelocity')
    if not menuRef.autoPeek:get() then
        if (math.abs(velocity.x)>2 or math.abs(velocity.y)>2) and not menuRef.slowWalk:get() and bit.band(lp:get_prop('m_fFlags'), bit.lshift(1,0)) ~= 0 and lp:get_prop('m_flDuckAmount')<=0.8 then
            state='Movine'
        elseif menuRef.slowWalk:get() and (math.abs(velocity.x)>2 or math.abs(velocity.y)>2) then
            state='Slowwalking'
        elseif bit.band(lp:get_prop('m_fFlags'), bit.lshift(1,0)) == 0 then
            state='Air'
        elseif lp:get_prop('m_flDuckAmount') > 0.8 then
            state='Crouching'
        else
            state='Stand'
        end
    elseif menuRef.autoPeek:get() then
        state='OnPeek'
    end

    if AimAntinCore[state].isOv~=nil and not AimAntinCore[state].isOv:get() then
        state = 'Global'
    end

    menuRef.pitch:set(AimAntinCore[state]["pitch"]:get())
    menuRef.yawBase:set(AimAntinCore[state]["yawBase"]:get())
    menuRef.desync:set(AimAntinCore[state]["desync"]:get())
    menuRef.desyncm:set(false)
    menuRef.desyncs:set(false)
    local direction = 'Left'
    if antiaim.get_desync_side()==1 then
        direction = 'Left'
    else
        direction = 'Right'
    end
    for index, value in ipairs(definedList.initArrayName) do
        if value ~= "yawAddMode" and value ~= "jitter" then
            menuRef[value]:set(AimAntinCore[value][direction][state]:get())
        end
    end
    local yawAddValue = 0
    if AimAntinCore["yawAddMode"][direction][state]:get()==1 then
        yawAddValue=AimAntinCore["yawAdd"][direction][state]:get()
    elseif AimAntinCore["yawAddMode"][direction][state]:get()==2 then
        local side = invert and -1 or 1
        local jitter = AimAntinCore["jitter"][direction][state]:get() / 2 * side
        yawAddValue=(AimAntinCore["yawAdd"][direction][state]:get() + jitter)
        invert = not invert
    elseif AimAntinCore["yawAddMode"][direction][state]:get()==3 then
        local jitter = AimAntinCore["jitter"][direction][state]:get()
        yawAddValue=client.random_int(-(math.abs(jitter)),math.abs(jitter))
    end
    menuRef.yawAdd:set(yawAddValue)
end


callbacks.add(e_callbacks.PAINT, AimAntinCore.uiUpdate)
callbacks.add(e_callbacks.ANTIAIM,AimAntinCore.Core)

local fakelagS = menu.add_selection('Fake Lag','Current Condition',definedList.playerStausFl,#definedList.playerStausFl)
local fakelag = {}
for k,v in ipairs (definedList.playerStausFl) do
    local group_name = "Fake Lag"
    fakelag[v] = {
        mode = menu.add_selection(group_name,v.."FL Mode",{"Static","MaxNum","Random","Valve"}),
        min = menu.add_slider(group_name, v.." FL Min Value", 0, 15),
        max = menu.add_slider(group_name, v.." FL Max Value", 0, 15),
        static=menu.add_slider(group_name, v.." FL Static Value", 0, 15),
    }
end
fakelag.shotingFl={
    enable= menu.add_checkbox("Fake Lag","Fakelag in Hide Shot mode"),
    enableBool = false
}
fakelag.uiUpdate = function()
    if not menu.is_open() then
        return
    end
    local selectNam = fakelagS:get_item_name(fakelagS:get())
    for k,v in ipairs (definedList.playerStausFl) do
        if selectNam==v then
            fakelag[v].mode:set_visible(true)
            fakelag[v].min:set_visible(true)
            fakelag[v].max:set_visible(true)
            if fakelag[v].mode:get()==1 then
                fakelag[v].min:set_visible(false)
                fakelag[v].max:set_visible(false)
                fakelag[v].static:set_visible(true)
            elseif fakelag[v].mode:get()==3 then
                fakelag[v].static:set_visible(false)
                fakelag[v].min:set_visible(true)
                fakelag[v].max:set_visible(true)
            else
                fakelag[v].static:set_visible(false)
                fakelag[v].min:set_visible(false)
                fakelag[v].max:set_visible(false)
            end
        else
            fakelag[v].mode:set_visible(false)
            fakelag[v].min:set_visible(false)
            fakelag[v].max:set_visible(false)
            fakelag[v].static:set_visible(false)
        end
    end
end
fakelag.Core = function(ctx)
    local state = 'Stand'
    local lp = entity_list.get_local_player()
    if lp==nil then
        return
    end
    local velocity = lp:get_prop('m_vecVelocity')
    if not menuRef.autoPeek:get() then
        if (math.abs(velocity.x)>2 or math.abs(velocity.y)>2) and not menuRef.slowWalk:get() and bit.band(lp:get_prop('m_fFlags'), bit.lshift(1,0)) ~= 0 and lp:get_prop('m_flDuckAmount')<=0.8 then
            state='Movine'
        elseif menuRef.slowWalk:get() and (math.abs(velocity.x)>2 or math.abs(velocity.y)>2) then
            state='Slowwalking'
        elseif bit.band(lp:get_prop('m_fFlags'), bit.lshift(1,0)) == 0 then
            state='Air'
        elseif lp:get_prop('m_flDuckAmount') > 0.8 then
            state='Crouching'
        else
            state='Stand'
        end
    elseif menuRef.autoPeek:get() then
        state='OnPeek'
    end

    local mode = fakelag[state].mode:get()
    if mode == 1 then
        if engine.get_choked_commands() >= fakelag[state].static:get() then
            definedList.UserCMDSend(ctx)
        else
            definedList.UserCMDChoke(ctx)
        end
    elseif mode == 2 then
            definedList.UserCMDChoke(ctx)
    elseif mode == 3 then
        if engine.get_choked_commands() >= math.random(fakelag[state].min:get(),fakelag[state].max:get()) then
            definedList.UserCMDSend(ctx)
        else
            definedList.UserCMDChoke(ctx)
        end
    elseif mode == 4 then
        if engine.get_choked_commands() >=6 then
            definedList.UserCMDSend(ctx)
        else
            definedList.UserCMDChoke(ctx)
        end
    end
    if fakelag.shotingFl.enable:get() then
        if fakelag.shotingFl.enableBool then
            definedList.UserCMDSend(ctx)
            fakelag.shotingFl.enableBool = false
            return
        end
    end
end

callbacks.add(e_callbacks.PAINT, fakelag.uiUpdate)
callbacks.add(e_callbacks.ANTIAIM,fakelag.Core)
callbacks.add(e_callbacks.EVENT, function()
    fakelag.shotingFl.enableBool=true
end, "weapon_fire")