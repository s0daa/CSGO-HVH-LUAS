-- ###################
-- credits @Yuuki
-- ###################
ffi.cdef[[
    typedef bool(__thiscall *DispatchUserMessage_t)(void*, int messageType, int passthroughFlags, int size, const void* data);
    typedef bool(__thiscall *hkDispatchUserMessage_t)(void*, int messageType, int passthroughFlags, int size, const void* data);
]]
local interface = ffi.cast("uintptr_t**", memory.create_interface("client.dll", "VClient018"))
local orig_table = ffi.cast("uintptr_t*", interface[0])
local table_size = 0
local hook_index = 38

-- not necessary btw
while(orig_table[table_size] ~= 0x0) do
    table_size = table_size + 1
end

local hooked_table = ffi.new("uintptr_t[?]", table_size)
for i = 0, table_size - 1 do
    hooked_table[i] = orig_table[i]
end

interface[0] = hooked_table

-- ctrl+c + ctrl+v enum from csgo src
local messages = {
    CS_UM_VGUIMenu		                = 1,
	CS_UM_Geiger		                = 2,
	CS_UM_Train			                = 3,
	CS_UM_HudText		                = 4,
	CS_UM_SayText		                = 5,
	CS_UM_SayText2		                = 6,
	CS_UM_TextMsg		                = 7,
	CS_UM_HudMsg		                = 8,
	CS_UM_ResetHud		                = 9,
	CS_UM_GameTitle		                = 10,
	CS_UM_Shake			                = 12,
	CS_UM_Fade			                = 13,
	CS_UM_Rumble		                = 14,
	CS_UM_CloseCaption	                = 15,
	CS_UM_CloseCaptionDirect            = 16,
	CS_UM_SendAudio		                = 17,
	CS_UM_RawAudio		                = 18,
	CS_UM_VoiceMask		                = 19,
	CS_UM_RequestState                  = 20,
	CS_UM_Damage		                = 21,
	CS_UM_RadioText		                = 22,
	CS_UM_HintText		                = 23,
	CS_UM_KeyHintText	                = 24,
	CS_UM_ProcessSpottedEntityUpdate    = 25,
	CS_UM_ReloadEffect	                = 26,
	CS_UM_AdjustMoney	                = 27,
	CS_UM_UpdateTeamMoney               = 28,
	CS_UM_StopSpectatorMode             = 29,
	CS_UM_KillCam		                = 30,
	CS_UM_DesiredTimescale              = 31,
	CS_UM_CurrentTimescale              = 32,
	CS_UM_AchievementEvent              = 33,
	CS_UM_MatchEndConditions            = 34,
	CS_UM_DisconnectToLobby             = 35,
	CS_UM_PlayerStatsUpdate             = 36,
	CS_UM_DisplayInventory              = 37,
	CS_UM_WarmupHasEnded                = 38,
	CS_UM_ClientInfo                    = 39,
	CS_UM_XRankGet                      = 40,
	CS_UM_XRankUpd                      = 41,
	CS_UM_CallVoteFailed                = 45,
	CS_UM_VoteStart                     = 46,
	CS_UM_VotePass                      = 47,
	CS_UM_VoteFailed                    = 48,
	CS_UM_VoteSetup                     = 49,
	CS_UM_ServerRankRevealAll           = 50,
	CS_UM_SendLastKillerDamageToClient  = 51,
	CS_UM_ServerRankUpdate              = 52,
	CS_UM_ItemPickup                    = 53,
	CS_UM_ShowMenu                      = 54,
	CS_UM_BarTime                       = 55,
	CS_UM_AmmoDenied                    = 56,
	CS_UM_MarkAchievement               = 57,
	CS_UM_MatchStatsUpdate              = 58,
	CS_UM_ItemDrop                      = 59,
	CS_UM_GlowPropTurnOff               = 60,
	CS_UM_SendPlayerItemDrops           = 61,
	CS_UM_RoundBackupFilenames          = 62,
	CS_UM_SendPlayerItemFound           = 63,
	CS_UM_ReportHit                     = 64,
	CS_UM_XpUpdate                      = 65,
	CS_UM_QuestProgress                 = 66,
	CS_UM_ScoreLeaderboardData          = 67,
	CS_UM_PlayerDecalDigitalSignature   = 68,
}

local msg_by_id = {}
for k, v in pairs(messages) do
    msg_by_id[v] = k
end

local blocked_messages = {
    ["CS_UM_TextMsg"] = true,
    ["CS_UM_ShowMenu"] = false,
    ["CS_UM_SayText"] = true,
    ["CS_UM_VGUIMenu"] = true,
    ["CS_UM_RadioText"] = true,
}

local block_menu = menu.add_checkbox("Filter Server Ads", "Block ShowMenu event", false)
local debug = menu.add_checkbox("Filter Server Ads", "debug", false)

local oDispatch = ffi.cast("DispatchUserMessage_t", orig_table[hook_index])
local function hkDispatch(this, type, flags, size, data)

    local isReturn = true
    local protected = function()

		blocked_messages["CS_UM_ShowMenu"] = block_menu:get()

		if debug:get() then
			print("[filter chat ads debug]", "Message type:", msg_by_id[type])
		end

        if blocked_messages[msg_by_id[type]] then
            isReturn = false
        end
    end

    local status, message = pcall(protected)
    
    if not status then
        print(message)
    end

    if isReturn then
        return oDispatch(this, type, flags, size, data)
    end

    return true
end

hooked_table[hook_index] = ffi.cast("uintptr_t", ffi.cast("void*", ffi.cast("hkDispatchUserMessage_t", hkDispatch)))

callbacks.add(e_callbacks.SHUTDOWN, function()
    hooked_table[hook_index] = orig_table[hook_index]
    interface[0] = orig_table
end)