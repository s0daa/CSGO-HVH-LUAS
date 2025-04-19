--[[
                           _   _     __    ___    _____                             __  
                          (_) | |   /_ |  / _ \  | ____|                           / /
   ___   ___   _ __ ___    _  | |_   | | | (_) | | |__         _ __ ___   ___     / / 
  / __| / __| | '_ ` _ \  | | | __|  | |  \__, | |___ \       | '_ ` _ \ / _ \   / /  
 | (__  \__ \ | | | | | | | | | |_   | |    / /   ___) |  _   | | | | | |  __/  / /   
  \___| |___/ |_| |_| |_| |_|  \__|  |_|   /_/   |____/  (_)  |_| |_| |_|\___| /_/    
   
   
    Script Name: Actual Overwatch Bot - Works while PLAYING
    Script Author: csmit195
    Script Version: 1.0
    Script Description: Sapphyrus, /me quietly nudges sapphyrus's ear. queue *erp*. wait what. no one will ever see this, tell them i did it for science.
]]
local panorama_events = require 'gamesense/panorama_events'

-- Panorama Hooks
local js = panorama.open()
local OverwatchAPI = js.OverwatchAPI
local GameStateAPI = js.GameStateAPI

local function init()
    -- GUI
    local GUI = {}
    local Data = database.read('csmit195_OWBot') or {}
    Data.TotalOverwatches = Data.TotalOverwatches or 0

    GUI.Enable = ui.new_checkbox('MISC', 'Miscellaneous', 'Overwatch Bot')
    GUI.ForceConvictOptions = ui.new_multiselect('MISC', 'Miscellaneous', 'Verdict', {'Aimbot', 'Wallhacks', 'Other', 'Griefing'})
    GUI.DownloadDelay = ui.new_slider('MISC', 'Miscellaneous', 'Download delay', 5, 300, 5, true, 'm')
    GUI.VerdictDelay = ui.new_slider('MISC', 'Miscellaneous', 'Verdict delay', 5, 300, 35, true, 'm')
    GUI.OnlyProcess = ui.new_combobox('MISC', 'Miscellaneous', 'Only process', {'Main-menu', 'In-game', 'Both'})
    GUI.DownloadRules = ui.new_combobox('MISC', 'Miscellaneous', 'Only download', {'Always', 'Round End', 'Self Death', 'Both'})
    GUI.Stats = {}
    GUI.Stats.Header = ui.new_label('MISC', 'Miscellaneous', 'Statistics:')
    GUI.Stats.CasesCompleted = ui.new_label('MISC', 'Miscellaneous', 'Cases Completed: ' .. Data.TotalOverwatches)
    GUI.Stats.CasesAccurate = ui.new_label('MISC', 'Miscellaneous', 'Cases Accurate: IN_DEV')
    GUI.Stats.TotalXP = ui.new_label('MISC', 'Miscellaneous', 'Total XP Earned: IN_DEV')

    ui.set(GUI.ForceConvictOptions, {'Aimbot', 'Wallhacks', 'Other'})

    -- LOGIC
    local CaseActive
    local PendingProcess
	local LastCaseTime = 0
    local function ProcessOverwatch()
        if PendingProcess then return end
        if not ui.get(GUI.Enable) then return end
        if CaseActive then return end

        local ProcessRule = ui.get(GUI.OnlyProcess)
        local InServer = GameStateAPI.IsConnectedOrConnectingToServer()
        if ProcessRule ~= 'Both' and ( ( ProcessRule == 'Main-menu' and InServer ) or ( ProcessRule == 'In-game' and not InServer ) ) then
            PendingProcess = true
            return client.delay_call(1, ProcessOverwatch)
        end

        PendingProcess = false
        
        local CaseDescription = OverwatchAPI.GetAssignedCaseDescription()
        local CasePercentage = OverwatchAPI.GetEvidencePreparationPercentage()
        
        if ( globals.realtime() - LastCaseTime > ui.get(GUI.DownloadDelay) * 60 and ( CaseDescription:sub(1, 4) == 'OWC#' or tonumber(CaseDescription) ~= nil ) and CasePercentage == 0 ) then
            OverwatchAPI.StartDownloadingCaseEvidence();
			LastCaseTime = globals.realtime()
            print('[OVERWATCH BOT] ', 'Starting Case Download')
        end

        if (tonumber(CaseDescription) ~= nil) then
            -- Is Downloading
            --print('[OVERWATCH BOT] ', 'Case Download Progress: ', CasePercentage)
        end

        if (tonumber(CaseDescription) ~= nil and CasePercentage == 100) then
            -- Finished Downloading
            print('[OVERWATCH BOT] ', 'Case: ', CaseDescription, ', Finished Download, Waiting: ', ui.get(GUI.VerdictDelay))
            CaseActive = true
            local function Convict()
                local _ProcessRule = ui.get(GUI.OnlyProcess)
                local _InServer = GameStateAPI.IsConnectedOrConnectingToServer()
                if _ProcessRule ~= 'Both' and ( ( _ProcessRule == 'Main-menu' and _InServer ) or ( _ProcessRule == 'In-game' and not _InServer ) ) then
                    print('[OVERWATCH BOT] not allowed to process, waiting til conditions are sufficient')
                    return client.delay_call(5, Convict)
                end

                local Verdict = {}
                for index, ConvictOption in ipairs(ui.get(GUI.ForceConvictOptions)) do
                    Verdict[ConvictOption] = 'convict'
                end
                
                local Verdict = string.format('aimbot:%s;wallhack:%s;speedhack:%s;grief:%s;', Verdict.Aimbot or 'dismiss', Verdict.Wallhacks or 'dismiss', Verdict.Other or 'dismiss', Verdict.Griefing or 'dismiss')
                
                print('[OVERWATCH BOT] ', 'Convicting player for: ', Verdict)
                OverwatchAPI.SubmitCaseVerdict(Verdict)

                print('[OVERWATCH BOT] ', 'Finished Convicting, waiting for next case')
                
                Data.TotalOverwatches = Data.TotalOverwatches + 1
                ui.set(GUI.Stats.CasesCompleted, 'Cases Completed: ' .. Data.TotalOverwatches)
                
                CaseActive = false
            end

            client.delay_call(ui.get(GUI.VerdictDelay) * 60, Convict)
        end

        if (CaseDescription == '' and CasePercentage == 100) then
            -- Conviction Done (don't really need anything here) waiting...
            
        end
    end

    client.set_event_callback('round_end', function()
        local DownloadRule = ui.get(GUI.DownloadRules)
        if ( DownloadRule == 'Round End' or DownloadRule == 'Both' ) then
            ProcessOverwatch()
        end
    end)

    client.set_event_callback('player_death', function(e)
        local DownloadRule = ui.get(GUI.DownloadRules)
        if ( DownloadRule == 'Self Death' or DownloadRule == 'Both' ) then
            local LocalPlayer = entity.get_local_player()
            local Attacker = client.userid_to_entindex(e.attacker)
            local Victim = client.userid_to_entindex(e.userid)
            if ( LocalPlayer == Victim ) then
                ProcessOverwatch()
            end
        end
    end)

    local LastTick = globals.realtime()
    client.set_event_callback('post_render', function()
        local DownloadRule = ui.get(GUI.DownloadRules)
        if ( ( DownloadRule == 'Always' or not GameStateAPI.IsConnectedOrConnectingToServer() ) and globals.realtime() - LastTick > 1 ) then
            ProcessOverwatch()
            LastTick = globals.realtime()
        end
    end)

    panorama_events.register_event('PanoramaComponent_Overwatch_CaseUpdated', ProcessOverwatch)

    GUI.Toggle = function(void)
        local State = (type(void) == 'bool' and void) or (type(void) == 'number' and ui.get(void) ) or (void == nil and ui.get(GUI.Enable))
        ui.set_visible(GUI.VerdictDelay, State)
        ui.set_visible(GUI.DownloadDelay, State)
        ui.set_visible(GUI.ForceConvictOptions, State)
        ui.set_visible(GUI.OnlyProcess, State)
        ui.set_visible(GUI.DownloadRules, State)
        for i, UIElem in pairs(GUI.Stats) do
            ui.set_visible(UIElem, State)
        end

        Data.Active = State

        if State and ProcessOverwatch then ProcessOverwatch() end
    end

    ui.set_callback(GUI.Enable, GUI.Toggle)
    client.delay_call(1, ui.set, GUI.Enable, Data.Active) -- eww.
    GUI.Toggle(Data.Active)

    client.set_event_callback('shutdown', function()
        database.write('csmit195_OWBot', Data)
    end)
end

init()