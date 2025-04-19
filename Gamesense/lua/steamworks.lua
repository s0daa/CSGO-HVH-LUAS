--
-- dependencies
--

local ffi = require "ffi"
local md5 = require "gamesense/md5"
local cast, cdef, typeof, sizeof, istype, ffi_string, ffi_copy = ffi.cast, ffi.cdef, ffi.typeof, ffi.sizeof, ffi.istype, ffi.string, ffi.copy
local string_len, string_sub, string_gsub, string_match, string_gmatch, string_lower, string_upper, string_format, string_reverse = string.len, string.sub, string.gsub, string.match, string.gmatch, string.lower, string.upper, string.format, string.reverse
local assert, tostring, tonumber, setmetatable, pairs, ipairs, pcall, xpcall, error, type = assert, tostring, tonumber, setmetatable, pairs, ipairs, pcall, xpcall, error, type
local error_log, find_signature, timestamp = client.error_log, client.find_signature, client.timestamp
local table_insert, table_remove = table.insert, table.remove
local math_floor, math_min, math_max = math.floor, math.min, math.max
local band, bor, rshift, lshift, bswap = bit.band, bit.bor, bit.rshift, bit.lshift, bit.bswap
local md5_sum = md5.sum

--
-- constants
--

local uintptr_t = typeof("uintptr_t")
local uint64_t = typeof("uint64_t")
local BASE_STEAMID64 = 76561197960265728ULL

local uint64_t_arr = typeof("uint64_t[?]")
-- local uint64_t_ptr = typeof("uint64_t*")
local uint32_t_arr = typeof("uint32_t[?]")
local uint32_t_ptr = typeof("uint32_t*")
local uint8_t_arr = typeof("uint8_t[?]")
local uint8_t_ptr = typeof("uint8_t*")
local bool_arr = typeof("bool[?]")
local bool_ptr = typeof("bool*")

--
-- utility functions
--

local function find_sig(mdlname, pattern, typename, offset, deref_count)
	local raw_match = find_signature(mdlname, pattern) or error("signature not found", 2)
	local match = cast("uintptr_t", raw_match)

	if offset ~= nil and offset ~= 0 then
		match = match + offset
	end

	if deref_count ~= nil then
		for i = 1, deref_count do
			match = cast("uintptr_t*", match)[0]
			if match == nil then
				return error("signature not found")
			end
		end
	end

	return cast(typename, match)
end

local function vtable_entry(instance, index, typ)
	assert(instance ~= nil)
	assert(cast("void***", instance)[0] ~= nil)
	return cast(typ, (cast("void***", instance)[0])[index])
end

local function pointer_key(p)
	return tonumber(cast(uintptr_t, p))
end

local function is_defined(typ)
	return (pcall(typeof, typ))
end

local function safe_cdef(name, typedef)
	if not is_defined(name) then
		cdef(typedef)
	end
end

local function struct_to_tbl(inst, fields, string_field_lookup)
	local index = {}
	local tbl = setmetatable({}, {__index = index})

	if inst ~= nil then
		for key, key_alt in pairs(fields) do
			local val = inst[key]

			if string_field_lookup ~= nil and string_field_lookup[key] and val ~= nil then
				val = ffi_string(inst[key])
			end

			tbl[key] = val
			index[key_alt] = val
		end
	end

	return tbl
end

local function error_log_prefix(text)
	return function(message)
		return error_log(text .. tostring(message))
	end
end

--
-- references to parent objects
--

local PARENT_TBL = setmetatable({}, {__mode = "k"})

local function DEREF_GCSAFE(parent)
	local child = parent[0]

	-- prevent parent from getting garbage collected if child wasnt garbage collected yet
	PARENT_TBL[child] = parent

	return child
end

--
-- basic module initialization
--

local M = {}

local index_funcs, index_funcs_extra = {}, {}

setmetatable(M, {
	__index = function(tbl, key)
		if tbl == M then
			if index_funcs[key] ~= nil then
				-- print("[!] Initializing interface ", key)
				M[key] = index_funcs[key]()
				index_funcs[key] = nil

				if index_funcs_extra[key] ~= nil then
					index_funcs_extra[key]()
				end

				return M[key]
			end
		end
	end
})

--
-- enums
--

local enums = {
	ESteamIPType = {IPv4=0,IPv6=1},
	EUniverse = {Invalid=0,Public=1,Beta=2,Internal=3,Dev=4,Max=5},
	EResult = {None=0,OK=1,Fail=2,NoConnection=3,InvalidPassword=5,LoggedInElsewhere=6,InvalidProtocolVer=7,InvalidParam=8,FileNotFound=9,Busy=10,InvalidState=11,InvalidName=12,InvalidEmail=13,DuplicateName=14,AccessDenied=15,Timeout=16,Banned=17,AccountNotFound=18,InvalidSteamID=19,ServiceUnavailable=20,NotLoggedOn=21,Pending=22,EncryptionFailure=23,InsufficientPrivilege=24,LimitExceeded=25,Revoked=26,Expired=27,AlreadyRedeemed=28,DuplicateRequest=29,AlreadyOwned=30,IPNotFound=31,PersistFailed=32,LockingFailed=33,LogonSessionReplaced=34,ConnectFailed=35,HandshakeFailed=36,IOFailure=37,RemoteDisconnect=38,ShoppingCartNotFound=39,Blocked=40,Ignored=41,NoMatch=42,AccountDisabled=43,ServiceReadOnly=44,AccountNotFeatured=45,AdministratorOK=46,ContentVersion=47,TryAnotherCM=48,PasswordRequiredToKickSession=49,AlreadyLoggedInElsewhere=50,Suspended=51,Cancelled=52,DataCorruption=53,DiskFull=54,RemoteCallFailed=55,PasswordUnset=56,ExternalAccountUnlinked=57,PSNTicketInvalid=58,ExternalAccountAlreadyLinked=59,RemoteFileConflict=60,IllegalPassword=61,SameAsPreviousValue=62,AccountLogonDenied=63,CannotUseOldPassword=64,InvalidLoginAuthCode=65,AccountLogonDeniedNoMail=66,HardwareNotCapableOfIPT=67,IPTInitError=68,ParentalControlRestricted=69,FacebookQueryError=70,ExpiredLoginAuthCode=71,IPLoginRestrictionFailed=72,AccountLockedDown=73,AccountLogonDeniedVerifiedEmailRequired=74,NoMatchingURL=75,BadResponse=76,RequirePasswordReEntry=77,ValueOutOfRange=78,UnexpectedError=79,Disabled=80,InvalidCEGSubmission=81,RestrictedDevice=82,RegionLocked=83,RateLimitExceeded=84,AccountLoginDeniedNeedTwoFactor=85,ItemDeleted=86,AccountLoginDeniedThrottle=87,TwoFactorCodeMismatch=88,TwoFactorActivationCodeMismatch=89,AccountAssociatedToMultiplePartners=90,NotModified=91,NoMobileDevice=92,TimeNotSynced=93,SmsCodeFailed=94,AccountLimitExceeded=95,AccountActivityLimitExceeded=96,PhoneActivityLimitExceeded=97,RefundToWallet=98,EmailSendFailure=99,NotSettled=100,NeedCaptcha=101,GSLTDenied=102,GSOwnerDenied=103,InvalidItemType=104,IPBanned=105,GSLTExpired=106,InsufficientFunds=107,TooManyPending=108,NoSiteLicensesFound=109,WGNetworkSendExceeded=110,AccountNotFriends=111,LimitedUserAccount=112,CantRemoveItem=113,AccountDeleted=114,ExistingUserCancelledLicense=115,CommunityCooldown=116,NoLauncherSpecified=117,MustAgreeToSSA=118,LauncherMigrated=119},
	EVoiceResult = {OK=0,NotInitialized=1,NotRecording=2,NoData=3,BufferTooSmall=4,DataCorrupted=5,Restricted=6,UnsupportedCodec=7,ReceiverOutOfDate=8,ReceiverDidNotAnswer=9},
	EDenyReason = {Invalid=0,InvalidVersion=1,Generic=2,NotLoggedOn=3,NoLicense=4,Cheater=5,LoggedInElseWhere=6,UnknownText=7,IncompatibleAnticheat=8,MemoryCorruption=9,IncompatibleSoftware=10,SteamConnectionLost=11,SteamConnectionError=12,SteamResponseTimedOut=13,SteamValidationStalled=14,SteamOwnerLeftGuestUser=15},
	EBeginAuthSessionResult = {OK=0,InvalidTicket=1,DuplicateRequest=2,InvalidVersion=3,GameMismatch=4,ExpiredTicket=5},
	EAuthSessionResponse = {OK=0,UserNotConnectedToSteam=1,NoLicenseOrExpired=2,VACBanned=3,LoggedInElseWhere=4,VACCheckTimedOut=5,AuthTicketCanceled=6,AuthTicketInvalidAlreadyUsed=7,AuthTicketInvalid=8,PublisherIssuedBan=9},
	EUserHasLicenseForAppResult = {HasLicense=0,DoesNotHaveLicense=1,NoAuth=2},
	EAccountType = {Invalid=0,Individual=1,Multiseat=2,GameServer=3,AnonGameServer=4,Pending=5,ContentServer=6,Clan=7,Chat=8,ConsoleUser=9,AnonUser=10,Max=11},
	EChatEntryType = {Invalid=0,ChatMsg=1,Typing=2,InviteGame=3,Emote=4,LeftConversation=6,Entered=7,WasKicked=8,WasBanned=9,Disconnected=10,HistoricalChat=11,LinkBlocked=14},
	EChatRoomEnterResponse = {Success=1,DoesntExist=2,NotAllowed=3,Full=4,Error=5,Banned=6,Limited=7,ClanDisabled=8,CommunityBan=9,MemberBlockedYou=10,YouBlockedMember=11,RatelimitExceeded=15},
	EChatSteamIDInstanceFlags = {InstanceMask=4095,FlagClan=524288,FlagLobby=262144,FlagMMSLobby=131072},
	ENotificationPosition = {TopLeft=0,TopRight=1,BottomLeft=2,BottomRight=3},
	EMarketNotAllowedReasonFlags = {None=0,TemporaryFailure=1,AccountDisabled=2,AccountLockedDown=4,AccountLimited=8,TradeBanned=16,AccountNotTrusted=32,SteamGuardNotEnabled=64,SteamGuardOnlyRecentlyEnabled=128,RecentPasswordReset=256,NewPaymentMethod=512,InvalidCookie=1024,UsingNewDevice=2048,RecentSelfRefund=4096,NewPaymentMethodCannotBeVerified=8192,NoRecentPurchases=16384,AcceptedWalletGift=32768},
	EDurationControlProgress = {Full=0,Half=1,None=2,ExitSoon_3h=3,ExitSoon_5h=4,ExitSoon_Night=5},
	EDurationControlNotification = {None=0,["1Hour"]=1,["3Hours"]=2,HalfProgress=3,NoProgress=4,ExitSoon_3h=5,ExitSoon_5h=6,ExitSoon_Night=7},
	EDurationControlOnlineState = {Invalid=0,Offline=1,Online=2,OnlineHighPri=3},
	ESteamIPv6ConnectivityProtocol = {Invalid=0,HTTP=1,UDP=2},
	ESteamIPv6ConnectivityState = {Unknown=0,Good=1,Bad=2},
	EFriendRelationship = {None=0,Blocked=1,RequestRecipient=2,Friend=3,RequestInitiator=4,Ignored=5,IgnoredFriend=6,Suggested_DEPRECATED=7,Max=8},
	EPersonaState = {Offline=0,Online=1,Busy=2,Away=3,Snooze=4,LookingToTrade=5,LookingToPlay=6,Invisible=7,Max=8},
	EFriendFlags = {None=0,Blocked=1,FriendshipRequested=2,Immediate=4,ClanMember=8,OnGameServer=16,RequestingFriendship=128,RequestingInfo=256,Ignored=512,IgnoredFriend=1024,ChatMember=4096,All=65535},
	EOverlayToStoreFlag = {None=0,AddToCart=1,AddToCartAndShow=2},
	EActivateGameOverlayToWebPageMode = {Default=0,Modal=1},
	EPersonaChange = {Name=1,Status=2,ComeOnline=4,GoneOffline=8,GamePlayed=16,GameServer=32,Avatar=64,JoinedSource=128,LeftSource=256,RelationshipChanged=512,NameFirstSet=1024,Broadcast=2048,Nickname=4096,SteamLevel=8192,RichPresence=16384},
	ESteamAPICallFailure = {None=-1,SteamGone=0,NetworkFailure=1,InvalidHandle=2,MismatchedCallback=3},
	EGamepadTextInputMode = {Normal=0,Password=1},
	EGamepadTextInputLineMode = {SingleLine=0,MultipleLines=1},
	ETextFilteringContext = {Unknown=0,GameContent=1,Chat=2,Name=3},
	ECheckFileSignature = {InvalidSignature=0,ValidSignature=1,FileNotFound=2,NoSignaturesFoundForThisApp=3,NoSignaturesFoundForThisFile=4},
	EMatchMakingServerResponse = {eServerResponded=0,eServerFailedToRespond=1,eNoServersListedOnMasterServer=2},
	ELobbyType = {Private=0,FriendsOnly=1,Public=2,Invisible=3,PrivateUnique=4},
	ELobbyComparison = {EqualToOrLessThan=-2,LessThan=-1,Equal=0,GreaterThan=1,EqualToOrGreaterThan=2,NotEqual=3},
	ELobbyDistanceFilter = {Close=0,Default=1,Far=2,Worldwide=3},
	ESteamPartyBeaconLocationType = {Invalid=0,ChatGroup=1,Max=2},
	ERemoteStoragePublishedFileVisibility = {Public=0,FriendsOnly=1,Private=2,Unlisted=3},
	EWorkshopFileType = {First=0,Community=0,Microtransaction=1,Collection=2,Art=3,Video=4,Screenshot=5,Game=6,Software=7,Concept=8,WebGuide=9,IntegratedGuide=10,Merch=11,ControllerBinding=12,SteamworksAccessInvite=13,SteamVideo=14,GameManagedItem=15,Max=16},
	EWorkshopVote = {Unvoted=0,For=1,Against=2,Later=3},
	EWorkshopFileAction = {Played=0,Completed=1},
	ELeaderboardDataRequest = {Global=0,GlobalAroundUser=1,Friends=2,Users=3},
	ELeaderboardSortMethod = {None=0,Ascending=1,Descending=2},
	ELeaderboardDisplayType = {None=0,Numeric=1,TimeSeconds=2,TimeMilliSeconds=3},
	ELeaderboardUploadScoreMethod = {None=0,KeepBest=1,ForceUpdate=2},
	ERegisterActivationCodeResult = {OK=0,Fail=1,AlreadyRegistered=2,Timeout=3,AlreadyOwned=4},
	EP2PSessionError = {None=0,NoRightsToApp=2,Timeout=4,NotRunningApp_DELETED=1,DestinationNotLoggedIn_DELETED=3,Max=5},
	EP2PSend = {Unreliable=0,UnreliableNoDelay=1,Reliable=2,ReliableWithBuffering=3},
	ESNetSocketState = {Invalid=0,Connected=1,Initiated=10,LocalCandidatesFound=11,ReceivedRemoteCandidates=12,ChallengeHandshake=15,Disconnecting=21,LocalDisconnect=22,TimeoutDuringConnect=23,RemoteEndDisconnected=24,ConnectionBroken=25},
	ESNetSocketConnectionType = {NotConnected=0,UDP=1,UDPRelay=2},
	EVRScreenshotType = {None=0,Mono=1,Stereo=2,MonoCubemap=3,MonoPanorama=4,StereoPanorama=5},
	AudioPlayback_Status = {Undefined=0,Playing=1,Paused=2,Idle=3},
	EHTTPMethod = {Invalid=0,GET=1,HEAD=2,POST=3,PUT=4,DELETE=5,OPTIONS=6,PATCH=7},
	EHTTPStatusCode = {Invalid=0,["100Continue"]=100,["101SwitchingProtocols"]=101,["200OK"]=200,["201Created"]=201,["202Accepted"]=202,["203NonAuthoritative"]=203,["204NoContent"]=204,["205ResetContent"]=205,["206PartialContent"]=206,["300MultipleChoices"]=300,["301MovedPermanently"]=301,["302Found"]=302,["303SeeOther"]=303,["304NotModified"]=304,["305UseProxy"]=305,["307TemporaryRedirect"]=307,["400BadRequest"]=400,["401Unauthorized"]=401,["402PaymentRequired"]=402,["403Forbidden"]=403,["404NotFound"]=404,["405MethodNotAllowed"]=405,["406NotAcceptable"]=406,["407ProxyAuthRequired"]=407,["408RequestTimeout"]=408,["409Conflict"]=409,["410Gone"]=410,["411LengthRequired"]=411,["412PreconditionFailed"]=412,["413RequestEntityTooLarge"]=413,["414RequestURITooLong"]=414,["415UnsupportedMediaType"]=415,["416RequestedRangeNotSatisfiable"]=416,["417ExpectationFailed"]=417,["4xxUnknown"]=418,["429TooManyRequests"]=429,["444ConnectionClosed"]=444,["500InternalServerError"]=500,["501NotImplemented"]=501,["502BadGateway"]=502,["503ServiceUnavailable"]=503,["504GatewayTimeout"]=504,["505HTTPVersionNotSupported"]=505,["5xxUnknown"]=599},
	EInputSourceMode = {None=0,Dpad=1,Buttons=2,FourButtons=3,AbsoluteMouse=4,RelativeMouse=5,JoystickMove=6,JoystickMouse=7,JoystickCamera=8,ScrollWheel=9,rigger=10,ouchMenu=11,MouseJoystick=12,MouseRegion=13,RadialMenu=14,SingleButton=15,Switches=16},
	EParentalFeature = {Invalid=0,Store=1,Community=2,Profile=3,Friends=4,News=5,Trading=6,Settings=7,Console=8,Browser=9,ParentalSetup=10,Library=11,Test=12,SiteLicense=13,Max=14},
	ESteamDeviceFormFactor = {Unknown=0,Phone=1,Tablet=2,Computer=3,TV=4},
	ESteamNetworkingAvailability = {CannotTry=-102,Failed=-101,Previously=-100,Retrying=-10,NeverTried=1,Waiting=2,Attempting=3,Current=100,Unknown=0},
	ESteamNetworkingIdentityType = {Invalid=0,SteamID=16,XboxPairwiseID=17,SonyPSN=18,GoogleStadia=19,IPAddress=1,GenericString=2,GenericBytes=3,UnknownType=4},
	ESteamNetworkingConnectionState = {None=0,Connecting=1,FindingRoute=2,Connected=3,ClosedByPeer=4,ProblemDetectedLocally=5,FinWait=-1,Linger=-2,Dead=-3},
	ESteamNetTransportKind = {Unknown=0,LoopbackBuffers=1,LocalHost=2,UDP=3,UDPProbablyLocal=4,TURN=5,SDRP2P=6,SDRHostedServer=7},
	ESteamNetworkingConfigScope = {Global=1,SocketsInterface=2,ListenSocket=3,Connection=4},
	ESteamNetworkingConfigDataType = {Int32=1,Int64=2,Float=3,String=4,Ptr=5},
	ESteamNetworkingConfigValue = {Invalid=0,FakePacketLoss_Send=2,FakePacketLoss_Recv=3,FakePacketLag_Send=4,FakePacketLag_Recv=5,FakePacketReorder_Send=6,FakePacketReorder_Recv=7,FakePacketReorder_Time=8,FakePacketDup_Send=26,FakePacketDup_Recv=27,FakePacketDup_TimeMax=28,TimeoutInitial=24,TimeoutConnected=25,SendBufferSize=9,SendRateMin=10,SendRateMax=11,NagleTime=12,IP_AllowWithoutAuth=23,MTU_PacketSize=32,MTU_DataSize=33,Unencrypted=34,EnumerateDevVars=35,SymmetricConnect=37,LocalVirtualPort=38,Callback_ConnectionStatusChanged=201,Callback_AuthStatusChanged=202,Callback_RelayNetworkStatusChanged=203,Callback_MessagesSessionRequest=204,Callback_MessagesSessionFailed=205,Callback_CreateConnectionSignaling=206,P2P_STUN_ServerList=103,P2P_Transport_ICE_Enable=104,P2P_Transport_ICE_Penalty=105,P2P_Transport_SDR_Penalty=106,SDRClient_ConsecutitivePingTimeoutsFailInitial=19,SDRClient_ConsecutitivePingTimeoutsFail=20,SDRClient_MinPingsBeforePingAccurate=21,SDRClient_SingleSocket=22,SDRClient_ForceRelayCluster=29,SDRClient_DebugTicketAddress=30,SDRClient_ForceProxyAddr=31,SDRClient_FakeClusterPing=36,LogLevel_AckRTT=13,LogLevel_PacketDecode=14,LogLevel_Message=15,LogLevel_PacketGaps=16,LogLevel_P2PRendezvous=17,LogLevel_SDRRelayPings=18},
	ESteamNetworkingGetConfigValueResult = {BadValue=-1,BadScopeObj=-2,BufferTooSmall=-3,OK=1,OKInherited=2},
	ESteamNetworkingSocketsDebugOutputType = {None=0,Bug=1,Error=2,Important=3,Warning=4,Msg=5,Verbose=6,Debug=7,Everything=8},
	EHTMLMouseButton = {Left=0,Right=1,Middle=2},
	EHTMLKeyModifiers = {None=0,AltDown=1,CtrlDown=2,ShiftDown=4},
	PlayerAcceptState_t = {Unknown=0,PlayerAccepted=1,PlayerDeclined=2},
}

-- create fallback mapping value -> key
for name, enum in pairs(enums) do
	local metatable = {__index={}}
	for key, value in pairs(enum) do
		-- accept all lower / upper case variants
		metatable.__index[string_lower(key)] = value
		metatable.__index[string_upper(key)] = value

		-- accept reverse mapping
		metatable.__index[value] = key
	end
	setmetatable(enum, metatable)
	M[name] = enum
end

--
-- constants
--

local constants = {--[[--constants--]]}

-- define enums globally in module
for name, value in pairs(constants) do
	M[name] = value
end

--
-- SteamID class
--

if not is_defined("SteamID") then
	cdef([[
		typedef union {
			uint64_t steamid64;
			struct {
			  uint32_t accountid : 32;
			  unsigned int instance : 20;
			  unsigned int type : 4;
			  unsigned int universe : 8;
			};
			struct {
			  uint32_t low;
			  uint32_t high;
			};
		} __attribute__((packed)) SteamID;
	]])
end

assert(sizeof("SteamID") == 8)

local to_steamid
local SteamID = typeof("SteamID")
do
	local EAccountType = enums.EAccountType
	local EChatSteamIDInstanceFlags = enums.EChatSteamIDInstanceFlags

	local TYPE_CHARS = {
		[EAccountType.INVALID] = 'I',
		[EAccountType.INDIVIDUAL] = 'U',
		[EAccountType.MULTISEAT] = 'M',
		[EAccountType.GAMESERVER] = 'G',
		[EAccountType.ANONGAMESERVER] = 'A',
		[EAccountType.PENDING] = 'P',
		[EAccountType.CONTENTSERVER] = 'C',
		[EAccountType.CLAN] = 'g',
		[EAccountType.CHAT] = 'T',
		[EAccountType.ANONUSER] = 'a',
	}

	local INVITE_DICT = {
		['0'] = 'b',
		['1'] = 'c',
		['2'] = 'd',
		['3'] = 'f',
		['4'] = 'g',
		['5'] = 'h',
		['6'] = 'j',
		['7'] = 'k',
		['8'] = 'm',
		['9'] = 'n',
		['a'] = 'p',
		['b'] = 'q',
		['c'] = 'r',
		['d'] = 't',
		['e'] = 'v',
		['f'] = 'w',
	}

	local FRIEND_CODE_BASE32_STR = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"

	local FRIEND_CODE_BASE32, FRIEND_CODE_BASE32_REVERSE = {}, {}
	for i=1, 32 do
		local c = FRIEND_CODE_BASE32_STR:sub(i, i)
		FRIEND_CODE_BASE32[i-1] = c
		FRIEND_CODE_BASE32_REVERSE[c] = i-1
	end
	local FRIEND_CODE_PATTERN_CHAR = "[" .. FRIEND_CODE_BASE32_STR .. "]"

	local TYPE_CHARS_REVERSE = {}
	for key, char in pairs(TYPE_CHARS) do
		TYPE_CHARS_REVERSE[char] = key
	end

	local INSTANCE_DESKTOP = 1

	local FLAG_CLAN = EChatSteamIDInstanceFlags.FlagClan
	local FLAG_LOBBY = EChatSteamIDInstanceFlags.FlagLobby

	local TYPE_INVALID, TYPE_INDIVIDUAL, TYPE_GAMESERVER, TYPE_ANONGAMESERVER, TYLE_MULTISEAT, TYPE_CLAN, TYPE_CHAT, TYPE_MAX = EAccountType.INVALID, EAccountType.INDIVIDUAL, EAccountType.GAMESERVER, EAccountType.ANONGAMESERVER, EAccountType.MULTISEAT, EAccountType.CLAN, EAccountType.CHAT, EAccountType.MAX

	-- patterns for parsing steamids
	local STEAMID64_PATTERN = "^765(" .. string.rep("%d", 14) .. ")$"
	local STEAMID2_PATTERN = "^STEAM_([012345]):([01]):(%d+)$"
	local STEAMID3_SHORT_PATTERN = "^%[(%a):([012345]):(%d+)%]$"
	local STEAMID3_LONG_PATTERN = "^%[(%a):([012345]):(%d+):(%d+)%]$"
	local FRIEND_CODE_PATTERN = "^(" .. string.rep(FRIEND_CODE_PATTERN_CHAR, 5) .. ")%-(" .. string.rep(FRIEND_CODE_PATTERN_CHAR, 4) .. ")$"

	local function steamid_render_steam64(self)
		return string_sub(tostring(self.steamid64), 1, -4)
	end

	local function steamid_render_steam2(self, newer_format)
		if self.type ~= TYPE_INDIVIDUAL then
			return error("Cannot render non-individual ID as Steam2")
		end

		local universe = self.universe
		if (newer_format or newer_format == nil) and universe == 1 then
			universe = 0
		end

		return string_format("STEAM_%d:%d:%d", universe, band(self.accountid, 1), math_floor(self.accountid / 2))
	end

	local function steamid_render_steam3(self)
		local type_char

		if band(self.instance, FLAG_CLAN) == FLAG_CLAN then
			type_char = "c"
		elseif band(self.instance, FLAG_LOBBY) == FLAG_LOBBY then
			type_char = "L"
		else
			type_char = TYPE_CHARS[self.type] or "i"
		end

		local render_instance = self.type == TYPE_ANONGAMESERVER or self.type == TYLE_MULTISEAT or (self.type == TYPE_INDIVIDUAL and self.instance ~= INSTANCE_DESKTOP)

		return string_format("[%s:%d:%d%s]", type_char, self.universe, self.accountid, render_instance and (":" .. self.instance) or "")
	end

	local function steamid_render_invite(self)
		if self.type ~= TYPE_INVALID and self.type ~= TYPE_INDIVIDUAL then
			return error("Cannot only render individual / invalid ID as Steam Invite")
		end

		local hex = string_gsub(string_format("%x", self.accountid), ".", function(chr)
			return INVITE_DICT[chr] or chr
		end)

		local len = string_len(hex)
		if len > 3 then
			local pos = math_floor(len / 2)

			return string_format("%s-%s", string_sub(hex, 1, pos), string_sub(hex, pos+1, -1))
		end

		return hex
	end

	-- full credits to:
	-- https://github.com/xPaw/SteamID.php/blob/a3493148bbf01de5246ca5107c29cd4347f1bc45/SteamID.php#L339-L406
	-- https://github.com/emily33901/go-csfriendcode/blob/master/friendcode.go

	local function steamid_render_friend_code(self)
		if self.type ~= TYPE_INVALID and self.type ~= TYPE_INDIVIDUAL then
			return error("Cannot only render individual / invalid ID as Friend Code")
		end

		-- if true then return "AAAAA-AAAA" end

		-- shift by string "CSGO" (0x4353474)
		local buf_uint64 = uint64_t_arr(1, bor(self.accountid, 0x4353474F00000000ULL))

		-- convert to little endian string
		local hash = ffi_string(cast("const char*", buf_uint64), 8)

		-- Hash the exported number
		hash = md5_sum(hash)

		-- Take the first 4 bytes and convert it back to a number
		ffi_copy(cast("void*", buf_uint64), hash, 4)

		local hash_uint = buf_uint64[0]
		local result = 0ULL

		-- blame valve
		for i=0, 7 do
			local id_nibble = tonumber(band(rshift(self.steamid64, i*4), 0xF))
			local hash_nibble = tonumber(band(rshift(hash_uint, i), 1))

			local a = bor(lshift(result, 4), id_nibble)

			result = bor(lshift(rshift(result, 28), 32), a)
			result = bor(lshift(rshift(result, 31), 32), bor(lshift(a, 1), hash_nibble))
		end

		-- swap endianness
		result = bswap(result)

		-- yes
		local code = ""
		for i=0, 8 do
			if i == 5 then
				code = code .. "-"
			end

			code = code .. FRIEND_CODE_BASE32[tonumber(band(rshift(result, 20+i*5), 31))]
		end

		return code
	end

	local function steamid_is_valid(self)
		if self.type <= TYPE_INVALID or self.type >= TYPE_MAX then
			return false
		end

		if self.universe <= 0 or self.universe > 4 then
			return false
		end

		if self.type == TYPE_INDIVIDUAL and (self.accountid == 0 or self.instance > 4) then
			return false
		end

		if self.type == TYPE_CLAN and (self.accountid == 0 or self.instance ~= 0) then
			return false
		end

		if self.type == TYPE_GAMESERVER and self.accountid == 0 then
			return false
		end

		return true
	end

	local function steamid_pack(self, big_endian)
		local res = ffi_string(cast("const char*", uint64_t_arr(1, self.steamid64)), 8)

		if big_endian then
			res = string_reverse(res)
		end

		return res
	end

	local function steamid_mt_eq(self, other)
		if not istype(SteamID, self) then
			-- make 1234 == steamid -> steamid == 1234
			self, other = other, self
		end

		local t = type(other)

		if t == "nil" then
			return false
		elseif t == "cdata" and istype(SteamID, other) then
			return self.steamid64 == other.steamid64
		elseif (t == "number" or t == "cdata") and (self.accountid == other or self.steamid64 == other) then
			return true
		end

		return self.steamid64 == to_steamid(other).steamid64
	end

	pcall(ffi.metatype, SteamID, {
		__index = {
			is_valid = steamid_is_valid,
			render_steam2 = steamid_render_steam2,
			render_steam3 = steamid_render_steam3,
			render_steam64 = steamid_render_steam64,
			render_steam_invite = steamid_render_invite,
			render_friend_code = steamid_render_friend_code,
			pack = steamid_pack
		},
		__tostring = steamid_render_steam64,
		__eq = steamid_mt_eq
	})

	function to_steamid(steamid)
		if istype(SteamID, steamid) then
			return steamid
		elseif istype(uint64_t, steamid) and steamid > BASE_STEAMID64 then
			return SteamID(steamid)
		end

		local t = type(steamid)
		if t == "string" then
			local id64_part = string_match(steamid, STEAMID64_PATTERN)
			if id64_part ~= nil then
				return SteamID(76500000000000000ULL + tonumber(id64_part))
			end

			local id2_universe, id2_odd, id2_accountid = string_match(steamid, STEAMID2_PATTERN)
			if id2_universe ~= nil then
				local ret = SteamID()

				ret.universe = id2_universe == "0" and 1 or tonumber(id2_universe)
				ret.type = TYPE_INDIVIDUAL
				ret.instance = INSTANCE_DESKTOP
				ret.accountid = tonumber(id2_accountid) * 2 + id2_odd

				return ret
			end

			local id3_typechar, id3_universe, id3_accountid, id3_instance = string_match(steamid, STEAMID3_SHORT_PATTERN)
			if id3_typechar ~= nil then
				if id3_typechar == "U" then
					id3_instance = INSTANCE_DESKTOP
				else
					id3_instance = 0
				end
			else
				id3_typechar, id3_universe, id3_accountid, id3_instance = string_match(steamid, STEAMID3_LONG_PATTERN)
			end

			if id3_typechar ~= nil then
				local ret = SteamID()

				ret.universe = tonumber(id3_universe)
				ret.instance = tonumber(id3_instance)
				ret.accountid = tonumber(id3_accountid)

				if id3_typechar == "c" then
					ret.instance = bor(ret.instance, FLAG_CLAN)
					ret.type = TYPE_CHAT
				elseif id3_typechar == "L" then
					ret.instance = bor(ret.instance, FLAG_LOBBY)
					ret.type = TYPE_CHAT
				else
					ret.type = TYPE_CHARS_REVERSE[id3_typechar] or 0
				end

				return ret
			end

			local fc_part1, fc_part2 = string_match(steamid, FRIEND_CODE_PATTERN)
			if fc_part1 ~= nil then
				local full_code = "AAAA" .. fc_part1 .. fc_part2

				local result = 0ULL
				local i = 0
				for char in string_gmatch(full_code, ".") do
					local val = cast(uint64_t, FRIEND_CODE_BASE32_REVERSE[char])

					result = bor(result, lshift(val, i*5))

					i = i + 1
				end

				result = bswap(result)

				local ret = SteamID()

				for _=0, 7 do
					result = rshift(result, 1)

					local id_nibble = band(result, 0xF)

					result = rshift(result, 4)

					ret.accountid = bor(lshift(ret.accountid, 4), id_nibble)
				end

				ret.type = TYPE_INDIVIDUAL
				ret.universe = 1
				ret.instance = 1

				return ret
			end
		elseif t == "number" and steamid > 0 then
			return SteamID(BASE_STEAMID64 + steamid)
		end

		return nil
	end
end

--
-- struct definitions
--

safe_cdef("SteamIPAddress_t", [[
	typedef struct {
		uint8_t m_rgubIPv6[16];
		int m_eType;
	} SteamIPAddress_t;
]])

safe_cdef("FriendGameInfo_t", [[
	typedef struct {
		uint64_t m_gameID;
		uint32_t m_unGameIP;
		uint16_t m_usGamePort;
		uint16_t m_usQueryPort;
		SteamID m_steamIDLobby;
	} FriendGameInfo_t;
]])

safe_cdef("MatchMakingKeyValuePair_t", [[
	typedef struct {
		char m_szKey[256];
		char m_szValue[256];
	} MatchMakingKeyValuePair_t;
]])

safe_cdef("servernetadr_t", [[
	typedef struct {
		uint16_t m_usConnectionPort;
		uint16_t m_usQueryPort;
		uint32_t m_unIP;
	} servernetadr_t;
]])

safe_cdef("gameserveritem_t", [[
	typedef struct {
		servernetadr_t m_NetAdr;
		int m_nPing;
		bool m_bHadSuccessfulResponse;
		bool m_bDoNotRefresh;
		char m_szGameDir[32];
		char m_szMap[32];
		char m_szGameDescription[64];
		uint32_t m_nAppID;
		int m_nPlayers;
		int m_nMaxPlayers;
		int m_nBotPlayers;
		bool m_bPassword;
		bool m_bSecure;
		uint32_t m_ulTimeLastPlayed;
		int m_nServerVersion;
		char m_szServerName[64];
		char m_szGameTags[128];
		SteamID m_steamID;
	} gameserveritem_t;
]])

safe_cdef("SteamPartyBeaconLocation_t", [[
	typedef struct {
		int m_eType;
		uint64_t m_ulLocationID;
	} SteamPartyBeaconLocation_t;
]])

safe_cdef("SteamParamStringArray_t", [[
	typedef struct {
		const char ** m_ppStrings;
		int32_t m_nNumStrings;
	} SteamParamStringArray_t;
]])

safe_cdef("LeaderboardEntry_t", [[
	typedef struct {
		SteamID m_steamIDUser;
		int32_t m_nGlobalRank;
		int32_t m_nScore;
		int32_t m_cDetails;
		uint64_t m_hUGC;
	} LeaderboardEntry_t;
]])

safe_cdef("P2PSessionState_t", [[
	typedef struct {
		uint8_t m_bConnectionActive;
		uint8_t m_bConnecting;
		uint8_t m_eP2PSessionError;
		uint8_t m_bUsingRelay;
		int32_t m_nBytesQueuedForSend;
		int32_t m_nPacketsQueuedForSend;
		uint32_t m_nRemoteIP;
		uint16_t m_nRemotePort;
	} P2PSessionState_t;
]])

safe_cdef("InputAnalogActionData_t", [[
	typedef struct {
		int eMode;
		float x;
		float y;
		bool bActive;
	} InputAnalogActionData_t;
]])

safe_cdef("InputDigitalActionData_t", [[
	typedef struct {
		bool bState;
		bool bActive;
	} InputDigitalActionData_t;
]])

safe_cdef("InputMotionData_t", [[
	typedef struct {
		float rotQuatX;
		float rotQuatY;
		float rotQuatZ;
		float rotQuatW;
		float posAccelX;
		float posAccelY;
		float posAccelZ;
		float rotVelX;
		float rotVelY;
		float rotVelZ;
	} InputMotionData_t;
]])

safe_cdef("SteamUGCDetails_t", [[
	typedef struct {
		uint64_t m_nPublishedFileId;
		int m_eResult;
		int m_eFileType;
		unsigned int m_nCreatorAppID;
		unsigned int m_nConsumerAppID;
		char m_rgchTitle[129];
		char m_rgchDescription[8000];
		uint64_t m_ulSteamIDOwner;
		uint32_t m_rtimeCreated;
		uint32_t m_rtimeUpdated;
		uint32_t m_rtimeAddedToUserList;
		int m_eVisibility;
		bool m_bBanned;
		bool m_bAcceptedForUse;
		bool m_bTagsTruncated;
		char m_rgchTags[1025];
		uint64_t m_hFile;
		uint64_t m_hPreviewFile;
		char m_pchFileName[260];
		int32_t m_nFileSize;
		int32_t m_nPreviewFileSize;
		char m_rgchURL[256];
		uint32_t m_unVotesUp;
		uint32_t m_unVotesDown;
		float m_flScore;
		uint32_t m_unNumChildren;
	} SteamUGCDetails_t;
]])

safe_cdef("SteamItemDetails_t", [[
	typedef struct {
		uint64_t m_itemId;
		int m_iDefinition;
		uint16_t m_unQuantity;
		uint16_t m_unFlags;
	} SteamItemDetails_t;
]])

safe_cdef("SteamNetworkingIPAddr", [[
	typedef struct {
		uint8_t m_ipv6[16];
		uint16_t m_port;
	} SteamNetworkingIPAddr;
]])

safe_cdef("SteamNetworkingIdentity", [[
	typedef struct {
		int m_eType;
		int m_cbSize;
		char m_szUnknownRawString[128];
	} SteamNetworkingIdentity;
]])

safe_cdef("SteamNetConnectionInfo_t", [[
	typedef struct {
		SteamNetworkingIdentity m_identityRemote;
		int64_t m_nUserData;
		unsigned int m_hListenSocket;
		SteamNetworkingIPAddr m_addrRemote;
		uint16_t m__pad1;
		unsigned int m_idPOPRemote;
		unsigned int m_idPOPRelay;
		int m_eState;
		int m_eEndReason;
		char m_szEndDebug[128];
		char m_szConnectionDescription[128];
		int m_eTransportKind;
		uint32_t reserved[63];
	} SteamNetConnectionInfo_t;
]])

safe_cdef("SteamNetworkingQuickConnectionStatus", [[
	typedef struct {
		int m_eState;
		int m_nPing;
		float m_flConnectionQualityLocal;
		float m_flConnectionQualityRemote;
		float m_flOutPacketsPerSec;
		float m_flOutBytesPerSec;
		float m_flInPacketsPerSec;
		float m_flInBytesPerSec;
		int m_nSendRateBytesPerSecond;
		int m_cbPendingUnreliable;
		int m_cbPendingReliable;
		int m_cbSentUnackedReliable;
		long long m_usecQueueTime;
		uint32_t reserved[16];
	} SteamNetworkingQuickConnectionStatus;
]])

safe_cdef("SteamNetworkingMessage_t", [[
	typedef struct _SteamNetworkingMessage_t {
		void * m_pData;
		int m_cbSize;
		unsigned int m_conn;
		SteamNetworkingIdentity m_identityPeer;
		int64_t m_nConnUserData;
		long long m_usecTimeReceived;
		int64_t m_nMessageNumber;
		void (__thiscall * m_pfnFreeData)(struct _SteamNetworkingMessage_t *);
		void (__thiscall * m_pfnRelease)(struct _SteamNetworkingMessage_t *);
		int m_nChannel;
		int m_nFlags;
		int64_t m_nUserData;
	} SteamNetworkingMessage_t;
]])

safe_cdef("SteamNetworkPingLocation_t", [[
	typedef struct {
		uint8_t m_data[512];
	} SteamNetworkPingLocation_t;
]])

safe_cdef("SteamNetworkingConfigValue_t", [[
	typedef struct {
		int m_eValue;
		int m_eDataType;
		int64_t m_int64;
	} SteamNetworkingConfigValue_t;
]])

safe_cdef("SteamNetworkingPOPIDRender", [[
	typedef struct {
		char buf[8];
	} SteamNetworkingPOPIDRender;
]])

safe_cdef("SteamNetworkingIdentityRender", [[
	typedef struct {
		char buf[128];
	} SteamNetworkingIdentityRender;
]])

safe_cdef("SteamNetworkingIPAddrRender", [[
	typedef struct {
		char buf[48];
	} SteamNetworkingIPAddrRender;
]])

safe_cdef("SteamDatagramHostedAddress", [[
	typedef struct {
		int m_cbSize;
		char m_data[128];
	} SteamDatagramHostedAddress;
]])

safe_cdef("SteamDatagramGameCoordinatorServerLogin", [[
	typedef struct {
		SteamNetworkingIdentity m_identity;
		SteamDatagramHostedAddress m_routing;
		unsigned int m_nAppID;
		unsigned int m_rtime;
		int m_cbAppData;
		char m_appData[2048];
	} SteamDatagramGameCoordinatorServerLogin;
]])

safe_cdef("SteamNetAuthenticationStatus_t", [[
	typedef struct {
		int m_eAvail;
		char m_debugMsg[256];
	} SteamNetAuthenticationStatus_t;
]])

safe_cdef("SteamRelayNetworkStatus_t", [[
	typedef struct {
		int m_eAvail;
		int m_bPingMeasurementInProgress;
		int m_eAvailNetworkConfig;
		int m_eAvailAnyRelay;
		char m_debugMsg[256];
	} SteamRelayNetworkStatus_t;
]])

safe_cdef("SteamNetConnectionStatusChangedCallback_t", [[
	typedef struct {
		unsigned int m_hConn;
		SteamNetConnectionInfo_t m_info;
		int m_eOldState;
	} SteamNetConnectionStatusChangedCallback_t;
]])

safe_cdef("SteamNetworkingMessagesSessionRequest_t", [[
	typedef struct {
		SteamNetworkingIdentity m_identityRemote;
	} SteamNetworkingMessagesSessionRequest_t;
]])

safe_cdef("SteamNetworkingMessagesSessionFailed_t", [[
	typedef struct {
		SteamNetConnectionInfo_t m_info;
	} SteamNetworkingMessagesSessionFailed_t;
]])


--
-- some fixes
--

safe_cdef("SteamDatagramRelayAuthTicket", [[
	typedef struct {
		SteamNetworkingIdentity m_identityGameserver;
		SteamNetworkingIdentity m_identityAuthorizedClient;
		uint32_t m_unPublicIP;
		uint32_t m_rtimeTicketExpiry;
		SteamDatagramHostedAddress m_routing;
		uint32_t m_nAppID;
		int m_nRestrictToVirtualPort;
		int m_nExtraFields;

		struct {
			enum EType
			{
				k_EType_String,
				k_EType_Int,
				k_EType_Fixed64,
			};
			int m_eType;
			char m_szName[28];

			union {
				char m_szStringValue[128];
				int64_t m_nIntValue;
				uint64_t m_nFixed64Value;
			};
		} m_vecExtraFields[ 16 ];

	} SteamDatagramRelayAuthTicket;
]])

--
-- structs
--

local structs = {
	SteamIPAddress_t = typeof("SteamIPAddress_t"),
	SteamIPAddress_t_arr = typeof("SteamIPAddress_t [?]"),
	FriendGameInfo_t = typeof("FriendGameInfo_t"),
	FriendGameInfo_t_arr = typeof("FriendGameInfo_t [?]"),
	MatchMakingKeyValuePair_t = typeof("MatchMakingKeyValuePair_t"),
	MatchMakingKeyValuePair_t_arr = typeof("MatchMakingKeyValuePair_t [?]"),
	servernetadr_t = typeof("servernetadr_t"),
	servernetadr_t_arr = typeof("servernetadr_t [?]"),
	gameserveritem_t = typeof("gameserveritem_t"),
	gameserveritem_t_arr = typeof("gameserveritem_t [?]"),
	SteamPartyBeaconLocation_t = typeof("SteamPartyBeaconLocation_t"),
	SteamPartyBeaconLocation_t_arr = typeof("SteamPartyBeaconLocation_t [?]"),
	SteamParamStringArray_t = typeof("SteamParamStringArray_t"),
	SteamParamStringArray_t_arr = typeof("SteamParamStringArray_t [?]"),
	LeaderboardEntry_t = typeof("LeaderboardEntry_t"),
	LeaderboardEntry_t_arr = typeof("LeaderboardEntry_t [?]"),
	P2PSessionState_t = typeof("P2PSessionState_t"),
	P2PSessionState_t_arr = typeof("P2PSessionState_t [?]"),
	InputAnalogActionData_t = typeof("InputAnalogActionData_t"),
	InputAnalogActionData_t_arr = typeof("InputAnalogActionData_t [?]"),
	InputDigitalActionData_t = typeof("InputDigitalActionData_t"),
	InputDigitalActionData_t_arr = typeof("InputDigitalActionData_t [?]"),
	InputMotionData_t = typeof("InputMotionData_t"),
	InputMotionData_t_arr = typeof("InputMotionData_t [?]"),
	SteamUGCDetails_t = typeof("SteamUGCDetails_t"),
	SteamUGCDetails_t_arr = typeof("SteamUGCDetails_t [?]"),
	SteamItemDetails_t = typeof("SteamItemDetails_t"),
	SteamItemDetails_t_arr = typeof("SteamItemDetails_t [?]"),
	SteamNetworkingIPAddr = typeof("SteamNetworkingIPAddr"),
	SteamNetworkingIPAddr_arr = typeof("SteamNetworkingIPAddr [?]"),
	SteamNetworkingIdentity = typeof("SteamNetworkingIdentity"),
	SteamNetworkingIdentity_arr = typeof("SteamNetworkingIdentity [?]"),
	SteamNetConnectionInfo_t = typeof("SteamNetConnectionInfo_t"),
	SteamNetConnectionInfo_t_arr = typeof("SteamNetConnectionInfo_t [?]"),
	SteamNetworkingQuickConnectionStatus = typeof("SteamNetworkingQuickConnectionStatus"),
	SteamNetworkingQuickConnectionStatus_arr = typeof("SteamNetworkingQuickConnectionStatus [?]"),
	SteamNetworkingMessage_t = typeof("SteamNetworkingMessage_t"),
	SteamNetworkingMessage_t_arr = typeof("SteamNetworkingMessage_t [?]"),
	SteamNetworkPingLocation_t = typeof("SteamNetworkPingLocation_t"),
	SteamNetworkPingLocation_t_arr = typeof("SteamNetworkPingLocation_t [?]"),
	SteamNetworkingConfigValue_t = typeof("SteamNetworkingConfigValue_t"),
	SteamNetworkingConfigValue_t_arr = typeof("SteamNetworkingConfigValue_t [?]"),
	SteamNetworkingPOPIDRender = typeof("SteamNetworkingPOPIDRender"),
	SteamNetworkingPOPIDRender_arr = typeof("SteamNetworkingPOPIDRender [?]"),
	SteamNetworkingIdentityRender = typeof("SteamNetworkingIdentityRender"),
	SteamNetworkingIdentityRender_arr = typeof("SteamNetworkingIdentityRender [?]"),
	SteamNetworkingIPAddrRender = typeof("SteamNetworkingIPAddrRender"),
	SteamNetworkingIPAddrRender_arr = typeof("SteamNetworkingIPAddrRender [?]"),
	SteamDatagramHostedAddress = typeof("SteamDatagramHostedAddress"),
	SteamDatagramHostedAddress_arr = typeof("SteamDatagramHostedAddress [?]"),
	SteamDatagramGameCoordinatorServerLogin = typeof("SteamDatagramGameCoordinatorServerLogin"),
	SteamDatagramGameCoordinatorServerLogin_arr = typeof("SteamDatagramGameCoordinatorServerLogin [?]"),
	SteamNetAuthenticationStatus_t = typeof("SteamNetAuthenticationStatus_t"),
	SteamNetAuthenticationStatus_t_arr = typeof("SteamNetAuthenticationStatus_t [?]"),
	SteamRelayNetworkStatus_t = typeof("SteamRelayNetworkStatus_t"),
	SteamRelayNetworkStatus_t_arr = typeof("SteamRelayNetworkStatus_t [?]"),
	SteamNetConnectionStatusChangedCallback_t = typeof("SteamNetConnectionStatusChangedCallback_t"),
	SteamNetConnectionStatusChangedCallback_t_arr = typeof("SteamNetConnectionStatusChangedCallback_t [?]"),
	SteamNetworkingMessagesSessionRequest_t = typeof("SteamNetworkingMessagesSessionRequest_t"),
	SteamNetworkingMessagesSessionRequest_t_arr = typeof("SteamNetworkingMessagesSessionRequest_t [?]"),
	SteamNetworkingMessagesSessionFailed_t = typeof("SteamNetworkingMessagesSessionFailed_t"),
	SteamNetworkingMessagesSessionFailed_t_arr = typeof("SteamNetworkingMessagesSessionFailed_t [?]"),
}

for name, struct in pairs(structs) do
	M[name] = struct
end

--
-- steam client context
--

local client_context_interfaces = {
	"ISteamUser021",
	"ISteamFriends017",
	"ISteamUtils010",
	"ISteamMatchmaking009",
	"ISteamGameSearch001",
	"ISteamUserStats012",
	"ISteamApps008",
	"ISteamMatchmakingServers002",
	"ISteamNetworking006",
	"ISteamRemoteStorage014",
	"ISteamScreenshots003",
	"ISteamHTTP003",
	"ISteamController007",
	"ISteamUGC014",
	"ISteamAppList001",
	"ISteamMusic001",
	"ISteamMusicRemote001",
	"ISteamHTMLSurface005",
	"ISteamInventory003",
	"ISteamVideo002",
	"ISteamParentalSettings001",
	"ISteamInput001"
}

local client_context_raw = cast("uintptr_t**", find_sig(
	"client_panorama.dll",
	"\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x0F\x84",
	"uintptr_t",
	1, 1
))

local client_context = {}
for i, interface in ipairs(client_context_interfaces) do
	client_context[interface] = client_context_raw[i-1][0]
	client_context[interface:gsub("%d+$", "")] = client_context_raw[i-1][0]
end

--
-- get dll exports
--

local pGetModuleHandle_sig = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC\xCC\x85\xC0\x74\x0B") or error("Couldn't find signature #1")
local pGetProcAddress_sig = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC\xCC\xA3\xCC\xCC\xCC\xCC\xEB\x05") or error("Couldn't find signature #2")

local jmp_ecx = client.find_signature("engine.dll", "\xFF\xE1")

local pGetProcAddress = cast("uint32_t**", cast("uint32_t", pGetProcAddress_sig) + 2)[0][0]
local fnGetProcAddress = cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", jmp_ecx)

local pGetModuleHandle = cast("uint32_t**", cast("uint32_t", pGetModuleHandle_sig) + 2)[0][0]
local fnGetModuleHandle = cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", jmp_ecx)

local function proc_bind(module_name, function_name, typedef)
	local ctype = typeof(typedef)
	local module_handle = fnGetModuleHandle(pGetModuleHandle, 0, module_name)
	local proc_address = fnGetProcAddress(pGetProcAddress, 0, module_handle, function_name)
	local call_fn = cast(ctype, jmp_ecx)

	return function(...)
		return call_fn(proc_address, 0, ...)
	end
end

--
-- steamworks.await support
--

local AWAIT_DEFAULT_DELAY = 10
local await_mt = {}
await_mt.__call = function(_, delay, fallback)
	if type(delay) == "function" then
		delay, fallback = fallback, delay
	end

	return setmetatable({tonumber(delay) or AWAIT_DEFAULT_DELAY, fallback}, await_mt)
end
M.await = await_mt.__call()

local function is_valid_callback(callback)
	local t = type(callback)

	return t == "function" or (t == "table" and getmetatable(callback) == await_mt)
end

--
-- steam callbacks / callresults
--

local callback_info = {
	[101]={},
	[102]={fields={"m_eResult","m_bStillRetrying"},fields_alt={"result","still_retrying"},types={"int","bool"}},
	[103]={fields={"m_eResult"},fields_alt={"result"},types={"int"}},
	[113]={fields={"m_uAppID","m_unGameServerIP","m_usGameServerPort","m_bSecure","m_uReason"},fields_alt={"appid","game_server_ip","game_server_port","secure","reason"},types={"uint32_t","uint32_t","uint16_t","uint16_t","uint32_t"}},
	[115]={fields={"m_bSecure"},fields_alt={"secure"},types={"bool"}},
	[117]={fields={"m_eFailureType"},fields_alt={"failure_type"},types={"uint8_t"}},
	[125]={},
	[143]={fields={"m_SteamID","m_eAuthSessionResponse","m_OwnerSteamID"},fields_alt={"steamid","auth_session_response","owner_steamid"},types={"SteamID","int","SteamID"}},
	[152]={fields={"m_unAppID","m_ulOrderID","m_bAuthorized"},fields_alt={"appid","order_id","authorized"},types={"uint32_t","uint64_t","bool"}},
	[163]={fields={"m_hAuthTicket","m_eResult"},fields_alt={"auth_ticket","result"},types={"unsigned int","int"}},
	[164]={fields={"m_szURL"},fields_alt={"url"},types={"char [256]"}},
	[201]={fields={"m_SteamID","m_OwnerSteamID"},fields_alt={"steamid","owner_steamid"},types={"SteamID","SteamID"}},
	[202]={fields={"m_SteamID","m_eDenyReason","m_rgchOptionalText"},fields_alt={"steamid","deny_reason","optional_text"},types={"SteamID","int","char [128]"}},
	[203]={fields={"m_SteamID","m_eDenyReason"},fields_alt={"steamid","deny_reason"},types={"SteamID","int"}},
	[206]={fields={"m_SteamID","m_pchAchievement","m_bUnlocked"},fields_alt={"steamid","achievement","unlocked"},types={"SteamID","char [128]","bool"}},
	[207]={fields={"m_eResult","m_nRank","m_unTotalConnects","m_unTotalMinutesPlayed"},fields_alt={"result","rank","total_connects","total_minutes_played"},types={"int","int32_t","uint32_t","uint32_t"}},
	[208]={fields={"m_SteamIDUser","m_SteamIDGroup","m_bMember","m_bOfficer"},fields_alt={"steamid_user","steamid_group","member","officer"},types={"SteamID","SteamID","bool","bool"}},
	[304]={fields={"m_ulSteamID","m_nChangeFlags"},fields_alt={"steamid","change_flags"},types={"SteamID","int"}},
	[331]={fields={"m_bActive"},fields_alt={"active"},types={"bool"}},
	[332]={fields={"m_rgchServer","m_rgchPassword"},fields_alt={"server","password"},types={"char [64]","char [64]"}},
	[333]={fields={"m_steamIDLobby","m_steamIDFriend"},fields_alt={"steamid_lobby","steamid_friend"},types={"SteamID","SteamID"}},
	[334]={fields={"m_steamID","m_iImage","m_iWide","m_iTall"},fields_alt={"steamid","image","wide","tall"},types={"SteamID","int","int","int"}},
	[336]={fields={"m_steamIDFriend","m_nAppID"},fields_alt={"steamid_friend","appid"},types={"SteamID","unsigned int"}},
	[337]={fields={"m_steamIDFriend","m_rgchConnect"},fields_alt={"steamid_friend","connect"},types={"SteamID","char [256]"}},
	[338]={fields={"m_steamIDClanChat","m_steamIDUser","m_iMessageID"},fields_alt={"steamid_clan_chat","steamid_user","message_id"},types={"SteamID","SteamID","int"}},
	[339]={fields={"m_steamIDClanChat","m_steamIDUser"},fields_alt={"steamid_clan_chat","steamid_user"},types={"SteamID","SteamID"}},
	[340]={fields={"m_steamIDClanChat","m_steamIDUser","m_bKicked","m_bDropped"},fields_alt={"steamid_clan_chat","steamid_user","kicked","dropped"},types={"SteamID","SteamID","bool","bool"}},
	[343]={fields={"m_steamIDUser","m_iMessageID"},fields_alt={"steamid_user","message_id"},types={"SteamID","int"}},
	[348]={},
	[349]={fields={"rgchURI"},fields_alt={"uri"},types={"char [1024]"}},
	[502]={fields={"m_nIP","m_nQueryPort","m_nConnPort","m_nAppID","m_nFlags","m_bAdd","m_unAccountId"},fields_alt={"ip","query_port","conn_port","appid","flags","add","account_id"},types={"uint32_t","uint32_t","uint32_t","uint32_t","uint32_t","bool","unsigned int"}},
	[503]={fields={"m_ulSteamIDUser","m_ulSteamIDLobby","m_ulGameID"},fields_alt={"steamid_user","steamid_lobby","game_id"},types={"SteamID","SteamID","uint64_t"}},
	[505]={fields={"m_ulSteamIDLobby","m_ulSteamIDMember","m_bSuccess"},fields_alt={"steamid_lobby","steamid_member","success"},types={"SteamID","SteamID","bool"}},
	[506]={fields={"m_ulSteamIDLobby","m_ulSteamIDUserChanged","m_ulSteamIDMakingChange","m_rgfChatMemberStateChange"},fields_alt={"steamid_lobby","steamid_user_changed","steamid_making_change","chat_member_state_change"},types={"SteamID","SteamID","SteamID","uint32_t"}},
	[507]={fields={"m_ulSteamIDLobby","m_ulSteamIDUser","m_eChatEntryType","m_iChatID"},fields_alt={"steamid_lobby","steamid_user","chat_entry_type","chat_id"},types={"SteamID","SteamID","uint8_t","uint32_t"}},
	[509]={fields={"m_ulSteamIDLobby","m_ulSteamIDGameServer","m_unIP","m_usPort"},fields_alt={"steamid_lobby","steamid_game_server","ip","port"},types={"SteamID","SteamID","uint32_t","uint16_t"}},
	[512]={fields={"m_ulSteamIDLobby","m_ulSteamIDAdmin","m_bKickedDueToDisconnect"},fields_alt={"steamid_lobby","steamid_admin","kicked_due_to_disconnect"},types={"SteamID","SteamID","bool"}},
	[515]={fields={"m_bGameBootInviteExists","m_steamIDLobby"},fields_alt={"game_boot_invite_exists","steamid_lobby"},types={"bool","SteamID"}},
	[516]={fields={"m_eResult"},fields_alt={"result"},types={"int"}},
	[701]={},
	[702]={fields={"m_nMinutesBatteryLeft"},fields_alt={"minutes_battery_left"},types={"uint8_t"}},
	[703]={fields={"m_hAsyncCall","m_iCallback","m_cubParam"},fields_alt={"async_call","callback","param"},types={"uint64_t","int","uint32_t"}},
	[704]={},
	[714]={fields={"m_bSubmitted","m_unSubmittedText"},fields_alt={"submitted","submitted_text"},types={"bool","uint32_t"}},
	[1005]={fields={"m_nAppID"},fields_alt={"appid"},types={"unsigned int"}},
	[1008]={fields={"m_eResult","m_unPackageRegistered"},fields_alt={"result","package_registered"},types={"int","uint32_t"}},
	[1014]={},
	[1021]={fields={"m_eResult","m_nAppID","m_cchKeyLength","m_rgchKey"},fields_alt={"result","appid","key_length","key"},types={"int","uint32_t","uint32_t","char [240]"}},
	[1030]={fields={"m_unAppID","m_bIsOffline","m_unSecondsAllowed","m_unSecondsPlayed"},fields_alt={"appid","is_offline","seconds_allowed","seconds_played"},types={"unsigned int","bool","uint32_t","uint32_t"}},
	[1101]={fields={"m_nGameID","m_eResult","m_steamIDUser"},fields_alt={"game_id","result","steamid_user"},types={"uint64_t","int","SteamID"}},
	[1102]={fields={"m_nGameID","m_eResult"},fields_alt={"game_id","result"},types={"uint64_t","int"}},
	[1103]={fields={"m_nGameID","m_bGroupAchievement","m_rgchAchievementName","m_nCurProgress","m_nMaxProgress"},fields_alt={"game_id","group_achievement","achievement_name","cur_progress","max_progress"},types={"uint64_t","bool","char [128]","uint32_t","uint32_t"}},
	[1108]={fields={"m_steamIDUser"},fields_alt={"steamid_user"},types={"SteamID"}},
	[1109]={fields={"m_nGameID","m_rgchAchievementName","m_bAchieved","m_nIconHandle"},fields_alt={"game_id","achievement_name","achieved","icon_handle"},types={"uint64_t","char [128]","bool","int"}},
	[1112]={fields={"m_nGameID","m_eResult","m_ulRequiredDiskSpace"},fields_alt={"game_id","result","required_disk_space"},types={"uint64_t","int","uint64_t"}},
	[1201]={fields={"m_hSocket","m_hListenSocket","m_steamIDRemote","m_eSNetSocketState"},fields_alt={"socket","listen_socket","steamid_remote","snet_socket_state"},types={"unsigned int","unsigned int","SteamID","int"}},
	[1202]={fields={"m_steamIDRemote"},fields_alt={"steamid_remote"},types={"SteamID"}},
	[1203]={fields={"m_steamIDRemote","m_eP2PSessionError"},fields_alt={"steamid_remote","p2p_session_error"},types={"SteamID","uint8_t"}},
	[1221]={fields={"m_hConn","m_info","m_eOldState"},fields_alt={"conn","info","old_state"},types={"unsigned int","SteamNetConnectionInfo_t","int"}},
	[1222]={fields={"m_eAvail","m_debugMsg"},fields_alt={"avail","debug_msg"},types={"int","char [256]"}},
	[1251]={fields={"m_identityRemote"},fields_alt={"identity_remote"},types={"SteamNetworkingIdentity"}},
	[1252]={fields={"m_info"},fields_alt={"info"},types={"SteamNetConnectionInfo_t"}},
	[1281]={fields={"m_eAvail","m_bPingMeasurementInProgress","m_eAvailNetworkConfig","m_eAvailAnyRelay","m_debugMsg"},fields_alt={"avail","ping_measurement_in_progress","avail_network_config","avail_any_relay","debug_msg"},types={"int","int","int","int","char [256]"}},
	[1301]={fields={"m_nAppID","m_eResult","m_unNumDownloads"},fields_alt={"appid","result","num_downloads"},types={"unsigned int","int","int"}},
	[1302]={fields={"m_nAppID","m_eResult","m_unNumUploads"},fields_alt={"appid","result","num_uploads"},types={"unsigned int","int","int"}},
	[1303]={fields={"m_rgchCurrentFile","m_nAppID","m_uBytesTransferredThisChunk","m_dAppPercentComplete","m_bUploading"},fields_alt={"current_file","appid","bytes_transferred_this_chunk","app_percent_complete","uploading"},types={"char [260]","unsigned int","uint32_t","double","bool"}},
	[1305]={fields={"m_nAppID","m_eResult"},fields_alt={"appid","result"},types={"unsigned int","int"}},
	[1309]={fields={"m_eResult","m_nPublishedFileId","m_bUserNeedsToAcceptWorkshopLegalAgreement"},fields_alt={"result","published_file_id","user_needs_to_accept_workshop_legal_agreement"},types={"int","uint64_t","bool"}},
	[1321]={fields={"m_nPublishedFileId","m_nAppID"},fields_alt={"published_file_id","appid"},types={"uint64_t","unsigned int"}},
	[1322]={fields={"m_nPublishedFileId","m_nAppID"},fields_alt={"published_file_id","appid"},types={"uint64_t","unsigned int"}},
	[1323]={fields={"m_nPublishedFileId","m_nAppID"},fields_alt={"published_file_id","appid"},types={"uint64_t","unsigned int"}},
	[1325]={fields={"m_eResult","m_nPublishedFileId","m_eVote"},fields_alt={"result","published_file_id","vote"},types={"int","uint64_t","int"}},
	[1326]={fields={"m_eResult","m_nResultsReturned","m_nTotalResultCount","m_rgPublishedFileId"},fields_alt={"result","results_returned","total_result_count","published_file_id"},types={"int","int32_t","int32_t","uint64_t [50]"}},
	[1330]={fields={"m_nPublishedFileId","m_nAppID","m_ulUnused"},fields_alt={"published_file_id","appid","unused"},types={"uint64_t","unsigned int","uint64_t"}},
	[2101]={fields={"m_hRequest","m_ulContextValue","m_bRequestSuccessful","m_eStatusCode","m_unBodySize"},fields_alt={"request","context_value","request_successful","status_code","body_size"},types={"unsigned int","uint64_t","bool","int","uint32_t"}},
	[2102]={fields={"m_hRequest","m_ulContextValue"},fields_alt={"request","context_value"},types={"unsigned int","uint64_t"}},
	[2103]={fields={"m_hRequest","m_ulContextValue","m_cOffset","m_cBytesReceived"},fields_alt={"request","context_value","offset","bytes_received"},types={"unsigned int","uint64_t","uint32_t","uint32_t"}},
	[2301]={fields={"m_hLocal","m_eResult"},fields_alt={"local","result"},types={"unsigned int","int"}},
	[2302]={},
	[3405]={fields={"m_unAppID","m_nPublishedFileId"},fields_alt={"appid","published_file_id"},types={"unsigned int","uint64_t"}},
	[3406]={fields={"m_unAppID","m_nPublishedFileId","m_eResult"},fields_alt={"appid","published_file_id","result"},types={"unsigned int","uint64_t","int"}},
	[3901]={fields={"m_nAppID"},fields_alt={"appid"},types={"unsigned int"}},
	[3902]={fields={"m_nAppID"},fields_alt={"appid"},types={"unsigned int"}},
	[4001]={},
	[4002]={fields={"m_flNewVolume"},fields_alt={"new_volume"},types={"float"}},
	[4011]={fields={"m_flNewVolume"},fields_alt={"new_volume"},types={"float"}},
	[4012]={fields={"nID"},fields_alt={"id"},types={"int"}},
	[4013]={fields={"nID"},fields_alt={"id"},types={"int"}},
	[4101]={},
	[4102]={},
	[4103]={},
	[4104]={},
	[4105]={},
	[4106]={},
	[4107]={},
	[4108]={},
	[4109]={fields={"m_bShuffled"},fields_alt={"shuffled"},types={"bool"}},
	[4110]={fields={"m_bLooped"},fields_alt={"looped"},types={"bool"}},
	[4114]={fields={"m_nPlayingRepeatStatus"},fields_alt={"playing_repeat_status"},types={"int"}},
	[4502]={fields={"unBrowserHandle","pBGRA","unWide","unTall","unUpdateX","unUpdateY","unUpdateWide","unUpdateTall","unScrollX","unScrollY","flPageScale","unPageSerial"},fields_alt={"browser_handle","bgra","wide","tall","update_x","update_y","update_wide","update_tall","scroll_x","scroll_y","page_scale","page_serial"},types={"unsigned int","const char *","uint32_t","uint32_t","uint32_t","uint32_t","uint32_t","uint32_t","uint32_t","uint32_t","float","uint32_t"}},
	[4503]={fields={"unBrowserHandle","pchURL","pchTarget","pchPostData","bIsRedirect"},fields_alt={"browser_handle","url","target","post_data","is_redirect"},types={"unsigned int","const char *","const char *","const char *","bool"},string_fields={"pchURL","pchTarget","pchPostData"}},
	[4504]={fields={"unBrowserHandle"},fields_alt={"browser_handle"},types={"unsigned int"}},
	[4505]={fields={"unBrowserHandle","pchURL","pchPostData","bIsRedirect","pchPageTitle","bNewNavigation"},fields_alt={"browser_handle","url","post_data","is_redirect","page_title","new_navigation"},types={"unsigned int","const char *","const char *","bool","const char *","bool"},string_fields={"pchURL","pchPostData","pchPageTitle"}},
	[4506]={fields={"unBrowserHandle","pchURL","pchPageTitle"},fields_alt={"browser_handle","url","page_title"},types={"unsigned int","const char *","const char *"},string_fields={"pchURL","pchPageTitle"}},
	[4507]={fields={"unBrowserHandle","pchURL"},fields_alt={"browser_handle","url"},types={"unsigned int","const char *"},string_fields={"pchURL"}},
	[4508]={fields={"unBrowserHandle","pchTitle"},fields_alt={"browser_handle","title"},types={"unsigned int","const char *"},string_fields={"pchTitle"}},
	[4509]={fields={"unBrowserHandle","unResults","unCurrentMatch"},fields_alt={"browser_handle","results","current_match"},types={"unsigned int","uint32_t","uint32_t"}},
	[4510]={fields={"unBrowserHandle","bCanGoBack","bCanGoForward"},fields_alt={"browser_handle","can_go_back","can_go_forward"},types={"unsigned int","bool","bool"}},
	[4511]={fields={"unBrowserHandle","unScrollMax","unScrollCurrent","flPageScale","bVisible","unPageSize"},fields_alt={"browser_handle","scroll_max","scroll_current","page_scale","visible","page_size"},types={"unsigned int","uint32_t","uint32_t","float","bool","uint32_t"}},
	[4512]={fields={"unBrowserHandle","unScrollMax","unScrollCurrent","flPageScale","bVisible","unPageSize"},fields_alt={"browser_handle","scroll_max","scroll_current","page_scale","visible","page_size"},types={"unsigned int","uint32_t","uint32_t","float","bool","uint32_t"}},
	[4513]={fields={"unBrowserHandle","x","y","pchURL","bInput","bLiveLink"},fields_alt={"browser_handle","x","y","url","input","live_link"},types={"unsigned int","uint32_t","uint32_t","const char *","bool","bool"},string_fields={"pchURL"}},
	[4514]={fields={"unBrowserHandle","pchMessage"},fields_alt={"browser_handle","message"},types={"unsigned int","const char *"},string_fields={"pchMessage"}},
	[4515]={fields={"unBrowserHandle","pchMessage"},fields_alt={"browser_handle","message"},types={"unsigned int","const char *"},string_fields={"pchMessage"}},
	[4516]={fields={"unBrowserHandle","pchTitle","pchInitialFile"},fields_alt={"browser_handle","title","initial_file"},types={"unsigned int","const char *","const char *"},string_fields={"pchTitle","pchInitialFile"}},
	[4521]={fields={"unBrowserHandle","pchURL","unX","unY","unWide","unTall","unNewWindow_BrowserHandle_IGNORE"},fields_alt={"browser_handle","url","x","y","wide","tall","new_window_browser_handle"},types={"unsigned int","const char *","uint32_t","uint32_t","uint32_t","uint32_t","unsigned int"},string_fields={"pchURL"}},
	[4522]={fields={"unBrowserHandle","eMouseCursor"},fields_alt={"browser_handle","mouse_cursor"},types={"unsigned int","uint32_t"}},
	[4523]={fields={"unBrowserHandle","pchMsg"},fields_alt={"browser_handle","msg"},types={"unsigned int","const char *"},string_fields={"pchMsg"}},
	[4524]={fields={"unBrowserHandle","pchMsg"},fields_alt={"browser_handle","msg"},types={"unsigned int","const char *"},string_fields={"pchMsg"}},
	[4525]={fields={"unBrowserHandle","pchMsg"},fields_alt={"browser_handle","msg"},types={"unsigned int","const char *"},string_fields={"pchMsg"}},
	[4526]={fields={"unBrowserHandle"},fields_alt={"browser_handle"},types={"unsigned int"}},
	[4527]={fields={"unBrowserHandle","unOldBrowserHandle"},fields_alt={"browser_handle","old_browser_handle"},types={"unsigned int","unsigned int"}},
	[4611]={fields={"m_eResult","m_unVideoAppID","m_rgchURL"},fields_alt={"result","video_appid","url"},types={"int","unsigned int","char [256]"}},
	[4624]={fields={"m_eResult","m_unVideoAppID"},fields_alt={"result","video_appid"},types={"int","unsigned int"}},
	[4700]={fields={"m_handle","m_result"},fields_alt={"handle","result"},types={"int","int"}},
	[4701]={fields={"m_handle"},fields_alt={"handle"},types={"int"}},
	[4702]={},
	[5001]={},
	[5201]={fields={"m_ullSearchID","m_eResult","m_lobbyID","m_steamIDEndedSearch","m_nSecondsRemainingEstimate","m_cPlayersSearching"},fields_alt={"search_id","result","lobby_id","steamid_ended_search","seconds_remaining_estimate","players_searching"},types={"uint64_t","int","SteamID","SteamID","int32_t","int32_t"}},
	[5202]={fields={"m_ullSearchID","m_eResult","m_nCountPlayersInGame","m_nCountAcceptedGame","m_steamIDHost","m_bFinalCallback"},fields_alt={"search_id","result","count_players_in_game","count_accepted_game","steamid_host","final_callback"},types={"uint64_t","int","int32_t","int32_t","SteamID","bool"}},
	[5211]={fields={"m_eResult","m_ullSearchID"},fields_alt={"result","search_id"},types={"int","uint64_t"}},
	[5212]={fields={"m_eResult","m_ullSearchID","m_SteamIDPlayerFound","m_SteamIDLobby","m_ePlayerAcceptState","m_nPlayerIndex","m_nTotalPlayersFound","m_nTotalPlayersAcceptedGame","m_nSuggestedTeamIndex","m_ullUniqueGameID"},fields_alt={"result","search_id","steamid_player_found","steamid_lobby","player_accept_state","player_index","total_players_found","total_players_accepted_game","suggested_team_index","unique_game_id"},types={"int","uint64_t","SteamID","SteamID","int","int32_t","int32_t","int32_t","int32_t","uint64_t"}},
	[5213]={fields={"m_eResult","m_ullSearchID","m_ullUniqueGameID"},fields_alt={"result","search_id","unique_game_id"},types={"int","uint64_t","uint64_t"}},
	[5214]={fields={"m_eResult","ullUniqueGameID","steamIDPlayer"},fields_alt={"result","unique_game_id","steamid_player"},types={"int","uint64_t","SteamID"}},
	[5215]={fields={"m_eResult","ullUniqueGameID"},fields_alt={"result","unique_game_id"},types={"int","uint64_t"}},
	[5303]={fields={"m_ulBeaconID","m_steamIDJoiner"},fields_alt={"beacon_id","steamid_joiner"},types={"uint64_t","SteamID"}},
	[5305]={},
	[5306]={},
	[5701]={fields={"m_unSessionID"},fields_alt={"session_id"},types={"unsigned int"}},
	[5702]={fields={"m_unSessionID"},fields_alt={"session_id"},types={"unsigned int"}}
}
local callback_name_lookup = {steamserversconnected=101,steamserverconnectfailure=102,steamserversdisconnected=103,clientgameserverdeny=113,ipcfailure=117,licensesupdated=125,validateauthticketresponse=143,microtxnauthorizationresponse=152,getauthsessionticketresponse=163,gamewebcallback=164,personastatechange=304,gameoverlayactivated=331,gameserverchangerequested=332,gamelobbyjoinrequested=333,avatarimageloaded=334,friendrichpresenceupdate=336,gamerichpresencejoinrequested=337,gameconnectedclanchatmsg=338,gameconnectedchatjoin=339,gameconnectedchatleave=340,gameconnectedfriendchatmsg=343,unreadchatmessageschanged=348,overlaybrowserprotocolnavigation=349,ipcountry=701,lowbatterypower=702,steamapicallcompleted=703,steamshutdown=704,gamepadtextinputdismissed=714,favoriteslistchanged=502,lobbyinvite=503,lobbydataupdate=505,lobbychatupdate=506,lobbychatmsg=507,lobbygamecreated=509,lobbykicked=512,psngamebootinviteresult=515,favoriteslistaccountsupdated=516,searchforgameprogresscallback=5201,searchforgameresultcallback=5202,requestplayersforgameprogresscallback=5211,requestplayersforgameresultcallback=5212,requestplayersforgamefinalresultcallback=5213,submitplayerresultresultcallback=5214,endgameresultcallback=5215,reservationnotificationcallback=5303,availablebeaconlocationsupdated=5305,activebeaconsupdated=5306,remotestorageappsyncedclient=1301,remotestorageappsyncedserver=1302,remotestorageappsyncprogress=1303,remotestorageappsyncstatuscheck=1305,remotestoragepublishfileresult=1309,remotestoragepublishedfilesubscribed=1321,remotestoragepublishedfileunsubscribed=1322,remotestoragepublishedfiledeleted=1323,remotestorageuservotedetails=1325,remotestorageenumerateusersharedworkshopfilesresult=1326,remotestoragepublishedfileupdated=1330,userstatsreceived=1101,userstatsstored=1102,userachievementstored=1103,userstatsunloaded=1108,userachievementiconfetched=1109,ps3trophiesinstalled=1112,dlcinstalled=1005,registeractivationcoderesponse=1008,newurllaunchparameters=1014,appproofofpurchasekeyresponse=1021,timedtrialstatus=1030,p2psessionrequest=1202,p2psessionconnectfail=1203,socketstatuscallback=1201,screenshotready=2301,screenshotrequested=2302,playbackstatushaschanged=4001,volumehaschanged=4002,musicplayerremotewillactivate=4101,musicplayerremotewilldeactivate=4102,musicplayerremotetofront=4103,musicplayerwillquit=4104,musicplayerwantsplay=4105,musicplayerwantspause=4106,musicplayerwantsplayprevious=4107,musicplayerwantsplaynext=4108,musicplayerwantsshuffled=4109,musicplayerwantslooped=4110,musicplayerwantsvolume=4011,musicplayerselectsqueueentry=4012,musicplayerselectsplaylistentry=4013,musicplayerwantsplayingrepeatstatus=4114,httprequestcompleted=2101,httprequestheadersreceived=2102,httprequestdatareceived=2103,iteminstalled=3405,downloaditemresult=3406,steamappinstalled=3901,steamappuninstalled=3902,html_needspaint=4502,html_startrequest=4503,html_closebrowser=4504,html_urlchanged=4505,html_finishedrequest=4506,html_openlinkinnewtab=4507,html_changedtitle=4508,html_searchresults=4509,html_cangobackandforward=4510,html_horizontalscroll=4511,html_verticalscroll=4512,html_linkatposition=4513,html_jsalert=4514,html_jsconfirm=4515,html_fileopendialog=4516,html_newwindow=4521,html_setcursor=4522,html_statustext=4523,html_showtooltip=4524,html_updatetooltip=4525,html_hidetooltip=4526,html_browserrestarted=4527,steaminventoryresultready=4700,steaminventoryfullupdate=4701,steaminventorydefinitionupdate=4702,getvideourlresult=4611,getopfsettingsresult=4624,steamparentalsettingschanged=5001,steamremoteplaysessionconnected=5701,steamremoteplaysessiondisconnected=5702,steamnetworkingmessagessessionrequest=1251,steamnetworkingmessagessessionfailed=1252,steamnetconnectionstatuschangedcallback=1221,steamnetauthenticationstatus=1222,steamrelaynetworkstatus=1281,gsclientapprove=201,gsclientdeny=202,gsclientkick=203,gsclientachievementstatus=206,gspolicyresponse=115,gsgameplaystats=207,gsclientgroupstatus=208,gsstatsunloaded=1108}

if not pcall(sizeof, "SteamAPICall_t") then
	cdef([[
		typedef uint64_t SteamAPICall_t;

		struct SteamAPI_callback_base_vtbl {
			void(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);
			void(__thiscall *run2)(struct SteamAPI_callback_base *, void *);
			int(__thiscall *get_size)(struct SteamAPI_callback_base *);
		};

		struct SteamAPI_callback_base {
			struct SteamAPI_callback_base_vtbl *vtbl;
			uint8_t flags;
			int id;
			uint64_t api_call_handle;
			struct SteamAPI_callback_base_vtbl vtbl_storage[1];
		};
	]])
end

local ESteamAPICallFailure = enums.ESteamAPICallFailure

local SteamAPI_RegisterCallResult, SteamAPI_UnregisterCallResult
local SteamAPI_RegisterCallback, SteamAPI_UnregisterCallback

-- initialize isteamutils and native_GetAPICallFailureReason
local steamutils = client_context.ISteamUtils
local native_GetAPICallFailureReason = vtable_entry(steamutils, 12, "int(__thiscall*)(void*, SteamAPICall_t)")
local native_IsAPICallCompleted = vtable_entry(steamutils, 11, "bool(__thiscall*)(void*, SteamAPICall_t, bool*)")

local function GetAPICallFailureReason(handle)
	return native_GetAPICallFailureReason(steamutils, handle)
end

local failed_out = bool_arr(1)
local function IsAPICallCompleted(handle)
	local complete = native_IsAPICallCompleted(steamutils, handle, failed_out)

	return complete, failed_out[0]
end

local callback_base        = typeof("struct SteamAPI_callback_base")
local sizeof_callback_base = sizeof(callback_base)
local callback_base_array  = typeof("struct SteamAPI_callback_base[1]")
local callback_base_ptr    = typeof("struct SteamAPI_callback_base*")
local api_call_handlers    = {}
local api_call_info        = {}
local pending_call_results = {}
local registered_callbacks_instances = {}

-- local function render_multiline(x, y, r, g, b, a, flags, max_width, ...)
-- 	local text = table.concat({...})

-- 	local width_max, height = 0, 0
-- 	for line in string.gmatch(text, "([^\n]+)") do
-- 		renderer.text(x, y+height, r, g, b, a, flags, max_width, line)

-- 		local w, h = renderer.measure_text(flags, line)
-- 		width_max = math.max(width_max, w)
-- 		height = height + h
-- 	end

-- 	return width_max, height
-- end

-- local inspect = require "inspect"
-- client.set_event_callback("paint_ui", function()
-- 	render_multiline(150, 150, 255, 255, 255, 255, "", 0, "api_call_handlers: ", inspect(api_call_handlers))
-- 	render_multiline(350, 150, 255, 255, 255, 255, "", 0, "api_call_info: ", inspect(api_call_info))
-- 	render_multiline(550, 150, 255, 255, 255, 255, "", 0, "pending_call_results: ", inspect(pending_call_results))
-- 	render_multiline(750, 150, 255, 255, 255, 255, "", 0, "registered_callbacks_instances: ", inspect(registered_callbacks_instances))
-- end)

local callback_base_error = error_log_prefix("[steamworks] callback failed: ")

local function callback_base_run_common(self, param, io_failure)
	if io_failure then
		io_failure = ESteamAPICallFailure[GetAPICallFailureReason(self.api_call_handle)] or true
	end

	-- prevent SteamAPI_UnregisterCallResult from being called for this callresult
	self.api_call_handle = 0

	local key = pointer_key(self)
	local handler = api_call_handlers[key]

	if handler ~= nil then
		local info = api_call_info[key]
		if info ~= nil then
			if param ~= nil then
				param = cast(info.struct, param)
			end
			local data = struct_to_tbl(param, info.keys, info.string_keys_lookup)

			if io_failure ~= false then
				data.io_failure = io_failure
			end

			xpcall(handler, error_log, data)
		else
			xpcall(handler, error_log, param, io_failure)
		end
	end

	-- clear out data if we're not dealing with a callback
	if pending_call_results[key] ~= nil then
		api_call_handlers[key] = nil
		api_call_info[key] = nil
		pending_call_results[key] = nil
	end
end

local function callback_base_run1(self, param, io_failure, api_call_handle)
	if api_call_handle == self.api_call_handle then
		xpcall(callback_base_run_common, callback_base_error, self, param, io_failure)
	end
end

local function callback_base_run2(self, param)
	xpcall(callback_base_run_common, callback_base_error, self, param, false)
end

local function callback_base_get_size()
	return sizeof_callback_base
end

local function call_result_cancel(self)
	if self.api_call_handle ~= 0 then
		SteamAPI_UnregisterCallResult(self, self.api_call_handle)
		self.api_call_handle = 0

		local key = pointer_key(self)
		api_call_handlers[key] = nil
		api_call_info[key] = nil
		pending_call_results[key] = nil
	end
end

pcall(ffi.metatype, callback_base, {
	__gc = call_result_cancel,
	__index = {
		cancel = call_result_cancel
	}
})

local callback_base_run1_ct = cast("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", callback_base_run1)
local callback_base_run2_ct = cast("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", callback_base_run2)
local callback_base_get_size_ct = cast("int(__thiscall *)(struct SteamAPI_callback_base *)", callback_base_get_size)

SteamAPI_RegisterCallResult = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xFF\x75\x10", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
SteamAPI_UnregisterCallResult = find_sig("steam_api.dll", "\x55\x8B\xEC\xFF\x75\x10\xFF\x75\x0C", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")

SteamAPI_RegisterCallback = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\x3D\xCC\xCC\xCC\xCC\xCC\x7E\x0D\x68\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC\x5D\xC3\xC7\x05", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
SteamAPI_UnregisterCallback = find_sig("steam_api.dll", "\x55\x8B\xEC\x83\xEC\x08\x80\x3D", "void(__cdecl*)(struct SteamAPI_callback_base *)")

local SteamAPI_RunCallbacks = find_sig("steam_api.dll", "\x32\xC9\x83\x3D\xCC\xCC\xCC\xCC\xCC", "void(__cdecl*)(void)")

local function register_call_result(api_call_handle, handler, id, info)
	assert(api_call_handle ~= 0)
	local instance_storage = callback_base_array()
	local instance = cast(callback_base_ptr, instance_storage)

	instance.vtbl_storage[0].run1 = callback_base_run1_ct
	instance.vtbl_storage[0].run2 = callback_base_run2_ct
	instance.vtbl_storage[0].get_size = callback_base_get_size_ct
	instance.vtbl = instance.vtbl_storage
	instance.api_call_handle = api_call_handle
	instance.id = id

	local res, timed_out = api_call_handle, false

	local await = (type(handler) == "table" and getmetatable(handler) == await_mt) and handler or nil
	if await then
		jit.off(true, true)

		-- this will be returned if our callback times out
		res = nil

		-- this will be executed if we time out
		local fallback = type(await[2]) == "function" and await[2] or nil

		handler = function(data)
			if timed_out and fallback ~= nil then
				xpcall(fallback, error_log, data)
			end

			res = data
		end
	end

	local key = pointer_key(instance)
	api_call_handlers[key] = handler
	api_call_info[key] = info
	pending_call_results[key] = instance_storage

	SteamAPI_RegisterCallResult(instance, api_call_handle)

	if await then
		local start = timestamp()
		local timeout = math_min(999, math_max(0, tonumber(await[1]) or AWAIT_DEFAULT_DELAY))
		local timestamp_end = start + timeout

		-- repeatedly call SteamAPI_RunCallbacks until we get our alert (or time out after 10ms)
		while true do
			if res ~= nil or timestamp() > timestamp_end then
				-- print(IsAPICallCompleted(api_call_handle))
				break
			end

			SteamAPI_RunCallbacks()
		end
		timed_out = true
	end

	return res
end

local registered_user_callbacks = {}

local function get_global_callback_handler(id, user_callbacks)
	local info = callback_info[id]
	local string_field_lookup = {}
	local fields = info.fields
	local fields_alt = info.fields_alt
	local fields_kv = {}

	for _, key in ipairs(info.string_fields or {}) do
		string_field_lookup[key] = true
	end

	local struct_text = "struct {"

	for i, key in ipairs(fields) do
		local type_match, arr_match = string_match(info.types[i], "^(.*)(%[.*%])$")

		if type_match ~= nil then
			struct_text = struct_text .. type_match .. " " .. key .. arr_match .. "; "
		else
			struct_text = struct_text .. info.types[i] .. " " .. key .. "; "
		end

		fields_kv[key] = fields_alt[i] or true
	end
	struct_text = struct_text .. "} *"

	local struct = typeof(struct_text)

	return function(param, io_failure)
		if param ~= nil then
			param = cast(struct, param)
		end

		local data = struct_to_tbl(param, fields_kv, string_field_lookup)

		if io_failure ~= false then
			data.io_failure = io_failure
		end

		for _, user_callback in ipairs(user_callbacks) do
			xpcall(user_callback, error_log, data)
		end
	end
end

-- function to set a global callback
local function set_callback(id, callback)
	if type(id) == "string" and callback_name_lookup[string_lower(string_gsub(id, "_t$", ""))] ~= nil then
		id = callback_name_lookup[string_lower(string_gsub(id, "_t$", ""))]
	end

	if callback_info[id] == nil then
		return error("Invalid Steam callback")
	end

	if registered_user_callbacks[id] == nil then
		assert(registered_callbacks_instances[id] == nil)

		-- need to register our global handler for this callback
		registered_user_callbacks[id] = {}

		local instance_storage = callback_base_array()
		local instance = cast(callback_base_ptr, instance_storage)

		instance.vtbl_storage[0].run1 = callback_base_run1_ct
		instance.vtbl_storage[0].run2 = callback_base_run2_ct
		instance.vtbl_storage[0].get_size = callback_base_get_size_ct
		instance.vtbl = instance.vtbl_storage
		instance.api_call_handle = 0
		instance.id = id

		local key = pointer_key(instance)
		api_call_handlers[key] = get_global_callback_handler(id, registered_user_callbacks[id])
		registered_callbacks_instances[id] = instance_storage

		SteamAPI_RegisterCallback(instance, id)
	else
		-- dont register same callback twice
		for _, user_callback in ipairs(registered_user_callbacks[id]) do
			if user_callback == callback then
				return false
			end
		end
	end

	table_insert(registered_user_callbacks[id], callback)
	return true
end
M.set_callback = set_callback

local function unset_callback(id, callback)
	if type(id) == "string" and callback_name_lookup[string_lower(string_gsub(id, "_t$", ""))] ~= nil then
		id = callback_name_lookup[string_lower(string_gsub(id, "_t$", ""))]
	end

	if callback_info[id] == nil then
		return error("Invalid Steam callback")
	end

	if registered_user_callbacks[id] == nil then
		return false
	end

	for i, user_callback in ipairs(registered_user_callbacks[id]) do
		if user_callback == callback then
			table_remove(registered_user_callbacks[id], i)
			break
		end
	end

	-- clear our global callback again
	if #registered_user_callbacks[id] == 0 then
		local instance_storage = registered_callbacks_instances[id]
		local instance = cast(callback_base_ptr, instance_storage)
		SteamAPI_UnregisterCallback(instance)

		registered_user_callbacks[id] = nil
		registered_callbacks_instances[id] = nil

		local key = pointer_key(instance)

		api_call_handlers[key] = nil
	end

	return true
end
M.unset_callback = unset_callback

-- function to wait for a callback
function M.await_callback(id, timeout, callback)
	if type(id) == "string" and callback_name_lookup[string_lower(string_gsub(id, "_t$", ""))] ~= nil then
		id = callback_name_lookup[string_lower(string_gsub(id, "_t$", ""))]
	end

	if callback_info[id] == nil then
		return error("Invalid Steam callback")
	end

	-- register callback if its passed
	local registered = false
	if callback ~= nil then
		registered = set_callback(id, callback)
	end

	-- wait for callback to be called

	-- if the callback was successfully registered (so not already registered) then unregister it
	if registered then
		unset_callback(id, callback)
	end
end

--
-- utility functions for "user created interfaces"
--

local function get_user_interface_callback_handler(user_callbacks)
	return function(instance, ...)
		local user_callback = user_callbacks[pointer_key(instance)]
		if user_callback ~= nil then
			xpcall(user_callback, error_log, instance, ...)
		end
	end
end

--
-- random other utilities
--

local function to_steamid_required(steamid, err_text)
	return to_steamid(steamid) or error(err_text, 3)
end

local function to_enum(int_or_string, enum)
	local t = type(int_or_string)

	if t == "number" or t == "string" then
		local e = enum[int_or_string]

		if e ~= nil then
			return t == "string" and e or int_or_string
		end
	end
end

local function to_enum_required(int_or_string, enum, err_text)
	return to_enum(int_or_string, enum) or error(err_text, 3)
end

local function ipv4_int_to_string(ip)
	local buf = uint32_t_arr(1, ip)
	local strbuf = cast(uint8_t_ptr, buf)

	return string_format("%d.%d.%d.%d", strbuf[3], strbuf[2], strbuf[1], strbuf[0])
end

local function ipv4_string_to_int(ip)
	local a, b, c, d = string_match(ip, "^(%d+)%.(%d+)%.(%d+)%.(%d+)$")

	if a ~= nil then
		local buf = uint8_t_arr(4, tonumber(d), tonumber(c), tonumber(b), tonumber(a))

		return cast(uint32_t_ptr, buf)[0]
	end
end

local function to_ip_int_required(ip, err_text)
	local t = type(ip)

	if t == "number" then
		return ip
	elseif t == "string" then
		return ipv4_string_to_int(ip) or error(err_text, 3)
	end

	error(err_text, 3)
end

M.SteamID = to_steamid
M.CSteamID = to_steamid
M.ipv4_parse = ipv4_string_to_int
M.ipv4_tostring = ipv4_int_to_string

--
-- out types for interfaces
--

local new_FriendGameInfo_arr = typeof("FriendGameInfo_t [1]")
local new_SteamID_arr = typeof("SteamID [1]")
local new_bool_arr = typeof("bool [1]")
local new_double_arr = typeof("double [1]")
local new_float_arr = typeof("float [1]")
local new_int32_arr = typeof("int32_t [1]")
local new_int64_arr = typeof("int64_t [1]")
local new_int_arr = typeof("int [1]")
local new_uint16_arr = typeof("uint16_t [1]")
local new_uint32_arr = typeof("uint32_t [1]")
local new_uint64_arr = typeof("uint64_t [1]")
local new_unsigned_int_arr = typeof("unsigned int [1]")

--
-- all interfaces
--

-- this shit takes a few hundred ms for some reason?
-- local native_ConnectToGlobalUser = vtable_bind("steamclient.dll", "SteamClient020", 2, "int(__thiscall*)(void*, int)")
-- local hSteamUser = native_ConnectToGlobalUser(hSteamPipe)

local imports_match = cast("char*", find_signature("client.dll", "\xFF\x15\xCC\xCC\xCC\xCC\x8B\xD8\xFF\x15") or error("Invalid SteamAPI_GetHSteamUser signature"))

local SteamAPI_GetHSteamUser = cast("int(__cdecl***)()", imports_match + 2)[0][0]
local SteamAPI_GetHSteamPipe = cast("int(__cdecl***)()", imports_match + 10)[0][0]

local hSteamPipe = SteamAPI_GetHSteamPipe()
local hSteamUser = SteamAPI_GetHSteamUser()

--
-- ISteamUser (SteamUser021, user created: false)
--

local ISteamUser = {version="SteamUser021",version_number=21}

index_funcs.ISteamUser = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 5, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "SteamUser021")

	local GetHSteamUser_native = vtable_entry(this, 0, "int(__thiscall*)(void*)")
	function ISteamUser.GetHSteamUser()
		return GetHSteamUser_native(this)
	end
	ISteamUser.get_hsteamuser = ISteamUser.GetHSteamUser

	local BLoggedOn_native = vtable_entry(this, 1, "bool(__thiscall*)(void*)")
	function ISteamUser.BLoggedOn()
		return BLoggedOn_native(this)
	end
	ISteamUser.logged_on = ISteamUser.BLoggedOn

	local GetSteamID_native = vtable_entry(this, 2, "void(__thiscall*)(void*, SteamID *)")
	function ISteamUser.GetSteamID()
		local CSteamID_out = new_SteamID_arr()
		GetSteamID_native(this, CSteamID_out)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamUser.get_steamid = ISteamUser.GetSteamID

	local InitiateGameConnection_native = vtable_entry(this, 3, "int(__thiscall*)(void*, void *, int, SteamID, uint32_t, uint16_t, bool)")
	function ISteamUser.InitiateGameConnection(pAuthBlob, cbMaxAuthBlob, steamIDGameServer, unIPServer, usPortServer, bSecure)
		steamIDGameServer = to_steamid_required(steamIDGameServer, "steamid_game_server is required")
		unIPServer = to_ip_int_required(unIPServer, "ip_server is required")
		return InitiateGameConnection_native(this, pAuthBlob, cbMaxAuthBlob, steamIDGameServer, unIPServer, usPortServer, bSecure)
	end
	ISteamUser.initiate_game_connection = ISteamUser.InitiateGameConnection

	local TerminateGameConnection_native = vtable_entry(this, 4, "void(__thiscall*)(void*, uint32_t, uint16_t)")
	function ISteamUser.TerminateGameConnection(unIPServer, usPortServer)
		unIPServer = to_ip_int_required(unIPServer, "ip_server is required")
		return TerminateGameConnection_native(this, unIPServer, usPortServer)
	end
	ISteamUser.terminate_game_connection = ISteamUser.TerminateGameConnection

	local TrackAppUsageEvent_native = vtable_entry(this, 5, "void(__thiscall*)(void*, uint64_t, int, const char *)")
	function ISteamUser.TrackAppUsageEvent(gameID, eAppUsageEvent, pchExtraInfo)
		return TrackAppUsageEvent_native(this, gameID, eAppUsageEvent, pchExtraInfo)
	end
	ISteamUser.track_app_usage_event = ISteamUser.TrackAppUsageEvent

	local GetUserDataFolder_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, char *, int)")
	function ISteamUser.GetUserDataFolder(pchBuffer, cubBuffer)
		return GetUserDataFolder_native(this, pchBuffer, cubBuffer)
	end
	ISteamUser.get_user_data_folder = ISteamUser.GetUserDataFolder

	local StartVoiceRecording_native = vtable_entry(this, 7, "void(__thiscall*)(void*)")
	function ISteamUser.StartVoiceRecording()
		return StartVoiceRecording_native(this)
	end
	ISteamUser.start_voice_recording = ISteamUser.StartVoiceRecording

	local StopVoiceRecording_native = vtable_entry(this, 8, "void(__thiscall*)(void*)")
	function ISteamUser.StopVoiceRecording()
		return StopVoiceRecording_native(this)
	end
	ISteamUser.stop_voice_recording = ISteamUser.StopVoiceRecording

	local GetAvailableVoice_native = vtable_entry(this, 9, "int(__thiscall*)(void*, uint32_t *, uint32_t *, uint32_t)")
	function ISteamUser.GetAvailableVoice(pcbUncompressed_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)
		local pcbCompressed_out = new_uint32_arr()
		local res = GetAvailableVoice_native(this, pcbCompressed_out, pcbUncompressed_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)

		return res, DEREF_GCSAFE(pcbCompressed_out)
	end
	ISteamUser.get_available_voice = ISteamUser.GetAvailableVoice

	local GetVoice_native = vtable_entry(this, 10, "int(__thiscall*)(void*, bool, void *, uint32_t, uint32_t *, bool, void *, uint32_t, uint32_t *, uint32_t)")
	function ISteamUser.GetVoice(bWantCompressed, pDestBuffer, cbDestBufferSize, bWantUncompressed_Deprecated, pUncompressedDestBuffer_Deprecated, cbUncompressedDestBufferSize_Deprecated, nUncompressBytesWritten_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)
		local nBytesWritten_out = new_uint32_arr()
		local res = GetVoice_native(this, bWantCompressed, pDestBuffer, cbDestBufferSize, nBytesWritten_out, bWantUncompressed_Deprecated, pUncompressedDestBuffer_Deprecated, cbUncompressedDestBufferSize_Deprecated, nUncompressBytesWritten_Deprecated, nUncompressedVoiceDesiredSampleRate_Deprecated)

		return res, DEREF_GCSAFE(nBytesWritten_out)
	end
	ISteamUser.get_voice = ISteamUser.GetVoice

	local DecompressVoice_native = vtable_entry(this, 11, "int(__thiscall*)(void*, const void *, uint32_t, void *, uint32_t, uint32_t *, uint32_t)")
	function ISteamUser.DecompressVoice(pCompressed, cbCompressed, pDestBuffer, cbDestBufferSize, nDesiredSampleRate)
		local nBytesWritten_out = new_uint32_arr()
		local res = DecompressVoice_native(this, pCompressed, cbCompressed, pDestBuffer, cbDestBufferSize, nBytesWritten_out, nDesiredSampleRate)

		return res, DEREF_GCSAFE(nBytesWritten_out)
	end
	ISteamUser.decompress_voice = ISteamUser.DecompressVoice

	local GetVoiceOptimalSampleRate_native = vtable_entry(this, 12, "uint32_t(__thiscall*)(void*)")
	function ISteamUser.GetVoiceOptimalSampleRate()
		return GetVoiceOptimalSampleRate_native(this)
	end
	ISteamUser.get_voice_optimal_sample_rate = ISteamUser.GetVoiceOptimalSampleRate

	local GetAuthSessionTicket_native = vtable_entry(this, 13, "unsigned int(__thiscall*)(void*, void *, int, uint32_t *)")
	function ISteamUser.GetAuthSessionTicket(pTicket, cbMaxTicket)
		local pcbTicket_out = new_uint32_arr()
		local res = GetAuthSessionTicket_native(this, pTicket, cbMaxTicket, pcbTicket_out)

		return res, DEREF_GCSAFE(pcbTicket_out)
	end
	ISteamUser.get_auth_session_ticket = ISteamUser.GetAuthSessionTicket

	local BeginAuthSession_native = vtable_entry(this, 14, "int(__thiscall*)(void*, const void *, int, SteamID)")
	function ISteamUser.BeginAuthSession(pAuthTicket, cbAuthTicket, steamID)
		steamID = to_steamid_required(steamID, "steamid is required")
		return BeginAuthSession_native(this, pAuthTicket, cbAuthTicket, steamID)
	end
	ISteamUser.begin_auth_session = ISteamUser.BeginAuthSession

	local EndAuthSession_native = vtable_entry(this, 15, "void(__thiscall*)(void*, SteamID)")
	function ISteamUser.EndAuthSession(steamID)
		steamID = to_steamid_required(steamID, "steamid is required")
		return EndAuthSession_native(this, steamID)
	end
	ISteamUser.end_auth_session = ISteamUser.EndAuthSession

	local CancelAuthTicket_native = vtable_entry(this, 16, "void(__thiscall*)(void*, unsigned int)")
	function ISteamUser.CancelAuthTicket(hAuthTicket)
		return CancelAuthTicket_native(this, hAuthTicket)
	end
	ISteamUser.cancel_auth_ticket = ISteamUser.CancelAuthTicket

	local UserHasLicenseForApp_native = vtable_entry(this, 17, "int(__thiscall*)(void*, SteamID, unsigned int)")
	function ISteamUser.UserHasLicenseForApp(steamID, appID)
		steamID = to_steamid_required(steamID, "steamid is required")
		return UserHasLicenseForApp_native(this, steamID, appID)
	end
	ISteamUser.user_has_license_for_app = ISteamUser.UserHasLicenseForApp

	local BIsBehindNAT_native = vtable_entry(this, 18, "bool(__thiscall*)(void*)")
	function ISteamUser.BIsBehindNAT()
		return BIsBehindNAT_native(this)
	end
	ISteamUser.is_behind_nat = ISteamUser.BIsBehindNAT

	local AdvertiseGame_native = vtable_entry(this, 19, "void(__thiscall*)(void*, SteamID, uint32_t, uint16_t)")
	function ISteamUser.AdvertiseGame(steamIDGameServer, unIPServer, usPortServer)
		steamIDGameServer = to_steamid_required(steamIDGameServer, "steamid_game_server is required")
		unIPServer = to_ip_int_required(unIPServer, "ip_server is required")
		return AdvertiseGame_native(this, steamIDGameServer, unIPServer, usPortServer)
	end
	ISteamUser.advertise_game = ISteamUser.AdvertiseGame

	local RequestEncryptedAppTicket_native = vtable_entry(this, 20, "uint64_t(__thiscall*)(void*, void *, int)")
	local RequestEncryptedAppTicket_info = {
		struct = typeof([[
			struct {
				int m_eResult;
			} *
		]]),
		keys = {m_eResult="result"}
	}
	function ISteamUser.RequestEncryptedAppTicket(pDataToInclude, cbDataToInclude, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestEncryptedAppTicket_native(this, pDataToInclude, cbDataToInclude)

		if callback ~= nil then
			res = register_call_result(res, callback, 154, RequestEncryptedAppTicket_info)
		end

		return res
	end
	ISteamUser.request_encrypted_app_ticket = ISteamUser.RequestEncryptedAppTicket

	local GetEncryptedAppTicket_native = vtable_entry(this, 21, "bool(__thiscall*)(void*, void *, int, uint32_t *)")
	function ISteamUser.GetEncryptedAppTicket(pTicket, cbMaxTicket)
		local pcbTicket_out = new_uint32_arr()
		local res = GetEncryptedAppTicket_native(this, pTicket, cbMaxTicket, pcbTicket_out)

		return res, DEREF_GCSAFE(pcbTicket_out)
	end
	ISteamUser.get_encrypted_app_ticket = ISteamUser.GetEncryptedAppTicket

	local GetGameBadgeLevel_native = vtable_entry(this, 22, "int(__thiscall*)(void*, int, bool)")
	function ISteamUser.GetGameBadgeLevel(nSeries, bFoil)
		return GetGameBadgeLevel_native(this, nSeries, bFoil)
	end
	ISteamUser.get_game_badge_level = ISteamUser.GetGameBadgeLevel

	local GetPlayerSteamLevel_native = vtable_entry(this, 23, "int(__thiscall*)(void*)")
	function ISteamUser.GetPlayerSteamLevel()
		return GetPlayerSteamLevel_native(this)
	end
	ISteamUser.get_player_steam_level = ISteamUser.GetPlayerSteamLevel

	local RequestStoreAuthURL_native = vtable_entry(this, 24, "uint64_t(__thiscall*)(void*, const char *)")
	local RequestStoreAuthURL_info = {
		struct = typeof([[
			struct {
				char m_szURL[512];
			} *
		]]),
		keys = {m_szURL="url"}
	}
	function ISteamUser.RequestStoreAuthURL(pchRedirectURL, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestStoreAuthURL_native(this, pchRedirectURL)

		if callback ~= nil then
			res = register_call_result(res, callback, 165, RequestStoreAuthURL_info)
		end

		return res
	end
	ISteamUser.request_store_auth_url = ISteamUser.RequestStoreAuthURL

	local BIsPhoneVerified_native = vtable_entry(this, 25, "bool(__thiscall*)(void*)")
	function ISteamUser.BIsPhoneVerified()
		return BIsPhoneVerified_native(this)
	end
	ISteamUser.is_phone_verified = ISteamUser.BIsPhoneVerified

	local BIsTwoFactorEnabled_native = vtable_entry(this, 26, "bool(__thiscall*)(void*)")
	function ISteamUser.BIsTwoFactorEnabled()
		return BIsTwoFactorEnabled_native(this)
	end
	ISteamUser.is_two_factor_enabled = ISteamUser.BIsTwoFactorEnabled

	local BIsPhoneIdentifying_native = vtable_entry(this, 27, "bool(__thiscall*)(void*)")
	function ISteamUser.BIsPhoneIdentifying()
		return BIsPhoneIdentifying_native(this)
	end
	ISteamUser.is_phone_identifying = ISteamUser.BIsPhoneIdentifying

	local BIsPhoneRequiringVerification_native = vtable_entry(this, 28, "bool(__thiscall*)(void*)")
	function ISteamUser.BIsPhoneRequiringVerification()
		return BIsPhoneRequiringVerification_native(this)
	end
	ISteamUser.is_phone_requiring_verification = ISteamUser.BIsPhoneRequiringVerification

	local GetMarketEligibility_native = vtable_entry(this, 29, "uint64_t(__thiscall*)(void*)")
	local GetMarketEligibility_info = {
		struct = typeof([[
			struct {
				bool m_bAllowed;
				int m_eNotAllowedReason;
				unsigned int m_rtAllowedAtTime;
				int m_cdaySteamGuardRequiredDays;
				int m_cdayNewDeviceCooldown;
			} *
		]]),
		keys = {m_bAllowed="allowed",m_eNotAllowedReason="not_allowed_reason",m_rtAllowedAtTime="allowed_at_time",m_cdaySteamGuardRequiredDays="steam_guard_required_days",m_cdayNewDeviceCooldown="new_device_cooldown"}
	}
	function ISteamUser.GetMarketEligibility(callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = GetMarketEligibility_native(this)

		if callback ~= nil then
			res = register_call_result(res, callback, 166, GetMarketEligibility_info)
		end

		return res
	end
	ISteamUser.get_market_eligibility = ISteamUser.GetMarketEligibility

	local GetDurationControl_native = vtable_entry(this, 30, "uint64_t(__thiscall*)(void*)")
	local GetDurationControl_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				unsigned int m_appid;
				bool m_bApplicable;
				int32_t m_csecsLast5h;
				int m_progress;
				int m_notification;
				int32_t m_csecsToday;
				int32_t m_csecsRemaining;
			} *
		]]),
		keys = {m_eResult="result",m_appid="appid",m_bApplicable="applicable",m_csecsLast5h="last5h",m_progress="progress",m_notification="notification",m_csecsToday="today",m_csecsRemaining="remaining"}
	}
	function ISteamUser.GetDurationControl(callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = GetDurationControl_native(this)

		if callback ~= nil then
			res = register_call_result(res, callback, 167, GetDurationControl_info)
		end

		return res
	end
	ISteamUser.get_duration_control = ISteamUser.GetDurationControl

	local BSetDurationControlOnlineState_native = vtable_entry(this, 31, "bool(__thiscall*)(void*, int)")
	function ISteamUser.BSetDurationControlOnlineState(eNewState)
		eNewState = to_enum_required(eNewState, enums.EDurationControlOnlineState, "new_state is required")
		return BSetDurationControlOnlineState_native(this, eNewState)
	end
	ISteamUser.set_duration_control_online_state = ISteamUser.BSetDurationControlOnlineState

	return ISteamUser
end

--
-- ISteamFriends (SteamFriends017, user created: false)
--

local ISteamFriends = {version="SteamFriends017",version_number=17}

index_funcs.ISteamFriends = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 8, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "SteamFriends017")

	local GetPersonaName_native = vtable_entry(this, 0, "const char *(__thiscall*)(void*)")
	function ISteamFriends.GetPersonaName()
		local res = GetPersonaName_native(this)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_persona_name = ISteamFriends.GetPersonaName

	local SetPersonaName_native = vtable_entry(this, 1, "uint64_t(__thiscall*)(void*, const char *)")
	local SetPersonaName_info = {
		struct = typeof([[
			struct {
				bool m_bSuccess;
				bool m_bLocalSuccess;
				int m_result;
			} *
		]]),
		keys = {m_bSuccess="success",m_bLocalSuccess="local_success",m_result="result"}
	}
	function ISteamFriends.SetPersonaName(pchPersonaName, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = SetPersonaName_native(this, pchPersonaName)

		if callback ~= nil then
			res = register_call_result(res, callback, 347, SetPersonaName_info)
		end

		return res
	end
	ISteamFriends.set_persona_name = ISteamFriends.SetPersonaName

	local GetPersonaState_native = vtable_entry(this, 2, "int(__thiscall*)(void*)")
	function ISteamFriends.GetPersonaState()
		return GetPersonaState_native(this)
	end
	ISteamFriends.get_persona_state = ISteamFriends.GetPersonaState

	local GetFriendCount_native = vtable_entry(this, 3, "int(__thiscall*)(void*, int)")
	function ISteamFriends.GetFriendCount(iFriendFlags)
		iFriendFlags = to_enum_required(iFriendFlags, enums.EFriendFlags, "friend_flags is required")
		return GetFriendCount_native(this, iFriendFlags)
	end
	ISteamFriends.get_friend_count = ISteamFriends.GetFriendCount

	local GetFriendByIndex_native = vtable_entry(this, 4, "void(__thiscall*)(void*, SteamID *, int, int)")
	function ISteamFriends.GetFriendByIndex(iFriend, iFriendFlags)
		iFriendFlags = to_enum_required(iFriendFlags, enums.EFriendFlags, "friend_flags is required")
		local CSteamID_out = new_SteamID_arr()
		GetFriendByIndex_native(this, CSteamID_out, iFriend, iFriendFlags)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamFriends.get_friend_by_index = ISteamFriends.GetFriendByIndex

	local GetFriendRelationship_native = vtable_entry(this, 5, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendRelationship(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetFriendRelationship_native(this, steamIDFriend)
	end
	ISteamFriends.get_friend_relationship = ISteamFriends.GetFriendRelationship

	local GetFriendPersonaState_native = vtable_entry(this, 6, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendPersonaState(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetFriendPersonaState_native(this, steamIDFriend)
	end
	ISteamFriends.get_friend_persona_state = ISteamFriends.GetFriendPersonaState

	local GetFriendPersonaName_native = vtable_entry(this, 7, "const char *(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendPersonaName(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		local res = GetFriendPersonaName_native(this, steamIDFriend)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_friend_persona_name = ISteamFriends.GetFriendPersonaName

	local GetFriendGamePlayed_native = vtable_entry(this, 8, "bool(__thiscall*)(void*, SteamID, FriendGameInfo_t *)")
	function ISteamFriends.GetFriendGamePlayed(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		local pFriendGameInfo_out = new_FriendGameInfo_arr()
		local res = GetFriendGamePlayed_native(this, steamIDFriend, pFriendGameInfo_out)

		return res, DEREF_GCSAFE(pFriendGameInfo_out)
	end
	ISteamFriends.get_friend_game_played = ISteamFriends.GetFriendGamePlayed

	local GetFriendPersonaNameHistory_native = vtable_entry(this, 9, "const char *(__thiscall*)(void*, SteamID, int)")
	function ISteamFriends.GetFriendPersonaNameHistory(steamIDFriend, iPersonaName)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		local res = GetFriendPersonaNameHistory_native(this, steamIDFriend, iPersonaName)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_friend_persona_name_history = ISteamFriends.GetFriendPersonaNameHistory

	local GetFriendSteamLevel_native = vtable_entry(this, 10, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendSteamLevel(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetFriendSteamLevel_native(this, steamIDFriend)
	end
	ISteamFriends.get_friend_steam_level = ISteamFriends.GetFriendSteamLevel

	local GetPlayerNickname_native = vtable_entry(this, 11, "const char *(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetPlayerNickname(steamIDPlayer)
		steamIDPlayer = to_steamid_required(steamIDPlayer, "steamid_player is required")
		local res = GetPlayerNickname_native(this, steamIDPlayer)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_player_nickname = ISteamFriends.GetPlayerNickname

	local GetFriendsGroupCount_native = vtable_entry(this, 12, "int(__thiscall*)(void*)")
	function ISteamFriends.GetFriendsGroupCount()
		return GetFriendsGroupCount_native(this)
	end
	ISteamFriends.get_friends_group_count = ISteamFriends.GetFriendsGroupCount

	local GetFriendsGroupIDByIndex_native = vtable_entry(this, 13, "short(__thiscall*)(void*, int)")
	function ISteamFriends.GetFriendsGroupIDByIndex(iFG)
		return GetFriendsGroupIDByIndex_native(this, iFG)
	end
	ISteamFriends.get_friends_group_id_by_index = ISteamFriends.GetFriendsGroupIDByIndex

	local GetFriendsGroupName_native = vtable_entry(this, 14, "const char *(__thiscall*)(void*, short)")
	function ISteamFriends.GetFriendsGroupName(friendsGroupID)
		local res = GetFriendsGroupName_native(this, friendsGroupID)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_friends_group_name = ISteamFriends.GetFriendsGroupName

	local GetFriendsGroupMembersCount_native = vtable_entry(this, 15, "int(__thiscall*)(void*, short)")
	function ISteamFriends.GetFriendsGroupMembersCount(friendsGroupID)
		return GetFriendsGroupMembersCount_native(this, friendsGroupID)
	end
	ISteamFriends.get_friends_group_members_count = ISteamFriends.GetFriendsGroupMembersCount

	local GetFriendsGroupMembersList_native = vtable_entry(this, 16, "void(__thiscall*)(void*, short, SteamID *, int)")
	function ISteamFriends.GetFriendsGroupMembersList(friendsGroupID, pOutSteamIDMembers, nMembersCount)
		return GetFriendsGroupMembersList_native(this, friendsGroupID, pOutSteamIDMembers, nMembersCount)
	end
	ISteamFriends.get_friends_group_members_list = ISteamFriends.GetFriendsGroupMembersList

	local HasFriend_native = vtable_entry(this, 17, "bool(__thiscall*)(void*, SteamID, int)")
	function ISteamFriends.HasFriend(steamIDFriend, iFriendFlags)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		iFriendFlags = to_enum_required(iFriendFlags, enums.EFriendFlags, "friend_flags is required")
		return HasFriend_native(this, steamIDFriend, iFriendFlags)
	end
	ISteamFriends.has_friend = ISteamFriends.HasFriend

	local GetClanCount_native = vtable_entry(this, 18, "int(__thiscall*)(void*)")
	function ISteamFriends.GetClanCount()
		return GetClanCount_native(this)
	end
	ISteamFriends.get_clan_count = ISteamFriends.GetClanCount

	local GetClanByIndex_native = vtable_entry(this, 19, "void(__thiscall*)(void*, SteamID *, int)")
	function ISteamFriends.GetClanByIndex(iClan)
		local CSteamID_out = new_SteamID_arr()
		GetClanByIndex_native(this, CSteamID_out, iClan)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamFriends.get_clan_by_index = ISteamFriends.GetClanByIndex

	local GetClanName_native = vtable_entry(this, 20, "const char *(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetClanName(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		local res = GetClanName_native(this, steamIDClan)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_clan_name = ISteamFriends.GetClanName

	local GetClanTag_native = vtable_entry(this, 21, "const char *(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetClanTag(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		local res = GetClanTag_native(this, steamIDClan)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_clan_tag = ISteamFriends.GetClanTag

	local GetClanActivityCounts_native = vtable_entry(this, 22, "bool(__thiscall*)(void*, SteamID, int *, int *, int *)")
	function ISteamFriends.GetClanActivityCounts(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		local pnOnline_out = new_int_arr()
		local pnInGame_out = new_int_arr()
		local pnChatting_out = new_int_arr()
		local res = GetClanActivityCounts_native(this, steamIDClan, pnOnline_out, pnInGame_out, pnChatting_out)

		return res, DEREF_GCSAFE(pnOnline_out), DEREF_GCSAFE(pnInGame_out), DEREF_GCSAFE(pnChatting_out)
	end
	ISteamFriends.get_clan_activity_counts = ISteamFriends.GetClanActivityCounts

	local DownloadClanActivityCounts_native = vtable_entry(this, 23, "uint64_t(__thiscall*)(void*, SteamID *, int)")
	local DownloadClanActivityCounts_info = {
		struct = typeof([[
			struct {
				bool m_bSuccess;
			} *
		]]),
		keys = {m_bSuccess="success"}
	}
	function ISteamFriends.DownloadClanActivityCounts(psteamIDClans, cClansToRequest, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = DownloadClanActivityCounts_native(this, psteamIDClans, cClansToRequest)

		if callback ~= nil then
			res = register_call_result(res, callback, 341, DownloadClanActivityCounts_info)
		end

		return res
	end
	ISteamFriends.download_clan_activity_counts = ISteamFriends.DownloadClanActivityCounts

	local GetFriendCountFromSource_native = vtable_entry(this, 24, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendCountFromSource(steamIDSource)
		steamIDSource = to_steamid_required(steamIDSource, "steamid_source is required")
		return GetFriendCountFromSource_native(this, steamIDSource)
	end
	ISteamFriends.get_friend_count_from_source = ISteamFriends.GetFriendCountFromSource

	local GetFriendFromSourceByIndex_native = vtable_entry(this, 25, "void(__thiscall*)(void*, SteamID *, SteamID, int)")
	function ISteamFriends.GetFriendFromSourceByIndex(steamIDSource, iFriend)
		steamIDSource = to_steamid_required(steamIDSource, "steamid_source is required")
		local CSteamID_out = new_SteamID_arr()
		GetFriendFromSourceByIndex_native(this, CSteamID_out, steamIDSource, iFriend)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamFriends.get_friend_from_source_by_index = ISteamFriends.GetFriendFromSourceByIndex

	local IsUserInSource_native = vtable_entry(this, 26, "bool(__thiscall*)(void*, SteamID, SteamID)")
	function ISteamFriends.IsUserInSource(steamIDUser, steamIDSource)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		steamIDSource = to_steamid_required(steamIDSource, "steamid_source is required")
		return IsUserInSource_native(this, steamIDUser, steamIDSource)
	end
	ISteamFriends.is_user_in_source = ISteamFriends.IsUserInSource

	local SetInGameVoiceSpeaking_native = vtable_entry(this, 27, "void(__thiscall*)(void*, SteamID, bool)")
	function ISteamFriends.SetInGameVoiceSpeaking(steamIDUser, bSpeaking)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return SetInGameVoiceSpeaking_native(this, steamIDUser, bSpeaking)
	end
	ISteamFriends.set_in_game_voice_speaking = ISteamFriends.SetInGameVoiceSpeaking

	local ActivateGameOverlay_native = vtable_entry(this, 28, "void(__thiscall*)(void*, const char *)")
	function ISteamFriends.ActivateGameOverlay(pchDialog)
		return ActivateGameOverlay_native(this, pchDialog)
	end
	ISteamFriends.activate_game_overlay = ISteamFriends.ActivateGameOverlay

	local ActivateGameOverlayToUser_native = vtable_entry(this, 29, "void(__thiscall*)(void*, const char *, SteamID)")
	function ISteamFriends.ActivateGameOverlayToUser(pchDialog, steamID)
		steamID = to_steamid_required(steamID, "steamid is required")
		return ActivateGameOverlayToUser_native(this, pchDialog, steamID)
	end
	ISteamFriends.activate_game_overlay_to_user = ISteamFriends.ActivateGameOverlayToUser

	local ActivateGameOverlayToWebPage_native = vtable_entry(this, 30, "void(__thiscall*)(void*, const char *, int)")
	function ISteamFriends.ActivateGameOverlayToWebPage(pchURL, eMode)
		eMode = to_enum_required(eMode, enums.EActivateGameOverlayToWebPageMode, "mode is required")
		return ActivateGameOverlayToWebPage_native(this, pchURL, eMode)
	end
	ISteamFriends.activate_game_overlay_to_web_page = ISteamFriends.ActivateGameOverlayToWebPage

	local ActivateGameOverlayToStore_native = vtable_entry(this, 31, "void(__thiscall*)(void*, unsigned int, int)")
	function ISteamFriends.ActivateGameOverlayToStore(nAppID, eFlag)
		eFlag = to_enum_required(eFlag, enums.EOverlayToStoreFlag, "flag is required")
		return ActivateGameOverlayToStore_native(this, nAppID, eFlag)
	end
	ISteamFriends.activate_game_overlay_to_store = ISteamFriends.ActivateGameOverlayToStore

	local SetPlayedWith_native = vtable_entry(this, 32, "void(__thiscall*)(void*, SteamID)")
	function ISteamFriends.SetPlayedWith(steamIDUserPlayedWith)
		steamIDUserPlayedWith = to_steamid_required(steamIDUserPlayedWith, "steamid_user_played_with is required")
		return SetPlayedWith_native(this, steamIDUserPlayedWith)
	end
	ISteamFriends.set_played_with = ISteamFriends.SetPlayedWith

	local ActivateGameOverlayInviteDialog_native = vtable_entry(this, 33, "void(__thiscall*)(void*, SteamID)")
	function ISteamFriends.ActivateGameOverlayInviteDialog(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return ActivateGameOverlayInviteDialog_native(this, steamIDLobby)
	end
	ISteamFriends.activate_game_overlay_invite_dialog = ISteamFriends.ActivateGameOverlayInviteDialog

	local GetSmallFriendAvatar_native = vtable_entry(this, 34, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetSmallFriendAvatar(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetSmallFriendAvatar_native(this, steamIDFriend)
	end
	ISteamFriends.get_small_friend_avatar = ISteamFriends.GetSmallFriendAvatar

	local GetMediumFriendAvatar_native = vtable_entry(this, 35, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetMediumFriendAvatar(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetMediumFriendAvatar_native(this, steamIDFriend)
	end
	ISteamFriends.get_medium_friend_avatar = ISteamFriends.GetMediumFriendAvatar

	local GetLargeFriendAvatar_native = vtable_entry(this, 36, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetLargeFriendAvatar(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetLargeFriendAvatar_native(this, steamIDFriend)
	end
	ISteamFriends.get_large_friend_avatar = ISteamFriends.GetLargeFriendAvatar

	local RequestUserInformation_native = vtable_entry(this, 37, "bool(__thiscall*)(void*, SteamID, bool)")
	function ISteamFriends.RequestUserInformation(steamIDUser, bRequireNameOnly)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return RequestUserInformation_native(this, steamIDUser, bRequireNameOnly)
	end
	ISteamFriends.request_user_information = ISteamFriends.RequestUserInformation

	local RequestClanOfficerList_native = vtable_entry(this, 38, "uint64_t(__thiscall*)(void*, SteamID)")
	local RequestClanOfficerList_info = {
		struct = typeof([[
			struct {
				SteamID m_steamIDClan;
				int m_cOfficers;
				bool m_bSuccess;
			} *
		]]),
		keys = {m_steamIDClan="steamid_clan",m_cOfficers="officers",m_bSuccess="success"}
	}
	function ISteamFriends.RequestClanOfficerList(steamIDClan, callback)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestClanOfficerList_native(this, steamIDClan)

		if callback ~= nil then
			res = register_call_result(res, callback, 335, RequestClanOfficerList_info)
		end

		return res
	end
	ISteamFriends.request_clan_officer_list = ISteamFriends.RequestClanOfficerList

	local GetClanOwner_native = vtable_entry(this, 39, "void(__thiscall*)(void*, SteamID *, SteamID)")
	function ISteamFriends.GetClanOwner(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		local CSteamID_out = new_SteamID_arr()
		GetClanOwner_native(this, CSteamID_out, steamIDClan)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamFriends.get_clan_owner = ISteamFriends.GetClanOwner

	local GetClanOfficerCount_native = vtable_entry(this, 40, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetClanOfficerCount(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		return GetClanOfficerCount_native(this, steamIDClan)
	end
	ISteamFriends.get_clan_officer_count = ISteamFriends.GetClanOfficerCount

	local GetClanOfficerByIndex_native = vtable_entry(this, 41, "void(__thiscall*)(void*, SteamID *, SteamID, int)")
	function ISteamFriends.GetClanOfficerByIndex(steamIDClan, iOfficer)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		local CSteamID_out = new_SteamID_arr()
		GetClanOfficerByIndex_native(this, CSteamID_out, steamIDClan, iOfficer)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamFriends.get_clan_officer_by_index = ISteamFriends.GetClanOfficerByIndex

	local GetUserRestrictions_native = vtable_entry(this, 42, "uint32_t(__thiscall*)(void*)")
	function ISteamFriends.GetUserRestrictions()
		return GetUserRestrictions_native(this)
	end
	ISteamFriends.get_user_restrictions = ISteamFriends.GetUserRestrictions

	local SetRichPresence_native = vtable_entry(this, 43, "bool(__thiscall*)(void*, const char *, const char *)")
	function ISteamFriends.SetRichPresence(pchKey, pchValue)
		return SetRichPresence_native(this, pchKey, pchValue)
	end
	ISteamFriends.set_rich_presence = ISteamFriends.SetRichPresence

	local ClearRichPresence_native = vtable_entry(this, 44, "void(__thiscall*)(void*)")
	function ISteamFriends.ClearRichPresence()
		return ClearRichPresence_native(this)
	end
	ISteamFriends.clear_rich_presence = ISteamFriends.ClearRichPresence

	local GetFriendRichPresence_native = vtable_entry(this, 45, "const char *(__thiscall*)(void*, SteamID, const char *)")
	function ISteamFriends.GetFriendRichPresence(steamIDFriend, pchKey)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		local res = GetFriendRichPresence_native(this, steamIDFriend, pchKey)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_friend_rich_presence = ISteamFriends.GetFriendRichPresence

	local GetFriendRichPresenceKeyCount_native = vtable_entry(this, 46, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendRichPresenceKeyCount(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetFriendRichPresenceKeyCount_native(this, steamIDFriend)
	end
	ISteamFriends.get_friend_rich_presence_key_count = ISteamFriends.GetFriendRichPresenceKeyCount

	local GetFriendRichPresenceKeyByIndex_native = vtable_entry(this, 47, "const char *(__thiscall*)(void*, SteamID, int)")
	function ISteamFriends.GetFriendRichPresenceKeyByIndex(steamIDFriend, iKey)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		local res = GetFriendRichPresenceKeyByIndex_native(this, steamIDFriend, iKey)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamFriends.get_friend_rich_presence_key_by_index = ISteamFriends.GetFriendRichPresenceKeyByIndex

	local RequestFriendRichPresence_native = vtable_entry(this, 48, "void(__thiscall*)(void*, SteamID)")
	function ISteamFriends.RequestFriendRichPresence(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return RequestFriendRichPresence_native(this, steamIDFriend)
	end
	ISteamFriends.request_friend_rich_presence = ISteamFriends.RequestFriendRichPresence

	local InviteUserToGame_native = vtable_entry(this, 49, "bool(__thiscall*)(void*, SteamID, const char *)")
	function ISteamFriends.InviteUserToGame(steamIDFriend, pchConnectString)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return InviteUserToGame_native(this, steamIDFriend, pchConnectString)
	end
	ISteamFriends.invite_user_to_game = ISteamFriends.InviteUserToGame

	local GetCoplayFriendCount_native = vtable_entry(this, 50, "int(__thiscall*)(void*)")
	function ISteamFriends.GetCoplayFriendCount()
		return GetCoplayFriendCount_native(this)
	end
	ISteamFriends.get_coplay_friend_count = ISteamFriends.GetCoplayFriendCount

	local GetCoplayFriend_native = vtable_entry(this, 51, "void(__thiscall*)(void*, SteamID *, int)")
	function ISteamFriends.GetCoplayFriend(iCoplayFriend)
		local CSteamID_out = new_SteamID_arr()
		GetCoplayFriend_native(this, CSteamID_out, iCoplayFriend)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamFriends.get_coplay_friend = ISteamFriends.GetCoplayFriend

	local GetFriendCoplayTime_native = vtable_entry(this, 52, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendCoplayTime(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetFriendCoplayTime_native(this, steamIDFriend)
	end
	ISteamFriends.get_friend_coplay_time = ISteamFriends.GetFriendCoplayTime

	local GetFriendCoplayGame_native = vtable_entry(this, 53, "unsigned int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetFriendCoplayGame(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return GetFriendCoplayGame_native(this, steamIDFriend)
	end
	ISteamFriends.get_friend_coplay_game = ISteamFriends.GetFriendCoplayGame

	local JoinClanChatRoom_native = vtable_entry(this, 54, "uint64_t(__thiscall*)(void*, SteamID)")
	local JoinClanChatRoom_info = {
		struct = typeof([[
			struct {
				SteamID m_steamIDClanChat;
				int m_eChatRoomEnterResponse;
			} *
		]]),
		keys = {m_steamIDClanChat="steamid_clan_chat",m_eChatRoomEnterResponse="chat_room_enter_response"}
	}
	function ISteamFriends.JoinClanChatRoom(steamIDClan, callback)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = JoinClanChatRoom_native(this, steamIDClan)

		if callback ~= nil then
			res = register_call_result(res, callback, 342, JoinClanChatRoom_info)
		end

		return res
	end
	ISteamFriends.join_clan_chat_room = ISteamFriends.JoinClanChatRoom

	local LeaveClanChatRoom_native = vtable_entry(this, 55, "bool(__thiscall*)(void*, SteamID)")
	function ISteamFriends.LeaveClanChatRoom(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		return LeaveClanChatRoom_native(this, steamIDClan)
	end
	ISteamFriends.leave_clan_chat_room = ISteamFriends.LeaveClanChatRoom

	local GetClanChatMemberCount_native = vtable_entry(this, 56, "int(__thiscall*)(void*, SteamID)")
	function ISteamFriends.GetClanChatMemberCount(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		return GetClanChatMemberCount_native(this, steamIDClan)
	end
	ISteamFriends.get_clan_chat_member_count = ISteamFriends.GetClanChatMemberCount

	local GetChatMemberByIndex_native = vtable_entry(this, 57, "void(__thiscall*)(void*, SteamID *, SteamID, int)")
	function ISteamFriends.GetChatMemberByIndex(steamIDClan, iUser)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		local CSteamID_out = new_SteamID_arr()
		GetChatMemberByIndex_native(this, CSteamID_out, steamIDClan, iUser)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamFriends.get_chat_member_by_index = ISteamFriends.GetChatMemberByIndex

	local SendClanChatMessage_native = vtable_entry(this, 58, "bool(__thiscall*)(void*, SteamID, const char *)")
	function ISteamFriends.SendClanChatMessage(steamIDClanChat, pchText)
		steamIDClanChat = to_steamid_required(steamIDClanChat, "steamid_clan_chat is required")
		return SendClanChatMessage_native(this, steamIDClanChat, pchText)
	end
	ISteamFriends.send_clan_chat_message = ISteamFriends.SendClanChatMessage

	local GetClanChatMessage_native = vtable_entry(this, 59, "int(__thiscall*)(void*, SteamID, int, void *, int, int *, SteamID *)")
	function ISteamFriends.GetClanChatMessage(steamIDClanChat, iMessage, prgchText, cchTextMax)
		steamIDClanChat = to_steamid_required(steamIDClanChat, "steamid_clan_chat is required")
		local peChatEntryType_out = new_int_arr()
		local psteamidChatter_out = new_SteamID_arr()
		local res = GetClanChatMessage_native(this, steamIDClanChat, iMessage, prgchText, cchTextMax, peChatEntryType_out, psteamidChatter_out)

		return res, DEREF_GCSAFE(peChatEntryType_out), DEREF_GCSAFE(psteamidChatter_out)
	end
	ISteamFriends.get_clan_chat_message = ISteamFriends.GetClanChatMessage

	local IsClanChatAdmin_native = vtable_entry(this, 60, "bool(__thiscall*)(void*, SteamID, SteamID)")
	function ISteamFriends.IsClanChatAdmin(steamIDClanChat, steamIDUser)
		steamIDClanChat = to_steamid_required(steamIDClanChat, "steamid_clan_chat is required")
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return IsClanChatAdmin_native(this, steamIDClanChat, steamIDUser)
	end
	ISteamFriends.is_clan_chat_admin = ISteamFriends.IsClanChatAdmin

	local IsClanChatWindowOpenInSteam_native = vtable_entry(this, 61, "bool(__thiscall*)(void*, SteamID)")
	function ISteamFriends.IsClanChatWindowOpenInSteam(steamIDClanChat)
		steamIDClanChat = to_steamid_required(steamIDClanChat, "steamid_clan_chat is required")
		return IsClanChatWindowOpenInSteam_native(this, steamIDClanChat)
	end
	ISteamFriends.is_clan_chat_window_open_in_steam = ISteamFriends.IsClanChatWindowOpenInSteam

	local OpenClanChatWindowInSteam_native = vtable_entry(this, 62, "bool(__thiscall*)(void*, SteamID)")
	function ISteamFriends.OpenClanChatWindowInSteam(steamIDClanChat)
		steamIDClanChat = to_steamid_required(steamIDClanChat, "steamid_clan_chat is required")
		return OpenClanChatWindowInSteam_native(this, steamIDClanChat)
	end
	ISteamFriends.open_clan_chat_window_in_steam = ISteamFriends.OpenClanChatWindowInSteam

	local CloseClanChatWindowInSteam_native = vtable_entry(this, 63, "bool(__thiscall*)(void*, SteamID)")
	function ISteamFriends.CloseClanChatWindowInSteam(steamIDClanChat)
		steamIDClanChat = to_steamid_required(steamIDClanChat, "steamid_clan_chat is required")
		return CloseClanChatWindowInSteam_native(this, steamIDClanChat)
	end
	ISteamFriends.close_clan_chat_window_in_steam = ISteamFriends.CloseClanChatWindowInSteam

	local SetListenForFriendsMessages_native = vtable_entry(this, 64, "bool(__thiscall*)(void*, bool)")
	function ISteamFriends.SetListenForFriendsMessages(bInterceptEnabled)
		return SetListenForFriendsMessages_native(this, bInterceptEnabled)
	end
	ISteamFriends.set_listen_for_friends_messages = ISteamFriends.SetListenForFriendsMessages

	local ReplyToFriendMessage_native = vtable_entry(this, 65, "bool(__thiscall*)(void*, SteamID, const char *)")
	function ISteamFriends.ReplyToFriendMessage(steamIDFriend, pchMsgToSend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return ReplyToFriendMessage_native(this, steamIDFriend, pchMsgToSend)
	end
	ISteamFriends.reply_to_friend_message = ISteamFriends.ReplyToFriendMessage

	local GetFriendMessage_native = vtable_entry(this, 66, "int(__thiscall*)(void*, SteamID, int, void *, int, int *)")
	function ISteamFriends.GetFriendMessage(steamIDFriend, iMessageID, pvData, cubData)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		local peChatEntryType_out = new_int_arr()
		local res = GetFriendMessage_native(this, steamIDFriend, iMessageID, pvData, cubData, peChatEntryType_out)

		return res, DEREF_GCSAFE(peChatEntryType_out)
	end
	ISteamFriends.get_friend_message = ISteamFriends.GetFriendMessage

	local GetFollowerCount_native = vtable_entry(this, 67, "uint64_t(__thiscall*)(void*, SteamID)")
	local GetFollowerCount_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				SteamID m_steamID;
				int m_nCount;
			} *
		]]),
		keys = {m_eResult="result",m_steamID="steamid",m_nCount="count"}
	}
	function ISteamFriends.GetFollowerCount(steamID, callback)
		steamID = to_steamid_required(steamID, "steamid is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = GetFollowerCount_native(this, steamID)

		if callback ~= nil then
			res = register_call_result(res, callback, 344, GetFollowerCount_info)
		end

		return res
	end
	ISteamFriends.get_follower_count = ISteamFriends.GetFollowerCount

	local IsFollowing_native = vtable_entry(this, 68, "uint64_t(__thiscall*)(void*, SteamID)")
	local IsFollowing_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				SteamID m_steamID;
				bool m_bIsFollowing;
			} *
		]]),
		keys = {m_eResult="result",m_steamID="steamid",m_bIsFollowing="is_following"}
	}
	function ISteamFriends.IsFollowing(steamID, callback)
		steamID = to_steamid_required(steamID, "steamid is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = IsFollowing_native(this, steamID)

		if callback ~= nil then
			res = register_call_result(res, callback, 345, IsFollowing_info)
		end

		return res
	end
	ISteamFriends.is_following = ISteamFriends.IsFollowing

	local EnumerateFollowingList_native = vtable_entry(this, 69, "uint64_t(__thiscall*)(void*, uint32_t)")
	local EnumerateFollowingList_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				SteamID m_rgSteamID[50];
				int32_t m_nResultsReturned;
				int32_t m_nTotalResultCount;
			} *
		]]),
		keys = {m_eResult="result",m_rgSteamID="steamid",m_nResultsReturned="results_returned",m_nTotalResultCount="total_result_count"}
	}
	function ISteamFriends.EnumerateFollowingList(unStartIndex, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = EnumerateFollowingList_native(this, unStartIndex)

		if callback ~= nil then
			res = register_call_result(res, callback, 346, EnumerateFollowingList_info)
		end

		return res
	end
	ISteamFriends.enumerate_following_list = ISteamFriends.EnumerateFollowingList

	local IsClanPublic_native = vtable_entry(this, 70, "bool(__thiscall*)(void*, SteamID)")
	function ISteamFriends.IsClanPublic(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		return IsClanPublic_native(this, steamIDClan)
	end
	ISteamFriends.is_clan_public = ISteamFriends.IsClanPublic

	local IsClanOfficialGameGroup_native = vtable_entry(this, 71, "bool(__thiscall*)(void*, SteamID)")
	function ISteamFriends.IsClanOfficialGameGroup(steamIDClan)
		steamIDClan = to_steamid_required(steamIDClan, "steamid_clan is required")
		return IsClanOfficialGameGroup_native(this, steamIDClan)
	end
	ISteamFriends.is_clan_official_game_group = ISteamFriends.IsClanOfficialGameGroup

	local GetNumChatsWithUnreadPriorityMessages_native = vtable_entry(this, 72, "int(__thiscall*)(void*)")
	function ISteamFriends.GetNumChatsWithUnreadPriorityMessages()
		return GetNumChatsWithUnreadPriorityMessages_native(this)
	end
	ISteamFriends.get_num_chats_with_unread_priority_messages = ISteamFriends.GetNumChatsWithUnreadPriorityMessages

	local ActivateGameOverlayRemotePlayTogetherInviteDialog_native = vtable_entry(this, 73, "void(__thiscall*)(void*, SteamID)")
	function ISteamFriends.ActivateGameOverlayRemotePlayTogetherInviteDialog(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return ActivateGameOverlayRemotePlayTogetherInviteDialog_native(this, steamIDLobby)
	end
	ISteamFriends.activate_game_overlay_remote_play_together_invite_dialog = ISteamFriends.ActivateGameOverlayRemotePlayTogetherInviteDialog

	local RegisterProtocolInOverlayBrowser_native = vtable_entry(this, 74, "bool(__thiscall*)(void*, const char *)")
	function ISteamFriends.RegisterProtocolInOverlayBrowser(pchProtocol)
		return RegisterProtocolInOverlayBrowser_native(this, pchProtocol)
	end
	ISteamFriends.register_protocol_in_overlay_browser = ISteamFriends.RegisterProtocolInOverlayBrowser

	local ActivateGameOverlayInviteDialogConnectString_native = vtable_entry(this, 75, "void(__thiscall*)(void*, const char *)")
	function ISteamFriends.ActivateGameOverlayInviteDialogConnectString(pchConnectString)
		return ActivateGameOverlayInviteDialogConnectString_native(this, pchConnectString)
	end
	ISteamFriends.activate_game_overlay_invite_dialog_connect_string = ISteamFriends.ActivateGameOverlayInviteDialogConnectString

	return ISteamFriends
end

--
-- ISteamUtils (SteamUtils010, user created: false)
--

local ISteamUtils = {version="SteamUtils010",version_number=10}

index_funcs.ISteamUtils = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 9, "void*(__thiscall*)(void*, int, const char *)")(hSteamPipe, "SteamUtils010")

	local GetSecondsSinceAppActive_native = vtable_entry(this, 0, "uint32_t(__thiscall*)(void*)")
	function ISteamUtils.GetSecondsSinceAppActive()
		return GetSecondsSinceAppActive_native(this)
	end
	ISteamUtils.get_seconds_since_app_active = ISteamUtils.GetSecondsSinceAppActive

	local GetSecondsSinceComputerActive_native = vtable_entry(this, 1, "uint32_t(__thiscall*)(void*)")
	function ISteamUtils.GetSecondsSinceComputerActive()
		return GetSecondsSinceComputerActive_native(this)
	end
	ISteamUtils.get_seconds_since_computer_active = ISteamUtils.GetSecondsSinceComputerActive

	local GetConnectedUniverse_native = vtable_entry(this, 2, "int(__thiscall*)(void*)")
	function ISteamUtils.GetConnectedUniverse()
		return GetConnectedUniverse_native(this)
	end
	ISteamUtils.get_connected_universe = ISteamUtils.GetConnectedUniverse

	local GetServerRealTime_native = vtable_entry(this, 3, "uint32_t(__thiscall*)(void*)")
	function ISteamUtils.GetServerRealTime()
		return GetServerRealTime_native(this)
	end
	ISteamUtils.get_server_real_time = ISteamUtils.GetServerRealTime

	local GetIPCountry_native = vtable_entry(this, 4, "const char *(__thiscall*)(void*)")
	function ISteamUtils.GetIPCountry()
		local res = GetIPCountry_native(this)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamUtils.get_ip_country = ISteamUtils.GetIPCountry

	local GetImageSize_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, int, uint32_t *, uint32_t *)")
	function ISteamUtils.GetImageSize(iImage)
		local pnWidth_out = new_uint32_arr()
		local pnHeight_out = new_uint32_arr()
		local res = GetImageSize_native(this, iImage, pnWidth_out, pnHeight_out)

		return res, DEREF_GCSAFE(pnWidth_out), DEREF_GCSAFE(pnHeight_out)
	end
	ISteamUtils.get_image_size = ISteamUtils.GetImageSize

	local GetImageRGBA_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, int, uint8_t *, int)")
	function ISteamUtils.GetImageRGBA(iImage, pubDest, nDestBufferSize)
		return GetImageRGBA_native(this, iImage, pubDest, nDestBufferSize)
	end
	ISteamUtils.get_image_rgba = ISteamUtils.GetImageRGBA

	local GetCurrentBatteryPower_native = vtable_entry(this, 8, "uint8_t(__thiscall*)(void*)")
	function ISteamUtils.GetCurrentBatteryPower()
		return GetCurrentBatteryPower_native(this)
	end
	ISteamUtils.get_current_battery_power = ISteamUtils.GetCurrentBatteryPower

	local GetAppID_native = vtable_entry(this, 9, "uint32_t(__thiscall*)(void*)")
	function ISteamUtils.GetAppID()
		return GetAppID_native(this)
	end
	ISteamUtils.get_appid = ISteamUtils.GetAppID

	local SetOverlayNotificationPosition_native = vtable_entry(this, 10, "void(__thiscall*)(void*, int)")
	function ISteamUtils.SetOverlayNotificationPosition(eNotificationPosition)
		eNotificationPosition = to_enum_required(eNotificationPosition, enums.ENotificationPosition, "notification_position is required")
		return SetOverlayNotificationPosition_native(this, eNotificationPosition)
	end
	ISteamUtils.set_overlay_notification_position = ISteamUtils.SetOverlayNotificationPosition

	local IsAPICallCompleted_native = vtable_entry(this, 11, "bool(__thiscall*)(void*, uint64_t, bool *)")
	function ISteamUtils.IsAPICallCompleted(hSteamAPICall)
		local pbFailed_out = new_bool_arr()
		local res = IsAPICallCompleted_native(this, hSteamAPICall, pbFailed_out)

		return res, DEREF_GCSAFE(pbFailed_out)
	end
	ISteamUtils.is_api_call_completed = ISteamUtils.IsAPICallCompleted

	local GetAPICallFailureReason_native = vtable_entry(this, 12, "int(__thiscall*)(void*, uint64_t)")
	function ISteamUtils.GetAPICallFailureReason(hSteamAPICall)
		return GetAPICallFailureReason_native(this, hSteamAPICall)
	end
	ISteamUtils.get_api_call_failure_reason = ISteamUtils.GetAPICallFailureReason

	local GetAPICallResult_native = vtable_entry(this, 13, "bool(__thiscall*)(void*, uint64_t, void *, int, int, bool *)")
	function ISteamUtils.GetAPICallResult(hSteamAPICall, pCallback, cubCallback, iCallbackExpected)
		local pbFailed_out = new_bool_arr()
		local res = GetAPICallResult_native(this, hSteamAPICall, pCallback, cubCallback, iCallbackExpected, pbFailed_out)

		return res, DEREF_GCSAFE(pbFailed_out)
	end
	ISteamUtils.get_api_call_result = ISteamUtils.GetAPICallResult

	local GetIPCCallCount_native = vtable_entry(this, 15, "uint32_t(__thiscall*)(void*)")
	function ISteamUtils.GetIPCCallCount()
		return GetIPCCallCount_native(this)
	end
	ISteamUtils.get_ipc_call_count = ISteamUtils.GetIPCCallCount

	local SetWarningMessageHook_native = vtable_entry(this, 16, "void(__thiscall*)(void*, void*(__cdecl*)(int, const char*))")
	function ISteamUtils.SetWarningMessageHook(pFunction)
		return SetWarningMessageHook_native(this, pFunction)
	end
	ISteamUtils.set_warning_message_hook = ISteamUtils.SetWarningMessageHook

	local IsOverlayEnabled_native = vtable_entry(this, 17, "bool(__thiscall*)(void*)")
	function ISteamUtils.IsOverlayEnabled()
		return IsOverlayEnabled_native(this)
	end
	ISteamUtils.is_overlay_enabled = ISteamUtils.IsOverlayEnabled

	local BOverlayNeedsPresent_native = vtable_entry(this, 18, "bool(__thiscall*)(void*)")
	function ISteamUtils.BOverlayNeedsPresent()
		return BOverlayNeedsPresent_native(this)
	end
	ISteamUtils.overlay_needs_present = ISteamUtils.BOverlayNeedsPresent

	local CheckFileSignature_native = vtable_entry(this, 19, "uint64_t(__thiscall*)(void*, const char *)")
	local CheckFileSignature_info = {
		struct = typeof([[
			struct {
				int m_eCheckFileSignature;
			} *
		]]),
		keys = {m_eCheckFileSignature="check_file_signature"}
	}
	function ISteamUtils.CheckFileSignature(szFileName, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = CheckFileSignature_native(this, szFileName)

		if callback ~= nil then
			res = register_call_result(res, callback, 705, CheckFileSignature_info)
		end

		return res
	end
	ISteamUtils.check_file_signature = ISteamUtils.CheckFileSignature

	local ShowGamepadTextInput_native = vtable_entry(this, 20, "bool(__thiscall*)(void*, int, int, const char *, uint32_t, const char *)")
	function ISteamUtils.ShowGamepadTextInput(eInputMode, eLineInputMode, pchDescription, unCharMax, pchExistingText)
		eInputMode = to_enum_required(eInputMode, enums.EGamepadTextInputMode, "input_mode is required")
		eLineInputMode = to_enum_required(eLineInputMode, enums.EGamepadTextInputLineMode, "line_input_mode is required")
		return ShowGamepadTextInput_native(this, eInputMode, eLineInputMode, pchDescription, unCharMax, pchExistingText)
	end
	ISteamUtils.show_gamepad_text_input = ISteamUtils.ShowGamepadTextInput

	local GetEnteredGamepadTextLength_native = vtable_entry(this, 21, "uint32_t(__thiscall*)(void*)")
	function ISteamUtils.GetEnteredGamepadTextLength()
		return GetEnteredGamepadTextLength_native(this)
	end
	ISteamUtils.get_entered_gamepad_text_length = ISteamUtils.GetEnteredGamepadTextLength

	local GetEnteredGamepadTextInput_native = vtable_entry(this, 22, "bool(__thiscall*)(void*, char *, uint32_t)")
	function ISteamUtils.GetEnteredGamepadTextInput(pchText, cchText)
		return GetEnteredGamepadTextInput_native(this, pchText, cchText)
	end
	ISteamUtils.get_entered_gamepad_text_input = ISteamUtils.GetEnteredGamepadTextInput

	local GetSteamUILanguage_native = vtable_entry(this, 23, "const char *(__thiscall*)(void*)")
	function ISteamUtils.GetSteamUILanguage()
		local res = GetSteamUILanguage_native(this)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamUtils.get_steam_ui_language = ISteamUtils.GetSteamUILanguage

	local IsSteamRunningInVR_native = vtable_entry(this, 24, "bool(__thiscall*)(void*)")
	function ISteamUtils.IsSteamRunningInVR()
		return IsSteamRunningInVR_native(this)
	end
	ISteamUtils.is_steam_running_in_vr = ISteamUtils.IsSteamRunningInVR

	local SetOverlayNotificationInset_native = vtable_entry(this, 25, "void(__thiscall*)(void*, int, int)")
	function ISteamUtils.SetOverlayNotificationInset(nHorizontalInset, nVerticalInset)
		return SetOverlayNotificationInset_native(this, nHorizontalInset, nVerticalInset)
	end
	ISteamUtils.set_overlay_notification_inset = ISteamUtils.SetOverlayNotificationInset

	local IsSteamInBigPictureMode_native = vtable_entry(this, 26, "bool(__thiscall*)(void*)")
	function ISteamUtils.IsSteamInBigPictureMode()
		return IsSteamInBigPictureMode_native(this)
	end
	ISteamUtils.is_steam_in_big_picture_mode = ISteamUtils.IsSteamInBigPictureMode

	local StartVRDashboard_native = vtable_entry(this, 27, "void(__thiscall*)(void*)")
	function ISteamUtils.StartVRDashboard()
		return StartVRDashboard_native(this)
	end
	ISteamUtils.start_vr_dashboard = ISteamUtils.StartVRDashboard

	local IsVRHeadsetStreamingEnabled_native = vtable_entry(this, 28, "bool(__thiscall*)(void*)")
	function ISteamUtils.IsVRHeadsetStreamingEnabled()
		return IsVRHeadsetStreamingEnabled_native(this)
	end
	ISteamUtils.is_vr_headset_streaming_enabled = ISteamUtils.IsVRHeadsetStreamingEnabled

	local SetVRHeadsetStreamingEnabled_native = vtable_entry(this, 29, "void(__thiscall*)(void*, bool)")
	function ISteamUtils.SetVRHeadsetStreamingEnabled(bEnabled)
		return SetVRHeadsetStreamingEnabled_native(this, bEnabled)
	end
	ISteamUtils.set_vr_headset_streaming_enabled = ISteamUtils.SetVRHeadsetStreamingEnabled

	local IsSteamChinaLauncher_native = vtable_entry(this, 30, "bool(__thiscall*)(void*)")
	function ISteamUtils.IsSteamChinaLauncher()
		return IsSteamChinaLauncher_native(this)
	end
	ISteamUtils.is_steam_china_launcher = ISteamUtils.IsSteamChinaLauncher

	local InitFilterText_native = vtable_entry(this, 31, "bool(__thiscall*)(void*, uint32_t)")
	function ISteamUtils.InitFilterText(unFilterOptions)
		return InitFilterText_native(this, unFilterOptions)
	end
	ISteamUtils.init_filter_text = ISteamUtils.InitFilterText

	local FilterText_native = vtable_entry(this, 32, "int(__thiscall*)(void*, int, SteamID, const char *, char *, uint32_t)")
	function ISteamUtils.FilterText(eContext, sourceSteamID, pchInputMessage, pchOutFilteredText, nByteSizeOutFilteredText)
		eContext = to_enum_required(eContext, enums.ETextFilteringContext, "context is required")
		sourceSteamID = to_steamid_required(sourceSteamID, "source_steamid is required")
		return FilterText_native(this, eContext, sourceSteamID, pchInputMessage, pchOutFilteredText, nByteSizeOutFilteredText)
	end
	ISteamUtils.filter_text = ISteamUtils.FilterText

	local GetIPv6ConnectivityState_native = vtable_entry(this, 33, "int(__thiscall*)(void*, int)")
	function ISteamUtils.GetIPv6ConnectivityState(eProtocol)
		eProtocol = to_enum_required(eProtocol, enums.ESteamIPv6ConnectivityProtocol, "protocol is required")
		return GetIPv6ConnectivityState_native(this, eProtocol)
	end
	ISteamUtils.get_ipv6_connectivity_state = ISteamUtils.GetIPv6ConnectivityState

	return ISteamUtils
end

--
-- ISteamMatchmaking (SteamMatchMaking009, user created: false)
--

local ISteamMatchmaking = {version="SteamMatchMaking009",version_number=9}

index_funcs.ISteamMatchmaking = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 10, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "SteamMatchMaking009")

	local GetFavoriteGameCount_native = vtable_entry(this, 0, "int(__thiscall*)(void*)")
	function ISteamMatchmaking.GetFavoriteGameCount()
		return GetFavoriteGameCount_native(this)
	end
	ISteamMatchmaking.get_favorite_game_count = ISteamMatchmaking.GetFavoriteGameCount

	local GetFavoriteGame_native = vtable_entry(this, 1, "bool(__thiscall*)(void*, int, unsigned int *, uint32_t *, uint16_t *, uint16_t *, uint32_t *, uint32_t *)")
	function ISteamMatchmaking.GetFavoriteGame(iGame)
		local pnAppID_out = new_unsigned_int_arr()
		local pnIP_out = new_uint32_arr()
		local pnConnPort_out = new_uint16_arr()
		local pnQueryPort_out = new_uint16_arr()
		local punFlags_out = new_uint32_arr()
		local pRTime32LastPlayedOnServer_out = new_uint32_arr()
		local res = GetFavoriteGame_native(this, iGame, pnAppID_out, pnIP_out, pnConnPort_out, pnQueryPort_out, punFlags_out, pRTime32LastPlayedOnServer_out)

		return res, DEREF_GCSAFE(pnAppID_out), DEREF_GCSAFE(pnIP_out), DEREF_GCSAFE(pnConnPort_out), DEREF_GCSAFE(pnQueryPort_out), DEREF_GCSAFE(punFlags_out), DEREF_GCSAFE(pRTime32LastPlayedOnServer_out)
	end
	ISteamMatchmaking.get_favorite_game = ISteamMatchmaking.GetFavoriteGame

	local AddFavoriteGame_native = vtable_entry(this, 2, "int(__thiscall*)(void*, unsigned int, uint32_t, uint16_t, uint16_t, uint32_t, uint32_t)")
	function ISteamMatchmaking.AddFavoriteGame(nAppID, nIP, nConnPort, nQueryPort, unFlags, rTime32LastPlayedOnServer)
		return AddFavoriteGame_native(this, nAppID, nIP, nConnPort, nQueryPort, unFlags, rTime32LastPlayedOnServer)
	end
	ISteamMatchmaking.add_favorite_game = ISteamMatchmaking.AddFavoriteGame

	local RemoveFavoriteGame_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, unsigned int, uint32_t, uint16_t, uint16_t, uint32_t)")
	function ISteamMatchmaking.RemoveFavoriteGame(nAppID, nIP, nConnPort, nQueryPort, unFlags)
		return RemoveFavoriteGame_native(this, nAppID, nIP, nConnPort, nQueryPort, unFlags)
	end
	ISteamMatchmaking.remove_favorite_game = ISteamMatchmaking.RemoveFavoriteGame

	local RequestLobbyList_native = vtable_entry(this, 4, "uint64_t(__thiscall*)(void*)")
	local RequestLobbyList_info = {
		struct = typeof([[
			struct {
				uint32_t m_nLobbiesMatching;
			} *
		]]),
		keys = {m_nLobbiesMatching="lobbies_matching"}
	}
	function ISteamMatchmaking.RequestLobbyList(callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestLobbyList_native(this)

		if callback ~= nil then
			res = register_call_result(res, callback, 510, RequestLobbyList_info)
		end

		return res
	end
	ISteamMatchmaking.request_lobby_list = ISteamMatchmaking.RequestLobbyList

	local AddRequestLobbyListStringFilter_native = vtable_entry(this, 5, "void(__thiscall*)(void*, const char *, const char *, int)")
	function ISteamMatchmaking.AddRequestLobbyListStringFilter(pchKeyToMatch, pchValueToMatch, eComparisonType)
		eComparisonType = to_enum_required(eComparisonType, enums.ELobbyComparison, "comparison_type is required")
		return AddRequestLobbyListStringFilter_native(this, pchKeyToMatch, pchValueToMatch, eComparisonType)
	end
	ISteamMatchmaking.add_request_lobby_list_string_filter = ISteamMatchmaking.AddRequestLobbyListStringFilter

	local AddRequestLobbyListNumericalFilter_native = vtable_entry(this, 6, "void(__thiscall*)(void*, const char *, int, int)")
	function ISteamMatchmaking.AddRequestLobbyListNumericalFilter(pchKeyToMatch, nValueToMatch, eComparisonType)
		eComparisonType = to_enum_required(eComparisonType, enums.ELobbyComparison, "comparison_type is required")
		return AddRequestLobbyListNumericalFilter_native(this, pchKeyToMatch, nValueToMatch, eComparisonType)
	end
	ISteamMatchmaking.add_request_lobby_list_numerical_filter = ISteamMatchmaking.AddRequestLobbyListNumericalFilter

	local AddRequestLobbyListNearValueFilter_native = vtable_entry(this, 7, "void(__thiscall*)(void*, const char *, int)")
	function ISteamMatchmaking.AddRequestLobbyListNearValueFilter(pchKeyToMatch, nValueToBeCloseTo)
		return AddRequestLobbyListNearValueFilter_native(this, pchKeyToMatch, nValueToBeCloseTo)
	end
	ISteamMatchmaking.add_request_lobby_list_near_value_filter = ISteamMatchmaking.AddRequestLobbyListNearValueFilter

	local AddRequestLobbyListFilterSlotsAvailable_native = vtable_entry(this, 8, "void(__thiscall*)(void*, int)")
	function ISteamMatchmaking.AddRequestLobbyListFilterSlotsAvailable(nSlotsAvailable)
		return AddRequestLobbyListFilterSlotsAvailable_native(this, nSlotsAvailable)
	end
	ISteamMatchmaking.add_request_lobby_list_filter_slots_available = ISteamMatchmaking.AddRequestLobbyListFilterSlotsAvailable

	local AddRequestLobbyListDistanceFilter_native = vtable_entry(this, 9, "void(__thiscall*)(void*, int)")
	function ISteamMatchmaking.AddRequestLobbyListDistanceFilter(eLobbyDistanceFilter)
		eLobbyDistanceFilter = to_enum_required(eLobbyDistanceFilter, enums.ELobbyDistanceFilter, "lobby_distance_filter is required")
		return AddRequestLobbyListDistanceFilter_native(this, eLobbyDistanceFilter)
	end
	ISteamMatchmaking.add_request_lobby_list_distance_filter = ISteamMatchmaking.AddRequestLobbyListDistanceFilter

	local AddRequestLobbyListResultCountFilter_native = vtable_entry(this, 10, "void(__thiscall*)(void*, int)")
	function ISteamMatchmaking.AddRequestLobbyListResultCountFilter(cMaxResults)
		return AddRequestLobbyListResultCountFilter_native(this, cMaxResults)
	end
	ISteamMatchmaking.add_request_lobby_list_result_count_filter = ISteamMatchmaking.AddRequestLobbyListResultCountFilter

	local AddRequestLobbyListCompatibleMembersFilter_native = vtable_entry(this, 11, "void(__thiscall*)(void*, SteamID)")
	function ISteamMatchmaking.AddRequestLobbyListCompatibleMembersFilter(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return AddRequestLobbyListCompatibleMembersFilter_native(this, steamIDLobby)
	end
	ISteamMatchmaking.add_request_lobby_list_compatible_members_filter = ISteamMatchmaking.AddRequestLobbyListCompatibleMembersFilter

	local GetLobbyByIndex_native = vtable_entry(this, 12, "void(__thiscall*)(void*, SteamID *, int)")
	function ISteamMatchmaking.GetLobbyByIndex(iLobby)
		local CSteamID_out = new_SteamID_arr()
		GetLobbyByIndex_native(this, CSteamID_out, iLobby)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamMatchmaking.get_lobby_by_index = ISteamMatchmaking.GetLobbyByIndex

	local CreateLobby_native = vtable_entry(this, 13, "uint64_t(__thiscall*)(void*, int, int)")
	local CreateLobby_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				SteamID m_ulSteamIDLobby;
			} *
		]]),
		keys = {m_eResult="result",m_ulSteamIDLobby="steamid_lobby"}
	}
	function ISteamMatchmaking.CreateLobby(eLobbyType, cMaxMembers, callback)
		eLobbyType = to_enum_required(eLobbyType, enums.ELobbyType, "lobby_type is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = CreateLobby_native(this, eLobbyType, cMaxMembers)

		if callback ~= nil then
			res = register_call_result(res, callback, 513, CreateLobby_info)
		end

		return res
	end
	ISteamMatchmaking.create_lobby = ISteamMatchmaking.CreateLobby

	local JoinLobby_native = vtable_entry(this, 14, "uint64_t(__thiscall*)(void*, SteamID)")
	local JoinLobby_info = {
		struct = typeof([[
			struct {
				SteamID m_ulSteamIDLobby;
				uint32_t m_rgfChatPermissions;
				bool m_bLocked;
				uint32_t m_EChatRoomEnterResponse;
			} *
		]]),
		keys = {m_ulSteamIDLobby="steamid_lobby",m_rgfChatPermissions="chat_permissions",m_bLocked="locked",m_EChatRoomEnterResponse="e_chat_room_enter_response"}
	}
	function ISteamMatchmaking.JoinLobby(steamIDLobby, callback)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = JoinLobby_native(this, steamIDLobby)

		if callback ~= nil then
			res = register_call_result(res, callback, 504, JoinLobby_info)
		end

		return res
	end
	ISteamMatchmaking.join_lobby = ISteamMatchmaking.JoinLobby

	local LeaveLobby_native = vtable_entry(this, 15, "void(__thiscall*)(void*, SteamID)")
	function ISteamMatchmaking.LeaveLobby(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return LeaveLobby_native(this, steamIDLobby)
	end
	ISteamMatchmaking.leave_lobby = ISteamMatchmaking.LeaveLobby

	local InviteUserToLobby_native = vtable_entry(this, 16, "bool(__thiscall*)(void*, SteamID, SteamID)")
	function ISteamMatchmaking.InviteUserToLobby(steamIDLobby, steamIDInvitee)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		steamIDInvitee = to_steamid_required(steamIDInvitee, "steamid_invitee is required")
		return InviteUserToLobby_native(this, steamIDLobby, steamIDInvitee)
	end
	ISteamMatchmaking.invite_user_to_lobby = ISteamMatchmaking.InviteUserToLobby

	local GetNumLobbyMembers_native = vtable_entry(this, 17, "int(__thiscall*)(void*, SteamID)")
	function ISteamMatchmaking.GetNumLobbyMembers(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return GetNumLobbyMembers_native(this, steamIDLobby)
	end
	ISteamMatchmaking.get_num_lobby_members = ISteamMatchmaking.GetNumLobbyMembers

	local GetLobbyMemberByIndex_native = vtable_entry(this, 18, "void(__thiscall*)(void*, SteamID *, SteamID, int)")
	function ISteamMatchmaking.GetLobbyMemberByIndex(steamIDLobby, iMember)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		local CSteamID_out = new_SteamID_arr()
		GetLobbyMemberByIndex_native(this, CSteamID_out, steamIDLobby, iMember)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamMatchmaking.get_lobby_member_by_index = ISteamMatchmaking.GetLobbyMemberByIndex

	local GetLobbyData_native = vtable_entry(this, 19, "const char *(__thiscall*)(void*, SteamID, const char *)")
	function ISteamMatchmaking.GetLobbyData(steamIDLobby, pchKey)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		local res = GetLobbyData_native(this, steamIDLobby, pchKey)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamMatchmaking.get_lobby_data = ISteamMatchmaking.GetLobbyData

	local SetLobbyData_native = vtable_entry(this, 20, "bool(__thiscall*)(void*, SteamID, const char *, const char *)")
	function ISteamMatchmaking.SetLobbyData(steamIDLobby, pchKey, pchValue)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return SetLobbyData_native(this, steamIDLobby, pchKey, pchValue)
	end
	ISteamMatchmaking.set_lobby_data = ISteamMatchmaking.SetLobbyData

	local GetLobbyDataCount_native = vtable_entry(this, 21, "int(__thiscall*)(void*, SteamID)")
	function ISteamMatchmaking.GetLobbyDataCount(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return GetLobbyDataCount_native(this, steamIDLobby)
	end
	ISteamMatchmaking.get_lobby_data_count = ISteamMatchmaking.GetLobbyDataCount

	local GetLobbyDataByIndex_native = vtable_entry(this, 22, "bool(__thiscall*)(void*, SteamID, int, char *, int, char *, int)")
	function ISteamMatchmaking.GetLobbyDataByIndex(steamIDLobby, iLobbyData, pchKey, cchKeyBufferSize, pchValue, cchValueBufferSize)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return GetLobbyDataByIndex_native(this, steamIDLobby, iLobbyData, pchKey, cchKeyBufferSize, pchValue, cchValueBufferSize)
	end
	ISteamMatchmaking.get_lobby_data_by_index = ISteamMatchmaking.GetLobbyDataByIndex

	local DeleteLobbyData_native = vtable_entry(this, 23, "bool(__thiscall*)(void*, SteamID, const char *)")
	function ISteamMatchmaking.DeleteLobbyData(steamIDLobby, pchKey)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return DeleteLobbyData_native(this, steamIDLobby, pchKey)
	end
	ISteamMatchmaking.delete_lobby_data = ISteamMatchmaking.DeleteLobbyData

	local GetLobbyMemberData_native = vtable_entry(this, 24, "const char *(__thiscall*)(void*, SteamID, SteamID, const char *)")
	function ISteamMatchmaking.GetLobbyMemberData(steamIDLobby, steamIDUser, pchKey)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local res = GetLobbyMemberData_native(this, steamIDLobby, steamIDUser, pchKey)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamMatchmaking.get_lobby_member_data = ISteamMatchmaking.GetLobbyMemberData

	local SetLobbyMemberData_native = vtable_entry(this, 25, "void(__thiscall*)(void*, SteamID, const char *, const char *)")
	function ISteamMatchmaking.SetLobbyMemberData(steamIDLobby, pchKey, pchValue)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return SetLobbyMemberData_native(this, steamIDLobby, pchKey, pchValue)
	end
	ISteamMatchmaking.set_lobby_member_data = ISteamMatchmaking.SetLobbyMemberData

	local SendLobbyChatMsg_native = vtable_entry(this, 26, "bool(__thiscall*)(void*, SteamID, const void *, int)")
	function ISteamMatchmaking.SendLobbyChatMsg(steamIDLobby, pvMsgBody, cubMsgBody)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return SendLobbyChatMsg_native(this, steamIDLobby, pvMsgBody, cubMsgBody)
	end
	ISteamMatchmaking.send_lobby_chat_msg = ISteamMatchmaking.SendLobbyChatMsg

	local GetLobbyChatEntry_native = vtable_entry(this, 27, "int(__thiscall*)(void*, SteamID, int, SteamID *, void *, int, int *)")
	function ISteamMatchmaking.GetLobbyChatEntry(steamIDLobby, iChatID, pvData, cubData)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		local pSteamIDUser_out = new_SteamID_arr()
		local peChatEntryType_out = new_int_arr()
		local res = GetLobbyChatEntry_native(this, steamIDLobby, iChatID, pSteamIDUser_out, pvData, cubData, peChatEntryType_out)

		return res, DEREF_GCSAFE(pSteamIDUser_out), DEREF_GCSAFE(peChatEntryType_out)
	end
	ISteamMatchmaking.get_lobby_chat_entry = ISteamMatchmaking.GetLobbyChatEntry

	local RequestLobbyData_native = vtable_entry(this, 28, "bool(__thiscall*)(void*, SteamID)")
	function ISteamMatchmaking.RequestLobbyData(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return RequestLobbyData_native(this, steamIDLobby)
	end
	ISteamMatchmaking.request_lobby_data = ISteamMatchmaking.RequestLobbyData

	local SetLobbyGameServer_native = vtable_entry(this, 29, "void(__thiscall*)(void*, SteamID, uint32_t, uint16_t, SteamID)")
	function ISteamMatchmaking.SetLobbyGameServer(steamIDLobby, unGameServerIP, unGameServerPort, steamIDGameServer)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		unGameServerIP = to_ip_int_required(unGameServerIP, "game_server_ip is required")
		steamIDGameServer = to_steamid_required(steamIDGameServer, "steamid_game_server is required")
		return SetLobbyGameServer_native(this, steamIDLobby, unGameServerIP, unGameServerPort, steamIDGameServer)
	end
	ISteamMatchmaking.set_lobby_game_server = ISteamMatchmaking.SetLobbyGameServer

	local GetLobbyGameServer_native = vtable_entry(this, 30, "bool(__thiscall*)(void*, SteamID, uint32_t *, uint16_t *, SteamID *)")
	function ISteamMatchmaking.GetLobbyGameServer(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		local punGameServerIP_out = new_uint32_arr()
		local punGameServerPort_out = new_uint16_arr()
		local psteamIDGameServer_out = new_SteamID_arr()
		local res = GetLobbyGameServer_native(this, steamIDLobby, punGameServerIP_out, punGameServerPort_out, psteamIDGameServer_out)

		return res, DEREF_GCSAFE(punGameServerIP_out), DEREF_GCSAFE(punGameServerPort_out), DEREF_GCSAFE(psteamIDGameServer_out)
	end
	ISteamMatchmaking.get_lobby_game_server = ISteamMatchmaking.GetLobbyGameServer

	local SetLobbyMemberLimit_native = vtable_entry(this, 31, "bool(__thiscall*)(void*, SteamID, int)")
	function ISteamMatchmaking.SetLobbyMemberLimit(steamIDLobby, cMaxMembers)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return SetLobbyMemberLimit_native(this, steamIDLobby, cMaxMembers)
	end
	ISteamMatchmaking.set_lobby_member_limit = ISteamMatchmaking.SetLobbyMemberLimit

	local GetLobbyMemberLimit_native = vtable_entry(this, 32, "int(__thiscall*)(void*, SteamID)")
	function ISteamMatchmaking.GetLobbyMemberLimit(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return GetLobbyMemberLimit_native(this, steamIDLobby)
	end
	ISteamMatchmaking.get_lobby_member_limit = ISteamMatchmaking.GetLobbyMemberLimit

	local SetLobbyType_native = vtable_entry(this, 33, "bool(__thiscall*)(void*, SteamID, int)")
	function ISteamMatchmaking.SetLobbyType(steamIDLobby, eLobbyType)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		eLobbyType = to_enum_required(eLobbyType, enums.ELobbyType, "lobby_type is required")
		return SetLobbyType_native(this, steamIDLobby, eLobbyType)
	end
	ISteamMatchmaking.set_lobby_type = ISteamMatchmaking.SetLobbyType

	local SetLobbyJoinable_native = vtable_entry(this, 34, "bool(__thiscall*)(void*, SteamID, bool)")
	function ISteamMatchmaking.SetLobbyJoinable(steamIDLobby, bLobbyJoinable)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		return SetLobbyJoinable_native(this, steamIDLobby, bLobbyJoinable)
	end
	ISteamMatchmaking.set_lobby_joinable = ISteamMatchmaking.SetLobbyJoinable

	local GetLobbyOwner_native = vtable_entry(this, 35, "void(__thiscall*)(void*, SteamID *, SteamID)")
	function ISteamMatchmaking.GetLobbyOwner(steamIDLobby)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		local CSteamID_out = new_SteamID_arr()
		GetLobbyOwner_native(this, CSteamID_out, steamIDLobby)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamMatchmaking.get_lobby_owner = ISteamMatchmaking.GetLobbyOwner

	local SetLobbyOwner_native = vtable_entry(this, 36, "bool(__thiscall*)(void*, SteamID, SteamID)")
	function ISteamMatchmaking.SetLobbyOwner(steamIDLobby, steamIDNewOwner)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		steamIDNewOwner = to_steamid_required(steamIDNewOwner, "steamid_new_owner is required")
		return SetLobbyOwner_native(this, steamIDLobby, steamIDNewOwner)
	end
	ISteamMatchmaking.set_lobby_owner = ISteamMatchmaking.SetLobbyOwner

	local SetLinkedLobby_native = vtable_entry(this, 37, "bool(__thiscall*)(void*, SteamID, SteamID)")
	function ISteamMatchmaking.SetLinkedLobby(steamIDLobby, steamIDLobbyDependent)
		steamIDLobby = to_steamid_required(steamIDLobby, "steamid_lobby is required")
		steamIDLobbyDependent = to_steamid_required(steamIDLobbyDependent, "steamid_lobby_dependent is required")
		return SetLinkedLobby_native(this, steamIDLobby, steamIDLobbyDependent)
	end
	ISteamMatchmaking.set_linked_lobby = ISteamMatchmaking.SetLinkedLobby

	return ISteamMatchmaking
end

--
-- ISteamMatchmakingServerListResponse (no version, user created: true)
--

local ISteamMatchmakingServerListResponse = {}
M.ISteamMatchmakingServerListResponse = ISteamMatchmakingServerListResponse

do
	safe_cdef("ISteamMatchmakingServerListResponse", [[
		typedef struct _ISteamMatchmakingServerListResponse {
			void* vtbl;
			struct {
				void(__thiscall* ServerResponded)(void*, void *, int);
				void(__thiscall* ServerFailedToRespond)(void*, void *, int);
				void(__thiscall* RefreshComplete)(void*, void *, int);
			} vtbl_storage[1];
		} ISteamMatchmakingServerListResponse;
	]])

	local callback_base_array  = typeof("struct _ISteamMatchmakingServerListResponse[1]")
	local callback_base_ptr    = typeof("struct _ISteamMatchmakingServerListResponse*")

	local registered_user_callbacks
	local vtbl_callbacks
	local instances = {}

	function ISteamMatchmakingServerListResponse.new(user_callbacks)
		if type(user_callbacks) ~= "table" then
			return error("Invalid user_callbacks, expected table", 2)
		end

		if vtbl_callbacks == nil then
			registered_user_callbacks = {ServerResponded={},ServerFailedToRespond={},RefreshComplete={}}
			vtbl_callbacks = {
				ServerResponded = cast(typeof("void(__thiscall*)(void*, void *, int)"), get_user_interface_callback_handler(registered_user_callbacks["ServerResponded"])),
				ServerFailedToRespond = cast(typeof("void(__thiscall*)(void*, void *, int)"), get_user_interface_callback_handler(registered_user_callbacks["ServerFailedToRespond"])),
				RefreshComplete = cast(typeof("void(__thiscall*)(void*, void *, int)"), get_user_interface_callback_handler(registered_user_callbacks["RefreshComplete"]))
			}
		end

		for key, value in pairs(user_callbacks) do
			if vtbl_callbacks[key] == nil then
				return error("Unknown callback: " .. tostring(key), 2)
			elseif type(value) ~= "function" then
				return error(string_format("Invalid callback type for %s: %s", tostring(key), type(value)), 2)
			end
		end

		local instance_storage = callback_base_array()
		local instance = cast(callback_base_ptr, instance_storage)
		local instance_key = pointer_key(instance)

		for key, value in pairs(vtbl_callbacks) do
			if user_callbacks[key] ~= nil then
				registered_user_callbacks[key][instance_key] = user_callbacks[key]
			end
		end

		for key, value in pairs(vtbl_callbacks) do
			instance.vtbl_storage[0][key] = value
		end

		instance.vtbl = instance.vtbl_storage
		instances[instance_key] = instance_storage

		return instance
	end
end

--
-- ISteamMatchmakingPingResponse (no version, user created: true)
--

local ISteamMatchmakingPingResponse = {}
M.ISteamMatchmakingPingResponse = ISteamMatchmakingPingResponse

do
	safe_cdef("ISteamMatchmakingPingResponse", [[
		typedef struct _ISteamMatchmakingPingResponse {
			void* vtbl;
			struct {
				void(__thiscall* ServerResponded)(void*, gameserveritem_t &);
				void(__thiscall* ServerFailedToRespond)(void*);
			} vtbl_storage[1];
		} ISteamMatchmakingPingResponse;
	]])

	local callback_base_array  = typeof("struct _ISteamMatchmakingPingResponse[1]")
	local callback_base_ptr    = typeof("struct _ISteamMatchmakingPingResponse*")

	local registered_user_callbacks
	local vtbl_callbacks
	local instances = {}

	function ISteamMatchmakingPingResponse.new(user_callbacks)
		if type(user_callbacks) ~= "table" then
			return error("Invalid user_callbacks, expected table", 2)
		end

		if vtbl_callbacks == nil then
			registered_user_callbacks = {ServerResponded={},ServerFailedToRespond={}}
			vtbl_callbacks = {
				ServerResponded = cast(typeof("void(__thiscall*)(void*, gameserveritem_t &)"), get_user_interface_callback_handler(registered_user_callbacks["ServerResponded"])),
				ServerFailedToRespond = cast(typeof("void(__thiscall*)(void*)"), get_user_interface_callback_handler(registered_user_callbacks["ServerFailedToRespond"]))
			}
		end

		for key, value in pairs(user_callbacks) do
			if vtbl_callbacks[key] == nil then
				return error("Unknown callback: " .. tostring(key), 2)
			elseif type(value) ~= "function" then
				return error(string_format("Invalid callback type for %s: %s", tostring(key), type(value)), 2)
			end
		end

		local instance_storage = callback_base_array()
		local instance = cast(callback_base_ptr, instance_storage)
		local instance_key = pointer_key(instance)

		for key, value in pairs(vtbl_callbacks) do
			if user_callbacks[key] ~= nil then
				registered_user_callbacks[key][instance_key] = user_callbacks[key]
			end
		end

		for key, value in pairs(vtbl_callbacks) do
			instance.vtbl_storage[0][key] = value
		end

		instance.vtbl = instance.vtbl_storage
		instances[instance_key] = instance_storage

		return instance
	end
end

--
-- ISteamMatchmakingPlayersResponse (no version, user created: true)
--

local ISteamMatchmakingPlayersResponse = {}
M.ISteamMatchmakingPlayersResponse = ISteamMatchmakingPlayersResponse

do
	safe_cdef("ISteamMatchmakingPlayersResponse", [[
		typedef struct _ISteamMatchmakingPlayersResponse {
			void* vtbl;
			struct {
				void(__thiscall* AddPlayerToList)(void*, const char *, int, float);
				void(__thiscall* PlayersFailedToRespond)(void*);
				void(__thiscall* PlayersRefreshComplete)(void*);
			} vtbl_storage[1];
		} ISteamMatchmakingPlayersResponse;
	]])

	local callback_base_array  = typeof("struct _ISteamMatchmakingPlayersResponse[1]")
	local callback_base_ptr    = typeof("struct _ISteamMatchmakingPlayersResponse*")

	local registered_user_callbacks
	local vtbl_callbacks
	local instances = {}

	function ISteamMatchmakingPlayersResponse.new(user_callbacks)
		if type(user_callbacks) ~= "table" then
			return error("Invalid user_callbacks, expected table", 2)
		end

		if vtbl_callbacks == nil then
			registered_user_callbacks = {AddPlayerToList={},PlayersFailedToRespond={},PlayersRefreshComplete={}}
			vtbl_callbacks = {
				AddPlayerToList = cast(typeof("void(__thiscall*)(void*, const char *, int, float)"), get_user_interface_callback_handler(registered_user_callbacks["AddPlayerToList"])),
				PlayersFailedToRespond = cast(typeof("void(__thiscall*)(void*)"), get_user_interface_callback_handler(registered_user_callbacks["PlayersFailedToRespond"])),
				PlayersRefreshComplete = cast(typeof("void(__thiscall*)(void*)"), get_user_interface_callback_handler(registered_user_callbacks["PlayersRefreshComplete"]))
			}
		end

		for key, value in pairs(user_callbacks) do
			if vtbl_callbacks[key] == nil then
				return error("Unknown callback: " .. tostring(key), 2)
			elseif type(value) ~= "function" then
				return error(string_format("Invalid callback type for %s: %s", tostring(key), type(value)), 2)
			end
		end

		local instance_storage = callback_base_array()
		local instance = cast(callback_base_ptr, instance_storage)
		local instance_key = pointer_key(instance)

		for key, value in pairs(vtbl_callbacks) do
			if user_callbacks[key] ~= nil then
				registered_user_callbacks[key][instance_key] = user_callbacks[key]
			end
		end

		for key, value in pairs(vtbl_callbacks) do
			instance.vtbl_storage[0][key] = value
		end

		instance.vtbl = instance.vtbl_storage
		instances[instance_key] = instance_storage

		return instance
	end
end

--
-- ISteamMatchmakingRulesResponse (no version, user created: true)
--

local ISteamMatchmakingRulesResponse = {}
M.ISteamMatchmakingRulesResponse = ISteamMatchmakingRulesResponse

do
	safe_cdef("ISteamMatchmakingRulesResponse", [[
		typedef struct _ISteamMatchmakingRulesResponse {
			void* vtbl;
			struct {
				void(__thiscall* RulesResponded)(void*, const char *, const char *);
				void(__thiscall* RulesFailedToRespond)(void*);
				void(__thiscall* RulesRefreshComplete)(void*);
			} vtbl_storage[1];
		} ISteamMatchmakingRulesResponse;
	]])

	local callback_base_array  = typeof("struct _ISteamMatchmakingRulesResponse[1]")
	local callback_base_ptr    = typeof("struct _ISteamMatchmakingRulesResponse*")

	local registered_user_callbacks
	local vtbl_callbacks
	local instances = {}

	function ISteamMatchmakingRulesResponse.new(user_callbacks)
		if type(user_callbacks) ~= "table" then
			return error("Invalid user_callbacks, expected table", 2)
		end

		if vtbl_callbacks == nil then
			registered_user_callbacks = {RulesResponded={},RulesFailedToRespond={},RulesRefreshComplete={}}
			vtbl_callbacks = {
				RulesResponded = cast(typeof("void(__thiscall*)(void*, const char *, const char *)"), get_user_interface_callback_handler(registered_user_callbacks["RulesResponded"])),
				RulesFailedToRespond = cast(typeof("void(__thiscall*)(void*)"), get_user_interface_callback_handler(registered_user_callbacks["RulesFailedToRespond"])),
				RulesRefreshComplete = cast(typeof("void(__thiscall*)(void*)"), get_user_interface_callback_handler(registered_user_callbacks["RulesRefreshComplete"]))
			}
		end

		for key, value in pairs(user_callbacks) do
			if vtbl_callbacks[key] == nil then
				return error("Unknown callback: " .. tostring(key), 2)
			elseif type(value) ~= "function" then
				return error(string_format("Invalid callback type for %s: %s", tostring(key), type(value)), 2)
			end
		end

		local instance_storage = callback_base_array()
		local instance = cast(callback_base_ptr, instance_storage)
		local instance_key = pointer_key(instance)

		for key, value in pairs(vtbl_callbacks) do
			if user_callbacks[key] ~= nil then
				registered_user_callbacks[key][instance_key] = user_callbacks[key]
			end
		end

		for key, value in pairs(vtbl_callbacks) do
			instance.vtbl_storage[0][key] = value
		end

		instance.vtbl = instance.vtbl_storage
		instances[instance_key] = instance_storage

		return instance
	end
end

--
-- ISteamMatchmakingServers (SteamMatchMakingServers002, user created: false)
--

local ISteamMatchmakingServers = {version="SteamMatchMakingServers002",version_number=2}

index_funcs.ISteamMatchmakingServers = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 11, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "SteamMatchMakingServers002")

	local RequestInternetServerList_native = vtable_entry(this, 0, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")
	function ISteamMatchmakingServers.RequestInternetServerList(iApp, ppchFilters, nFilters, pRequestServersResponse)
		return RequestInternetServerList_native(this, iApp, ppchFilters, nFilters, pRequestServersResponse)
	end
	ISteamMatchmakingServers.request_internet_server_list = ISteamMatchmakingServers.RequestInternetServerList

	local RequestLANServerList_native = vtable_entry(this, 1, "void *(__thiscall*)(void*, unsigned int, ISteamMatchmakingServerListResponse *)")
	function ISteamMatchmakingServers.RequestLANServerList(iApp, pRequestServersResponse)
		return RequestLANServerList_native(this, iApp, pRequestServersResponse)
	end
	ISteamMatchmakingServers.request_lan_server_list = ISteamMatchmakingServers.RequestLANServerList

	local RequestFriendsServerList_native = vtable_entry(this, 2, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")
	function ISteamMatchmakingServers.RequestFriendsServerList(iApp, ppchFilters, nFilters, pRequestServersResponse)
		return RequestFriendsServerList_native(this, iApp, ppchFilters, nFilters, pRequestServersResponse)
	end
	ISteamMatchmakingServers.request_friends_server_list = ISteamMatchmakingServers.RequestFriendsServerList

	local RequestFavoritesServerList_native = vtable_entry(this, 3, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")
	function ISteamMatchmakingServers.RequestFavoritesServerList(iApp, ppchFilters, nFilters, pRequestServersResponse)
		return RequestFavoritesServerList_native(this, iApp, ppchFilters, nFilters, pRequestServersResponse)
	end
	ISteamMatchmakingServers.request_favorites_server_list = ISteamMatchmakingServers.RequestFavoritesServerList

	local RequestHistoryServerList_native = vtable_entry(this, 4, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")
	function ISteamMatchmakingServers.RequestHistoryServerList(iApp, ppchFilters, nFilters, pRequestServersResponse)
		return RequestHistoryServerList_native(this, iApp, ppchFilters, nFilters, pRequestServersResponse)
	end
	ISteamMatchmakingServers.request_history_server_list = ISteamMatchmakingServers.RequestHistoryServerList

	local RequestSpectatorServerList_native = vtable_entry(this, 5, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")
	function ISteamMatchmakingServers.RequestSpectatorServerList(iApp, ppchFilters, nFilters, pRequestServersResponse)
		return RequestSpectatorServerList_native(this, iApp, ppchFilters, nFilters, pRequestServersResponse)
	end
	ISteamMatchmakingServers.request_spectator_server_list = ISteamMatchmakingServers.RequestSpectatorServerList

	local ReleaseRequest_native = vtable_entry(this, 6, "void(__thiscall*)(void*, void *)")
	function ISteamMatchmakingServers.ReleaseRequest(hServerListRequest)
		return ReleaseRequest_native(this, hServerListRequest)
	end
	ISteamMatchmakingServers.release_request = ISteamMatchmakingServers.ReleaseRequest

	local GetServerDetails_native = vtable_entry(this, 7, "gameserveritem_t *(__thiscall*)(void*, void *, int)")
	function ISteamMatchmakingServers.GetServerDetails(hRequest, iServer)
		return GetServerDetails_native(this, hRequest, iServer)
	end
	ISteamMatchmakingServers.get_server_details = ISteamMatchmakingServers.GetServerDetails

	local CancelQuery_native = vtable_entry(this, 8, "void(__thiscall*)(void*, void *)")
	function ISteamMatchmakingServers.CancelQuery(hRequest)
		return CancelQuery_native(this, hRequest)
	end
	ISteamMatchmakingServers.cancel_query = ISteamMatchmakingServers.CancelQuery

	local RefreshQuery_native = vtable_entry(this, 9, "void(__thiscall*)(void*, void *)")
	function ISteamMatchmakingServers.RefreshQuery(hRequest)
		return RefreshQuery_native(this, hRequest)
	end
	ISteamMatchmakingServers.refresh_query = ISteamMatchmakingServers.RefreshQuery

	local IsRefreshing_native = vtable_entry(this, 10, "bool(__thiscall*)(void*, void *)")
	function ISteamMatchmakingServers.IsRefreshing(hRequest)
		return IsRefreshing_native(this, hRequest)
	end
	ISteamMatchmakingServers.is_refreshing = ISteamMatchmakingServers.IsRefreshing

	local GetServerCount_native = vtable_entry(this, 11, "int(__thiscall*)(void*, void *)")
	function ISteamMatchmakingServers.GetServerCount(hRequest)
		return GetServerCount_native(this, hRequest)
	end
	ISteamMatchmakingServers.get_server_count = ISteamMatchmakingServers.GetServerCount

	local RefreshServer_native = vtable_entry(this, 12, "void(__thiscall*)(void*, void *, int)")
	function ISteamMatchmakingServers.RefreshServer(hRequest, iServer)
		return RefreshServer_native(this, hRequest, iServer)
	end
	ISteamMatchmakingServers.refresh_server = ISteamMatchmakingServers.RefreshServer

	local PingServer_native = vtable_entry(this, 13, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingPingResponse *)")
	function ISteamMatchmakingServers.PingServer(unIP, usPort, pRequestServersResponse)
		unIP = to_ip_int_required(unIP, "ip is required")
		return PingServer_native(this, unIP, usPort, pRequestServersResponse)
	end
	ISteamMatchmakingServers.ping_server = ISteamMatchmakingServers.PingServer

	local PlayerDetails_native = vtable_entry(this, 14, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingPlayersResponse *)")
	function ISteamMatchmakingServers.PlayerDetails(unIP, usPort, pRequestServersResponse)
		unIP = to_ip_int_required(unIP, "ip is required")
		return PlayerDetails_native(this, unIP, usPort, pRequestServersResponse)
	end
	ISteamMatchmakingServers.player_details = ISteamMatchmakingServers.PlayerDetails

	local ServerRules_native = vtable_entry(this, 15, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingRulesResponse *)")
	function ISteamMatchmakingServers.ServerRules(unIP, usPort, pRequestServersResponse)
		unIP = to_ip_int_required(unIP, "ip is required")
		return ServerRules_native(this, unIP, usPort, pRequestServersResponse)
	end
	ISteamMatchmakingServers.server_rules = ISteamMatchmakingServers.ServerRules

	local CancelServerQuery_native = vtable_entry(this, 16, "void(__thiscall*)(void*, int)")
	function ISteamMatchmakingServers.CancelServerQuery(hServerQuery)
		return CancelServerQuery_native(this, hServerQuery)
	end
	ISteamMatchmakingServers.cancel_server_query = ISteamMatchmakingServers.CancelServerQuery

	return ISteamMatchmakingServers
end

--
-- ISteamUserStats (STEAMUSERSTATS_INTERFACE_VERSION012, user created: false)
--

local ISteamUserStats = {version="STEAMUSERSTATS_INTERFACE_VERSION012",version_number=12}

index_funcs.ISteamUserStats = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 13, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMUSERSTATS_INTERFACE_VERSION012")

	local RequestCurrentStats_native = vtable_entry(this, 0, "bool(__thiscall*)(void*)")
	function ISteamUserStats.RequestCurrentStats()
		return RequestCurrentStats_native(this)
	end
	ISteamUserStats.request_current_stats = ISteamUserStats.RequestCurrentStats

	local GetStatInt32_native = vtable_entry(this, 1, "bool(__thiscall*)(void*, const char *, int32_t *)")
	function ISteamUserStats.GetStatInt32(pchName)
		local pData_out = new_int32_arr()
		local res = GetStatInt32_native(this, pchName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamUserStats.get_stat_int32 = ISteamUserStats.GetStatInt32

	local GetStatFloat_native = vtable_entry(this, 2, "bool(__thiscall*)(void*, const char *, float *)")
	function ISteamUserStats.GetStatFloat(pchName)
		local pData_out = new_float_arr()
		local res = GetStatFloat_native(this, pchName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamUserStats.get_stat_float = ISteamUserStats.GetStatFloat

	local SetStatInt32_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, const char *, int32_t)")
	function ISteamUserStats.SetStatInt32(pchName, nData)
		return SetStatInt32_native(this, pchName, nData)
	end
	ISteamUserStats.set_stat_int32 = ISteamUserStats.SetStatInt32

	local SetStatFloat_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, const char *, float)")
	function ISteamUserStats.SetStatFloat(pchName, fData)
		return SetStatFloat_native(this, pchName, fData)
	end
	ISteamUserStats.set_stat_float = ISteamUserStats.SetStatFloat

	local UpdateAvgRateStat_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, const char *, float, double)")
	function ISteamUserStats.UpdateAvgRateStat(pchName, flCountThisSession, dSessionLength)
		return UpdateAvgRateStat_native(this, pchName, flCountThisSession, dSessionLength)
	end
	ISteamUserStats.update_avg_rate_stat = ISteamUserStats.UpdateAvgRateStat

	local GetAchievement_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, const char *, bool *)")
	function ISteamUserStats.GetAchievement(pchName)
		local pbAchieved_out = new_bool_arr()
		local res = GetAchievement_native(this, pchName, pbAchieved_out)

		return res, DEREF_GCSAFE(pbAchieved_out)
	end
	ISteamUserStats.get_achievement = ISteamUserStats.GetAchievement

	local SetAchievement_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, const char *)")
	function ISteamUserStats.SetAchievement(pchName)
		return SetAchievement_native(this, pchName)
	end
	ISteamUserStats.set_achievement = ISteamUserStats.SetAchievement

	local ClearAchievement_native = vtable_entry(this, 8, "bool(__thiscall*)(void*, const char *)")
	function ISteamUserStats.ClearAchievement(pchName)
		return ClearAchievement_native(this, pchName)
	end
	ISteamUserStats.clear_achievement = ISteamUserStats.ClearAchievement

	local GetAchievementAndUnlockTime_native = vtable_entry(this, 9, "bool(__thiscall*)(void*, const char *, bool *, uint32_t *)")
	function ISteamUserStats.GetAchievementAndUnlockTime(pchName)
		local pbAchieved_out = new_bool_arr()
		local punUnlockTime_out = new_uint32_arr()
		local res = GetAchievementAndUnlockTime_native(this, pchName, pbAchieved_out, punUnlockTime_out)

		return res, DEREF_GCSAFE(pbAchieved_out), DEREF_GCSAFE(punUnlockTime_out)
	end
	ISteamUserStats.get_achievement_and_unlock_time = ISteamUserStats.GetAchievementAndUnlockTime

	local StoreStats_native = vtable_entry(this, 10, "bool(__thiscall*)(void*)")
	function ISteamUserStats.StoreStats()
		return StoreStats_native(this)
	end
	ISteamUserStats.store_stats = ISteamUserStats.StoreStats

	local GetAchievementIcon_native = vtable_entry(this, 11, "int(__thiscall*)(void*, const char *)")
	function ISteamUserStats.GetAchievementIcon(pchName)
		return GetAchievementIcon_native(this, pchName)
	end
	ISteamUserStats.get_achievement_icon = ISteamUserStats.GetAchievementIcon

	local GetAchievementDisplayAttribute_native = vtable_entry(this, 12, "const char *(__thiscall*)(void*, const char *, const char *)")
	function ISteamUserStats.GetAchievementDisplayAttribute(pchName, pchKey)
		local res = GetAchievementDisplayAttribute_native(this, pchName, pchKey)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamUserStats.get_achievement_display_attribute = ISteamUserStats.GetAchievementDisplayAttribute

	local IndicateAchievementProgress_native = vtable_entry(this, 13, "bool(__thiscall*)(void*, const char *, uint32_t, uint32_t)")
	function ISteamUserStats.IndicateAchievementProgress(pchName, nCurProgress, nMaxProgress)
		return IndicateAchievementProgress_native(this, pchName, nCurProgress, nMaxProgress)
	end
	ISteamUserStats.indicate_achievement_progress = ISteamUserStats.IndicateAchievementProgress

	local GetNumAchievements_native = vtable_entry(this, 14, "uint32_t(__thiscall*)(void*)")
	function ISteamUserStats.GetNumAchievements()
		return GetNumAchievements_native(this)
	end
	ISteamUserStats.get_num_achievements = ISteamUserStats.GetNumAchievements

	local GetAchievementName_native = vtable_entry(this, 15, "const char *(__thiscall*)(void*, uint32_t)")
	function ISteamUserStats.GetAchievementName(iAchievement)
		local res = GetAchievementName_native(this, iAchievement)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamUserStats.get_achievement_name = ISteamUserStats.GetAchievementName

	local RequestUserStats_native = vtable_entry(this, 16, "uint64_t(__thiscall*)(void*, SteamID)")
	local RequestUserStats_info = {
		struct = typeof([[
			struct {
				uint64_t m_nGameID;
				int m_eResult;
				SteamID m_steamIDUser;
			} *
		]]),
		keys = {m_nGameID="game_id",m_eResult="result",m_steamIDUser="steamid_user"}
	}
	function ISteamUserStats.RequestUserStats(steamIDUser, callback)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestUserStats_native(this, steamIDUser)

		if callback ~= nil then
			res = register_call_result(res, callback, 1101, RequestUserStats_info)
		end

		return res
	end
	ISteamUserStats.request_user_stats = ISteamUserStats.RequestUserStats

	local GetUserStatInt32_native = vtable_entry(this, 17, "bool(__thiscall*)(void*, SteamID, const char *, int32_t *)")
	function ISteamUserStats.GetUserStatInt32(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local pData_out = new_int32_arr()
		local res = GetUserStatInt32_native(this, steamIDUser, pchName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamUserStats.get_user_stat_int32 = ISteamUserStats.GetUserStatInt32

	local GetUserStatFloat_native = vtable_entry(this, 18, "bool(__thiscall*)(void*, SteamID, const char *, float *)")
	function ISteamUserStats.GetUserStatFloat(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local pData_out = new_float_arr()
		local res = GetUserStatFloat_native(this, steamIDUser, pchName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamUserStats.get_user_stat_float = ISteamUserStats.GetUserStatFloat

	local GetUserAchievement_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, SteamID, const char *, bool *)")
	function ISteamUserStats.GetUserAchievement(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local pbAchieved_out = new_bool_arr()
		local res = GetUserAchievement_native(this, steamIDUser, pchName, pbAchieved_out)

		return res, DEREF_GCSAFE(pbAchieved_out)
	end
	ISteamUserStats.get_user_achievement = ISteamUserStats.GetUserAchievement

	local GetUserAchievementAndUnlockTime_native = vtable_entry(this, 20, "bool(__thiscall*)(void*, SteamID, const char *, bool *, uint32_t *)")
	function ISteamUserStats.GetUserAchievementAndUnlockTime(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local pbAchieved_out = new_bool_arr()
		local punUnlockTime_out = new_uint32_arr()
		local res = GetUserAchievementAndUnlockTime_native(this, steamIDUser, pchName, pbAchieved_out, punUnlockTime_out)

		return res, DEREF_GCSAFE(pbAchieved_out), DEREF_GCSAFE(punUnlockTime_out)
	end
	ISteamUserStats.get_user_achievement_and_unlock_time = ISteamUserStats.GetUserAchievementAndUnlockTime

	local ResetAllStats_native = vtable_entry(this, 21, "bool(__thiscall*)(void*, bool)")
	function ISteamUserStats.ResetAllStats(bAchievementsToo)
		return ResetAllStats_native(this, bAchievementsToo)
	end
	ISteamUserStats.reset_all_stats = ISteamUserStats.ResetAllStats

	local FindOrCreateLeaderboard_native = vtable_entry(this, 22, "uint64_t(__thiscall*)(void*, const char *, int, int)")
	local FindOrCreateLeaderboard_info = {
		struct = typeof([[
			struct {
				uint64_t m_hSteamLeaderboard;
				bool m_bLeaderboardFound;
			} *
		]]),
		keys = {m_hSteamLeaderboard="steam_leaderboard",m_bLeaderboardFound="leaderboard_found"}
	}
	function ISteamUserStats.FindOrCreateLeaderboard(pchLeaderboardName, eLeaderboardSortMethod, eLeaderboardDisplayType, callback)
		eLeaderboardSortMethod = to_enum_required(eLeaderboardSortMethod, enums.ELeaderboardSortMethod, "leaderboard_sort_method is required")
		eLeaderboardDisplayType = to_enum_required(eLeaderboardDisplayType, enums.ELeaderboardDisplayType, "leaderboard_display_type is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = FindOrCreateLeaderboard_native(this, pchLeaderboardName, eLeaderboardSortMethod, eLeaderboardDisplayType)

		if callback ~= nil then
			res = register_call_result(res, callback, 1104, FindOrCreateLeaderboard_info)
		end

		return res
	end
	ISteamUserStats.find_or_create_leaderboard = ISteamUserStats.FindOrCreateLeaderboard

	local FindLeaderboard_native = vtable_entry(this, 23, "uint64_t(__thiscall*)(void*, const char *)")
	local FindLeaderboard_info = {
		struct = typeof([[
			struct {
				uint64_t m_hSteamLeaderboard;
				bool m_bLeaderboardFound;
			} *
		]]),
		keys = {m_hSteamLeaderboard="steam_leaderboard",m_bLeaderboardFound="leaderboard_found"}
	}
	function ISteamUserStats.FindLeaderboard(pchLeaderboardName, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = FindLeaderboard_native(this, pchLeaderboardName)

		if callback ~= nil then
			res = register_call_result(res, callback, 1104, FindLeaderboard_info)
		end

		return res
	end
	ISteamUserStats.find_leaderboard = ISteamUserStats.FindLeaderboard

	local GetLeaderboardName_native = vtable_entry(this, 24, "const char *(__thiscall*)(void*, uint64_t)")
	function ISteamUserStats.GetLeaderboardName(hSteamLeaderboard)
		local res = GetLeaderboardName_native(this, hSteamLeaderboard)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamUserStats.get_leaderboard_name = ISteamUserStats.GetLeaderboardName

	local GetLeaderboardEntryCount_native = vtable_entry(this, 25, "int(__thiscall*)(void*, uint64_t)")
	function ISteamUserStats.GetLeaderboardEntryCount(hSteamLeaderboard)
		return GetLeaderboardEntryCount_native(this, hSteamLeaderboard)
	end
	ISteamUserStats.get_leaderboard_entry_count = ISteamUserStats.GetLeaderboardEntryCount

	local GetLeaderboardSortMethod_native = vtable_entry(this, 26, "int(__thiscall*)(void*, uint64_t)")
	function ISteamUserStats.GetLeaderboardSortMethod(hSteamLeaderboard)
		return GetLeaderboardSortMethod_native(this, hSteamLeaderboard)
	end
	ISteamUserStats.get_leaderboard_sort_method = ISteamUserStats.GetLeaderboardSortMethod

	local GetLeaderboardDisplayType_native = vtable_entry(this, 27, "int(__thiscall*)(void*, uint64_t)")
	function ISteamUserStats.GetLeaderboardDisplayType(hSteamLeaderboard)
		return GetLeaderboardDisplayType_native(this, hSteamLeaderboard)
	end
	ISteamUserStats.get_leaderboard_display_type = ISteamUserStats.GetLeaderboardDisplayType

	local DownloadLeaderboardEntries_native = vtable_entry(this, 28, "uint64_t(__thiscall*)(void*, uint64_t, int, int, int)")
	local DownloadLeaderboardEntries_info = {
		struct = typeof([[
			struct {
				uint64_t m_hSteamLeaderboard;
				uint64_t m_hSteamLeaderboardEntries;
				int m_cEntryCount;
			} *
		]]),
		keys = {m_hSteamLeaderboard="steam_leaderboard",m_hSteamLeaderboardEntries="steam_leaderboard_entries",m_cEntryCount="entry_count"}
	}
	function ISteamUserStats.DownloadLeaderboardEntries(hSteamLeaderboard, eLeaderboardDataRequest, nRangeStart, nRangeEnd, callback)
		eLeaderboardDataRequest = to_enum_required(eLeaderboardDataRequest, enums.ELeaderboardDataRequest, "leaderboard_data_request is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = DownloadLeaderboardEntries_native(this, hSteamLeaderboard, eLeaderboardDataRequest, nRangeStart, nRangeEnd)

		if callback ~= nil then
			res = register_call_result(res, callback, 1105, DownloadLeaderboardEntries_info)
		end

		return res
	end
	ISteamUserStats.download_leaderboard_entries = ISteamUserStats.DownloadLeaderboardEntries

	local DownloadLeaderboardEntriesForUsers_native = vtable_entry(this, 29, "uint64_t(__thiscall*)(void*, uint64_t, SteamID *, int)")
	local DownloadLeaderboardEntriesForUsers_info = {
		struct = typeof([[
			struct {
				uint64_t m_hSteamLeaderboard;
				uint64_t m_hSteamLeaderboardEntries;
				int m_cEntryCount;
			} *
		]]),
		keys = {m_hSteamLeaderboard="steam_leaderboard",m_hSteamLeaderboardEntries="steam_leaderboard_entries",m_cEntryCount="entry_count"}
	}
	function ISteamUserStats.DownloadLeaderboardEntriesForUsers(hSteamLeaderboard, prgUsers, cUsers, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = DownloadLeaderboardEntriesForUsers_native(this, hSteamLeaderboard, prgUsers, cUsers)

		if callback ~= nil then
			res = register_call_result(res, callback, 1105, DownloadLeaderboardEntriesForUsers_info)
		end

		return res
	end
	ISteamUserStats.download_leaderboard_entries_for_users = ISteamUserStats.DownloadLeaderboardEntriesForUsers

	local GetDownloadedLeaderboardEntry_native = vtable_entry(this, 30, "bool(__thiscall*)(void*, uint64_t, int, LeaderboardEntry_t *, int32_t *, int)")
	function ISteamUserStats.GetDownloadedLeaderboardEntry(hSteamLeaderboardEntries, index, pDetails, cDetailsMax)
		local pLeaderboardEntry_out = structs.LeaderboardEntry_t_arr(1)
		local res = GetDownloadedLeaderboardEntry_native(this, hSteamLeaderboardEntries, index, pLeaderboardEntry_out, pDetails, cDetailsMax)

		return res, DEREF_GCSAFE(pLeaderboardEntry_out)
	end
	ISteamUserStats.get_downloaded_leaderboard_entry = ISteamUserStats.GetDownloadedLeaderboardEntry

	local UploadLeaderboardScore_native = vtable_entry(this, 31, "uint64_t(__thiscall*)(void*, uint64_t, int, int32_t, const int32_t *, int)")
	local UploadLeaderboardScore_info = {
		struct = typeof([[
			struct {
				bool m_bSuccess;
				uint64_t m_hSteamLeaderboard;
				int32_t m_nScore;
				bool m_bScoreChanged;
				int m_nGlobalRankNew;
				int m_nGlobalRankPrevious;
			} *
		]]),
		keys = {m_bSuccess="success",m_hSteamLeaderboard="steam_leaderboard",m_nScore="score",m_bScoreChanged="score_changed",m_nGlobalRankNew="global_rank_new",m_nGlobalRankPrevious="global_rank_previous"}
	}
	function ISteamUserStats.UploadLeaderboardScore(hSteamLeaderboard, eLeaderboardUploadScoreMethod, nScore, pScoreDetails, cScoreDetailsCount, callback)
		eLeaderboardUploadScoreMethod = to_enum_required(eLeaderboardUploadScoreMethod, enums.ELeaderboardUploadScoreMethod, "leaderboard_upload_score_method is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = UploadLeaderboardScore_native(this, hSteamLeaderboard, eLeaderboardUploadScoreMethod, nScore, pScoreDetails, cScoreDetailsCount)

		if callback ~= nil then
			res = register_call_result(res, callback, 1106, UploadLeaderboardScore_info)
		end

		return res
	end
	ISteamUserStats.upload_leaderboard_score = ISteamUserStats.UploadLeaderboardScore

	local AttachLeaderboardUGC_native = vtable_entry(this, 32, "uint64_t(__thiscall*)(void*, uint64_t, uint64_t)")
	local AttachLeaderboardUGC_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				uint64_t m_hSteamLeaderboard;
			} *
		]]),
		keys = {m_eResult="result",m_hSteamLeaderboard="steam_leaderboard"}
	}
	function ISteamUserStats.AttachLeaderboardUGC(hSteamLeaderboard, hUGC, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = AttachLeaderboardUGC_native(this, hSteamLeaderboard, hUGC)

		if callback ~= nil then
			res = register_call_result(res, callback, 1111, AttachLeaderboardUGC_info)
		end

		return res
	end
	ISteamUserStats.attach_leaderboard_ugc = ISteamUserStats.AttachLeaderboardUGC

	local GetNumberOfCurrentPlayers_native = vtable_entry(this, 33, "uint64_t(__thiscall*)(void*)")
	local GetNumberOfCurrentPlayers_info = {
		struct = typeof([[
			struct {
				bool m_bSuccess;
				int32_t m_cPlayers;
			} *
		]]),
		keys = {m_bSuccess="success",m_cPlayers="players"}
	}
	function ISteamUserStats.GetNumberOfCurrentPlayers(callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = GetNumberOfCurrentPlayers_native(this)

		if callback ~= nil then
			res = register_call_result(res, callback, 1107, GetNumberOfCurrentPlayers_info)
		end

		return res
	end
	ISteamUserStats.get_number_of_current_players = ISteamUserStats.GetNumberOfCurrentPlayers

	local RequestGlobalAchievementPercentages_native = vtable_entry(this, 34, "uint64_t(__thiscall*)(void*)")
	local RequestGlobalAchievementPercentages_info = {
		struct = typeof([[
			struct {
				uint64_t m_nGameID;
				int m_eResult;
			} *
		]]),
		keys = {m_nGameID="game_id",m_eResult="result"}
	}
	function ISteamUserStats.RequestGlobalAchievementPercentages(callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestGlobalAchievementPercentages_native(this)

		if callback ~= nil then
			res = register_call_result(res, callback, 1110, RequestGlobalAchievementPercentages_info)
		end

		return res
	end
	ISteamUserStats.request_global_achievement_percentages = ISteamUserStats.RequestGlobalAchievementPercentages

	local GetMostAchievedAchievementInfo_native = vtable_entry(this, 35, "int(__thiscall*)(void*, char *, uint32_t, float *, bool *)")
	function ISteamUserStats.GetMostAchievedAchievementInfo(pchName, unNameBufLen)
		local pflPercent_out = new_float_arr()
		local pbAchieved_out = new_bool_arr()
		local res = GetMostAchievedAchievementInfo_native(this, pchName, unNameBufLen, pflPercent_out, pbAchieved_out)

		return res, DEREF_GCSAFE(pflPercent_out), DEREF_GCSAFE(pbAchieved_out)
	end
	ISteamUserStats.get_most_achieved_achievement_info = ISteamUserStats.GetMostAchievedAchievementInfo

	local GetNextMostAchievedAchievementInfo_native = vtable_entry(this, 36, "int(__thiscall*)(void*, int, char *, uint32_t, float *, bool *)")
	function ISteamUserStats.GetNextMostAchievedAchievementInfo(iIteratorPrevious, pchName, unNameBufLen)
		local pflPercent_out = new_float_arr()
		local pbAchieved_out = new_bool_arr()
		local res = GetNextMostAchievedAchievementInfo_native(this, iIteratorPrevious, pchName, unNameBufLen, pflPercent_out, pbAchieved_out)

		return res, DEREF_GCSAFE(pflPercent_out), DEREF_GCSAFE(pbAchieved_out)
	end
	ISteamUserStats.get_next_most_achieved_achievement_info = ISteamUserStats.GetNextMostAchievedAchievementInfo

	local GetAchievementAchievedPercent_native = vtable_entry(this, 37, "bool(__thiscall*)(void*, const char *, float *)")
	function ISteamUserStats.GetAchievementAchievedPercent(pchName)
		local pflPercent_out = new_float_arr()
		local res = GetAchievementAchievedPercent_native(this, pchName, pflPercent_out)

		return res, DEREF_GCSAFE(pflPercent_out)
	end
	ISteamUserStats.get_achievement_achieved_percent = ISteamUserStats.GetAchievementAchievedPercent

	local RequestGlobalStats_native = vtable_entry(this, 38, "uint64_t(__thiscall*)(void*, int)")
	local RequestGlobalStats_info = {
		struct = typeof([[
			struct {
				uint64_t m_nGameID;
				int m_eResult;
			} *
		]]),
		keys = {m_nGameID="game_id",m_eResult="result"}
	}
	function ISteamUserStats.RequestGlobalStats(nHistoryDays, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestGlobalStats_native(this, nHistoryDays)

		if callback ~= nil then
			res = register_call_result(res, callback, 1112, RequestGlobalStats_info)
		end

		return res
	end
	ISteamUserStats.request_global_stats = ISteamUserStats.RequestGlobalStats

	local GetGlobalStatInt64_native = vtable_entry(this, 39, "bool(__thiscall*)(void*, const char *, int64_t *)")
	function ISteamUserStats.GetGlobalStatInt64(pchStatName)
		local pData_out = new_int64_arr()
		local res = GetGlobalStatInt64_native(this, pchStatName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamUserStats.get_global_stat_int64 = ISteamUserStats.GetGlobalStatInt64

	local GetGlobalStatDouble_native = vtable_entry(this, 40, "bool(__thiscall*)(void*, const char *, double *)")
	function ISteamUserStats.GetGlobalStatDouble(pchStatName)
		local pData_out = new_double_arr()
		local res = GetGlobalStatDouble_native(this, pchStatName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamUserStats.get_global_stat_double = ISteamUserStats.GetGlobalStatDouble

	local GetGlobalStatHistoryInt64_native = vtable_entry(this, 41, "int32_t(__thiscall*)(void*, const char *, int64_t *, uint32_t)")
	function ISteamUserStats.GetGlobalStatHistoryInt64(pchStatName, pData, cubData)
		return GetGlobalStatHistoryInt64_native(this, pchStatName, pData, cubData)
	end
	ISteamUserStats.get_global_stat_history_int64 = ISteamUserStats.GetGlobalStatHistoryInt64

	local GetGlobalStatHistoryDouble_native = vtable_entry(this, 42, "int32_t(__thiscall*)(void*, const char *, double *, uint32_t)")
	function ISteamUserStats.GetGlobalStatHistoryDouble(pchStatName, pData, cubData)
		return GetGlobalStatHistoryDouble_native(this, pchStatName, pData, cubData)
	end
	ISteamUserStats.get_global_stat_history_double = ISteamUserStats.GetGlobalStatHistoryDouble

	local GetAchievementProgressLimitsInt32_native = vtable_entry(this, 43, "bool(__thiscall*)(void*, const char *, int32_t *, int32_t *)")
	function ISteamUserStats.GetAchievementProgressLimitsInt32(pchName)
		local pnMinProgress_out = new_int32_arr()
		local pnMaxProgress_out = new_int32_arr()
		local res = GetAchievementProgressLimitsInt32_native(this, pchName, pnMinProgress_out, pnMaxProgress_out)

		return res, DEREF_GCSAFE(pnMinProgress_out), DEREF_GCSAFE(pnMaxProgress_out)
	end
	ISteamUserStats.get_achievement_progress_limits_int32 = ISteamUserStats.GetAchievementProgressLimitsInt32

	local GetAchievementProgressLimitsFloat_native = vtable_entry(this, 44, "bool(__thiscall*)(void*, const char *, float *, float *)")
	function ISteamUserStats.GetAchievementProgressLimitsFloat(pchName)
		local pfMinProgress_out = new_float_arr()
		local pfMaxProgress_out = new_float_arr()
		local res = GetAchievementProgressLimitsFloat_native(this, pchName, pfMinProgress_out, pfMaxProgress_out)

		return res, DEREF_GCSAFE(pfMinProgress_out), DEREF_GCSAFE(pfMaxProgress_out)
	end
	ISteamUserStats.get_achievement_progress_limits_float = ISteamUserStats.GetAchievementProgressLimitsFloat

	return ISteamUserStats
end

--
-- ISteamApps (STEAMAPPS_INTERFACE_VERSION008, user created: false)
--

local ISteamApps = {version="STEAMAPPS_INTERFACE_VERSION008",version_number=8}

index_funcs.ISteamApps = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 15, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMAPPS_INTERFACE_VERSION008")

	local BIsSubscribed_native = vtable_entry(this, 0, "bool(__thiscall*)(void*)")
	function ISteamApps.BIsSubscribed()
		return BIsSubscribed_native(this)
	end
	ISteamApps.is_subscribed = ISteamApps.BIsSubscribed

	local BIsLowViolence_native = vtable_entry(this, 1, "bool(__thiscall*)(void*)")
	function ISteamApps.BIsLowViolence()
		return BIsLowViolence_native(this)
	end
	ISteamApps.is_low_violence = ISteamApps.BIsLowViolence

	local BIsCybercafe_native = vtable_entry(this, 2, "bool(__thiscall*)(void*)")
	function ISteamApps.BIsCybercafe()
		return BIsCybercafe_native(this)
	end
	ISteamApps.is_cybercafe = ISteamApps.BIsCybercafe

	local BIsVACBanned_native = vtable_entry(this, 3, "bool(__thiscall*)(void*)")
	function ISteamApps.BIsVACBanned()
		return BIsVACBanned_native(this)
	end
	ISteamApps.is_vac_banned = ISteamApps.BIsVACBanned

	local GetCurrentGameLanguage_native = vtable_entry(this, 4, "const char *(__thiscall*)(void*)")
	function ISteamApps.GetCurrentGameLanguage()
		local res = GetCurrentGameLanguage_native(this)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamApps.get_current_game_language = ISteamApps.GetCurrentGameLanguage

	local GetAvailableGameLanguages_native = vtable_entry(this, 5, "const char *(__thiscall*)(void*)")
	function ISteamApps.GetAvailableGameLanguages()
		local res = GetAvailableGameLanguages_native(this)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamApps.get_available_game_languages = ISteamApps.GetAvailableGameLanguages

	local BIsSubscribedApp_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamApps.BIsSubscribedApp(appID)
		return BIsSubscribedApp_native(this, appID)
	end
	ISteamApps.is_subscribed_app = ISteamApps.BIsSubscribedApp

	local BIsDlcInstalled_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamApps.BIsDlcInstalled(appID)
		return BIsDlcInstalled_native(this, appID)
	end
	ISteamApps.is_dlc_installed = ISteamApps.BIsDlcInstalled

	local GetEarliestPurchaseUnixTime_native = vtable_entry(this, 8, "uint32_t(__thiscall*)(void*, unsigned int)")
	function ISteamApps.GetEarliestPurchaseUnixTime(nAppID)
		return GetEarliestPurchaseUnixTime_native(this, nAppID)
	end
	ISteamApps.get_earliest_purchase_unix_time = ISteamApps.GetEarliestPurchaseUnixTime

	local BIsSubscribedFromFreeWeekend_native = vtable_entry(this, 9, "bool(__thiscall*)(void*)")
	function ISteamApps.BIsSubscribedFromFreeWeekend()
		return BIsSubscribedFromFreeWeekend_native(this)
	end
	ISteamApps.is_subscribed_from_free_weekend = ISteamApps.BIsSubscribedFromFreeWeekend

	local GetDLCCount_native = vtable_entry(this, 10, "int(__thiscall*)(void*)")
	function ISteamApps.GetDLCCount()
		return GetDLCCount_native(this)
	end
	ISteamApps.get_dlc_count = ISteamApps.GetDLCCount

	local BGetDLCDataByIndex_native = vtable_entry(this, 11, "bool(__thiscall*)(void*, int, unsigned int *, bool *, char *, int)")
	function ISteamApps.BGetDLCDataByIndex(iDLC, pchName, cchNameBufferSize)
		local pAppID_out = new_unsigned_int_arr()
		local pbAvailable_out = new_bool_arr()
		local res = BGetDLCDataByIndex_native(this, iDLC, pAppID_out, pbAvailable_out, pchName, cchNameBufferSize)

		return res, DEREF_GCSAFE(pAppID_out), DEREF_GCSAFE(pbAvailable_out)
	end
	ISteamApps.get_dlc_data_by_index = ISteamApps.BGetDLCDataByIndex

	local InstallDLC_native = vtable_entry(this, 12, "void(__thiscall*)(void*, unsigned int)")
	function ISteamApps.InstallDLC(nAppID)
		return InstallDLC_native(this, nAppID)
	end
	ISteamApps.install_dlc = ISteamApps.InstallDLC

	local UninstallDLC_native = vtable_entry(this, 13, "void(__thiscall*)(void*, unsigned int)")
	function ISteamApps.UninstallDLC(nAppID)
		return UninstallDLC_native(this, nAppID)
	end
	ISteamApps.uninstall_dlc = ISteamApps.UninstallDLC

	local RequestAppProofOfPurchaseKey_native = vtable_entry(this, 14, "void(__thiscall*)(void*, unsigned int)")
	function ISteamApps.RequestAppProofOfPurchaseKey(nAppID)
		return RequestAppProofOfPurchaseKey_native(this, nAppID)
	end
	ISteamApps.request_app_proof_of_purchase_key = ISteamApps.RequestAppProofOfPurchaseKey

	local GetCurrentBetaName_native = vtable_entry(this, 15, "bool(__thiscall*)(void*, char *, int)")
	function ISteamApps.GetCurrentBetaName(pchName, cchNameBufferSize)
		return GetCurrentBetaName_native(this, pchName, cchNameBufferSize)
	end
	ISteamApps.get_current_beta_name = ISteamApps.GetCurrentBetaName

	local MarkContentCorrupt_native = vtable_entry(this, 16, "bool(__thiscall*)(void*, bool)")
	function ISteamApps.MarkContentCorrupt(bMissingFilesOnly)
		return MarkContentCorrupt_native(this, bMissingFilesOnly)
	end
	ISteamApps.mark_content_corrupt = ISteamApps.MarkContentCorrupt

	local GetInstalledDepots_native = vtable_entry(this, 17, "uint32_t(__thiscall*)(void*, unsigned int, unsigned int *, uint32_t)")
	function ISteamApps.GetInstalledDepots(appID, pvecDepots, cMaxDepots)
		return GetInstalledDepots_native(this, appID, pvecDepots, cMaxDepots)
	end
	ISteamApps.get_installed_depots = ISteamApps.GetInstalledDepots

	local GetAppInstallDir_native = vtable_entry(this, 18, "uint32_t(__thiscall*)(void*, unsigned int, char *, uint32_t)")
	function ISteamApps.GetAppInstallDir(appID, pchFolder, cchFolderBufferSize)
		return GetAppInstallDir_native(this, appID, pchFolder, cchFolderBufferSize)
	end
	ISteamApps.get_app_install_dir = ISteamApps.GetAppInstallDir

	local BIsAppInstalled_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamApps.BIsAppInstalled(appID)
		return BIsAppInstalled_native(this, appID)
	end
	ISteamApps.is_app_installed = ISteamApps.BIsAppInstalled

	local GetAppOwner_native = vtable_entry(this, 20, "void(__thiscall*)(void*, SteamID *)")
	function ISteamApps.GetAppOwner()
		local CSteamID_out = new_SteamID_arr()
		GetAppOwner_native(this, CSteamID_out)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamApps.get_app_owner = ISteamApps.GetAppOwner

	local GetLaunchQueryParam_native = vtable_entry(this, 21, "const char *(__thiscall*)(void*, const char *)")
	function ISteamApps.GetLaunchQueryParam(pchKey)
		local res = GetLaunchQueryParam_native(this, pchKey)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamApps.get_launch_query_param = ISteamApps.GetLaunchQueryParam

	local GetDlcDownloadProgress_native = vtable_entry(this, 22, "bool(__thiscall*)(void*, unsigned int, uint64_t *, uint64_t *)")
	function ISteamApps.GetDlcDownloadProgress(nAppID)
		local punBytesDownloaded_out = new_uint64_arr()
		local punBytesTotal_out = new_uint64_arr()
		local res = GetDlcDownloadProgress_native(this, nAppID, punBytesDownloaded_out, punBytesTotal_out)

		return res, DEREF_GCSAFE(punBytesDownloaded_out), DEREF_GCSAFE(punBytesTotal_out)
	end
	ISteamApps.get_dlc_download_progress = ISteamApps.GetDlcDownloadProgress

	local GetAppBuildId_native = vtable_entry(this, 23, "int(__thiscall*)(void*)")
	function ISteamApps.GetAppBuildId()
		return GetAppBuildId_native(this)
	end
	ISteamApps.get_app_build_id = ISteamApps.GetAppBuildId

	local RequestAllProofOfPurchaseKeys_native = vtable_entry(this, 24, "void(__thiscall*)(void*)")
	function ISteamApps.RequestAllProofOfPurchaseKeys()
		return RequestAllProofOfPurchaseKeys_native(this)
	end
	ISteamApps.request_all_proof_of_purchase_keys = ISteamApps.RequestAllProofOfPurchaseKeys

	local GetFileDetails_native = vtable_entry(this, 25, "uint64_t(__thiscall*)(void*, const char *)")
	local GetFileDetails_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				uint64_t m_ulFileSize;
				uint8_t m_FileSHA[20];
				uint32_t m_unFlags;
			} *
		]]),
		keys = {m_eResult="result",m_ulFileSize="file_size",m_FileSHA="file_sha",m_unFlags="flags"}
	}
	function ISteamApps.GetFileDetails(pszFileName, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = GetFileDetails_native(this, pszFileName)

		if callback ~= nil then
			res = register_call_result(res, callback, 1023, GetFileDetails_info)
		end

		return res
	end
	ISteamApps.get_file_details = ISteamApps.GetFileDetails

	local GetLaunchCommandLine_native = vtable_entry(this, 26, "int(__thiscall*)(void*, char *, int)")
	function ISteamApps.GetLaunchCommandLine(pszCommandLine, cubCommandLine)
		return GetLaunchCommandLine_native(this, pszCommandLine, cubCommandLine)
	end
	ISteamApps.get_launch_command_line = ISteamApps.GetLaunchCommandLine

	local BIsSubscribedFromFamilySharing_native = vtable_entry(this, 27, "bool(__thiscall*)(void*)")
	function ISteamApps.BIsSubscribedFromFamilySharing()
		return BIsSubscribedFromFamilySharing_native(this)
	end
	ISteamApps.is_subscribed_from_family_sharing = ISteamApps.BIsSubscribedFromFamilySharing

	local BIsTimedTrial_native = vtable_entry(this, 28, "bool(__thiscall*)(void*, uint32_t *, uint32_t *)")
	function ISteamApps.BIsTimedTrial()
		local punSecondsAllowed_out = new_uint32_arr()
		local punSecondsPlayed_out = new_uint32_arr()
		local res = BIsTimedTrial_native(this, punSecondsAllowed_out, punSecondsPlayed_out)

		return res, DEREF_GCSAFE(punSecondsAllowed_out), DEREF_GCSAFE(punSecondsPlayed_out)
	end
	ISteamApps.is_timed_trial = ISteamApps.BIsTimedTrial

	return ISteamApps
end

--
-- ISteamNetworking (SteamNetworking006, user created: false)
--

local ISteamNetworking = {version="SteamNetworking006",version_number=6}

index_funcs.ISteamNetworking = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 16, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "SteamNetworking006")

	local SendP2PPacket_native = vtable_entry(this, 0, "bool(__thiscall*)(void*, SteamID, const void *, uint32_t, int, int)")
	function ISteamNetworking.SendP2PPacket(steamIDRemote, pubData, cubData, eP2PSendType, nChannel)
		steamIDRemote = to_steamid_required(steamIDRemote, "steamid_remote is required")
		eP2PSendType = to_enum_required(eP2PSendType, enums.EP2PSend, "p2p_send_type is required")
		return SendP2PPacket_native(this, steamIDRemote, pubData, cubData, eP2PSendType, nChannel)
	end
	ISteamNetworking.send_p2p_packet = ISteamNetworking.SendP2PPacket

	local IsP2PPacketAvailable_native = vtable_entry(this, 1, "bool(__thiscall*)(void*, uint32_t *, int)")
	function ISteamNetworking.IsP2PPacketAvailable(nChannel)
		local pcubMsgSize_out = new_uint32_arr()
		local res = IsP2PPacketAvailable_native(this, pcubMsgSize_out, nChannel)

		return res, DEREF_GCSAFE(pcubMsgSize_out)
	end
	ISteamNetworking.is_p2p_packet_available = ISteamNetworking.IsP2PPacketAvailable

	local ReadP2PPacket_native = vtable_entry(this, 2, "bool(__thiscall*)(void*, void *, uint32_t, uint32_t *, SteamID *, int)")
	function ISteamNetworking.ReadP2PPacket(pubDest, cubDest, psteamIDRemote, nChannel)
		local pcubMsgSize_out = new_uint32_arr()
		local res = ReadP2PPacket_native(this, pubDest, cubDest, pcubMsgSize_out, psteamIDRemote, nChannel)

		return res, DEREF_GCSAFE(pcubMsgSize_out)
	end
	ISteamNetworking.read_p2p_packet = ISteamNetworking.ReadP2PPacket

	local AcceptP2PSessionWithUser_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, SteamID)")
	function ISteamNetworking.AcceptP2PSessionWithUser(steamIDRemote)
		steamIDRemote = to_steamid_required(steamIDRemote, "steamid_remote is required")
		return AcceptP2PSessionWithUser_native(this, steamIDRemote)
	end
	ISteamNetworking.accept_p2p_session_with_user = ISteamNetworking.AcceptP2PSessionWithUser

	local CloseP2PSessionWithUser_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, SteamID)")
	function ISteamNetworking.CloseP2PSessionWithUser(steamIDRemote)
		steamIDRemote = to_steamid_required(steamIDRemote, "steamid_remote is required")
		return CloseP2PSessionWithUser_native(this, steamIDRemote)
	end
	ISteamNetworking.close_p2p_session_with_user = ISteamNetworking.CloseP2PSessionWithUser

	local CloseP2PChannelWithUser_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, SteamID, int)")
	function ISteamNetworking.CloseP2PChannelWithUser(steamIDRemote, nChannel)
		steamIDRemote = to_steamid_required(steamIDRemote, "steamid_remote is required")
		return CloseP2PChannelWithUser_native(this, steamIDRemote, nChannel)
	end
	ISteamNetworking.close_p2p_channel_with_user = ISteamNetworking.CloseP2PChannelWithUser

	local GetP2PSessionState_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, SteamID, P2PSessionState_t *)")
	function ISteamNetworking.GetP2PSessionState(steamIDRemote)
		steamIDRemote = to_steamid_required(steamIDRemote, "steamid_remote is required")
		local pConnectionState_out = structs.P2PSessionState_t_arr(1)
		local res = GetP2PSessionState_native(this, steamIDRemote, pConnectionState_out)

		return res, DEREF_GCSAFE(pConnectionState_out)
	end
	ISteamNetworking.get_p2p_session_state = ISteamNetworking.GetP2PSessionState

	local AllowP2PPacketRelay_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, bool)")
	function ISteamNetworking.AllowP2PPacketRelay(bAllow)
		return AllowP2PPacketRelay_native(this, bAllow)
	end
	ISteamNetworking.allow_p2p_packet_relay = ISteamNetworking.AllowP2PPacketRelay

	local CreateListenSocket_native = vtable_entry(this, 8, "unsigned int(__thiscall*)(void*, int, SteamIPAddress_t, uint16_t, bool)")
	function ISteamNetworking.CreateListenSocket(nVirtualP2PPort, nIP, nPort, bAllowUseOfPacketRelay)
		return CreateListenSocket_native(this, nVirtualP2PPort, nIP, nPort, bAllowUseOfPacketRelay)
	end
	ISteamNetworking.create_listen_socket = ISteamNetworking.CreateListenSocket

	local CreateP2PConnectionSocket_native = vtable_entry(this, 9, "unsigned int(__thiscall*)(void*, SteamID, int, int, bool)")
	function ISteamNetworking.CreateP2PConnectionSocket(steamIDTarget, nVirtualPort, nTimeoutSec, bAllowUseOfPacketRelay)
		steamIDTarget = to_steamid_required(steamIDTarget, "steamid_target is required")
		return CreateP2PConnectionSocket_native(this, steamIDTarget, nVirtualPort, nTimeoutSec, bAllowUseOfPacketRelay)
	end
	ISteamNetworking.create_p2p_connection_socket = ISteamNetworking.CreateP2PConnectionSocket

	local CreateConnectionSocket_native = vtable_entry(this, 10, "unsigned int(__thiscall*)(void*, SteamIPAddress_t, uint16_t, int)")
	function ISteamNetworking.CreateConnectionSocket(nIP, nPort, nTimeoutSec)
		return CreateConnectionSocket_native(this, nIP, nPort, nTimeoutSec)
	end
	ISteamNetworking.create_connection_socket = ISteamNetworking.CreateConnectionSocket

	local DestroySocket_native = vtable_entry(this, 11, "bool(__thiscall*)(void*, unsigned int, bool)")
	function ISteamNetworking.DestroySocket(hSocket, bNotifyRemoteEnd)
		return DestroySocket_native(this, hSocket, bNotifyRemoteEnd)
	end
	ISteamNetworking.destroy_socket = ISteamNetworking.DestroySocket

	local DestroyListenSocket_native = vtable_entry(this, 12, "bool(__thiscall*)(void*, unsigned int, bool)")
	function ISteamNetworking.DestroyListenSocket(hSocket, bNotifyRemoteEnd)
		return DestroyListenSocket_native(this, hSocket, bNotifyRemoteEnd)
	end
	ISteamNetworking.destroy_listen_socket = ISteamNetworking.DestroyListenSocket

	local SendDataOnSocket_native = vtable_entry(this, 13, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, bool)")
	function ISteamNetworking.SendDataOnSocket(hSocket, pubData, cubData, bReliable)
		return SendDataOnSocket_native(this, hSocket, pubData, cubData, bReliable)
	end
	ISteamNetworking.send_data_on_socket = ISteamNetworking.SendDataOnSocket

	local IsDataAvailableOnSocket_native = vtable_entry(this, 14, "bool(__thiscall*)(void*, unsigned int, uint32_t *)")
	function ISteamNetworking.IsDataAvailableOnSocket(hSocket)
		local pcubMsgSize_out = new_uint32_arr()
		local res = IsDataAvailableOnSocket_native(this, hSocket, pcubMsgSize_out)

		return res, DEREF_GCSAFE(pcubMsgSize_out)
	end
	ISteamNetworking.is_data_available_on_socket = ISteamNetworking.IsDataAvailableOnSocket

	local RetrieveDataFromSocket_native = vtable_entry(this, 15, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, uint32_t *)")
	function ISteamNetworking.RetrieveDataFromSocket(hSocket, pubDest, cubDest)
		local pcubMsgSize_out = new_uint32_arr()
		local res = RetrieveDataFromSocket_native(this, hSocket, pubDest, cubDest, pcubMsgSize_out)

		return res, DEREF_GCSAFE(pcubMsgSize_out)
	end
	ISteamNetworking.retrieve_data_from_socket = ISteamNetworking.RetrieveDataFromSocket

	local IsDataAvailable_native = vtable_entry(this, 16, "bool(__thiscall*)(void*, unsigned int, uint32_t *, unsigned int *)")
	function ISteamNetworking.IsDataAvailable(hListenSocket)
		local pcubMsgSize_out = new_uint32_arr()
		local phSocket_out = new_unsigned_int_arr()
		local res = IsDataAvailable_native(this, hListenSocket, pcubMsgSize_out, phSocket_out)

		return res, DEREF_GCSAFE(pcubMsgSize_out), DEREF_GCSAFE(phSocket_out)
	end
	ISteamNetworking.is_data_available = ISteamNetworking.IsDataAvailable

	local RetrieveData_native = vtable_entry(this, 17, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, uint32_t *, unsigned int *)")
	function ISteamNetworking.RetrieveData(hListenSocket, pubDest, cubDest)
		local pcubMsgSize_out = new_uint32_arr()
		local phSocket_out = new_unsigned_int_arr()
		local res = RetrieveData_native(this, hListenSocket, pubDest, cubDest, pcubMsgSize_out, phSocket_out)

		return res, DEREF_GCSAFE(pcubMsgSize_out), DEREF_GCSAFE(phSocket_out)
	end
	ISteamNetworking.retrieve_data = ISteamNetworking.RetrieveData

	local GetSocketInfo_native = vtable_entry(this, 18, "bool(__thiscall*)(void*, unsigned int, SteamID *, int *, SteamIPAddress_t *, uint16_t *)")
	function ISteamNetworking.GetSocketInfo(hSocket, pSteamIDRemote)
		local peSocketStatus_out = new_int_arr()
		local punIPRemote_out = structs.SteamIPAddress_t_arr(1)
		local punPortRemote_out = new_uint16_arr()
		local res = GetSocketInfo_native(this, hSocket, pSteamIDRemote, peSocketStatus_out, punIPRemote_out, punPortRemote_out)

		return res, DEREF_GCSAFE(peSocketStatus_out), DEREF_GCSAFE(punIPRemote_out), DEREF_GCSAFE(punPortRemote_out)
	end
	ISteamNetworking.get_socket_info = ISteamNetworking.GetSocketInfo

	local GetListenSocketInfo_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, unsigned int, SteamIPAddress_t *, uint16_t *)")
	function ISteamNetworking.GetListenSocketInfo(hListenSocket)
		local pnIP_out = structs.SteamIPAddress_t_arr(1)
		local pnPort_out = new_uint16_arr()
		local res = GetListenSocketInfo_native(this, hListenSocket, pnIP_out, pnPort_out)

		return res, DEREF_GCSAFE(pnIP_out), DEREF_GCSAFE(pnPort_out)
	end
	ISteamNetworking.get_listen_socket_info = ISteamNetworking.GetListenSocketInfo

	local GetSocketConnectionType_native = vtable_entry(this, 20, "int(__thiscall*)(void*, unsigned int)")
	function ISteamNetworking.GetSocketConnectionType(hSocket)
		return GetSocketConnectionType_native(this, hSocket)
	end
	ISteamNetworking.get_socket_connection_type = ISteamNetworking.GetSocketConnectionType

	local GetMaxPacketSize_native = vtable_entry(this, 21, "int(__thiscall*)(void*, unsigned int)")
	function ISteamNetworking.GetMaxPacketSize(hSocket)
		return GetMaxPacketSize_native(this, hSocket)
	end
	ISteamNetworking.get_max_packet_size = ISteamNetworking.GetMaxPacketSize

	return ISteamNetworking
end

--
-- ISteamScreenshots (STEAMSCREENSHOTS_INTERFACE_VERSION003, user created: false)
--

local ISteamScreenshots = {version="STEAMSCREENSHOTS_INTERFACE_VERSION003",version_number=3}

index_funcs.ISteamScreenshots = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 18, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMSCREENSHOTS_INTERFACE_VERSION003")

	local WriteScreenshot_native = vtable_entry(this, 0, "unsigned int(__thiscall*)(void*, void *, uint32_t, int, int)")
	function ISteamScreenshots.WriteScreenshot(pubRGB, cubRGB, nWidth, nHeight)
		return WriteScreenshot_native(this, pubRGB, cubRGB, nWidth, nHeight)
	end
	ISteamScreenshots.write_screenshot = ISteamScreenshots.WriteScreenshot

	local AddScreenshotToLibrary_native = vtable_entry(this, 1, "unsigned int(__thiscall*)(void*, const char *, const char *, int, int)")
	function ISteamScreenshots.AddScreenshotToLibrary(pchFilename, pchThumbnailFilename, nWidth, nHeight)
		return AddScreenshotToLibrary_native(this, pchFilename, pchThumbnailFilename, nWidth, nHeight)
	end
	ISteamScreenshots.add_screenshot_to_library = ISteamScreenshots.AddScreenshotToLibrary

	local TriggerScreenshot_native = vtable_entry(this, 2, "void(__thiscall*)(void*)")
	function ISteamScreenshots.TriggerScreenshot()
		return TriggerScreenshot_native(this)
	end
	ISteamScreenshots.trigger_screenshot = ISteamScreenshots.TriggerScreenshot

	local HookScreenshots_native = vtable_entry(this, 3, "void(__thiscall*)(void*, bool)")
	function ISteamScreenshots.HookScreenshots(bHook)
		return HookScreenshots_native(this, bHook)
	end
	ISteamScreenshots.hook_screenshots = ISteamScreenshots.HookScreenshots

	local SetLocation_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, unsigned int, const char *)")
	function ISteamScreenshots.SetLocation(hScreenshot, pchLocation)
		return SetLocation_native(this, hScreenshot, pchLocation)
	end
	ISteamScreenshots.set_location = ISteamScreenshots.SetLocation

	local TagUser_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, unsigned int, SteamID)")
	function ISteamScreenshots.TagUser(hScreenshot, steamID)
		steamID = to_steamid_required(steamID, "steamid is required")
		return TagUser_native(this, hScreenshot, steamID)
	end
	ISteamScreenshots.tag_user = ISteamScreenshots.TagUser

	local TagPublishedFile_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, unsigned int, uint64_t)")
	function ISteamScreenshots.TagPublishedFile(hScreenshot, unPublishedFileID)
		return TagPublishedFile_native(this, hScreenshot, unPublishedFileID)
	end
	ISteamScreenshots.tag_published_file = ISteamScreenshots.TagPublishedFile

	local IsScreenshotsHooked_native = vtable_entry(this, 7, "bool(__thiscall*)(void*)")
	function ISteamScreenshots.IsScreenshotsHooked()
		return IsScreenshotsHooked_native(this)
	end
	ISteamScreenshots.is_screenshots_hooked = ISteamScreenshots.IsScreenshotsHooked

	local AddVRScreenshotToLibrary_native = vtable_entry(this, 8, "unsigned int(__thiscall*)(void*, int, const char *, const char *)")
	function ISteamScreenshots.AddVRScreenshotToLibrary(eType, pchFilename, pchVRFilename)
		eType = to_enum_required(eType, enums.EVRScreenshotType, "type is required")
		return AddVRScreenshotToLibrary_native(this, eType, pchFilename, pchVRFilename)
	end
	ISteamScreenshots.add_vr_screenshot_to_library = ISteamScreenshots.AddVRScreenshotToLibrary

	return ISteamScreenshots
end

--
-- ISteamMusic (STEAMMUSIC_INTERFACE_VERSION001, user created: false)
--

local ISteamMusic = {version="STEAMMUSIC_INTERFACE_VERSION001",version_number=1}

index_funcs.ISteamMusic = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 29, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMMUSIC_INTERFACE_VERSION001")

	local BIsEnabled_native = vtable_entry(this, 0, "bool(__thiscall*)(void*)")
	function ISteamMusic.BIsEnabled()
		return BIsEnabled_native(this)
	end
	ISteamMusic.is_enabled = ISteamMusic.BIsEnabled

	local BIsPlaying_native = vtable_entry(this, 1, "bool(__thiscall*)(void*)")
	function ISteamMusic.BIsPlaying()
		return BIsPlaying_native(this)
	end
	ISteamMusic.is_playing = ISteamMusic.BIsPlaying

	local GetPlaybackStatus_native = vtable_entry(this, 2, "int(__thiscall*)(void*)")
	function ISteamMusic.GetPlaybackStatus()
		return GetPlaybackStatus_native(this)
	end
	ISteamMusic.get_playback_status = ISteamMusic.GetPlaybackStatus

	local Play_native = vtable_entry(this, 3, "void(__thiscall*)(void*)")
	function ISteamMusic.Play()
		return Play_native(this)
	end
	ISteamMusic.play = ISteamMusic.Play

	local Pause_native = vtable_entry(this, 4, "void(__thiscall*)(void*)")
	function ISteamMusic.Pause()
		return Pause_native(this)
	end
	ISteamMusic.pause = ISteamMusic.Pause

	local PlayPrevious_native = vtable_entry(this, 5, "void(__thiscall*)(void*)")
	function ISteamMusic.PlayPrevious()
		return PlayPrevious_native(this)
	end
	ISteamMusic.play_previous = ISteamMusic.PlayPrevious

	local PlayNext_native = vtable_entry(this, 6, "void(__thiscall*)(void*)")
	function ISteamMusic.PlayNext()
		return PlayNext_native(this)
	end
	ISteamMusic.play_next = ISteamMusic.PlayNext

	local SetVolume_native = vtable_entry(this, 7, "void(__thiscall*)(void*, float)")
	function ISteamMusic.SetVolume(flVolume)
		return SetVolume_native(this, flVolume)
	end
	ISteamMusic.set_volume = ISteamMusic.SetVolume

	local GetVolume_native = vtable_entry(this, 8, "float(__thiscall*)(void*)")
	function ISteamMusic.GetVolume()
		return GetVolume_native(this)
	end
	ISteamMusic.get_volume = ISteamMusic.GetVolume

	return ISteamMusic
end

--
-- ISteamMusicRemote (STEAMMUSICREMOTE_INTERFACE_VERSION001, user created: false)
--

local ISteamMusicRemote = {version="STEAMMUSICREMOTE_INTERFACE_VERSION001",version_number=1}

index_funcs.ISteamMusicRemote = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 30, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMMUSICREMOTE_INTERFACE_VERSION001")

	local RegisterSteamMusicRemote_native = vtable_entry(this, 0, "bool(__thiscall*)(void*, const char *)")
	function ISteamMusicRemote.RegisterSteamMusicRemote(pchName)
		return RegisterSteamMusicRemote_native(this, pchName)
	end
	ISteamMusicRemote.register_steam_music_remote = ISteamMusicRemote.RegisterSteamMusicRemote

	local DeregisterSteamMusicRemote_native = vtable_entry(this, 1, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.DeregisterSteamMusicRemote()
		return DeregisterSteamMusicRemote_native(this)
	end
	ISteamMusicRemote.deregister_steam_music_remote = ISteamMusicRemote.DeregisterSteamMusicRemote

	local BIsCurrentMusicRemote_native = vtable_entry(this, 2, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.BIsCurrentMusicRemote()
		return BIsCurrentMusicRemote_native(this)
	end
	ISteamMusicRemote.is_current_music_remote = ISteamMusicRemote.BIsCurrentMusicRemote

	local BActivationSuccess_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.BActivationSuccess(bValue)
		return BActivationSuccess_native(this, bValue)
	end
	ISteamMusicRemote.activation_success = ISteamMusicRemote.BActivationSuccess

	local SetDisplayName_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, const char *)")
	function ISteamMusicRemote.SetDisplayName(pchDisplayName)
		return SetDisplayName_native(this, pchDisplayName)
	end
	ISteamMusicRemote.set_display_name = ISteamMusicRemote.SetDisplayName

	local SetPNGIcon_64x64_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, void *, uint32_t)")
	function ISteamMusicRemote.SetPNGIcon_64x64(pvBuffer, cbBufferLength)
		return SetPNGIcon_64x64_native(this, pvBuffer, cbBufferLength)
	end
	ISteamMusicRemote.set_png_icon_64x64 = ISteamMusicRemote.SetPNGIcon_64x64

	local EnablePlayPrevious_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.EnablePlayPrevious(bValue)
		return EnablePlayPrevious_native(this, bValue)
	end
	ISteamMusicRemote.enable_play_previous = ISteamMusicRemote.EnablePlayPrevious

	local EnablePlayNext_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.EnablePlayNext(bValue)
		return EnablePlayNext_native(this, bValue)
	end
	ISteamMusicRemote.enable_play_next = ISteamMusicRemote.EnablePlayNext

	local EnableShuffled_native = vtable_entry(this, 8, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.EnableShuffled(bValue)
		return EnableShuffled_native(this, bValue)
	end
	ISteamMusicRemote.enable_shuffled = ISteamMusicRemote.EnableShuffled

	local EnableLooped_native = vtable_entry(this, 9, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.EnableLooped(bValue)
		return EnableLooped_native(this, bValue)
	end
	ISteamMusicRemote.enable_looped = ISteamMusicRemote.EnableLooped

	local EnableQueue_native = vtable_entry(this, 10, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.EnableQueue(bValue)
		return EnableQueue_native(this, bValue)
	end
	ISteamMusicRemote.enable_queue = ISteamMusicRemote.EnableQueue

	local EnablePlaylists_native = vtable_entry(this, 11, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.EnablePlaylists(bValue)
		return EnablePlaylists_native(this, bValue)
	end
	ISteamMusicRemote.enable_playlists = ISteamMusicRemote.EnablePlaylists

	local UpdatePlaybackStatus_native = vtable_entry(this, 12, "bool(__thiscall*)(void*, int)")
	function ISteamMusicRemote.UpdatePlaybackStatus(nStatus)
		nStatus = to_enum_required(nStatus, enums.AudioPlayback_Status, "status is required")
		return UpdatePlaybackStatus_native(this, nStatus)
	end
	ISteamMusicRemote.update_playback_status = ISteamMusicRemote.UpdatePlaybackStatus

	local UpdateShuffled_native = vtable_entry(this, 13, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.UpdateShuffled(bValue)
		return UpdateShuffled_native(this, bValue)
	end
	ISteamMusicRemote.update_shuffled = ISteamMusicRemote.UpdateShuffled

	local UpdateLooped_native = vtable_entry(this, 14, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.UpdateLooped(bValue)
		return UpdateLooped_native(this, bValue)
	end
	ISteamMusicRemote.update_looped = ISteamMusicRemote.UpdateLooped

	local UpdateVolume_native = vtable_entry(this, 15, "bool(__thiscall*)(void*, float)")
	function ISteamMusicRemote.UpdateVolume(flValue)
		return UpdateVolume_native(this, flValue)
	end
	ISteamMusicRemote.update_volume = ISteamMusicRemote.UpdateVolume

	local CurrentEntryWillChange_native = vtable_entry(this, 16, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.CurrentEntryWillChange()
		return CurrentEntryWillChange_native(this)
	end
	ISteamMusicRemote.current_entry_will_change = ISteamMusicRemote.CurrentEntryWillChange

	local CurrentEntryIsAvailable_native = vtable_entry(this, 17, "bool(__thiscall*)(void*, bool)")
	function ISteamMusicRemote.CurrentEntryIsAvailable(bAvailable)
		return CurrentEntryIsAvailable_native(this, bAvailable)
	end
	ISteamMusicRemote.current_entry_is_available = ISteamMusicRemote.CurrentEntryIsAvailable

	local UpdateCurrentEntryText_native = vtable_entry(this, 18, "bool(__thiscall*)(void*, const char *)")
	function ISteamMusicRemote.UpdateCurrentEntryText(pchText)
		return UpdateCurrentEntryText_native(this, pchText)
	end
	ISteamMusicRemote.update_current_entry_text = ISteamMusicRemote.UpdateCurrentEntryText

	local UpdateCurrentEntryElapsedSeconds_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, int)")
	function ISteamMusicRemote.UpdateCurrentEntryElapsedSeconds(nValue)
		return UpdateCurrentEntryElapsedSeconds_native(this, nValue)
	end
	ISteamMusicRemote.update_current_entry_elapsed_seconds = ISteamMusicRemote.UpdateCurrentEntryElapsedSeconds

	local UpdateCurrentEntryCoverArt_native = vtable_entry(this, 20, "bool(__thiscall*)(void*, void *, uint32_t)")
	function ISteamMusicRemote.UpdateCurrentEntryCoverArt(pvBuffer, cbBufferLength)
		return UpdateCurrentEntryCoverArt_native(this, pvBuffer, cbBufferLength)
	end
	ISteamMusicRemote.update_current_entry_cover_art = ISteamMusicRemote.UpdateCurrentEntryCoverArt

	local CurrentEntryDidChange_native = vtable_entry(this, 21, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.CurrentEntryDidChange()
		return CurrentEntryDidChange_native(this)
	end
	ISteamMusicRemote.current_entry_did_change = ISteamMusicRemote.CurrentEntryDidChange

	local QueueWillChange_native = vtable_entry(this, 22, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.QueueWillChange()
		return QueueWillChange_native(this)
	end
	ISteamMusicRemote.queue_will_change = ISteamMusicRemote.QueueWillChange

	local ResetQueueEntries_native = vtable_entry(this, 23, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.ResetQueueEntries()
		return ResetQueueEntries_native(this)
	end
	ISteamMusicRemote.reset_queue_entries = ISteamMusicRemote.ResetQueueEntries

	local SetQueueEntry_native = vtable_entry(this, 24, "bool(__thiscall*)(void*, int, int, const char *)")
	function ISteamMusicRemote.SetQueueEntry(nID, nPosition, pchEntryText)
		return SetQueueEntry_native(this, nID, nPosition, pchEntryText)
	end
	ISteamMusicRemote.set_queue_entry = ISteamMusicRemote.SetQueueEntry

	local SetCurrentQueueEntry_native = vtable_entry(this, 25, "bool(__thiscall*)(void*, int)")
	function ISteamMusicRemote.SetCurrentQueueEntry(nID)
		return SetCurrentQueueEntry_native(this, nID)
	end
	ISteamMusicRemote.set_current_queue_entry = ISteamMusicRemote.SetCurrentQueueEntry

	local QueueDidChange_native = vtable_entry(this, 26, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.QueueDidChange()
		return QueueDidChange_native(this)
	end
	ISteamMusicRemote.queue_did_change = ISteamMusicRemote.QueueDidChange

	local PlaylistWillChange_native = vtable_entry(this, 27, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.PlaylistWillChange()
		return PlaylistWillChange_native(this)
	end
	ISteamMusicRemote.playlist_will_change = ISteamMusicRemote.PlaylistWillChange

	local ResetPlaylistEntries_native = vtable_entry(this, 28, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.ResetPlaylistEntries()
		return ResetPlaylistEntries_native(this)
	end
	ISteamMusicRemote.reset_playlist_entries = ISteamMusicRemote.ResetPlaylistEntries

	local SetPlaylistEntry_native = vtable_entry(this, 29, "bool(__thiscall*)(void*, int, int, const char *)")
	function ISteamMusicRemote.SetPlaylistEntry(nID, nPosition, pchEntryText)
		return SetPlaylistEntry_native(this, nID, nPosition, pchEntryText)
	end
	ISteamMusicRemote.set_playlist_entry = ISteamMusicRemote.SetPlaylistEntry

	local SetCurrentPlaylistEntry_native = vtable_entry(this, 30, "bool(__thiscall*)(void*, int)")
	function ISteamMusicRemote.SetCurrentPlaylistEntry(nID)
		return SetCurrentPlaylistEntry_native(this, nID)
	end
	ISteamMusicRemote.set_current_playlist_entry = ISteamMusicRemote.SetCurrentPlaylistEntry

	local PlaylistDidChange_native = vtable_entry(this, 31, "bool(__thiscall*)(void*)")
	function ISteamMusicRemote.PlaylistDidChange()
		return PlaylistDidChange_native(this)
	end
	ISteamMusicRemote.playlist_did_change = ISteamMusicRemote.PlaylistDidChange

	return ISteamMusicRemote
end

--
-- ISteamHTTP (STEAMHTTP_INTERFACE_VERSION003, user created: false)
--

local ISteamHTTP = {version="STEAMHTTP_INTERFACE_VERSION003",version_number=3}

index_funcs.ISteamHTTP = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 24, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMHTTP_INTERFACE_VERSION003")

	local CreateHTTPRequest_native = vtable_entry(this, 0, "unsigned int(__thiscall*)(void*, int, const char *)")
	function ISteamHTTP.CreateHTTPRequest(eHTTPRequestMethod, pchAbsoluteURL)
		eHTTPRequestMethod = to_enum_required(eHTTPRequestMethod, enums.EHTTPMethod, "http_request_method is required")
		return CreateHTTPRequest_native(this, eHTTPRequestMethod, pchAbsoluteURL)
	end
	ISteamHTTP.create_http_request = ISteamHTTP.CreateHTTPRequest

	local SetHTTPRequestContextValue_native = vtable_entry(this, 1, "bool(__thiscall*)(void*, unsigned int, uint64_t)")
	function ISteamHTTP.SetHTTPRequestContextValue(hRequest, ulContextValue)
		return SetHTTPRequestContextValue_native(this, hRequest, ulContextValue)
	end
	ISteamHTTP.set_http_request_context_value = ISteamHTTP.SetHTTPRequestContextValue

	local SetHTTPRequestNetworkActivityTimeout_native = vtable_entry(this, 2, "bool(__thiscall*)(void*, unsigned int, uint32_t)")
	function ISteamHTTP.SetHTTPRequestNetworkActivityTimeout(hRequest, unTimeoutSeconds)
		return SetHTTPRequestNetworkActivityTimeout_native(this, hRequest, unTimeoutSeconds)
	end
	ISteamHTTP.set_http_request_network_activity_timeout = ISteamHTTP.SetHTTPRequestNetworkActivityTimeout

	local SetHTTPRequestHeaderValue_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, unsigned int, const char *, const char *)")
	function ISteamHTTP.SetHTTPRequestHeaderValue(hRequest, pchHeaderName, pchHeaderValue)
		return SetHTTPRequestHeaderValue_native(this, hRequest, pchHeaderName, pchHeaderValue)
	end
	ISteamHTTP.set_http_request_header_value = ISteamHTTP.SetHTTPRequestHeaderValue

	local SetHTTPRequestGetOrPostParameter_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, unsigned int, const char *, const char *)")
	function ISteamHTTP.SetHTTPRequestGetOrPostParameter(hRequest, pchParamName, pchParamValue)
		return SetHTTPRequestGetOrPostParameter_native(this, hRequest, pchParamName, pchParamValue)
	end
	ISteamHTTP.set_http_request_get_or_post_parameter = ISteamHTTP.SetHTTPRequestGetOrPostParameter

	local SendHTTPRequest_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, unsigned int, uint64_t *)")
	local SendHTTPRequest_info = {
		struct = typeof([[
			struct {
				unsigned int m_hRequest;
				uint64_t m_ulContextValue;
				bool m_bRequestSuccessful;
				int m_eStatusCode;
				uint32_t m_unBodySize;
			} *
		]]),
		keys = {m_hRequest="request",m_ulContextValue="context_value",m_bRequestSuccessful="request_successful",m_eStatusCode="status_code",m_unBodySize="body_size"}
	}
	function ISteamHTTP.SendHTTPRequest(hRequest, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local pCallHandle_out = new_uint64_arr()
		local res = SendHTTPRequest_native(this, hRequest, pCallHandle_out)

		if callback ~= nil then
			pCallHandle_out = register_call_result(pCallHandle_out, callback, 2101, SendHTTPRequest_info)
		end

		return res, DEREF_GCSAFE(pCallHandle_out)
	end
	ISteamHTTP.send_http_request = ISteamHTTP.SendHTTPRequest

	local SendHTTPRequestAndStreamResponse_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, unsigned int, uint64_t *)")
	local SendHTTPRequestAndStreamResponse_info = {
		struct = typeof([[
			struct {
				unsigned int m_hRequest;
				uint64_t m_ulContextValue;
				bool m_bRequestSuccessful;
				int m_eStatusCode;
				uint32_t m_unBodySize;
			} *
		]]),
		keys = {m_hRequest="request",m_ulContextValue="context_value",m_bRequestSuccessful="request_successful",m_eStatusCode="status_code",m_unBodySize="body_size"}
	}
	function ISteamHTTP.SendHTTPRequestAndStreamResponse(hRequest, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local pCallHandle_out = new_uint64_arr()
		local res = SendHTTPRequestAndStreamResponse_native(this, hRequest, pCallHandle_out)

		if callback ~= nil then
			pCallHandle_out = register_call_result(pCallHandle_out, callback, 2101, SendHTTPRequestAndStreamResponse_info)
		end

		return res, DEREF_GCSAFE(pCallHandle_out)
	end
	ISteamHTTP.send_http_request_and_stream_response = ISteamHTTP.SendHTTPRequestAndStreamResponse

	local DeferHTTPRequest_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamHTTP.DeferHTTPRequest(hRequest)
		return DeferHTTPRequest_native(this, hRequest)
	end
	ISteamHTTP.defer_http_request = ISteamHTTP.DeferHTTPRequest

	local PrioritizeHTTPRequest_native = vtable_entry(this, 8, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamHTTP.PrioritizeHTTPRequest(hRequest)
		return PrioritizeHTTPRequest_native(this, hRequest)
	end
	ISteamHTTP.prioritize_http_request = ISteamHTTP.PrioritizeHTTPRequest

	local GetHTTPResponseHeaderSize_native = vtable_entry(this, 9, "bool(__thiscall*)(void*, unsigned int, const char *, uint32_t *)")
	function ISteamHTTP.GetHTTPResponseHeaderSize(hRequest, pchHeaderName)
		local unResponseHeaderSize_out = new_uint32_arr()
		local res = GetHTTPResponseHeaderSize_native(this, hRequest, pchHeaderName, unResponseHeaderSize_out)

		return res, DEREF_GCSAFE(unResponseHeaderSize_out)
	end
	ISteamHTTP.get_http_response_header_size = ISteamHTTP.GetHTTPResponseHeaderSize

	local GetHTTPResponseHeaderValue_native = vtable_entry(this, 10, "bool(__thiscall*)(void*, unsigned int, const char *, uint8_t *, uint32_t)")
	function ISteamHTTP.GetHTTPResponseHeaderValue(hRequest, pchHeaderName, pHeaderValueBuffer, unBufferSize)
		return GetHTTPResponseHeaderValue_native(this, hRequest, pchHeaderName, pHeaderValueBuffer, unBufferSize)
	end
	ISteamHTTP.get_http_response_header_value = ISteamHTTP.GetHTTPResponseHeaderValue

	local GetHTTPResponseBodySize_native = vtable_entry(this, 11, "bool(__thiscall*)(void*, unsigned int, uint32_t *)")
	function ISteamHTTP.GetHTTPResponseBodySize(hRequest)
		local unBodySize_out = new_uint32_arr()
		local res = GetHTTPResponseBodySize_native(this, hRequest, unBodySize_out)

		return res, DEREF_GCSAFE(unBodySize_out)
	end
	ISteamHTTP.get_http_response_body_size = ISteamHTTP.GetHTTPResponseBodySize

	local GetHTTPResponseBodyData_native = vtable_entry(this, 12, "bool(__thiscall*)(void*, unsigned int, uint8_t *, uint32_t)")
	function ISteamHTTP.GetHTTPResponseBodyData(hRequest, pBodyDataBuffer, unBufferSize)
		return GetHTTPResponseBodyData_native(this, hRequest, pBodyDataBuffer, unBufferSize)
	end
	ISteamHTTP.get_http_response_body_data = ISteamHTTP.GetHTTPResponseBodyData

	local GetHTTPStreamingResponseBodyData_native = vtable_entry(this, 13, "bool(__thiscall*)(void*, unsigned int, uint32_t, uint8_t *, uint32_t)")
	function ISteamHTTP.GetHTTPStreamingResponseBodyData(hRequest, cOffset, pBodyDataBuffer, unBufferSize)
		return GetHTTPStreamingResponseBodyData_native(this, hRequest, cOffset, pBodyDataBuffer, unBufferSize)
	end
	ISteamHTTP.get_http_streaming_response_body_data = ISteamHTTP.GetHTTPStreamingResponseBodyData

	local ReleaseHTTPRequest_native = vtable_entry(this, 14, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamHTTP.ReleaseHTTPRequest(hRequest)
		return ReleaseHTTPRequest_native(this, hRequest)
	end
	ISteamHTTP.release_http_request = ISteamHTTP.ReleaseHTTPRequest

	local GetHTTPDownloadProgressPct_native = vtable_entry(this, 15, "bool(__thiscall*)(void*, unsigned int, float *)")
	function ISteamHTTP.GetHTTPDownloadProgressPct(hRequest)
		local pflPercentOut_out = new_float_arr()
		local res = GetHTTPDownloadProgressPct_native(this, hRequest, pflPercentOut_out)

		return res, DEREF_GCSAFE(pflPercentOut_out)
	end
	ISteamHTTP.get_http_download_progress_pct = ISteamHTTP.GetHTTPDownloadProgressPct

	local SetHTTPRequestRawPostBody_native = vtable_entry(this, 16, "bool(__thiscall*)(void*, unsigned int, const char *, uint8_t *, uint32_t)")
	function ISteamHTTP.SetHTTPRequestRawPostBody(hRequest, pchContentType, pubBody, unBodyLen)
		return SetHTTPRequestRawPostBody_native(this, hRequest, pchContentType, pubBody, unBodyLen)
	end
	ISteamHTTP.set_http_request_raw_post_body = ISteamHTTP.SetHTTPRequestRawPostBody

	local CreateCookieContainer_native = vtable_entry(this, 17, "unsigned int(__thiscall*)(void*, bool)")
	function ISteamHTTP.CreateCookieContainer(bAllowResponsesToModify)
		return CreateCookieContainer_native(this, bAllowResponsesToModify)
	end
	ISteamHTTP.create_cookie_container = ISteamHTTP.CreateCookieContainer

	local ReleaseCookieContainer_native = vtable_entry(this, 18, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamHTTP.ReleaseCookieContainer(hCookieContainer)
		return ReleaseCookieContainer_native(this, hCookieContainer)
	end
	ISteamHTTP.release_cookie_container = ISteamHTTP.ReleaseCookieContainer

	local SetCookie_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, unsigned int, const char *, const char *, const char *)")
	function ISteamHTTP.SetCookie(hCookieContainer, pchHost, pchUrl, pchCookie)
		return SetCookie_native(this, hCookieContainer, pchHost, pchUrl, pchCookie)
	end
	ISteamHTTP.set_cookie = ISteamHTTP.SetCookie

	local SetHTTPRequestCookieContainer_native = vtable_entry(this, 20, "bool(__thiscall*)(void*, unsigned int, unsigned int)")
	function ISteamHTTP.SetHTTPRequestCookieContainer(hRequest, hCookieContainer)
		return SetHTTPRequestCookieContainer_native(this, hRequest, hCookieContainer)
	end
	ISteamHTTP.set_http_request_cookie_container = ISteamHTTP.SetHTTPRequestCookieContainer

	local SetHTTPRequestUserAgentInfo_native = vtable_entry(this, 21, "bool(__thiscall*)(void*, unsigned int, const char *)")
	function ISteamHTTP.SetHTTPRequestUserAgentInfo(hRequest, pchUserAgentInfo)
		return SetHTTPRequestUserAgentInfo_native(this, hRequest, pchUserAgentInfo)
	end
	ISteamHTTP.set_http_request_user_agent_info = ISteamHTTP.SetHTTPRequestUserAgentInfo

	local SetHTTPRequestRequiresVerifiedCertificate_native = vtable_entry(this, 22, "bool(__thiscall*)(void*, unsigned int, bool)")
	function ISteamHTTP.SetHTTPRequestRequiresVerifiedCertificate(hRequest, bRequireVerifiedCertificate)
		return SetHTTPRequestRequiresVerifiedCertificate_native(this, hRequest, bRequireVerifiedCertificate)
	end
	ISteamHTTP.set_http_request_requires_verified_certificate = ISteamHTTP.SetHTTPRequestRequiresVerifiedCertificate

	local SetHTTPRequestAbsoluteTimeoutMS_native = vtable_entry(this, 23, "bool(__thiscall*)(void*, unsigned int, uint32_t)")
	function ISteamHTTP.SetHTTPRequestAbsoluteTimeoutMS(hRequest, unMilliseconds)
		return SetHTTPRequestAbsoluteTimeoutMS_native(this, hRequest, unMilliseconds)
	end
	ISteamHTTP.set_http_request_absolute_timeout_ms = ISteamHTTP.SetHTTPRequestAbsoluteTimeoutMS

	local GetHTTPRequestWasTimedOut_native = vtable_entry(this, 24, "bool(__thiscall*)(void*, unsigned int, bool *)")
	function ISteamHTTP.GetHTTPRequestWasTimedOut(hRequest)
		local pbWasTimedOut_out = new_bool_arr()
		local res = GetHTTPRequestWasTimedOut_native(this, hRequest, pbWasTimedOut_out)

		return res, DEREF_GCSAFE(pbWasTimedOut_out)
	end
	ISteamHTTP.get_http_request_was_timed_out = ISteamHTTP.GetHTTPRequestWasTimedOut

	return ISteamHTTP
end

--
-- ISteamHTMLSurface (STEAMHTMLSURFACE_INTERFACE_VERSION_005, user created: false)
--

local ISteamHTMLSurface = {version="STEAMHTMLSURFACE_INTERFACE_VERSION_005",version_number=5}

index_funcs.ISteamHTMLSurface = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 31, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMHTMLSURFACE_INTERFACE_VERSION_005")

	local Init_native = vtable_entry(this, 1, "bool(__thiscall*)(void*)")
	function ISteamHTMLSurface.Init()
		return Init_native(this)
	end
	ISteamHTMLSurface.init = ISteamHTMLSurface.Init

	local Shutdown_native = vtable_entry(this, 2, "bool(__thiscall*)(void*)")
	function ISteamHTMLSurface.Shutdown()
		return Shutdown_native(this)
	end
	ISteamHTMLSurface.shutdown = ISteamHTMLSurface.Shutdown

	local CreateBrowser_native = vtable_entry(this, 3, "uint64_t(__thiscall*)(void*, const char *, const char *)")
	local CreateBrowser_info = {
		struct = typeof([[
			struct {
				unsigned int unBrowserHandle;
			} *
		]]),
		keys = {unBrowserHandle="browser_handle"}
	}
	function ISteamHTMLSurface.CreateBrowser(pchUserAgent, pchUserCSS, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = CreateBrowser_native(this, pchUserAgent, pchUserCSS)

		if callback ~= nil then
			res = register_call_result(res, callback, 4501, CreateBrowser_info)
		end

		return res
	end
	ISteamHTMLSurface.create_browser = ISteamHTMLSurface.CreateBrowser

	local RemoveBrowser_native = vtable_entry(this, 4, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.RemoveBrowser(unBrowserHandle)
		return RemoveBrowser_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.remove_browser = ISteamHTMLSurface.RemoveBrowser

	local LoadURL_native = vtable_entry(this, 5, "void(__thiscall*)(void*, unsigned int, const char *, const char *)")
	function ISteamHTMLSurface.LoadURL(unBrowserHandle, pchURL, pchPostData)
		return LoadURL_native(this, unBrowserHandle, pchURL, pchPostData)
	end
	ISteamHTMLSurface.load_url = ISteamHTMLSurface.LoadURL

	local SetSize_native = vtable_entry(this, 6, "void(__thiscall*)(void*, unsigned int, uint32_t, uint32_t)")
	function ISteamHTMLSurface.SetSize(unBrowserHandle, unWidth, unHeight)
		return SetSize_native(this, unBrowserHandle, unWidth, unHeight)
	end
	ISteamHTMLSurface.set_size = ISteamHTMLSurface.SetSize

	local StopLoad_native = vtable_entry(this, 7, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.StopLoad(unBrowserHandle)
		return StopLoad_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.stop_load = ISteamHTMLSurface.StopLoad

	local Reload_native = vtable_entry(this, 8, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.Reload(unBrowserHandle)
		return Reload_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.reload = ISteamHTMLSurface.Reload

	local GoBack_native = vtable_entry(this, 9, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.GoBack(unBrowserHandle)
		return GoBack_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.go_back = ISteamHTMLSurface.GoBack

	local GoForward_native = vtable_entry(this, 10, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.GoForward(unBrowserHandle)
		return GoForward_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.go_forward = ISteamHTMLSurface.GoForward

	local AddHeader_native = vtable_entry(this, 11, "void(__thiscall*)(void*, unsigned int, const char *, const char *)")
	function ISteamHTMLSurface.AddHeader(unBrowserHandle, pchKey, pchValue)
		return AddHeader_native(this, unBrowserHandle, pchKey, pchValue)
	end
	ISteamHTMLSurface.add_header = ISteamHTMLSurface.AddHeader

	local ExecuteJavascript_native = vtable_entry(this, 12, "void(__thiscall*)(void*, unsigned int, const char *)")
	function ISteamHTMLSurface.ExecuteJavascript(unBrowserHandle, pchScript)
		return ExecuteJavascript_native(this, unBrowserHandle, pchScript)
	end
	ISteamHTMLSurface.execute_javascript = ISteamHTMLSurface.ExecuteJavascript

	local MouseUp_native = vtable_entry(this, 13, "void(__thiscall*)(void*, unsigned int, int)")
	function ISteamHTMLSurface.MouseUp(unBrowserHandle, eMouseButton)
		eMouseButton = to_enum_required(eMouseButton, enums.EHTMLMouseButton, "mouse_button is required")
		return MouseUp_native(this, unBrowserHandle, eMouseButton)
	end
	ISteamHTMLSurface.mouse_up = ISteamHTMLSurface.MouseUp

	local MouseDown_native = vtable_entry(this, 14, "void(__thiscall*)(void*, unsigned int, int)")
	function ISteamHTMLSurface.MouseDown(unBrowserHandle, eMouseButton)
		eMouseButton = to_enum_required(eMouseButton, enums.EHTMLMouseButton, "mouse_button is required")
		return MouseDown_native(this, unBrowserHandle, eMouseButton)
	end
	ISteamHTMLSurface.mouse_down = ISteamHTMLSurface.MouseDown

	local MouseDoubleClick_native = vtable_entry(this, 15, "void(__thiscall*)(void*, unsigned int, int)")
	function ISteamHTMLSurface.MouseDoubleClick(unBrowserHandle, eMouseButton)
		eMouseButton = to_enum_required(eMouseButton, enums.EHTMLMouseButton, "mouse_button is required")
		return MouseDoubleClick_native(this, unBrowserHandle, eMouseButton)
	end
	ISteamHTMLSurface.mouse_double_click = ISteamHTMLSurface.MouseDoubleClick

	local MouseMove_native = vtable_entry(this, 16, "void(__thiscall*)(void*, unsigned int, int, int)")
	function ISteamHTMLSurface.MouseMove(unBrowserHandle, x, y)
		return MouseMove_native(this, unBrowserHandle, x, y)
	end
	ISteamHTMLSurface.mouse_move = ISteamHTMLSurface.MouseMove

	local MouseWheel_native = vtable_entry(this, 17, "void(__thiscall*)(void*, unsigned int, int32_t)")
	function ISteamHTMLSurface.MouseWheel(unBrowserHandle, nDelta)
		return MouseWheel_native(this, unBrowserHandle, nDelta)
	end
	ISteamHTMLSurface.mouse_wheel = ISteamHTMLSurface.MouseWheel

	local KeyDown_native = vtable_entry(this, 18, "void(__thiscall*)(void*, unsigned int, uint32_t, int, bool)")
	function ISteamHTMLSurface.KeyDown(unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers, bIsSystemKey)
		eHTMLKeyModifiers = to_enum_required(eHTMLKeyModifiers, enums.EHTMLKeyModifiers, "html_key_modifiers is required")
		return KeyDown_native(this, unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers, bIsSystemKey)
	end
	ISteamHTMLSurface.key_down = ISteamHTMLSurface.KeyDown

	local KeyUp_native = vtable_entry(this, 19, "void(__thiscall*)(void*, unsigned int, uint32_t, int)")
	function ISteamHTMLSurface.KeyUp(unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers)
		eHTMLKeyModifiers = to_enum_required(eHTMLKeyModifiers, enums.EHTMLKeyModifiers, "html_key_modifiers is required")
		return KeyUp_native(this, unBrowserHandle, nNativeKeyCode, eHTMLKeyModifiers)
	end
	ISteamHTMLSurface.key_up = ISteamHTMLSurface.KeyUp

	local KeyChar_native = vtable_entry(this, 20, "void(__thiscall*)(void*, unsigned int, uint32_t, int)")
	function ISteamHTMLSurface.KeyChar(unBrowserHandle, cUnicodeChar, eHTMLKeyModifiers)
		eHTMLKeyModifiers = to_enum_required(eHTMLKeyModifiers, enums.EHTMLKeyModifiers, "html_key_modifiers is required")
		return KeyChar_native(this, unBrowserHandle, cUnicodeChar, eHTMLKeyModifiers)
	end
	ISteamHTMLSurface.key_char = ISteamHTMLSurface.KeyChar

	local SetHorizontalScroll_native = vtable_entry(this, 21, "void(__thiscall*)(void*, unsigned int, uint32_t)")
	function ISteamHTMLSurface.SetHorizontalScroll(unBrowserHandle, nAbsolutePixelScroll)
		return SetHorizontalScroll_native(this, unBrowserHandle, nAbsolutePixelScroll)
	end
	ISteamHTMLSurface.set_horizontal_scroll = ISteamHTMLSurface.SetHorizontalScroll

	local SetVerticalScroll_native = vtable_entry(this, 22, "void(__thiscall*)(void*, unsigned int, uint32_t)")
	function ISteamHTMLSurface.SetVerticalScroll(unBrowserHandle, nAbsolutePixelScroll)
		return SetVerticalScroll_native(this, unBrowserHandle, nAbsolutePixelScroll)
	end
	ISteamHTMLSurface.set_vertical_scroll = ISteamHTMLSurface.SetVerticalScroll

	local SetKeyFocus_native = vtable_entry(this, 23, "void(__thiscall*)(void*, unsigned int, bool)")
	function ISteamHTMLSurface.SetKeyFocus(unBrowserHandle, bHasKeyFocus)
		return SetKeyFocus_native(this, unBrowserHandle, bHasKeyFocus)
	end
	ISteamHTMLSurface.set_key_focus = ISteamHTMLSurface.SetKeyFocus

	local ViewSource_native = vtable_entry(this, 24, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.ViewSource(unBrowserHandle)
		return ViewSource_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.view_source = ISteamHTMLSurface.ViewSource

	local CopyToClipboard_native = vtable_entry(this, 25, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.CopyToClipboard(unBrowserHandle)
		return CopyToClipboard_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.copy_to_clipboard = ISteamHTMLSurface.CopyToClipboard

	local PasteFromClipboard_native = vtable_entry(this, 26, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.PasteFromClipboard(unBrowserHandle)
		return PasteFromClipboard_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.paste_from_clipboard = ISteamHTMLSurface.PasteFromClipboard

	local Find_native = vtable_entry(this, 27, "void(__thiscall*)(void*, unsigned int, const char *, bool, bool)")
	function ISteamHTMLSurface.Find(unBrowserHandle, pchSearchStr, bCurrentlyInFind, bReverse)
		return Find_native(this, unBrowserHandle, pchSearchStr, bCurrentlyInFind, bReverse)
	end
	ISteamHTMLSurface.find = ISteamHTMLSurface.Find

	local StopFind_native = vtable_entry(this, 28, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.StopFind(unBrowserHandle)
		return StopFind_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.stop_find = ISteamHTMLSurface.StopFind

	local GetLinkAtPosition_native = vtable_entry(this, 29, "void(__thiscall*)(void*, unsigned int, int, int)")
	function ISteamHTMLSurface.GetLinkAtPosition(unBrowserHandle, x, y)
		return GetLinkAtPosition_native(this, unBrowserHandle, x, y)
	end
	ISteamHTMLSurface.get_link_at_position = ISteamHTMLSurface.GetLinkAtPosition

	local SetCookie_native = vtable_entry(this, 30, "void(__thiscall*)(void*, const char *, const char *, const char *, const char *, unsigned int, bool, bool)")
	function ISteamHTMLSurface.SetCookie(pchHostname, pchKey, pchValue, pchPath, nExpires, bSecure, bHTTPOnly)
		return SetCookie_native(this, pchHostname, pchKey, pchValue, pchPath, nExpires, bSecure, bHTTPOnly)
	end
	ISteamHTMLSurface.set_cookie = ISteamHTMLSurface.SetCookie

	local SetPageScaleFactor_native = vtable_entry(this, 31, "void(__thiscall*)(void*, unsigned int, float, int, int)")
	function ISteamHTMLSurface.SetPageScaleFactor(unBrowserHandle, flZoom, nPointX, nPointY)
		return SetPageScaleFactor_native(this, unBrowserHandle, flZoom, nPointX, nPointY)
	end
	ISteamHTMLSurface.set_page_scale_factor = ISteamHTMLSurface.SetPageScaleFactor

	local SetBackgroundMode_native = vtable_entry(this, 32, "void(__thiscall*)(void*, unsigned int, bool)")
	function ISteamHTMLSurface.SetBackgroundMode(unBrowserHandle, bBackgroundMode)
		return SetBackgroundMode_native(this, unBrowserHandle, bBackgroundMode)
	end
	ISteamHTMLSurface.set_background_mode = ISteamHTMLSurface.SetBackgroundMode

	local SetDPIScalingFactor_native = vtable_entry(this, 33, "void(__thiscall*)(void*, unsigned int, float)")
	function ISteamHTMLSurface.SetDPIScalingFactor(unBrowserHandle, flDPIScaling)
		return SetDPIScalingFactor_native(this, unBrowserHandle, flDPIScaling)
	end
	ISteamHTMLSurface.set_dpi_scaling_factor = ISteamHTMLSurface.SetDPIScalingFactor

	local OpenDeveloperTools_native = vtable_entry(this, 34, "void(__thiscall*)(void*, unsigned int)")
	function ISteamHTMLSurface.OpenDeveloperTools(unBrowserHandle)
		return OpenDeveloperTools_native(this, unBrowserHandle)
	end
	ISteamHTMLSurface.open_developer_tools = ISteamHTMLSurface.OpenDeveloperTools

	local AllowStartRequest_native = vtable_entry(this, 35, "void(__thiscall*)(void*, unsigned int, bool)")
	function ISteamHTMLSurface.AllowStartRequest(unBrowserHandle, bAllowed)
		return AllowStartRequest_native(this, unBrowserHandle, bAllowed)
	end
	ISteamHTMLSurface.allow_start_request = ISteamHTMLSurface.AllowStartRequest

	local JSDialogResponse_native = vtable_entry(this, 36, "void(__thiscall*)(void*, unsigned int, bool)")
	function ISteamHTMLSurface.JSDialogResponse(unBrowserHandle, bResult)
		return JSDialogResponse_native(this, unBrowserHandle, bResult)
	end
	ISteamHTMLSurface.js_dialog_response = ISteamHTMLSurface.JSDialogResponse

	local FileLoadDialogResponse_native = vtable_entry(this, 37, "void(__thiscall*)(void*, unsigned int, const char **)")
	function ISteamHTMLSurface.FileLoadDialogResponse(unBrowserHandle, pchSelectedFiles)
		return FileLoadDialogResponse_native(this, unBrowserHandle, pchSelectedFiles)
	end
	ISteamHTMLSurface.file_load_dialog_response = ISteamHTMLSurface.FileLoadDialogResponse

	return ISteamHTMLSurface
end

--
-- ISteamInventory (STEAMINVENTORY_INTERFACE_V003, user created: false)
--

local ISteamInventory = {version="STEAMINVENTORY_INTERFACE_V003",version_number=3}

index_funcs.ISteamInventory = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 35, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMINVENTORY_INTERFACE_V003")

	local GetResultStatus_native = vtable_entry(this, 0, "int(__thiscall*)(void*, int)")
	function ISteamInventory.GetResultStatus(resultHandle)
		return GetResultStatus_native(this, resultHandle)
	end
	ISteamInventory.get_result_status = ISteamInventory.GetResultStatus

	local GetResultItems_native = vtable_entry(this, 1, "bool(__thiscall*)(void*, int, SteamItemDetails_t *, uint32_t *)")
	function ISteamInventory.GetResultItems(resultHandle, pOutItemsArray, punOutItemsArraySize)
		return GetResultItems_native(this, resultHandle, pOutItemsArray, punOutItemsArraySize)
	end
	ISteamInventory.get_result_items = ISteamInventory.GetResultItems

	local GetResultItemProperty_native = vtable_entry(this, 2, "bool(__thiscall*)(void*, int, uint32_t, const char *, char *, uint32_t *)")
	function ISteamInventory.GetResultItemProperty(resultHandle, unItemIndex, pchPropertyName, pchValueBuffer, punValueBufferSizeOut)
		return GetResultItemProperty_native(this, resultHandle, unItemIndex, pchPropertyName, pchValueBuffer, punValueBufferSizeOut)
	end
	ISteamInventory.get_result_item_property = ISteamInventory.GetResultItemProperty

	local GetResultTimestamp_native = vtable_entry(this, 3, "uint32_t(__thiscall*)(void*, int)")
	function ISteamInventory.GetResultTimestamp(resultHandle)
		return GetResultTimestamp_native(this, resultHandle)
	end
	ISteamInventory.get_result_timestamp = ISteamInventory.GetResultTimestamp

	local CheckResultSteamID_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, int, SteamID)")
	function ISteamInventory.CheckResultSteamID(resultHandle, steamIDExpected)
		steamIDExpected = to_steamid_required(steamIDExpected, "steamid_expected is required")
		return CheckResultSteamID_native(this, resultHandle, steamIDExpected)
	end
	ISteamInventory.check_result_steamid = ISteamInventory.CheckResultSteamID

	local DestroyResult_native = vtable_entry(this, 5, "void(__thiscall*)(void*, int)")
	function ISteamInventory.DestroyResult(resultHandle)
		return DestroyResult_native(this, resultHandle)
	end
	ISteamInventory.destroy_result = ISteamInventory.DestroyResult

	local GetAllItems_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, int *)")
	function ISteamInventory.GetAllItems()
		local pResultHandle_out = new_int_arr()
		local res = GetAllItems_native(this, pResultHandle_out)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.get_all_items = ISteamInventory.GetAllItems

	local GetItemsByID_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, int *, const uint64_t *, uint32_t)")
	function ISteamInventory.GetItemsByID(pInstanceIDs, unCountInstanceIDs)
		local pResultHandle_out = new_int_arr()
		local res = GetItemsByID_native(this, pResultHandle_out, pInstanceIDs, unCountInstanceIDs)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.get_items_by_id = ISteamInventory.GetItemsByID

	local SerializeResult_native = vtable_entry(this, 8, "bool(__thiscall*)(void*, int, void *, uint32_t *)")
	function ISteamInventory.SerializeResult(resultHandle, pOutBuffer, punOutBufferSize)
		return SerializeResult_native(this, resultHandle, pOutBuffer, punOutBufferSize)
	end
	ISteamInventory.serialize_result = ISteamInventory.SerializeResult

	local DeserializeResult_native = vtable_entry(this, 9, "bool(__thiscall*)(void*, int *, const void *, uint32_t, bool)")
	function ISteamInventory.DeserializeResult(pBuffer, unBufferSize, bRESERVED_MUST_BE_FALSE)
		local pOutResultHandle_out = new_int_arr()
		local res = DeserializeResult_native(this, pOutResultHandle_out, pBuffer, unBufferSize, bRESERVED_MUST_BE_FALSE)

		return res, DEREF_GCSAFE(pOutResultHandle_out)
	end
	ISteamInventory.deserialize_result = ISteamInventory.DeserializeResult

	local GenerateItems_native = vtable_entry(this, 10, "bool(__thiscall*)(void*, int *, const int *, const uint32_t *, uint32_t)")
	function ISteamInventory.GenerateItems(pArrayItemDefs, punArrayQuantity, unArrayLength)
		local pResultHandle_out = new_int_arr()
		local res = GenerateItems_native(this, pResultHandle_out, pArrayItemDefs, punArrayQuantity, unArrayLength)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.generate_items = ISteamInventory.GenerateItems

	local GrantPromoItems_native = vtable_entry(this, 11, "bool(__thiscall*)(void*, int *)")
	function ISteamInventory.GrantPromoItems()
		local pResultHandle_out = new_int_arr()
		local res = GrantPromoItems_native(this, pResultHandle_out)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.grant_promo_items = ISteamInventory.GrantPromoItems

	local AddPromoItem_native = vtable_entry(this, 12, "bool(__thiscall*)(void*, int *, int)")
	function ISteamInventory.AddPromoItem(itemDef)
		local pResultHandle_out = new_int_arr()
		local res = AddPromoItem_native(this, pResultHandle_out, itemDef)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.add_promo_item = ISteamInventory.AddPromoItem

	local AddPromoItems_native = vtable_entry(this, 13, "bool(__thiscall*)(void*, int *, const int *, uint32_t)")
	function ISteamInventory.AddPromoItems(pArrayItemDefs, unArrayLength)
		local pResultHandle_out = new_int_arr()
		local res = AddPromoItems_native(this, pResultHandle_out, pArrayItemDefs, unArrayLength)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.add_promo_items = ISteamInventory.AddPromoItems

	local ConsumeItem_native = vtable_entry(this, 14, "bool(__thiscall*)(void*, int *, uint64_t, uint32_t)")
	function ISteamInventory.ConsumeItem(itemConsume, unQuantity)
		local pResultHandle_out = new_int_arr()
		local res = ConsumeItem_native(this, pResultHandle_out, itemConsume, unQuantity)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.consume_item = ISteamInventory.ConsumeItem

	local ExchangeItems_native = vtable_entry(this, 15, "bool(__thiscall*)(void*, int *, const int *, const uint32_t *, uint32_t, const uint64_t *, const uint32_t *, uint32_t)")
	function ISteamInventory.ExchangeItems(pArrayGenerate, punArrayGenerateQuantity, unArrayGenerateLength, pArrayDestroy, punArrayDestroyQuantity, unArrayDestroyLength)
		local pResultHandle_out = new_int_arr()
		local res = ExchangeItems_native(this, pResultHandle_out, pArrayGenerate, punArrayGenerateQuantity, unArrayGenerateLength, pArrayDestroy, punArrayDestroyQuantity, unArrayDestroyLength)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.exchange_items = ISteamInventory.ExchangeItems

	local TransferItemQuantity_native = vtable_entry(this, 16, "bool(__thiscall*)(void*, int *, uint64_t, uint32_t, uint64_t)")
	function ISteamInventory.TransferItemQuantity(itemIdSource, unQuantity, itemIdDest)
		local pResultHandle_out = new_int_arr()
		local res = TransferItemQuantity_native(this, pResultHandle_out, itemIdSource, unQuantity, itemIdDest)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.transfer_item_quantity = ISteamInventory.TransferItemQuantity

	local SendItemDropHeartbeat_native = vtable_entry(this, 17, "void(__thiscall*)(void*)")
	function ISteamInventory.SendItemDropHeartbeat()
		return SendItemDropHeartbeat_native(this)
	end
	ISteamInventory.send_item_drop_heartbeat = ISteamInventory.SendItemDropHeartbeat

	local TriggerItemDrop_native = vtable_entry(this, 18, "bool(__thiscall*)(void*, int *, int)")
	function ISteamInventory.TriggerItemDrop(dropListDefinition)
		local pResultHandle_out = new_int_arr()
		local res = TriggerItemDrop_native(this, pResultHandle_out, dropListDefinition)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.trigger_item_drop = ISteamInventory.TriggerItemDrop

	local TradeItems_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, int *, SteamID, const uint64_t *, const uint32_t *, uint32_t, const uint64_t *, const uint32_t *, uint32_t)")
	function ISteamInventory.TradeItems(steamIDTradePartner, pArrayGive, pArrayGiveQuantity, nArrayGiveLength, pArrayGet, pArrayGetQuantity, nArrayGetLength)
		steamIDTradePartner = to_steamid_required(steamIDTradePartner, "steamid_trade_partner is required")
		local pResultHandle_out = new_int_arr()
		local res = TradeItems_native(this, pResultHandle_out, steamIDTradePartner, pArrayGive, pArrayGiveQuantity, nArrayGiveLength, pArrayGet, pArrayGetQuantity, nArrayGetLength)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.trade_items = ISteamInventory.TradeItems

	local LoadItemDefinitions_native = vtable_entry(this, 20, "bool(__thiscall*)(void*)")
	function ISteamInventory.LoadItemDefinitions()
		return LoadItemDefinitions_native(this)
	end
	ISteamInventory.load_item_definitions = ISteamInventory.LoadItemDefinitions

	local GetItemDefinitionIDs_native = vtable_entry(this, 21, "bool(__thiscall*)(void*, int *, uint32_t *)")
	function ISteamInventory.GetItemDefinitionIDs(pItemDefIDs, punItemDefIDsArraySize)
		return GetItemDefinitionIDs_native(this, pItemDefIDs, punItemDefIDsArraySize)
	end
	ISteamInventory.get_item_definition_ids = ISteamInventory.GetItemDefinitionIDs

	local GetItemDefinitionProperty_native = vtable_entry(this, 22, "bool(__thiscall*)(void*, int, const char *, char *, uint32_t *)")
	function ISteamInventory.GetItemDefinitionProperty(iDefinition, pchPropertyName, pchValueBuffer, punValueBufferSizeOut)
		return GetItemDefinitionProperty_native(this, iDefinition, pchPropertyName, pchValueBuffer, punValueBufferSizeOut)
	end
	ISteamInventory.get_item_definition_property = ISteamInventory.GetItemDefinitionProperty

	local RequestEligiblePromoItemDefinitionsIDs_native = vtable_entry(this, 23, "uint64_t(__thiscall*)(void*, SteamID)")
	local RequestEligiblePromoItemDefinitionsIDs_info = {
		struct = typeof([[
			struct {
				int m_result;
				SteamID m_steamID;
				int m_numEligiblePromoItemDefs;
				bool m_bCachedData;
			} *
		]]),
		keys = {m_result="result",m_steamID="steamid",m_numEligiblePromoItemDefs="num_eligible_promo_item_defs",m_bCachedData="cached_data"}
	}
	function ISteamInventory.RequestEligiblePromoItemDefinitionsIDs(steamID, callback)
		steamID = to_steamid_required(steamID, "steamid is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestEligiblePromoItemDefinitionsIDs_native(this, steamID)

		if callback ~= nil then
			res = register_call_result(res, callback, 4703, RequestEligiblePromoItemDefinitionsIDs_info)
		end

		return res
	end
	ISteamInventory.request_eligible_promo_item_definitions_ids = ISteamInventory.RequestEligiblePromoItemDefinitionsIDs

	local GetEligiblePromoItemDefinitionIDs_native = vtable_entry(this, 24, "bool(__thiscall*)(void*, SteamID, int *, uint32_t *)")
	function ISteamInventory.GetEligiblePromoItemDefinitionIDs(steamID, pItemDefIDs, punItemDefIDsArraySize)
		steamID = to_steamid_required(steamID, "steamid is required")
		return GetEligiblePromoItemDefinitionIDs_native(this, steamID, pItemDefIDs, punItemDefIDsArraySize)
	end
	ISteamInventory.get_eligible_promo_item_definition_ids = ISteamInventory.GetEligiblePromoItemDefinitionIDs

	local StartPurchase_native = vtable_entry(this, 25, "uint64_t(__thiscall*)(void*, const int *, const uint32_t *, uint32_t)")
	local StartPurchase_info = {
		struct = typeof([[
			struct {
				int m_result;
				uint64_t m_ulOrderID;
				uint64_t m_ulTransID;
			} *
		]]),
		keys = {m_result="result",m_ulOrderID="order_id",m_ulTransID="trans_id"}
	}
	function ISteamInventory.StartPurchase(pArrayItemDefs, punArrayQuantity, unArrayLength, callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = StartPurchase_native(this, pArrayItemDefs, punArrayQuantity, unArrayLength)

		if callback ~= nil then
			res = register_call_result(res, callback, 4704, StartPurchase_info)
		end

		return res
	end
	ISteamInventory.start_purchase = ISteamInventory.StartPurchase

	local RequestPrices_native = vtable_entry(this, 26, "uint64_t(__thiscall*)(void*)")
	local RequestPrices_info = {
		struct = typeof([[
			struct {
				int m_result;
				char m_rgchCurrency[4];
			} *
		]]),
		keys = {m_result="result",m_rgchCurrency="currency"}
	}
	function ISteamInventory.RequestPrices(callback)
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestPrices_native(this)

		if callback ~= nil then
			res = register_call_result(res, callback, 4705, RequestPrices_info)
		end

		return res
	end
	ISteamInventory.request_prices = ISteamInventory.RequestPrices

	local GetNumItemsWithPrices_native = vtable_entry(this, 27, "uint32_t(__thiscall*)(void*)")
	function ISteamInventory.GetNumItemsWithPrices()
		return GetNumItemsWithPrices_native(this)
	end
	ISteamInventory.get_num_items_with_prices = ISteamInventory.GetNumItemsWithPrices

	local GetItemsWithPrices_native = vtable_entry(this, 28, "bool(__thiscall*)(void*, int *, uint64_t *, uint64_t *, uint32_t)")
	function ISteamInventory.GetItemsWithPrices(pArrayItemDefs, pCurrentPrices, pBasePrices, unArrayLength)
		return GetItemsWithPrices_native(this, pArrayItemDefs, pCurrentPrices, pBasePrices, unArrayLength)
	end
	ISteamInventory.get_items_with_prices = ISteamInventory.GetItemsWithPrices

	local GetItemPrice_native = vtable_entry(this, 29, "bool(__thiscall*)(void*, int, uint64_t *, uint64_t *)")
	function ISteamInventory.GetItemPrice(iDefinition)
		local pCurrentPrice_out = new_uint64_arr()
		local pBasePrice_out = new_uint64_arr()
		local res = GetItemPrice_native(this, iDefinition, pCurrentPrice_out, pBasePrice_out)

		return res, DEREF_GCSAFE(pCurrentPrice_out), DEREF_GCSAFE(pBasePrice_out)
	end
	ISteamInventory.get_item_price = ISteamInventory.GetItemPrice

	local StartUpdateProperties_native = vtable_entry(this, 30, "void(__thiscall*)(void*, uint64_t *)")
	function ISteamInventory.StartUpdateProperties()
		local SteamInventoryUpdateHandle_t_out = new_uint64_arr()
		StartUpdateProperties_native(this, SteamInventoryUpdateHandle_t_out)

		return DEREF_GCSAFE(SteamInventoryUpdateHandle_t_out)
	end
	ISteamInventory.start_update_properties = ISteamInventory.StartUpdateProperties

	local RemoveProperty_native = vtable_entry(this, 31, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *)")
	function ISteamInventory.RemoveProperty(handle, nItemID, pchPropertyName)
		return RemoveProperty_native(this, handle, nItemID, pchPropertyName)
	end
	ISteamInventory.remove_property = ISteamInventory.RemoveProperty

	local SetPropertyString_native = vtable_entry(this, 32, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, const char *)")
	function ISteamInventory.SetPropertyString(handle, nItemID, pchPropertyName, pchPropertyValue)
		return SetPropertyString_native(this, handle, nItemID, pchPropertyName, pchPropertyValue)
	end
	ISteamInventory.set_property_string = ISteamInventory.SetPropertyString

	local SetPropertyBool_native = vtable_entry(this, 33, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, bool)")
	function ISteamInventory.SetPropertyBool(handle, nItemID, pchPropertyName, bValue)
		return SetPropertyBool_native(this, handle, nItemID, pchPropertyName, bValue)
	end
	ISteamInventory.set_property_bool = ISteamInventory.SetPropertyBool

	local SetPropertyInt64_native = vtable_entry(this, 34, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, int64_t)")
	function ISteamInventory.SetPropertyInt64(handle, nItemID, pchPropertyName, nValue)
		return SetPropertyInt64_native(this, handle, nItemID, pchPropertyName, nValue)
	end
	ISteamInventory.set_property_int64 = ISteamInventory.SetPropertyInt64

	local SetPropertyFloat_native = vtable_entry(this, 35, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, float)")
	function ISteamInventory.SetPropertyFloat(handle, nItemID, pchPropertyName, flValue)
		return SetPropertyFloat_native(this, handle, nItemID, pchPropertyName, flValue)
	end
	ISteamInventory.set_property_float = ISteamInventory.SetPropertyFloat

	local SubmitUpdateProperties_native = vtable_entry(this, 36, "bool(__thiscall*)(void*, uint64_t, int *)")
	function ISteamInventory.SubmitUpdateProperties(handle)
		local pResultHandle_out = new_int_arr()
		local res = SubmitUpdateProperties_native(this, handle, pResultHandle_out)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.submit_update_properties = ISteamInventory.SubmitUpdateProperties

	local InspectItem_native = vtable_entry(this, 37, "bool(__thiscall*)(void*, int *, const char *)")
	function ISteamInventory.InspectItem(pchItemToken)
		local pResultHandle_out = new_int_arr()
		local res = InspectItem_native(this, pResultHandle_out, pchItemToken)

		return res, DEREF_GCSAFE(pResultHandle_out)
	end
	ISteamInventory.inspect_item = ISteamInventory.InspectItem

	return ISteamInventory
end

--
-- ISteamVideo (STEAMVIDEO_INTERFACE_V002, user created: false)
--

local ISteamVideo = {version="STEAMVIDEO_INTERFACE_V002",version_number=2}

index_funcs.ISteamVideo = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 36, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMVIDEO_INTERFACE_V002")

	local GetVideoURL_native = vtable_entry(this, 0, "void(__thiscall*)(void*, unsigned int)")
	function ISteamVideo.GetVideoURL(unVideoAppID)
		return GetVideoURL_native(this, unVideoAppID)
	end
	ISteamVideo.get_video_url = ISteamVideo.GetVideoURL

	local IsBroadcasting_native = vtable_entry(this, 1, "bool(__thiscall*)(void*, int *)")
	function ISteamVideo.IsBroadcasting()
		local pnNumViewers_out = new_int_arr()
		local res = IsBroadcasting_native(this, pnNumViewers_out)

		return res, DEREF_GCSAFE(pnNumViewers_out)
	end
	ISteamVideo.is_broadcasting = ISteamVideo.IsBroadcasting

	local GetOPFSettings_native = vtable_entry(this, 2, "void(__thiscall*)(void*, unsigned int)")
	function ISteamVideo.GetOPFSettings(unVideoAppID)
		return GetOPFSettings_native(this, unVideoAppID)
	end
	ISteamVideo.get_opf_settings = ISteamVideo.GetOPFSettings

	local GetOPFStringForApp_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, unsigned int, char *, int32_t *)")
	function ISteamVideo.GetOPFStringForApp(unVideoAppID, pchBuffer, pnBufferSize)
		return GetOPFStringForApp_native(this, unVideoAppID, pchBuffer, pnBufferSize)
	end
	ISteamVideo.get_opf_string_for_app = ISteamVideo.GetOPFStringForApp

	return ISteamVideo
end

--
-- ISteamParentalSettings (STEAMPARENTALSETTINGS_INTERFACE_VERSION001, user created: false)
--

local ISteamParentalSettings = {version="STEAMPARENTALSETTINGS_INTERFACE_VERSION001",version_number=1}

index_funcs.ISteamParentalSettings = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 37, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMPARENTALSETTINGS_INTERFACE_VERSION001")

	local BIsParentalLockEnabled_native = vtable_entry(this, 0, "bool(__thiscall*)(void*)")
	function ISteamParentalSettings.BIsParentalLockEnabled()
		return BIsParentalLockEnabled_native(this)
	end
	ISteamParentalSettings.is_parental_lock_enabled = ISteamParentalSettings.BIsParentalLockEnabled

	local BIsParentalLockLocked_native = vtable_entry(this, 1, "bool(__thiscall*)(void*)")
	function ISteamParentalSettings.BIsParentalLockLocked()
		return BIsParentalLockLocked_native(this)
	end
	ISteamParentalSettings.is_parental_lock_locked = ISteamParentalSettings.BIsParentalLockLocked

	local BIsAppBlocked_native = vtable_entry(this, 2, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamParentalSettings.BIsAppBlocked(nAppID)
		return BIsAppBlocked_native(this, nAppID)
	end
	ISteamParentalSettings.is_app_blocked = ISteamParentalSettings.BIsAppBlocked

	local BIsAppInBlockList_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamParentalSettings.BIsAppInBlockList(nAppID)
		return BIsAppInBlockList_native(this, nAppID)
	end
	ISteamParentalSettings.is_app_in_block_list = ISteamParentalSettings.BIsAppInBlockList

	local BIsFeatureBlocked_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, int)")
	function ISteamParentalSettings.BIsFeatureBlocked(eFeature)
		eFeature = to_enum_required(eFeature, enums.EParentalFeature, "feature is required")
		return BIsFeatureBlocked_native(this, eFeature)
	end
	ISteamParentalSettings.is_feature_blocked = ISteamParentalSettings.BIsFeatureBlocked

	local BIsFeatureInBlockList_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, int)")
	function ISteamParentalSettings.BIsFeatureInBlockList(eFeature)
		eFeature = to_enum_required(eFeature, enums.EParentalFeature, "feature is required")
		return BIsFeatureInBlockList_native(this, eFeature)
	end
	ISteamParentalSettings.is_feature_in_block_list = ISteamParentalSettings.BIsFeatureInBlockList

	return ISteamParentalSettings
end

--
-- ISteamRemotePlay (STEAMREMOTEPLAY_INTERFACE_VERSION001, user created: false)
--

local ISteamRemotePlay = {version="STEAMREMOTEPLAY_INTERFACE_VERSION001",version_number=1}

index_funcs.ISteamRemotePlay = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 40, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "STEAMREMOTEPLAY_INTERFACE_VERSION001")

	local GetSessionCount_native = vtable_entry(this, 0, "uint32_t(__thiscall*)(void*)")
	function ISteamRemotePlay.GetSessionCount()
		return GetSessionCount_native(this)
	end
	ISteamRemotePlay.get_session_count = ISteamRemotePlay.GetSessionCount

	local GetSessionID_native = vtable_entry(this, 1, "unsigned int(__thiscall*)(void*, int)")
	function ISteamRemotePlay.GetSessionID(iSessionIndex)
		return GetSessionID_native(this, iSessionIndex)
	end
	ISteamRemotePlay.get_session_id = ISteamRemotePlay.GetSessionID

	local GetSessionSteamID_native = vtable_entry(this, 2, "void(__thiscall*)(void*, SteamID *, unsigned int)")
	function ISteamRemotePlay.GetSessionSteamID(unSessionID)
		local CSteamID_out = new_SteamID_arr()
		GetSessionSteamID_native(this, CSteamID_out, unSessionID)

		return DEREF_GCSAFE(CSteamID_out)
	end
	ISteamRemotePlay.get_session_steamid = ISteamRemotePlay.GetSessionSteamID

	local GetSessionClientName_native = vtable_entry(this, 3, "const char *(__thiscall*)(void*, unsigned int)")
	function ISteamRemotePlay.GetSessionClientName(unSessionID)
		local res = GetSessionClientName_native(this, unSessionID)

		return res ~= nil and ffi_string(res) or nil
	end
	ISteamRemotePlay.get_session_client_name = ISteamRemotePlay.GetSessionClientName

	local GetSessionClientFormFactor_native = vtable_entry(this, 4, "int(__thiscall*)(void*, unsigned int)")
	function ISteamRemotePlay.GetSessionClientFormFactor(unSessionID)
		return GetSessionClientFormFactor_native(this, unSessionID)
	end
	ISteamRemotePlay.get_session_client_form_factor = ISteamRemotePlay.GetSessionClientFormFactor

	local BGetSessionClientResolution_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, unsigned int, int *, int *)")
	function ISteamRemotePlay.BGetSessionClientResolution(unSessionID)
		local pnResolutionX_out = new_int_arr()
		local pnResolutionY_out = new_int_arr()
		local res = BGetSessionClientResolution_native(this, unSessionID, pnResolutionX_out, pnResolutionY_out)

		return res, DEREF_GCSAFE(pnResolutionX_out), DEREF_GCSAFE(pnResolutionY_out)
	end
	ISteamRemotePlay.get_session_client_resolution = ISteamRemotePlay.BGetSessionClientResolution

	local BSendRemotePlayTogetherInvite_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, SteamID)")
	function ISteamRemotePlay.BSendRemotePlayTogetherInvite(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamid_friend is required")
		return BSendRemotePlayTogetherInvite_native(this, steamIDFriend)
	end
	ISteamRemotePlay.send_remote_play_together_invite = ISteamRemotePlay.BSendRemotePlayTogetherInvite

	return ISteamRemotePlay
end

--
-- ISteamNetworkingMessages (SteamNetworkingMessages002, user created: false)
--

local ISteamNetworkingMessages = {version="SteamNetworkingMessages002",version_number=2}

index_funcs.ISteamNetworkingMessages = function()
	local this = proc_bind("steamnetworkingsockets.dll", "SteamNetworkingMessages_LibV2", "void*(__thiscall*)(unsigned int, unsigned int)")()

	local SendMessageToUser_native = vtable_entry(this, 0, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, const void *, uint32_t, int, int)")
	function ISteamNetworkingMessages.SendMessageToUser(identityRemote, pubData, cubData, nSendFlags, nRemoteChannel)
		return SendMessageToUser_native(this, identityRemote, pubData, cubData, nSendFlags, nRemoteChannel)
	end
	ISteamNetworkingMessages.send_message_to_user = ISteamNetworkingMessages.SendMessageToUser

	local ReceiveMessagesOnChannel_native = vtable_entry(this, 1, "int(__thiscall*)(void*, int, SteamNetworkingMessage_t **, int)")
	function ISteamNetworkingMessages.ReceiveMessagesOnChannel(nLocalChannel, ppOutMessages, nMaxMessages)
		return ReceiveMessagesOnChannel_native(this, nLocalChannel, ppOutMessages, nMaxMessages)
	end
	ISteamNetworkingMessages.receive_messages_on_channel = ISteamNetworkingMessages.ReceiveMessagesOnChannel

	local AcceptSessionWithUser_native = vtable_entry(this, 2, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &)")
	function ISteamNetworkingMessages.AcceptSessionWithUser(identityRemote)
		return AcceptSessionWithUser_native(this, identityRemote)
	end
	ISteamNetworkingMessages.accept_session_with_user = ISteamNetworkingMessages.AcceptSessionWithUser

	local CloseSessionWithUser_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &)")
	function ISteamNetworkingMessages.CloseSessionWithUser(identityRemote)
		return CloseSessionWithUser_native(this, identityRemote)
	end
	ISteamNetworkingMessages.close_session_with_user = ISteamNetworkingMessages.CloseSessionWithUser

	local CloseChannelWithUser_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &, int)")
	function ISteamNetworkingMessages.CloseChannelWithUser(identityRemote, nLocalChannel)
		return CloseChannelWithUser_native(this, identityRemote, nLocalChannel)
	end
	ISteamNetworkingMessages.close_channel_with_user = ISteamNetworkingMessages.CloseChannelWithUser

	local GetSessionConnectionInfo_native = vtable_entry(this, 5, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, SteamNetConnectionInfo_t *, SteamNetworkingQuickConnectionStatus *)")
	function ISteamNetworkingMessages.GetSessionConnectionInfo(identityRemote)
		local pConnectionInfo_out = structs.SteamNetConnectionInfo_t_arr(1)
		local pQuickStatus_out = structs.SteamNetworkingQuickConnectionStatus_arr(1)
		local res = GetSessionConnectionInfo_native(this, identityRemote, pConnectionInfo_out, pQuickStatus_out)

		return res, DEREF_GCSAFE(pConnectionInfo_out), DEREF_GCSAFE(pQuickStatus_out)
	end
	ISteamNetworkingMessages.get_session_connection_info = ISteamNetworkingMessages.GetSessionConnectionInfo

	return ISteamNetworkingMessages
end

--
-- ISteamNetworkingSockets (SteamNetworkingSockets009, user created: false)
--

local ISteamNetworkingSockets = {version="SteamNetworkingSockets009",version_number=9}

index_funcs.ISteamNetworkingSockets = function()
	local this = proc_bind("steamnetworkingsockets.dll", "SteamNetworkingSockets_LibV9", "void*(__thiscall*)(unsigned int, unsigned int)")()

	local CreateListenSocketIP_native = vtable_entry(this, 0, "unsigned int(__thiscall*)(void*, const SteamNetworkingIPAddr &, int, const SteamNetworkingConfigValue_t *)")
	function ISteamNetworkingSockets.CreateListenSocketIP(localAddress, nOptions, pOptions)
		return CreateListenSocketIP_native(this, localAddress, nOptions, pOptions)
	end
	ISteamNetworkingSockets.create_listen_socket_ip = ISteamNetworkingSockets.CreateListenSocketIP

	local ConnectByIPAddress_native = vtable_entry(this, 1, "unsigned int(__thiscall*)(void*, const SteamNetworkingIPAddr &, int, const SteamNetworkingConfigValue_t *)")
	function ISteamNetworkingSockets.ConnectByIPAddress(address, nOptions, pOptions)
		return ConnectByIPAddress_native(this, address, nOptions, pOptions)
	end
	ISteamNetworkingSockets.connect_by_ip_address = ISteamNetworkingSockets.ConnectByIPAddress

	local CreateListenSocketP2P_native = vtable_entry(this, 2, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")
	function ISteamNetworkingSockets.CreateListenSocketP2P(nLocalVirtualPort, nOptions, pOptions)
		return CreateListenSocketP2P_native(this, nLocalVirtualPort, nOptions, pOptions)
	end
	ISteamNetworkingSockets.create_listen_socket_p2p = ISteamNetworkingSockets.CreateListenSocketP2P

	local ConnectP2P_native = vtable_entry(this, 3, "unsigned int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, int, const SteamNetworkingConfigValue_t *)")
	function ISteamNetworkingSockets.ConnectP2P(identityRemote, nRemoteVirtualPort, nOptions, pOptions)
		return ConnectP2P_native(this, identityRemote, nRemoteVirtualPort, nOptions, pOptions)
	end
	ISteamNetworkingSockets.connect_p2p = ISteamNetworkingSockets.ConnectP2P

	local AcceptConnection_native = vtable_entry(this, 4, "int(__thiscall*)(void*, unsigned int)")
	function ISteamNetworkingSockets.AcceptConnection(hConn)
		return AcceptConnection_native(this, hConn)
	end
	ISteamNetworkingSockets.accept_connection = ISteamNetworkingSockets.AcceptConnection

	local CloseConnection_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, unsigned int, int, const char *, bool)")
	function ISteamNetworkingSockets.CloseConnection(hPeer, nReason, pszDebug, bEnableLinger)
		return CloseConnection_native(this, hPeer, nReason, pszDebug, bEnableLinger)
	end
	ISteamNetworkingSockets.close_connection = ISteamNetworkingSockets.CloseConnection

	local CloseListenSocket_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamNetworkingSockets.CloseListenSocket(hSocket)
		return CloseListenSocket_native(this, hSocket)
	end
	ISteamNetworkingSockets.close_listen_socket = ISteamNetworkingSockets.CloseListenSocket

	local SetConnectionUserData_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, unsigned int, int64_t)")
	function ISteamNetworkingSockets.SetConnectionUserData(hPeer, nUserData)
		return SetConnectionUserData_native(this, hPeer, nUserData)
	end
	ISteamNetworkingSockets.set_connection_user_data = ISteamNetworkingSockets.SetConnectionUserData

	local GetConnectionUserData_native = vtable_entry(this, 8, "int64_t(__thiscall*)(void*, unsigned int)")
	function ISteamNetworkingSockets.GetConnectionUserData(hPeer)
		return GetConnectionUserData_native(this, hPeer)
	end
	ISteamNetworkingSockets.get_connection_user_data = ISteamNetworkingSockets.GetConnectionUserData

	local SetConnectionName_native = vtable_entry(this, 9, "void(__thiscall*)(void*, unsigned int, const char *)")
	function ISteamNetworkingSockets.SetConnectionName(hPeer, pszName)
		return SetConnectionName_native(this, hPeer, pszName)
	end
	ISteamNetworkingSockets.set_connection_name = ISteamNetworkingSockets.SetConnectionName

	local GetConnectionName_native = vtable_entry(this, 10, "bool(__thiscall*)(void*, unsigned int, char *, int)")
	function ISteamNetworkingSockets.GetConnectionName(hPeer, pszName, nMaxLen)
		return GetConnectionName_native(this, hPeer, pszName, nMaxLen)
	end
	ISteamNetworkingSockets.get_connection_name = ISteamNetworkingSockets.GetConnectionName

	local SendMessageToConnection_native = vtable_entry(this, 11, "int(__thiscall*)(void*, unsigned int, const void *, uint32_t, int, int64_t *)")
	function ISteamNetworkingSockets.SendMessageToConnection(hConn, pData, cbData, nSendFlags)
		local pOutMessageNumber_out = new_int64_arr()
		local res = SendMessageToConnection_native(this, hConn, pData, cbData, nSendFlags, pOutMessageNumber_out)

		return res, DEREF_GCSAFE(pOutMessageNumber_out)
	end
	ISteamNetworkingSockets.send_message_to_connection = ISteamNetworkingSockets.SendMessageToConnection

	local SendMessages_native = vtable_entry(this, 12, "void(__thiscall*)(void*, int, SteamNetworkingMessage_t *const *, int64_t *)")
	function ISteamNetworkingSockets.SendMessages(nMessages, pMessages)
		local pOutMessageNumberOrResult_out = new_int64_arr()
		SendMessages_native(this, nMessages, pMessages, pOutMessageNumberOrResult_out)

		return DEREF_GCSAFE(pOutMessageNumberOrResult_out)
	end
	ISteamNetworkingSockets.send_messages = ISteamNetworkingSockets.SendMessages

	local FlushMessagesOnConnection_native = vtable_entry(this, 13, "int(__thiscall*)(void*, unsigned int)")
	function ISteamNetworkingSockets.FlushMessagesOnConnection(hConn)
		return FlushMessagesOnConnection_native(this, hConn)
	end
	ISteamNetworkingSockets.flush_messages_on_connection = ISteamNetworkingSockets.FlushMessagesOnConnection

	local ReceiveMessagesOnConnection_native = vtable_entry(this, 14, "int(__thiscall*)(void*, unsigned int, SteamNetworkingMessage_t **, int)")
	function ISteamNetworkingSockets.ReceiveMessagesOnConnection(hConn, ppOutMessages, nMaxMessages)
		return ReceiveMessagesOnConnection_native(this, hConn, ppOutMessages, nMaxMessages)
	end
	ISteamNetworkingSockets.receive_messages_on_connection = ISteamNetworkingSockets.ReceiveMessagesOnConnection

	local GetConnectionInfo_native = vtable_entry(this, 15, "bool(__thiscall*)(void*, unsigned int, SteamNetConnectionInfo_t *)")
	function ISteamNetworkingSockets.GetConnectionInfo(hConn)
		local pInfo_out = structs.SteamNetConnectionInfo_t_arr(1)
		local res = GetConnectionInfo_native(this, hConn, pInfo_out)

		return res, DEREF_GCSAFE(pInfo_out)
	end
	ISteamNetworkingSockets.get_connection_info = ISteamNetworkingSockets.GetConnectionInfo

	local GetQuickConnectionStatus_native = vtable_entry(this, 16, "bool(__thiscall*)(void*, unsigned int, SteamNetworkingQuickConnectionStatus *)")
	function ISteamNetworkingSockets.GetQuickConnectionStatus(hConn)
		local pStats_out = structs.SteamNetworkingQuickConnectionStatus_arr(1)
		local res = GetQuickConnectionStatus_native(this, hConn, pStats_out)

		return res, DEREF_GCSAFE(pStats_out)
	end
	ISteamNetworkingSockets.get_quick_connection_status = ISteamNetworkingSockets.GetQuickConnectionStatus

	local GetDetailedConnectionStatus_native = vtable_entry(this, 17, "int(__thiscall*)(void*, unsigned int, char *, int)")
	function ISteamNetworkingSockets.GetDetailedConnectionStatus(hConn, pszBuf, cbBuf)
		return GetDetailedConnectionStatus_native(this, hConn, pszBuf, cbBuf)
	end
	ISteamNetworkingSockets.get_detailed_connection_status = ISteamNetworkingSockets.GetDetailedConnectionStatus

	local GetListenSocketAddress_native = vtable_entry(this, 18, "bool(__thiscall*)(void*, unsigned int, SteamNetworkingIPAddr *)")
	function ISteamNetworkingSockets.GetListenSocketAddress(hSocket)
		local address_out = structs.SteamNetworkingIPAddr_arr(1)
		local res = GetListenSocketAddress_native(this, hSocket, address_out)

		return res, DEREF_GCSAFE(address_out)
	end
	ISteamNetworkingSockets.get_listen_socket_address = ISteamNetworkingSockets.GetListenSocketAddress

	local CreateSocketPair_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, unsigned int *, unsigned int *, bool, const SteamNetworkingIdentity *, const SteamNetworkingIdentity *)")
	function ISteamNetworkingSockets.CreateSocketPair(bUseNetworkLoopback, pIdentity1, pIdentity2)
		local pOutConnection1_out = new_unsigned_int_arr()
		local pOutConnection2_out = new_unsigned_int_arr()
		local res = CreateSocketPair_native(this, pOutConnection1_out, pOutConnection2_out, bUseNetworkLoopback, pIdentity1, pIdentity2)

		return res, DEREF_GCSAFE(pOutConnection1_out), DEREF_GCSAFE(pOutConnection2_out)
	end
	ISteamNetworkingSockets.create_socket_pair = ISteamNetworkingSockets.CreateSocketPair

	local GetIdentity_native = vtable_entry(this, 20, "bool(__thiscall*)(void*, SteamNetworkingIdentity *)")
	function ISteamNetworkingSockets.GetIdentity()
		local pIdentity_out = structs.SteamNetworkingIdentity_arr(1)
		local res = GetIdentity_native(this, pIdentity_out)

		return res, DEREF_GCSAFE(pIdentity_out)
	end
	ISteamNetworkingSockets.get_identity = ISteamNetworkingSockets.GetIdentity

	local InitAuthentication_native = vtable_entry(this, 21, "int(__thiscall*)(void*)")
	function ISteamNetworkingSockets.InitAuthentication()
		return InitAuthentication_native(this)
	end
	ISteamNetworkingSockets.init_authentication = ISteamNetworkingSockets.InitAuthentication

	local GetAuthenticationStatus_native = vtable_entry(this, 22, "int(__thiscall*)(void*, SteamNetAuthenticationStatus_t *)")
	function ISteamNetworkingSockets.GetAuthenticationStatus()
		local pDetails_out = structs.SteamNetAuthenticationStatus_t_arr(1)
		local res = GetAuthenticationStatus_native(this, pDetails_out)

		return res, DEREF_GCSAFE(pDetails_out)
	end
	ISteamNetworkingSockets.get_authentication_status = ISteamNetworkingSockets.GetAuthenticationStatus

	local CreatePollGroup_native = vtable_entry(this, 23, "unsigned int(__thiscall*)(void*)")
	function ISteamNetworkingSockets.CreatePollGroup()
		return CreatePollGroup_native(this)
	end
	ISteamNetworkingSockets.create_poll_group = ISteamNetworkingSockets.CreatePollGroup

	local DestroyPollGroup_native = vtable_entry(this, 24, "bool(__thiscall*)(void*, unsigned int)")
	function ISteamNetworkingSockets.DestroyPollGroup(hPollGroup)
		return DestroyPollGroup_native(this, hPollGroup)
	end
	ISteamNetworkingSockets.destroy_poll_group = ISteamNetworkingSockets.DestroyPollGroup

	local SetConnectionPollGroup_native = vtable_entry(this, 25, "bool(__thiscall*)(void*, unsigned int, unsigned int)")
	function ISteamNetworkingSockets.SetConnectionPollGroup(hConn, hPollGroup)
		return SetConnectionPollGroup_native(this, hConn, hPollGroup)
	end
	ISteamNetworkingSockets.set_connection_poll_group = ISteamNetworkingSockets.SetConnectionPollGroup

	local ReceiveMessagesOnPollGroup_native = vtable_entry(this, 26, "int(__thiscall*)(void*, unsigned int, SteamNetworkingMessage_t **, int)")
	function ISteamNetworkingSockets.ReceiveMessagesOnPollGroup(hPollGroup, ppOutMessages, nMaxMessages)
		return ReceiveMessagesOnPollGroup_native(this, hPollGroup, ppOutMessages, nMaxMessages)
	end
	ISteamNetworkingSockets.receive_messages_on_poll_group = ISteamNetworkingSockets.ReceiveMessagesOnPollGroup

	local ReceivedRelayAuthTicket_native = vtable_entry(this, 27, "bool(__thiscall*)(void*, const void *, int, SteamDatagramRelayAuthTicket *)")
	function ISteamNetworkingSockets.ReceivedRelayAuthTicket(pvTicket, cbTicket, pOutParsedTicket)
		return ReceivedRelayAuthTicket_native(this, pvTicket, cbTicket, pOutParsedTicket)
	end
	ISteamNetworkingSockets.received_relay_auth_ticket = ISteamNetworkingSockets.ReceivedRelayAuthTicket

	local FindRelayAuthTicketForServer_native = vtable_entry(this, 28, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, SteamDatagramRelayAuthTicket *)")
	function ISteamNetworkingSockets.FindRelayAuthTicketForServer(identityGameServer, nRemoteVirtualPort, pOutParsedTicket)
		return FindRelayAuthTicketForServer_native(this, identityGameServer, nRemoteVirtualPort, pOutParsedTicket)
	end
	ISteamNetworkingSockets.find_relay_auth_ticket_for_server = ISteamNetworkingSockets.FindRelayAuthTicketForServer

	local ConnectToHostedDedicatedServer_native = vtable_entry(this, 29, "unsigned int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, int, const SteamNetworkingConfigValue_t *)")
	function ISteamNetworkingSockets.ConnectToHostedDedicatedServer(identityTarget, nRemoteVirtualPort, nOptions, pOptions)
		return ConnectToHostedDedicatedServer_native(this, identityTarget, nRemoteVirtualPort, nOptions, pOptions)
	end
	ISteamNetworkingSockets.connect_to_hosted_dedicated_server = ISteamNetworkingSockets.ConnectToHostedDedicatedServer

	local GetHostedDedicatedServerPort_native = vtable_entry(this, 30, "uint16_t(__thiscall*)(void*)")
	function ISteamNetworkingSockets.GetHostedDedicatedServerPort()
		return GetHostedDedicatedServerPort_native(this)
	end
	ISteamNetworkingSockets.get_hosted_dedicated_server_port = ISteamNetworkingSockets.GetHostedDedicatedServerPort

	local GetHostedDedicatedServerPOPID_native = vtable_entry(this, 31, "unsigned int(__thiscall*)(void*)")
	function ISteamNetworkingSockets.GetHostedDedicatedServerPOPID()
		return GetHostedDedicatedServerPOPID_native(this)
	end
	ISteamNetworkingSockets.get_hosted_dedicated_server_pop_id = ISteamNetworkingSockets.GetHostedDedicatedServerPOPID

	local GetHostedDedicatedServerAddress_native = vtable_entry(this, 32, "int(__thiscall*)(void*, SteamDatagramHostedAddress *)")
	function ISteamNetworkingSockets.GetHostedDedicatedServerAddress()
		local pRouting_out = structs.SteamDatagramHostedAddress_arr(1)
		local res = GetHostedDedicatedServerAddress_native(this, pRouting_out)

		return res, DEREF_GCSAFE(pRouting_out)
	end
	ISteamNetworkingSockets.get_hosted_dedicated_server_address = ISteamNetworkingSockets.GetHostedDedicatedServerAddress

	local CreateHostedDedicatedServerListenSocket_native = vtable_entry(this, 33, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")
	function ISteamNetworkingSockets.CreateHostedDedicatedServerListenSocket(nLocalVirtualPort, nOptions, pOptions)
		return CreateHostedDedicatedServerListenSocket_native(this, nLocalVirtualPort, nOptions, pOptions)
	end
	ISteamNetworkingSockets.create_hosted_dedicated_server_listen_socket = ISteamNetworkingSockets.CreateHostedDedicatedServerListenSocket

	local GetGameCoordinatorServerLogin_native = vtable_entry(this, 34, "int(__thiscall*)(void*, SteamDatagramGameCoordinatorServerLogin *, int *, void *)")
	function ISteamNetworkingSockets.GetGameCoordinatorServerLogin(pLoginInfo, pcbSignedBlob, pBlob)
		return GetGameCoordinatorServerLogin_native(this, pLoginInfo, pcbSignedBlob, pBlob)
	end
	ISteamNetworkingSockets.get_game_coordinator_server_login = ISteamNetworkingSockets.GetGameCoordinatorServerLogin

	local ConnectP2PCustomSignaling_native = vtable_entry(this, 35, "unsigned int(__thiscall*)(void*, void* *, const SteamNetworkingIdentity *, int, int, const SteamNetworkingConfigValue_t *)")
	function ISteamNetworkingSockets.ConnectP2PCustomSignaling(pSignaling, pPeerIdentity, nRemoteVirtualPort, nOptions, pOptions)
		return ConnectP2PCustomSignaling_native(this, pSignaling, pPeerIdentity, nRemoteVirtualPort, nOptions, pOptions)
	end
	ISteamNetworkingSockets.connect_p2p_custom_signaling = ISteamNetworkingSockets.ConnectP2PCustomSignaling

	local ReceivedP2PCustomSignal_native = vtable_entry(this, 36, "bool(__thiscall*)(void*, const void *, int, void* *)")
	function ISteamNetworkingSockets.ReceivedP2PCustomSignal(pMsg, cbMsg, pContext)
		return ReceivedP2PCustomSignal_native(this, pMsg, cbMsg, pContext)
	end
	ISteamNetworkingSockets.received_p2p_custom_signal = ISteamNetworkingSockets.ReceivedP2PCustomSignal

	local GetCertificateRequest_native = vtable_entry(this, 37, "bool(__thiscall*)(void*, int *, void *, char * &)")
	function ISteamNetworkingSockets.GetCertificateRequest(pcbBlob, pBlob, errMsg)
		return GetCertificateRequest_native(this, pcbBlob, pBlob, errMsg)
	end
	ISteamNetworkingSockets.get_certificate_request = ISteamNetworkingSockets.GetCertificateRequest

	local SetCertificate_native = vtable_entry(this, 38, "bool(__thiscall*)(void*, const void *, int, char * &)")
	function ISteamNetworkingSockets.SetCertificate(pCertificate, cbCertificate, errMsg)
		return SetCertificate_native(this, pCertificate, cbCertificate, errMsg)
	end
	ISteamNetworkingSockets.set_certificate = ISteamNetworkingSockets.SetCertificate

	local RunCallbacks_native = vtable_entry(this, 39, "void(__thiscall*)(void*)")
	function ISteamNetworkingSockets.RunCallbacks()
		return RunCallbacks_native(this)
	end
	ISteamNetworkingSockets.run_callbacks = ISteamNetworkingSockets.RunCallbacks

	return ISteamNetworkingSockets
end

--
-- ISteamNetworkingUtils (SteamNetworkingUtils003, user created: false)
--

local ISteamNetworkingUtils = {version="SteamNetworkingUtils003",version_number=3}

index_funcs.ISteamNetworkingUtils = function()
	local this = proc_bind("steamnetworkingsockets.dll", "SteamNetworkingUtils_LibV3", "void*(__thiscall*)(unsigned int, unsigned int)")()

	local AllocateMessage_native = vtable_entry(this, 0, "SteamNetworkingMessage_t *(__thiscall*)(void*, int)")
	function ISteamNetworkingUtils.AllocateMessage(cbAllocateBuffer)
		return AllocateMessage_native(this, cbAllocateBuffer)
	end
	ISteamNetworkingUtils.allocate_message = ISteamNetworkingUtils.AllocateMessage

	local GetRelayNetworkStatus_native = vtable_entry(this, 1, "int(__thiscall*)(void*, SteamRelayNetworkStatus_t *)")
	function ISteamNetworkingUtils.GetRelayNetworkStatus()
		local pDetails_out = structs.SteamRelayNetworkStatus_t_arr(1)
		local res = GetRelayNetworkStatus_native(this, pDetails_out)

		return res, DEREF_GCSAFE(pDetails_out)
	end
	ISteamNetworkingUtils.get_relay_network_status = ISteamNetworkingUtils.GetRelayNetworkStatus

	local GetLocalPingLocation_native = vtable_entry(this, 2, "float(__thiscall*)(void*, SteamNetworkPingLocation_t &)")
	function ISteamNetworkingUtils.GetLocalPingLocation(result)
		return GetLocalPingLocation_native(this, result)
	end
	ISteamNetworkingUtils.get_local_ping_location = ISteamNetworkingUtils.GetLocalPingLocation

	local EstimatePingTimeBetweenTwoLocations_native = vtable_entry(this, 3, "int(__thiscall*)(void*, const SteamNetworkPingLocation_t &, const SteamNetworkPingLocation_t &)")
	function ISteamNetworkingUtils.EstimatePingTimeBetweenTwoLocations(location1, location2)
		return EstimatePingTimeBetweenTwoLocations_native(this, location1, location2)
	end
	ISteamNetworkingUtils.estimate_ping_time_between_two_locations = ISteamNetworkingUtils.EstimatePingTimeBetweenTwoLocations

	local EstimatePingTimeFromLocalHost_native = vtable_entry(this, 4, "int(__thiscall*)(void*, const SteamNetworkPingLocation_t &)")
	function ISteamNetworkingUtils.EstimatePingTimeFromLocalHost(remoteLocation)
		return EstimatePingTimeFromLocalHost_native(this, remoteLocation)
	end
	ISteamNetworkingUtils.estimate_ping_time_from_local_host = ISteamNetworkingUtils.EstimatePingTimeFromLocalHost

	local ConvertPingLocationToString_native = vtable_entry(this, 5, "void(__thiscall*)(void*, const SteamNetworkPingLocation_t &, char *, int)")
	function ISteamNetworkingUtils.ConvertPingLocationToString(location, pszBuf, cchBufSize)
		return ConvertPingLocationToString_native(this, location, pszBuf, cchBufSize)
	end
	ISteamNetworkingUtils.convert_ping_location_to_string = ISteamNetworkingUtils.ConvertPingLocationToString

	local ParsePingLocationString_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, const char *, SteamNetworkPingLocation_t &)")
	function ISteamNetworkingUtils.ParsePingLocationString(pszString, result)
		return ParsePingLocationString_native(this, pszString, result)
	end
	ISteamNetworkingUtils.parse_ping_location_string = ISteamNetworkingUtils.ParsePingLocationString

	local CheckPingDataUpToDate_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, float)")
	function ISteamNetworkingUtils.CheckPingDataUpToDate(flMaxAgeSeconds)
		return CheckPingDataUpToDate_native(this, flMaxAgeSeconds)
	end
	ISteamNetworkingUtils.check_ping_data_up_to_date = ISteamNetworkingUtils.CheckPingDataUpToDate

	local GetPingToDataCenter_native = vtable_entry(this, 8, "int(__thiscall*)(void*, unsigned int, unsigned int *)")
	function ISteamNetworkingUtils.GetPingToDataCenter(popID)
		local pViaRelayPoP_out = new_unsigned_int_arr()
		local res = GetPingToDataCenter_native(this, popID, pViaRelayPoP_out)

		return res, DEREF_GCSAFE(pViaRelayPoP_out)
	end
	ISteamNetworkingUtils.get_ping_to_data_center = ISteamNetworkingUtils.GetPingToDataCenter

	local GetDirectPingToPOP_native = vtable_entry(this, 9, "int(__thiscall*)(void*, unsigned int)")
	function ISteamNetworkingUtils.GetDirectPingToPOP(popID)
		return GetDirectPingToPOP_native(this, popID)
	end
	ISteamNetworkingUtils.get_direct_ping_to_pop = ISteamNetworkingUtils.GetDirectPingToPOP

	local GetPOPCount_native = vtable_entry(this, 10, "int(__thiscall*)(void*)")
	function ISteamNetworkingUtils.GetPOPCount()
		return GetPOPCount_native(this)
	end
	ISteamNetworkingUtils.get_pop_count = ISteamNetworkingUtils.GetPOPCount

	local GetPOPList_native = vtable_entry(this, 11, "int(__thiscall*)(void*, unsigned int *, int)")
	function ISteamNetworkingUtils.GetPOPList(list, nListSz)
		return GetPOPList_native(this, list, nListSz)
	end
	ISteamNetworkingUtils.get_pop_list = ISteamNetworkingUtils.GetPOPList

	local GetLocalTimestamp_native = vtable_entry(this, 12, "long long(__thiscall*)(void*)")
	function ISteamNetworkingUtils.GetLocalTimestamp()
		return GetLocalTimestamp_native(this)
	end
	ISteamNetworkingUtils.get_local_timestamp = ISteamNetworkingUtils.GetLocalTimestamp

	local SetDebugOutputFunction_native = vtable_entry(this, 13, "void(__thiscall*)(void*, int, void (__thiscall*)(int, const char *))")
	function ISteamNetworkingUtils.SetDebugOutputFunction(eDetailLevel, pfnFunc)
		eDetailLevel = to_enum_required(eDetailLevel, enums.ESteamNetworkingSocketsDebugOutputType, "detail_level is required")
		return SetDebugOutputFunction_native(this, eDetailLevel, pfnFunc)
	end
	ISteamNetworkingUtils.set_debug_output_function = ISteamNetworkingUtils.SetDebugOutputFunction

	local SetConfigValue_native = vtable_entry(this, 14, "bool(__thiscall*)(void*, int, int, intptr_t, int, const void *)")
	function ISteamNetworkingUtils.SetConfigValue(eValue, eScopeType, scopeObj, eDataType, pArg)
		eValue = to_enum_required(eValue, enums.ESteamNetworkingConfigValue, "value is required")
		eScopeType = to_enum_required(eScopeType, enums.ESteamNetworkingConfigScope, "scope_type is required")
		eDataType = to_enum_required(eDataType, enums.ESteamNetworkingConfigDataType, "data_type is required")
		return SetConfigValue_native(this, eValue, eScopeType, scopeObj, eDataType, pArg)
	end
	ISteamNetworkingUtils.set_config_value = ISteamNetworkingUtils.SetConfigValue

	local GetConfigValue_native = vtable_entry(this, 15, "int(__thiscall*)(void*, int, int, intptr_t, int *, void *, size_t *)")
	function ISteamNetworkingUtils.GetConfigValue(eValue, eScopeType, scopeObj, pResult, cbResult)
		eValue = to_enum_required(eValue, enums.ESteamNetworkingConfigValue, "value is required")
		eScopeType = to_enum_required(eScopeType, enums.ESteamNetworkingConfigScope, "scope_type is required")
		local pOutDataType_out = new_int_arr()
		local res = GetConfigValue_native(this, eValue, eScopeType, scopeObj, pOutDataType_out, pResult, cbResult)

		return res, DEREF_GCSAFE(pOutDataType_out)
	end
	ISteamNetworkingUtils.get_config_value = ISteamNetworkingUtils.GetConfigValue

	local GetConfigValueInfo_native = vtable_entry(this, 16, "bool(__thiscall*)(void*, int, const char **, int *, int *, int *)")
	function ISteamNetworkingUtils.GetConfigValueInfo(eValue, pOutName)
		eValue = to_enum_required(eValue, enums.ESteamNetworkingConfigValue, "value is required")
		local pOutDataType_out = new_int_arr()
		local pOutScope_out = new_int_arr()
		local pOutNextValue_out = new_int_arr()
		local res = GetConfigValueInfo_native(this, eValue, pOutName, pOutDataType_out, pOutScope_out, pOutNextValue_out)

		return res, DEREF_GCSAFE(pOutDataType_out), DEREF_GCSAFE(pOutScope_out), DEREF_GCSAFE(pOutNextValue_out)
	end
	ISteamNetworkingUtils.get_config_value_info = ISteamNetworkingUtils.GetConfigValueInfo

	local GetFirstConfigValue_native = vtable_entry(this, 17, "int(__thiscall*)(void*)")
	function ISteamNetworkingUtils.GetFirstConfigValue()
		return GetFirstConfigValue_native(this)
	end
	ISteamNetworkingUtils.get_first_config_value = ISteamNetworkingUtils.GetFirstConfigValue

	local SteamNetworkingIPAddr_ToString_native = vtable_entry(this, 18, "void(__thiscall*)(void*, const SteamNetworkingIPAddr &, char *, uint32_t, bool)")
	function ISteamNetworkingUtils.SteamNetworkingIPAddr_ToString(addr, buf, cbBuf, bWithPort)
		return SteamNetworkingIPAddr_ToString_native(this, addr, buf, cbBuf, bWithPort)
	end
	ISteamNetworkingUtils.steam_networking_ip_addr_to_string = ISteamNetworkingUtils.SteamNetworkingIPAddr_ToString

	local SteamNetworkingIPAddr_ParseString_native = vtable_entry(this, 19, "bool(__thiscall*)(void*, SteamNetworkingIPAddr *, const char *)")
	function ISteamNetworkingUtils.SteamNetworkingIPAddr_ParseString(pAddr, pszStr)
		return SteamNetworkingIPAddr_ParseString_native(this, pAddr, pszStr)
	end
	ISteamNetworkingUtils.steam_networking_ip_addr_parse_string = ISteamNetworkingUtils.SteamNetworkingIPAddr_ParseString

	local SteamNetworkingIdentity_ToString_native = vtable_entry(this, 20, "void(__thiscall*)(void*, const SteamNetworkingIdentity &, char *, uint32_t)")
	function ISteamNetworkingUtils.SteamNetworkingIdentity_ToString(identity, buf, cbBuf)
		return SteamNetworkingIdentity_ToString_native(this, identity, buf, cbBuf)
	end
	ISteamNetworkingUtils.steam_networking_identity_to_string = ISteamNetworkingUtils.SteamNetworkingIdentity_ToString

	local SteamNetworkingIdentity_ParseString_native = vtable_entry(this, 21, "bool(__thiscall*)(void*, SteamNetworkingIdentity *, const char *)")
	function ISteamNetworkingUtils.SteamNetworkingIdentity_ParseString(pIdentity, pszStr)
		return SteamNetworkingIdentity_ParseString_native(this, pIdentity, pszStr)
	end
	ISteamNetworkingUtils.steam_networking_identity_parse_string = ISteamNetworkingUtils.SteamNetworkingIdentity_ParseString

	return ISteamNetworkingUtils
end

--
-- ISteamGameServerStats (SteamGameServerStats001, user created: false)
--

local ISteamGameServerStats = {version="SteamGameServerStats001",version_number=1}

index_funcs.ISteamGameServerStats = function()
	local this = vtable_bind("steamclient.dll", "SteamClient020", 14, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "SteamGameServerStats001")

	local RequestUserStats_native = vtable_entry(this, 0, "uint64_t(__thiscall*)(void*, SteamID)")
	local RequestUserStats_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				SteamID m_steamIDUser;
			} *
		]]),
		keys = {m_eResult="result",m_steamIDUser="steamid_user"}
	}
	function ISteamGameServerStats.RequestUserStats(steamIDUser, callback)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = RequestUserStats_native(this, steamIDUser)

		if callback ~= nil then
			res = register_call_result(res, callback, 1800, RequestUserStats_info)
		end

		return res
	end
	ISteamGameServerStats.request_user_stats = ISteamGameServerStats.RequestUserStats

	local GetUserStatInt32_native = vtable_entry(this, 1, "bool(__thiscall*)(void*, SteamID, const char *, int32_t *)")
	function ISteamGameServerStats.GetUserStatInt32(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local pData_out = new_int32_arr()
		local res = GetUserStatInt32_native(this, steamIDUser, pchName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamGameServerStats.get_user_stat_int32 = ISteamGameServerStats.GetUserStatInt32

	local GetUserStatFloat_native = vtable_entry(this, 2, "bool(__thiscall*)(void*, SteamID, const char *, float *)")
	function ISteamGameServerStats.GetUserStatFloat(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local pData_out = new_float_arr()
		local res = GetUserStatFloat_native(this, steamIDUser, pchName, pData_out)

		return res, DEREF_GCSAFE(pData_out)
	end
	ISteamGameServerStats.get_user_stat_float = ISteamGameServerStats.GetUserStatFloat

	local GetUserAchievement_native = vtable_entry(this, 3, "bool(__thiscall*)(void*, SteamID, const char *, bool *)")
	function ISteamGameServerStats.GetUserAchievement(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		local pbAchieved_out = new_bool_arr()
		local res = GetUserAchievement_native(this, steamIDUser, pchName, pbAchieved_out)

		return res, DEREF_GCSAFE(pbAchieved_out)
	end
	ISteamGameServerStats.get_user_achievement = ISteamGameServerStats.GetUserAchievement

	local SetUserStatInt32_native = vtable_entry(this, 4, "bool(__thiscall*)(void*, SteamID, const char *, int32_t)")
	function ISteamGameServerStats.SetUserStatInt32(steamIDUser, pchName, nData)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return SetUserStatInt32_native(this, steamIDUser, pchName, nData)
	end
	ISteamGameServerStats.set_user_stat_int32 = ISteamGameServerStats.SetUserStatInt32

	local SetUserStatFloat_native = vtable_entry(this, 5, "bool(__thiscall*)(void*, SteamID, const char *, float)")
	function ISteamGameServerStats.SetUserStatFloat(steamIDUser, pchName, fData)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return SetUserStatFloat_native(this, steamIDUser, pchName, fData)
	end
	ISteamGameServerStats.set_user_stat_float = ISteamGameServerStats.SetUserStatFloat

	local UpdateUserAvgRateStat_native = vtable_entry(this, 6, "bool(__thiscall*)(void*, SteamID, const char *, float, double)")
	function ISteamGameServerStats.UpdateUserAvgRateStat(steamIDUser, pchName, flCountThisSession, dSessionLength)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return UpdateUserAvgRateStat_native(this, steamIDUser, pchName, flCountThisSession, dSessionLength)
	end
	ISteamGameServerStats.update_user_avg_rate_stat = ISteamGameServerStats.UpdateUserAvgRateStat

	local SetUserAchievement_native = vtable_entry(this, 7, "bool(__thiscall*)(void*, SteamID, const char *)")
	function ISteamGameServerStats.SetUserAchievement(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return SetUserAchievement_native(this, steamIDUser, pchName)
	end
	ISteamGameServerStats.set_user_achievement = ISteamGameServerStats.SetUserAchievement

	local ClearUserAchievement_native = vtable_entry(this, 8, "bool(__thiscall*)(void*, SteamID, const char *)")
	function ISteamGameServerStats.ClearUserAchievement(steamIDUser, pchName)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		return ClearUserAchievement_native(this, steamIDUser, pchName)
	end
	ISteamGameServerStats.clear_user_achievement = ISteamGameServerStats.ClearUserAchievement

	local StoreUserStats_native = vtable_entry(this, 9, "uint64_t(__thiscall*)(void*, SteamID)")
	local StoreUserStats_info = {
		struct = typeof([[
			struct {
				int m_eResult;
				SteamID m_steamIDUser;
			} *
		]]),
		keys = {m_eResult="result",m_steamIDUser="steamid_user"}
	}
	function ISteamGameServerStats.StoreUserStats(steamIDUser, callback)
		steamIDUser = to_steamid_required(steamIDUser, "steamid_user is required")
		if callback ~= nil and not is_valid_callback(callback) then
			return error("Invalid callback, expected function or await")
		end

		local res = StoreUserStats_native(this, steamIDUser)

		if callback ~= nil then
			res = register_call_result(res, callback, 1801, StoreUserStats_info)
		end

		return res
	end
	ISteamGameServerStats.store_user_stats = ISteamGameServerStats.StoreUserStats

	return ISteamGameServerStats
end

--
-- some extensions for interfaces
--

index_funcs_extra.ISteamFriends = function()
	--
	-- SteamFriends002 stuff
	-- https://github.com/SteamRE/open-steamworks/blob/master/Open%20Steamworks/ISteamFriends002.h
	--
	local steamfriends002 = vtable_bind("steamclient.dll", "SteamClient020", 8, "void*(__thiscall*)(void*, int, int, const char *)")(hSteamUser, hSteamPipe, "SteamFriends002")

	local SetPersonaState_native = vtable_entry(steamfriends002, 3, "void(__thiscall*)(void*, int)")
	M.ISteamFriends.SetPersonaState = function(ePersonaState)
		ePersonaState = to_enum_required(ePersonaState, enums.EPersonaState, "ePersonaState is required")
		return SetPersonaState_native(steamfriends002, ePersonaState)
	end
	M.ISteamFriends.set_persona_state = M.ISteamFriends.SetPersonaState

	local AddFriend_native = vtable_entry(steamfriends002, 13, "bool(__thiscall*)(void*, SteamID)")
	M.ISteamFriends.AddFriend = function(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamIDFriend is required")
		return AddFriend_native(steamfriends002, steamIDFriend)
	end
	M.ISteamFriends.add_friend = M.ISteamFriends.AddFriend

	local RemoveFriend_native = vtable_entry(steamfriends002, 14, "bool(__thiscall*)(void*, SteamID)")
	M.ISteamFriends.RemoveFriend = function(steamIDFriend)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamIDFriend is required")
		return RemoveFriend_native(steamfriends002, steamIDFriend)
	end
	M.ISteamFriends.remove_friend = M.ISteamFriends.RemoveFriend

	local SendMsgToFriend_native = vtable_entry(steamfriends002, 19, "bool(__thiscall*)(void*, SteamID, int, const char*, int)")
	M.ISteamFriends.SendMsgToFriend = function(steamIDFriend, eFriendMsgType, pvMsgBody)
		steamIDFriend = to_steamid_required(steamIDFriend, "steamIDFriend is required")
		eFriendMsgType = to_enum_required(eFriendMsgType, enums.EChatEntryType, "eFriendMsgType is required")
		local cubMsgBody = string_len(pvMsgBody)
		return SendMsgToFriend_native(steamfriends002, steamIDFriend, eFriendMsgType, pvMsgBody, cubMsgBody)
	end
	M.ISteamFriends.send_msg_to_friend = M.ISteamFriends.SendMsgToFriend

	-- fix GetPersonaState
	local get_friend_persona_state = M.ISteamFriends.GetFriendPersonaState
	local my_steamid = M.ISteamUser.GetSteamID()

	M.ISteamFriends.GetPersonaState = function()
		return get_friend_persona_state(my_steamid)
	end
	M.ISteamFriends.get_persona_state = M.ISteamFriends.GetPersonaState
end

index_funcs_extra.ISteamMatchmaking = function()
	local matchframework001 = client.create_interface("matchmaking.dll", "MATCHFRAMEWORK_001")

	local GetMatchSession_native = vtable_entry(matchframework001, 13, "void*(__thiscall*)(void*)")
	local GetLobbyID_native = vtable_thunk(4, "SteamID(__thiscall*)(void*)")
	M.ISteamMatchmaking.GetLobbyID = function()
		local match_session = GetMatchSession_native(matchframework001)

		if match_session ~= nil then
			local lobby_steam_id = GetLobbyID_native(match_session)

			if lobby_steam_id.accountid > 0 then
				return lobby_steam_id
			end
		end
	end
end

index_funcs_extra.ISteamNetworkingUtils = function()
	local GetNetworkConfigURL_native = proc_bind("steamnetworkingsockets.dll", "SteamDatagram_GetNetworkConfigURL", "char *(__thiscall*)(unsigned int, unsigned int)")

	M.ISteamNetworkingUtils.SteamDatagram_GetNetworkConfigURL = function()
		local str = GetNetworkConfigURL_native()

		if str ~= nil then
			return ffi.string(str)
		end
	end
end

--
-- clean up everything on shutdown
--

client.set_event_callback("shutdown", function()
	for _, value in pairs(pending_call_results) do
		local instance = cast(callback_base_ptr, value)
		call_result_cancel(instance)
	end

	for _, instance_storage in pairs(registered_callbacks_instances) do
		local instance = cast(callback_base_ptr, instance_storage)
		SteamAPI_UnregisterCallback(instance)
	end
end)

--
-- return module back to user
--

return M