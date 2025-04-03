local js = require "panorama"
local customplayers = {
	{"Local T Agent", "models/player/custom_player/legacy/tm_phoenix.mdl", false},
	{"Local CT Agent", "models/player/custom_player/legacy/ctm_sas.mdl", false},
	{"Blackwolf | Sabre", "models/player/custom_player/legacy/tm_balkan_variantj.mdl", false},
	{"Rezan The Ready | Sabre", "models/player/custom_player/legacy/tm_balkan_variantg.mdl", false},
	{"Maximus | Sabre", "models/player/custom_player/legacy/tm_balkan_varianti.mdl", false},
	{"Dragomir | Sabre", "models/player/custom_player/legacy/tm_balkan_variantf.mdl", false},
	{"Lt. Commander Ricksaw | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_varianti.mdl", false},
	{"'Two Times' McCoy | USAF TACP", "models/player/custom_player/legacy/ctm_st6_variantm.mdl", false},
	{"Buckshot | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variantg.mdl", false},
	{"Seal Team 6 Soldier | NSWC SEAL", "models/player/custom_player/legacy/ctm_st6_variante.mdl", false},
	{"3rd Commando Company | KSK", "models/player/custom_player/legacy/ctm_st6_variantk.mdl", false},
	{"'The Doctor' Romanov | Sabre", "models/player/custom_player/legacy/tm_balkan_varianth.mdl", false},
	{"Michael Syfers  | FBI Sniper", "models/player/custom_player/legacy/ctm_fbi_varianth.mdl", false},
	{"Markus Delrow | FBI HRT", "models/player/custom_player/legacy/ctm_fbi_variantg.mdl", false},
	{"Operator | FBI SWAT", "models/player/custom_player/legacy/ctm_fbi_variantf.mdl", false},
	{"Slingshot | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantg.mdl", false},
	{"Enforcer | Phoenix", "models/player/custom_player/legacy/tm_phoenix_variantf.mdl", false},
	{"Soldier | Phoenix", "models/player/custom_player/legacy/tm_phoenix_varianth.mdl", false},
	{"The Elite Mr. Muhlik | Elite Crew", "models/player/custom_player/legacy/tm_leet_variantf.mdl", false},
	{"Prof. Shahmat | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianti.mdl", false},
	{"Osiris | Elite Crew", "models/player/custom_player/legacy/tm_leet_varianth.mdl", false},
	{"Ground Rebel  | Elite Crew", "models/player/custom_player/legacy/tm_leet_variantg.mdl", false},
	{"Special Agent Ava | FBI", "models/player/custom_player/legacy/ctm_fbi_variantb.mdl", false},
	{"B Squadron Officer | SAS", "models/player/custom_player/legacy/ctm_sas_variantf.mdl", false},
	{"Anarchist", "models/player/custom_player/legacy/tm_anarchist.mdl", false},
	{"Anarchist (Variant A)", "models/player/custom_player/legacy/tm_anarchist_varianta.mdl", false},
	{"Anarchist (Variant B)", "models/player/custom_player/legacy/tm_anarchist_variantb.mdl", false},
	{"Anarchist (Variant C)", "models/player/custom_player/legacy/tm_anarchist_variantc.mdl", false},
	{"Anarchist (Variant D)", "models/player/custom_player/legacy/tm_anarchist_variantd.mdl", false},
	{"Pirate", "models/player/custom_player/legacy/tm_pirate.mdl", false},
	{"Pirate (Variant A)", "models/player/custom_player/legacy/tm_pirate_varianta.mdl", false},
	{"Pirate (Variant B)", "models/player/custom_player/legacy/tm_pirate_variantb.mdl", false},
	{"Pirate (Variant C)", "models/player/custom_player/legacy/tm_pirate_variantc.mdl", false},
	{"Pirate (Variant D)", "models/player/custom_player/legacy/tm_pirate_variantd.mdl", false},
	{"Professional", "models/player/custom_player/legacy/tm_professional.mdl", false},
	{"Professional (Variant 1)", "models/player/custom_player/legacy/tm_professional_var1.mdl", false},
	{"Professional (Variant 2)", "models/player/custom_player/legacy/tm_professional_var2.mdl", false},
	{"Professional (Variant 3)", "models/player/custom_player/legacy/tm_professional_var3.mdl", false},
	{"Professional (Variant 4)", "models/player/custom_player/legacy/tm_professional_var4.mdl", false},
	{"Separatist", "models/player/custom_player/legacy/tm_separatist.mdl", false},
	{"Separatist (Variant A)", "models/player/custom_player/legacy/tm_separatist_varianta.mdl", false},
	{"Separatist (Variant B)", "models/player/custom_player/legacy/tm_separatist_variantb.mdl", false},
	{"Separatist (Variant C)", "models/player/custom_player/legacy/tm_separatist_variantc.mdl", false},
	{"Separatist (Variant D)", "models/player/custom_player/legacy/tm_separatist_variantd.mdl", false},
	{"GIGN", "models/player/custom_player/legacy/ctm_gign.mdl", false},
	{"GIGN (Variant A)", "models/player/custom_player/legacy/ctm_gign_varianta.mdl", false},
	{"GIGN (Variant B)", "models/player/custom_player/legacy/ctm_gign_variantb.mdl", false},
	{"GIGN (Variant C)", "models/player/custom_player/legacy/ctm_gign_variantc.mdl", false},
	{"GIGN (Variant D)", "models/player/custom_player/legacy/ctm_gign_variantd.mdl", false},
	{"GSG-9", "models/player/custom_player/legacy/ctm_gsg9.mdl", false},
	{"GSG-9 (Variant A)", "models/player/custom_player/legacy/ctm_gsg9_varianta.mdl", false},
	{"GSG-9 (Variant B)", "models/player/custom_player/legacy/ctm_gsg9_variantb.mdl", false},
	{"GSG-9 (Variant C)", "models/player/custom_player/legacy/ctm_gsg9_variantc.mdl", false},
	{"GSG-9 (Variant D)", "models/player/custom_player/legacy/ctm_gsg9_variantd.mdl", false},
	{"IDF", "models/player/custom_player/legacy/ctm_idf.mdl", false},
	{"IDF (Variant B)", "models/player/custom_player/legacy/ctm_idf_variantb.mdl", false},
	{"IDF (Variant C)", "models/player/custom_player/legacy/ctm_idf_variantc.mdl", false},
	{"IDF (Variant D)", "models/player/custom_player/legacy/ctm_idf_variantd.mdl", false},
	{"IDF (Variant E)", "models/player/custom_player/legacy/ctm_idf_variante.mdl", false},
	{"IDF (Variant F)", "models/player/custom_player/legacy/ctm_idf_variantf.mdl", false},
	{"SWAT", "models/player/custom_player/legacy/ctm_swat.mdl", false},
	{"SWAT (Variant A)", "models/player/custom_player/legacy/ctm_swat_varianta.mdl", false},
	{"SWAT (Variant B)", "models/player/custom_player/legacy/ctm_swat_variantb.mdl", false},
	{"SWAT (Variant C)", "models/player/custom_player/legacy/ctm_swat_variantc.mdl", false},
	{"SWAT (Variant D)", "models/player/custom_player/legacy/ctm_swat_variantd.mdl", false},
	{"SAS (Variant A)", "models/player/custom_player/legacy/ctm_sas_varianta.mdl", false},
	{"SAS (Variant B)", "models/player/custom_player/legacy/ctm_sas_variantb.mdl", false},
	{"SAS (Variant C)", "models/player/custom_player/legacy/ctm_sas_variantc.mdl", false},
	{"SAS (Variant D)", "models/player/custom_player/legacy/ctm_sas_variantd.mdl", false},
	{"ST6", "models/player/custom_player/legacy/ctm_st6.mdl", false},
	{"ST6 (Variant A)", "models/player/custom_player/legacy/ctm_st6_varianta.mdl", false},
	{"ST6 (Variant B)", "models/player/custom_player/legacy/ctm_st6_variantb.mdl", false},
	{"ST6 (Variant C)", "models/player/custom_player/legacy/ctm_st6_variantc.mdl", false},
	{"ST6 (Variant D)", "models/player/custom_player/legacy/ctm_st6_variantd.mdl", false},
	{"Balkan (Variant E)", "models/player/custom_player/legacy/tm_balkan_variante.mdl", false},
	{"Balkan (Variant A)", "models/player/custom_player/legacy/tm_balkan_varianta.mdl", false},
	{"Balkan (Variant B)", "models/player/custom_player/legacy/tm_balkan_variantb.mdl", false},
	{"Balkan (Variant C)", "models/player/custom_player/legacy/tm_balkan_variantc.mdl", false},
	{"Balkan (Variant D)", "models/player/custom_player/legacy/tm_balkan_variantd.mdl", false},
	{"Jumpsuit (Variant A)", "models/player/custom_player/legacy/tm_jumpsuit_varianta.mdl", false},
	{"Jumpsuit (Variant B)", "models/player/custom_player/legacy/tm_jumpsuit_variantb.mdl", false},
	{"Jumpsuit (Variant C)", "models/player/custom_player/legacy/tm_jumpsuit_variantc.mdl", false},
	{"Phoenix Heavy", "models/player/custom_player/legacy/tm_phoenix_heavy.mdl", false},
	{"Heavy", "models/player/custom_player/legacy/ctm_heavy.mdl", false},
	{"Leet (Variant A)", "models/player/custom_player/legacy/tm_leet_varianta.mdl", false},
	{"Leet (Variant B)", "models/player/custom_player/legacy/tm_leet_variantb.mdl", false},
	{"Leet (Variant C)", "models/player/custom_player/legacy/tm_leet_variantc.mdl", false},
	{"Leet (Variant D)", "models/player/custom_player/legacy/tm_leet_variantd.mdl", false},
	{"Leet (Variant E)", "models/player/custom_player/legacy/tm_leet_variante.mdl", false},
	{"Phoenix", "models/player/custom_player/legacy/tm_phoenix.mdl", false},
	{"Phoenix (Variant A)", "models/player/custom_player/legacy/tm_phoenix_varianta.mdl", false},
	{"Phoenix (Variant B)", "models/player/custom_player/legacy/tm_phoenix_variantb.mdl", false},
	{"Phoenix (Variant C)", "models/player/custom_player/legacy/tm_phoenix_variantc.mdl", false},
	{"Phoenix (Variant D)", "models/player/custom_player/legacy/tm_phoenix_variantd.mdl", false},
	{"FBI", "models/player/custom_player/legacy/ctm_fbi.mdl", false},
	{"FBI (Variant A)", "models/player/custom_player/legacy/ctm_fbi_varianta.mdl", false},
	{"FBI (Variant C)", "models/player/custom_player/legacy/ctm_fbi_variantc.mdl", false},
	{"FBI (Variant D)", "models/player/custom_player/legacy/ctm_fbi_variantd.mdl", false},
	{"FBI (Variant E)", "models/player/custom_player/legacy/ctm_fbi_variante.mdl", false},
    {"SAS", "models/player/custom_player/legacy/ctm_sas.mdl", false}
}
local dances = {
    {"Fonzie_Pistol", "Emote_Fonzie_Pistol"},
    {"Bring_It_On", "Emote_Bring_It_On"},
    {"ThumbsDown", "Emote_ThumbsDown"},
    {"ThumbsUp", "Emote_ThumbsUp"},
    {"Celebration_Loop", "Emote_Celebration_Loop"},
    {"BlowKiss", "Emote_BlowKiss"},
    {"Calculated", "Emote_Calculated"},
    {"Confused", "Emote_Confused",},
    {"Chug", "Emote_Chug"},
    {"Cry", "Emote_Cry"},
    {"DustingOffHands", "Emote_DustingOffHands"},
    {"DustOffShoulders", "Emote_DustOffShoulders",},
    {"Facepalm", "Emote_Facepalm"},
    {"Fishing", "Emote_Fishing"},
    {"Flex", "Emote_Flex"},
    {"golfclap", "Emote_golfclap",},
    {"HandSignals", "Emote_HandSignals"},
    {"HeelClick", "Emote_HeelClick"},
    {"Hotstuff", "Emote_Hotstuff"},
    {"IBreakYou", "Emote_IBreakYou",},
    {"IHeartYou", "Emote_IHeartYou"},
    {"Kung", "Emote_Kung-Fu_Salute"},
    {"Laugh", "Emote_Laugh"},
    {"Luchador", "Emote_Luchador",},
    {"Make_It_Rain", "Emote_Make_It_Rain"},
    {"NotToday", "Emote_NotToday"},
    {"[RPS] Paper", "Emote_RockPaperScissor_Paper"},
    {"[RPS] Rock", "Emote_RockPaperScissor_Rock",},
    {"[RPS] Scissor", "Emote_RockPaperScissor_Scissor"},
    {"Salt", "Emote_Salt"},
    {"Salute", "Emote_Salute"},
    {"SmoothDrive", "Emote_SmoothDrive",},
    {"Snap", "Emote_Snap"},
    {"StageBow", "Emote_StageBow",},
    {"Wave2", "Emote_Wave2"},
    {"Yeet", "Emote_Yeet"},
    {"DanceMoves", "DanceMoves"},
    {"Mask_Off_Intro", "Emote_Mask_Off_Intro"},
    {"Zippy_Dance", "Emote_Zippy_Dance"},
    {"ElectroShuffle", "ElectroShuffle"},
    {"AerobicChamp", "Emote_AerobicChamp"},
    {"Bendy", "Emote_Bendy"},
    {"BandOfTheFort", "Emote_BandOfTheFort"},
    {"Boogie_Down_Intro", "Emote_Boogie_Down_Intro",},
    {"Capoeira", "Emote_Capoeira"},
    {"Charleston", "Emote_Charleston"},
    {"Chicken", "Emote_Chicken"},
    {"Dance_NoBones", "Emote_Dance_NoBones",},
    {"Dance_Shoot", "Emote_Dance_Shoot"},
    {"Dance_SwipeIt", "Emote_Dance_SwipeIt"},
    {"Dance_Disco_T3", "Emote_Dance_Disco_T3"},
    {"DG_Disco", "Emote_DG_Disco",},
    {"Dance_Worm", "Emote_Dance_Worm"},
    {"Dance_Loser", "Emote_Dance_Loser"},
    {"Dance_Breakdance", "Emote_Dance_Breakdance"},
    {"Dance_Pump", "Emote_Dance_Pump",},
    {"Dance_RideThePony", "Emote_Dance_RideThePony"},
    {"Dab", "Emote_Dab"},
    {"EasternBloc_Start", "Emote_EasternBloc_Start"},
    {"FancyFeet", "Emote_FancyFeet",},
    {"FlossDance", "Emote_FlossDance"},
    {"FlippnSexy", "Emote_FlippnSexy"},
    {"Fresh", "Emote_Fresh"},
    {"GrooveJam", "Emote_GrooveJam",},
    {"guitar", "Emote_guitar"},
    {"Hillbilly_Shuffle_Intro", "Emote_Hillbilly_Shuffle_Intro"},
    {"Hiphop_01", "Emote_Hiphop_01"},
    {"Hula_Start", "Emote_Hula_Start",},
    {"InfiniDab_Intro", "Emote_InfiniDab_Intro"},
    {"Intensity_Start", "Emote_Intensity_Start"},
    {"IrishJig_Start", "Emote_IrishJig_Start"},
    {"KoreanEagle", "Emote_KoreanEagle",},
    {"Kpop_02", "Emote_Kpop_02"},
    {"LivingLarge", "Emote_LivingLarge"},
    {"Maracas", "Emote_Maracas"},
    {"PopLock", "Emote_PopLock"},
    {"PopRock", "Emote_PopRock"},
    {"RobotDance", "Emote_RobotDance"},
    {"T-Rex", "Emote_T-Rex",},
    {"TechnoZombie", "Emote_TechnoZombie"},
    {"Twist", "Emote_Twist"},
    {"WarehouseDance_Start", "Emote_WarehouseDance_Start"},
    {"Wiggle", "Emote_Wiggle"},
    {"Youre_Awesome", "Emote_Youre_Awesome",}
}

local setup = function()
    js.eval([[
        var model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
    ]])
    local model_names = {}
    for i = 1, #customplayers do
        table.insert(model_names, customplayers[i][1])
    end
    local dance_names = {}
    for i = 1, #dances do
        table.insert(dance_names, dances[i][1])
    end
    local menu_items = {
        model_combo = menu.add_selection("Fortnite", "Model", model_names),
        dance_combo = menu.add_selection("Fortnite", "FORTNITE MOVE!", dance_names),
        checkbox_color = menu.add_checkbox("Fortnite", "Color"),
    }
    local menu_colors = { -- :)
        ambient_color = menu_items.checkbox_color:add_color_picker("bruh color")
    }
    local animations = {
        menu.add_button("Fortnite", "Update", function()
            variables = {
                model_path = customplayers[menu_items.model_combo:get()][2],
                dance_path = dances[menu_items.dance_combo:get()][2]
            }
            if entity_list.get_local_player() then return end
            js.eval([[
                model.visible = true;
            ]])
            js.eval([[
                model.SetScene("resource/ui/econ/ItemModelPanelCharMainMenu.res", "models/player/custom_player/legacy/tm_phoenix.mdl", false)
            ]])
            js.eval([[
                model.SetScene("resource/ui/fornite_dances.res", "]] .. variables.model_path .. [[", false)
                model.PlaySequence("]].. variables.dance_path ..[[", true)
            ]])
        end),
        menu.add_button("Fortnite", "Reset/Restore Animation/Model", function()
            js.eval([[
                model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
                model.visible = true;
                model.SetScene("resource/ui/econ/ItemModelPanelCharMainMenu.res", "models/player/custom_player/legacy/tm_phoenix.mdl", false)
                model.ResetAnimation( true )
                model.RestoreLightingState()
            ]] )    
        end),   
        set_ambient_color = function()
            if entity_list.get_local_player() then return end
            if menu_items.checkbox_color:get() then
                js.eval( [[
                    model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
                    model.SetAmbientLightColor(]] .. menu_colors.ambient_color:get().r .. [[, ]] .. menu_colors.ambient_color:get().g .. [[, ]] .. menu_colors.ambient_color:get().b .. [[);
                ]] )
            else
                js.eval( [[
                    model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
                    model.RestoreLightingState()
                ]] )     
            end
        end,
        restore = function()
            local model_path = customplayers[menu_items.model_combo:get()][2]
            js.eval([[
                model = $.GetContextPanel().GetChild(0).FindChildInLayoutFile( 'JsMainmenu_Vanity' );
                model.visible = true;
                model.SetScene("resource/ui/econ/ItemModelPanelCharMainMenu.res", "models/player/custom_player/legacy/tm_phoenix.mdl", false)
                model.ResetAnimation( true )
                model.RestoreLightingState()
            ]]) 
        end
    }
    local callbacks = {
        on_paint = function()
            animations:set_ambient_color()
        end,
        on_destroy = function()
            animations:restore()
        end,
        register = function(self)
            callbacks.add(e_callbacks.PAINT, self.on_paint)
            callbacks.add(e_callbacks.SHUTDOWN, self.on_destroy)
        end
    }
    callbacks:register()
end
setup()