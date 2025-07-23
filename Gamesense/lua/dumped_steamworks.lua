-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/md5")
local var_0_2 = var_0_0.cast
local var_0_3 = var_0_0.cdef
local var_0_4 = var_0_0.typeof
local var_0_5 = var_0_0.sizeof
local var_0_6 = var_0_0.istype
local var_0_7 = var_0_0.string
local var_0_8 = var_0_0.copy
local var_0_9 = string.len
local var_0_10 = string.sub
local var_0_11 = string.gsub
local var_0_12 = string.match
local var_0_13 = string.gmatch
local var_0_14 = string.lower
local var_0_15 = string.upper
local var_0_16 = string.format
local var_0_17 = string.reverse
local var_0_18 = assert
local var_0_19 = tostring
local var_0_20 = tonumber
local var_0_21 = setmetatable
local var_0_22 = pairs
local var_0_23 = ipairs
local var_0_24 = pcall
local var_0_25 = xpcall
local var_0_26 = error
local var_0_27 = type
local var_0_28 = client.error_log
local var_0_29 = client.find_signature
local var_0_30 = client.timestamp
local var_0_31 = table.insert
local var_0_32 = table.remove
local var_0_33 = math.floor
local var_0_34 = math.min
local var_0_35 = math.max
local var_0_36 = bit.band
local var_0_37 = bit.bor
local var_0_38 = bit.rshift
local var_0_39 = bit.lshift
local var_0_40 = bit.bswap
local var_0_41 = var_0_1.sum
local var_0_42 = var_0_4("uintptr_t")
local var_0_43 = var_0_4("uint64_t")
local var_0_44 = 76561197960265728ULL
local var_0_45 = var_0_4("uint64_t[?]")
local var_0_46 = var_0_4("uint32_t[?]")
local var_0_47 = var_0_4("uint32_t*")
local var_0_48 = var_0_4("uint8_t[?]")
local var_0_49 = var_0_4("uint8_t*")
local var_0_50 = var_0_4("bool[?]")
local var_0_51 = var_0_4("bool*")

local function var_0_52(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = var_0_29(arg_1_0, arg_1_1) or var_0_26("signature not found", 2)
	local var_1_1 = var_0_2("uintptr_t", var_1_0)

	if arg_1_3 ~= nil and arg_1_3 ~= 0 then
		var_1_1 = var_1_1 + arg_1_3
	end

	if arg_1_4 ~= nil then
		for iter_1_0 = 1, arg_1_4 do
			var_1_1 = var_0_2("uintptr_t*", var_1_1)[0]

			if var_1_1 == nil then
				return var_0_26("signature not found")
			end
		end
	end

	return var_0_2(arg_1_2, var_1_1)
end

local function var_0_53(arg_2_0, arg_2_1, arg_2_2)
	var_0_18(arg_2_0 ~= nil)
	var_0_18(var_0_2("void***", arg_2_0)[0] ~= nil)

	return var_0_2(arg_2_2, var_0_2("void***", arg_2_0)[0][arg_2_1])
end

local function var_0_54(arg_3_0)
	return var_0_20(var_0_2(var_0_42, arg_3_0))
end

local function var_0_55(arg_4_0)
	return (var_0_24(var_0_4, arg_4_0))
end

local function var_0_56(arg_5_0, arg_5_1)
	if not var_0_55(arg_5_0) then
		var_0_3(arg_5_1)
	end
end

local function var_0_57(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {}
	local var_6_1 = var_0_21({}, {
		__index = var_6_0
	})

	if arg_6_0 ~= nil then
		for iter_6_0, iter_6_1 in var_0_22(arg_6_1) do
			local var_6_2 = arg_6_0[iter_6_0]

			if arg_6_2 ~= nil and arg_6_2[iter_6_0] and var_6_2 ~= nil then
				var_6_2 = var_0_7(arg_6_0[iter_6_0])
			end

			var_6_1[iter_6_0] = var_6_2
			var_6_0[iter_6_1] = var_6_2
		end
	end

	return var_6_1
end

local function var_0_58(arg_7_0)
	return function(arg_8_0)
		return var_0_28(arg_7_0 .. var_0_19(arg_8_0))
	end
end

local var_0_59 = var_0_21({}, {
	__mode = "k"
})

local function var_0_60(arg_9_0)
	local var_9_0 = arg_9_0[0]

	var_0_59[var_9_0] = arg_9_0

	return var_9_0
end

local var_0_61 = {}
local var_0_62 = {}
local var_0_63 = {}

var_0_21(var_0_61, {
	__index = function(arg_10_0, arg_10_1)
		if arg_10_0 == var_0_61 and var_0_62[arg_10_1] ~= nil then
			var_0_61[arg_10_1] = var_0_62[arg_10_1]()
			var_0_62[arg_10_1] = nil

			if var_0_63[arg_10_1] ~= nil then
				var_0_63[arg_10_1]()
			end

			return var_0_61[arg_10_1]
		end
	end
})

local var_0_64 = {
	ESteamIPType = {
		IPv4 = 0,
		IPv6 = 1
	},
	EUniverse = {
		Max = 5,
		Dev = 4,
		Internal = 3,
		Beta = 2,
		Public = 1,
		Invalid = 0
	},
	EResult = {
		InvalidProtocolVer = 7,
		LoggedInElsewhere = 6,
		InvalidPassword = 5,
		NoConnection = 3,
		Fail = 2,
		OK = 1,
		None = 0,
		CachedCredentialInvalid = 126,
		PhoneNumberIsVOIP = 127,
		ChargerRequired = 125,
		InsufficientBattery = 124,
		NoVerifiedPhone = 123,
		ParseFailure = 122,
		InvalidSignature = 121,
		SteamRealmMismatch = 120,
		LauncherMigrated = 119,
		MustAgreeToSSA = 118,
		NoLauncherSpecified = 117,
		CommunityCooldown = 116,
		ExistingUserCancelledLicense = 115,
		AccountDeleted = 114,
		CantRemoveItem = 113,
		LimitedUserAccount = 112,
		AccountNotFriends = 111,
		WGNetworkSendExceeded = 110,
		NoSiteLicensesFound = 109,
		TooManyPending = 108,
		InsufficientFunds = 107,
		GSLTExpired = 106,
		IPBanned = 105,
		InvalidItemType = 104,
		GSOwnerDenied = 103,
		GSLTDenied = 102,
		NeedCaptcha = 101,
		NotSettled = 100,
		EmailSendFailure = 99,
		RefundToWallet = 98,
		PhoneActivityLimitExceeded = 97,
		AccountActivityLimitExceeded = 96,
		AccountLimitExceeded = 95,
		SmsCodeFailed = 94,
		TimeNotSynced = 93,
		NoMobileDevice = 92,
		NotModified = 91,
		AccountAssociatedToMultiplePartners = 90,
		TwoFactorActivationCodeMismatch = 89,
		TwoFactorCodeMismatch = 88,
		AccountLoginDeniedThrottle = 87,
		ItemDeleted = 86,
		AccountLoginDeniedNeedTwoFactor = 85,
		RateLimitExceeded = 84,
		RegionLocked = 83,
		RestrictedDevice = 82,
		InvalidCEGSubmission = 81,
		Disabled = 80,
		UnexpectedError = 79,
		ValueOutOfRange = 78,
		RequirePasswordReEntry = 77,
		BadResponse = 76,
		NoMatchingURL = 75,
		AccountLogonDeniedVerifiedEmailRequired = 74,
		AccountLockedDown = 73,
		IPLoginRestrictionFailed = 72,
		ExpiredLoginAuthCode = 71,
		FacebookQueryError = 70,
		ParentalControlRestricted = 69,
		IPTInitError = 68,
		HardwareNotCapableOfIPT = 67,
		AccountLogonDeniedNoMail = 66,
		InvalidLoginAuthCode = 65,
		CannotUseOldPassword = 64,
		AccountLogonDenied = 63,
		SameAsPreviousValue = 62,
		IllegalPassword = 61,
		RemoteFileConflict = 60,
		ExternalAccountAlreadyLinked = 59,
		PSNTicketInvalid = 58,
		ExternalAccountUnlinked = 57,
		PasswordUnset = 56,
		RemoteCallFailed = 55,
		DiskFull = 54,
		DataCorruption = 53,
		Cancelled = 52,
		Suspended = 51,
		AlreadyLoggedInElsewhere = 50,
		PasswordRequiredToKickSession = 49,
		TryAnotherCM = 48,
		ContentVersion = 47,
		AdministratorOK = 46,
		AccountNotFeatured = 45,
		ServiceReadOnly = 44,
		AccountDisabled = 43,
		NoMatch = 42,
		Ignored = 41,
		Blocked = 40,
		ShoppingCartNotFound = 39,
		RemoteDisconnect = 38,
		IOFailure = 37,
		HandshakeFailed = 36,
		ConnectFailed = 35,
		LogonSessionReplaced = 34,
		LockingFailed = 33,
		PersistFailed = 32,
		IPNotFound = 31,
		AlreadyOwned = 30,
		DuplicateRequest = 29,
		AlreadyRedeemed = 28,
		Expired = 27,
		Revoked = 26,
		LimitExceeded = 25,
		InsufficientPrivilege = 24,
		EncryptionFailure = 23,
		Pending = 22,
		NotLoggedOn = 21,
		ServiceUnavailable = 20,
		InvalidSteamID = 19,
		AccountNotFound = 18,
		Banned = 17,
		Timeout = 16,
		AccessDenied = 15,
		DuplicateName = 14,
		InvalidEmail = 13,
		InvalidName = 12,
		InvalidState = 11,
		Busy = 10,
		FileNotFound = 9,
		InvalidParam = 8
	},
	EVoiceResult = {
		ReceiverOutOfDate = 8,
		UnsupportedCodec = 7,
		Restricted = 6,
		DataCorrupted = 5,
		BufferTooSmall = 4,
		OK = 0,
		NotRecording = 2,
		NotInitialized = 1,
		NoData = 3,
		ReceiverDidNotAnswer = 9
	},
	EDenyReason = {
		SteamOwnerLeftGuestUser = 15,
		SteamValidationStalled = 14,
		NotLoggedOn = 3,
		SteamConnectionError = 12,
		SteamConnectionLost = 11,
		IncompatibleSoftware = 10,
		MemoryCorruption = 9,
		IncompatibleAnticheat = 8,
		UnknownText = 7,
		LoggedInElseWhere = 6,
		Cheater = 5,
		NoLicense = 4,
		Generic = 2,
		Invalid = 0,
		SteamResponseTimedOut = 13,
		InvalidVersion = 1
	},
	EBeginAuthSessionResult = {
		OK = 0,
		GameMismatch = 4,
		DuplicateRequest = 2,
		ExpiredTicket = 5,
		InvalidVersion = 3,
		InvalidTicket = 1
	},
	EAuthSessionResponse = {
		AuthTicketInvalidAlreadyUsed = 7,
		NoLicenseOrExpired = 2,
		PublisherIssuedBan = 9,
		AuthTicketInvalid = 8,
		OK = 0,
		AuthTicketCanceled = 6,
		VACCheckTimedOut = 5,
		VACBanned = 3,
		LoggedInElseWhere = 4,
		UserNotConnectedToSteam = 1
	},
	EUserHasLicenseForAppResult = {
		DoesNotHaveLicense = 1,
		HasLicense = 0,
		NoAuth = 2
	},
	EAccountType = {
		Individual = 1,
		Pending = 5,
		Max = 11,
		AnonUser = 10,
		ConsoleUser = 9,
		Chat = 8,
		Clan = 7,
		ContentServer = 6,
		AnonGameServer = 4,
		GameServer = 3,
		Multiseat = 2,
		Invalid = 0
	},
	EChatEntryType = {
		Emote = 4,
		InviteGame = 3,
		Typing = 2,
		ChatMsg = 1,
		WasKicked = 8,
		LinkBlocked = 14,
		HistoricalChat = 11,
		Disconnected = 10,
		WasBanned = 9,
		Invalid = 0,
		Entered = 7,
		LeftConversation = 6
	},
	EChatRoomEnterResponse = {
		CommunityBan = 9,
		ClanDisabled = 8,
		Limited = 7,
		Error = 5,
		Full = 4,
		NotAllowed = 3,
		DoesntExist = 2,
		Success = 1,
		Banned = 6,
		RatelimitExceeded = 15,
		YouBlockedMember = 11,
		MemberBlockedYou = 10
	},
	EChatSteamIDInstanceFlags = {
		FlagMMSLobby = 131072,
		FlagLobby = 262144,
		FlagClan = 524288,
		InstanceMask = 4095
	},
	ENotificationPosition = {
		BottomLeft = 2,
		TopRight = 1,
		TopLeft = 0,
		BottomRight = 3
	},
	EMarketNotAllowedReasonFlags = {
		NewPaymentMethodCannotBeVerified = 8192,
		AcceptedWalletGift = 32768,
		NoRecentPurchases = 16384,
		None = 0,
		RecentSelfRefund = 4096,
		UsingNewDevice = 2048,
		InvalidCookie = 1024,
		NewPaymentMethod = 512,
		RecentPasswordReset = 256,
		SteamGuardOnlyRecentlyEnabled = 128,
		SteamGuardNotEnabled = 64,
		AccountNotTrusted = 32,
		TradeBanned = 16,
		AccountLimited = 8,
		TemporaryFailure = 1,
		AccountDisabled = 2,
		AccountLockedDown = 4
	},
	EDurationControlProgress = {
		ExitSoon_5h = 4,
		ExitSoon_3h = 3,
		Half = 1,
		Full = 0,
		None = 2,
		ExitSoon_Night = 5
	},
	EDurationControlNotification = {
		ExitSoon_5h = 6,
		ExitSoon_3h = 5,
		NoProgress = 4,
		HalfProgress = 3,
		["3Hours"] = 2,
		["1Hour"] = 1,
		None = 0,
		ExitSoon_Night = 7
	},
	EDurationControlOnlineState = {
		Offline = 1,
		Invalid = 0,
		OnlineHighPri = 3,
		Online = 2
	},
	ESteamIPv6ConnectivityProtocol = {
		HTTP = 1,
		Invalid = 0,
		UDP = 2
	},
	ESteamIPv6ConnectivityState = {
		Good = 1,
		Unknown = 0,
		Bad = 2
	},
	EFriendRelationship = {
		None = 0,
		Max = 8,
		Suggested_DEPRECATED = 7,
		IgnoredFriend = 6,
		RequestInitiator = 4,
		Friend = 3,
		RequestRecipient = 2,
		Ignored = 5,
		Blocked = 1
	},
	EPersonaState = {
		Away = 3,
		Max = 8,
		Invisible = 7,
		LookingToPlay = 6,
		LookingToTrade = 5,
		Snooze = 4,
		Online = 1,
		Offline = 0,
		Busy = 2
	},
	EFriendFlags = {
		Immediate = 4,
		FriendshipRequested = 2,
		ClanMember = 8,
		Ignored = 512,
		All = 65535,
		None = 0,
		IgnoredFriend = 1024,
		ChatMember = 4096,
		RequestingInfo = 256,
		RequestingFriendship = 128,
		OnGameServer = 16,
		Blocked = 1
	},
	EOverlayToStoreFlag = {
		AddToCart = 1,
		None = 0,
		AddToCartAndShow = 2
	},
	EActivateGameOverlayToWebPageMode = {
		Modal = 1,
		Default = 0
	},
	ECommunityProfileItemType = {
		ProfileModifier = 2,
		AvatarFrame = 1,
		AnimatedAvatar = 0,
		MiniProfileBackground = 4,
		ProfileBackground = 3
	},
	ECommunityProfileItemProperty = {
		MovieMP4Small = 11,
		MovieWebMSmall = 10,
		MovieMP4 = 9,
		MovieWebM = 8,
		Class = 7,
		ypeID = 6,
		AppID = 5,
		Description = 4,
		itle = 3,
		InternalName = 2,
		ImageLarge = 1,
		ImageSmall = 0
	},
	EPersonaChange = {
		GameServer = 32,
		RichPresence = 16384,
		SteamLevel = 8192,
		Nickname = 4096,
		Broadcast = 2048,
		NameFirstSet = 1024,
		RelationshipChanged = 512,
		LeftSource = 256,
		JoinedSource = 128,
		Avatar = 64,
		GamePlayed = 16,
		GoneOffline = 8,
		ComeOnline = 4,
		Status = 2,
		Name = 1
	},
	ESteamAPICallFailure = {
		SteamGone = 0,
		InvalidHandle = 2,
		MismatchedCallback = 3,
		None = -1,
		NetworkFailure = 1
	},
	EGamepadTextInputMode = {
		Password = 1,
		Normal = 0
	},
	EGamepadTextInputLineMode = {
		SingleLine = 0,
		MultipleLines = 1
	},
	EFloatingGamepadTextInputMode = {
		ModeEmail = 2,
		ModeSingleLine = 0,
		ModeMultipleLines = 1,
		ModeNumeric = 3
	},
	ETextFilteringContext = {
		GameContent = 1,
		Unknown = 0,
		Name = 3,
		Chat = 2
	},
	ECheckFileSignature = {
		NoSignaturesFoundForThisApp = 3,
		FileNotFound = 2,
		NoSignaturesFoundForThisFile = 4,
		InvalidSignature = 0,
		ValidSignature = 1
	},
	EMatchMakingServerResponse = {
		eNoServersListedOnMasterServer = 2,
		eServerFailedToRespond = 1,
		eServerResponded = 0
	},
	ELobbyType = {
		Invisible = 3,
		Public = 2,
		PrivateUnique = 4,
		FriendsOnly = 1,
		Private = 0
	},
	ELobbyComparison = {
		GreaterThan = 1,
		Equal = 0,
		LessThan = -1,
		EqualToOrLessThan = -2,
		NotEqual = 3,
		EqualToOrGreaterThan = 2
	},
	ELobbyDistanceFilter = {
		Close = 0,
		Default = 1,
		Worldwide = 3,
		Far = 2
	},
	ESteamPartyBeaconLocationType = {
		ChatGroup = 1,
		Invalid = 0,
		Max = 2
	},
	ERemoteStoragePublishedFileVisibility = {
		Public = 0,
		Unlisted = 3,
		FriendsOnly = 1,
		Private = 2
	},
	EWorkshopFileType = {
		Max = 16,
		GameManagedItem = 15,
		SteamVideo = 14,
		SteamworksAccessInvite = 13,
		ControllerBinding = 12,
		Merch = 11,
		IntegratedGuide = 10,
		WebGuide = 9,
		Concept = 8,
		Software = 7,
		Game = 6,
		Screenshot = 5,
		Video = 4,
		Art = 3,
		Collection = 2,
		Microtransaction = 1,
		Community = 0,
		First = 0
	},
	EWorkshopVote = {
		Against = 2,
		For = 1,
		Unvoted = 0,
		Later = 3
	},
	EWorkshopFileAction = {
		Completed = 1,
		Played = 0
	},
	ELeaderboardDataRequest = {
		Friends = 2,
		GlobalAroundUser = 1,
		Global = 0,
		Users = 3
	},
	ELeaderboardSortMethod = {
		Descending = 2,
		Ascending = 1,
		None = 0
	},
	ELeaderboardDisplayType = {
		TimeMilliSeconds = 3,
		TimeSeconds = 2,
		Numeric = 1,
		None = 0
	},
	ELeaderboardUploadScoreMethod = {
		None = 0,
		ForceUpdate = 2,
		KeepBest = 1
	},
	ERegisterActivationCodeResult = {
		AlreadyOwned = 4,
		AlreadyRegistered = 2,
		Fail = 1,
		OK = 0,
		Timeout = 3
	},
	EP2PSessionError = {
		NotRunningApp_DELETED = 1,
		NoRightsToApp = 2,
		DestinationNotLoggedIn_DELETED = 3,
		Max = 5,
		None = 0,
		Timeout = 4
	},
	EP2PSend = {
		UnreliableNoDelay = 1,
		Unreliable = 0,
		ReliableWithBuffering = 3,
		Reliable = 2
	},
	ESNetSocketState = {
		Connected = 1,
		ReceivedRemoteCandidates = 12,
		ConnectionBroken = 25,
		RemoteEndDisconnected = 24,
		TimeoutDuringConnect = 23,
		LocalDisconnect = 22,
		Disconnecting = 21,
		ChallengeHandshake = 15,
		Invalid = 0,
		LocalCandidatesFound = 11,
		Initiated = 10
	},
	ESNetSocketConnectionType = {
		UDPRelay = 2,
		NotConnected = 0,
		UDP = 1
	},
	EVRScreenshotType = {
		MonoCubemap = 3,
		Stereo = 2,
		Mono = 1,
		StereoPanorama = 5,
		None = 0,
		MonoPanorama = 4
	},
	AudioPlayback_Status = {
		Undefined = 0,
		Idle = 3,
		Paused = 2,
		Playing = 1
	},
	EHTTPMethod = {
		POST = 3,
		PATCH = 7,
		OPTIONS = 6,
		DELETE = 5,
		PUT = 4,
		Invalid = 0,
		HEAD = 2,
		GET = 1
	},
	EHTTPStatusCode = {
		["408RequestTimeout"] = 408,
		["407ProxyAuthRequired"] = 407,
		["504GatewayTimeout"] = 504,
		["5xxUnknown"] = 599,
		["505HTTPVersionNotSupported"] = 505,
		Invalid = 0,
		["503ServiceUnavailable"] = 503,
		["502BadGateway"] = 502,
		["501NotImplemented"] = 501,
		["500InternalServerError"] = 500,
		["444ConnectionClosed"] = 444,
		["429TooManyRequests"] = 429,
		["4xxUnknown"] = 418,
		["417ExpectationFailed"] = 417,
		["416RequestedRangeNotSatisfiable"] = 416,
		["415UnsupportedMediaType"] = 415,
		["414RequestURITooLong"] = 414,
		["413RequestEntityTooLarge"] = 413,
		["412PreconditionFailed"] = 412,
		["411LengthRequired"] = 411,
		["410Gone"] = 410,
		["409Conflict"] = 409,
		["101SwitchingProtocols"] = 101,
		["100Continue"] = 100,
		["406NotAcceptable"] = 406,
		["405MethodNotAllowed"] = 405,
		["404NotFound"] = 404,
		["403Forbidden"] = 403,
		["402PaymentRequired"] = 402,
		["401Unauthorized"] = 401,
		["400BadRequest"] = 400,
		["307TemporaryRedirect"] = 307,
		["305UseProxy"] = 305,
		["304NotModified"] = 304,
		["303SeeOther"] = 303,
		["302Found"] = 302,
		["301MovedPermanently"] = 301,
		["300MultipleChoices"] = 300,
		["206PartialContent"] = 206,
		["205ResetContent"] = 205,
		["204NoContent"] = 204,
		["203NonAuthoritative"] = 203,
		["202Accepted"] = 202,
		["201Created"] = 201,
		["200OK"] = 200
	},
	EInputSourceMode = {
		rigger = 10,
		ScrollWheel = 9,
		JoystickCamera = 8,
		JoystickMouse = 7,
		JoystickMove = 6,
		RelativeMouse = 5,
		AbsoluteMouse = 4,
		FourButtons = 3,
		Buttons = 2,
		Dpad = 1,
		None = 0,
		Switches = 16,
		SingleButton = 15,
		RadialMenu = 14,
		MouseRegion = 13,
		MouseJoystick = 12,
		ouchMenu = 11
	},
	EUGCMatchingUGCType = {
		All = -1,
		Videos = 5,
		Artwork = 4,
		Collections = 3,
		Items_ReadyToUse = 2,
		Items_Mtx = 1,
		Items = 0,
		GameManagedItems = 12,
		ControllerBindings = 11,
		UsableInGame = 10,
		IntegratedGuides = 9,
		WebGuides = 8,
		AllGuides = 7,
		Screenshots = 6
	},
	EUserUGCList = {
		UsedOrPlayed = 7,
		Subscribed = 6,
		Favorited = 5,
		WillVoteLater = 4,
		VotedDown = 3,
		VotedUp = 2,
		VotedOn = 1,
		Published = 0,
		Followed = 8
	},
	EUserUGCListSortOrder = {
		VoteScoreDesc = 5,
		SubscriptionDateDesc = 4,
		LastUpdatedDesc = 3,
		itleAsc = 2,
		CreationOrderAsc = 1,
		CreationOrderDesc = 0,
		ForModeration = 6
	},
	EUGCQuery = {
		RankedByLastUpdatedDate = 19,
		RankedByLifetimePlaytimeSessions = 18,
		RankedByPlaytimeSessionsTrend = 17,
		RankedByLifetimeAveragePlaytime = 16,
		RankedByAveragePlaytimeTrend = 15,
		RankedByTotalPlaytime = 14,
		RankedByPlaytimeTrend = 13,
		RankedByTotalUniqueSubscriptions = 12,
		RankedByTextSearch = 11,
		RankedByVotesUp = 10,
		RankedByTotalVotesAsc = 9,
		NotYetRated = 8,
		CreatedByFollowedUsersRankedByPublicationDate = 7,
		RankedByNumTimesReported = 6,
		CreatedByFriendsRankedByPublicationDate = 5,
		FavoritedByFriendsRankedByPublicationDate = 4,
		RankedByTrend = 3,
		AcceptedForGameRankedByAcceptanceDate = 2,
		RankedByPublicationDate = 1,
		RankedByVote = 0
	},
	EItemUpdateStatus = {
		PreparingConfig = 1,
		UploadingPreviewFile = 4,
		CommittingChanges = 5,
		Invalid = 0,
		UploadingContent = 3,
		PreparingContent = 2
	},
	EItemStatistic = {
		NumComments = 10,
		NumPlaytimeSessions = 9,
		NumSecondsPlayed = 8,
		ReportScore = 7,
		NumUniqueWebsiteViews = 6,
		NumUniqueFollowers = 5,
		NumUniqueFavorites = 4,
		NumUniqueSubscriptions = 3,
		NumFollowers = 2,
		NumFavorites = 1,
		NumSubscriptions = 0,
		NumPlaytimeSessionsDuringTimePeriod = 12,
		NumSecondsPlayedDuringTimePeriod = 11
	},
	EItemPreviewType = {
		EnvironmentMap_LatLong = 4,
		EnvironmentMap_HorizontalCross = 3,
		Sketchfab = 2,
		YouTubeVideo = 1,
		Image = 0,
		ReservedMax = 255
	},
	EParentalFeature = {
		Console = 8,
		Settings = 7,
		Trading = 6,
		News = 5,
		Profile = 3,
		Store = 1,
		Community = 2,
		Library = 11,
		Friends = 4,
		Max = 14,
		SiteLicense = 13,
		Test = 12,
		Invalid = 0,
		ParentalSetup = 10,
		Browser = 9
	},
	ESteamDeviceFormFactor = {
		Tablet = 2,
		Phone = 1,
		Unknown = 0,
		TV = 4,
		Computer = 3
	},
	ESteamNetworkingAvailability = {
		NeverTried = 1,
		Retrying = -10,
		Previously = -100,
		Failed = -101,
		CannotTry = -102,
		Unknown = 0,
		Current = 100,
		Attempting = 3,
		Waiting = 2
	},
	ESteamNetworkingIdentityType = {
		UnknownType = 4,
		GenericBytes = 3,
		GenericString = 2,
		IPAddress = 1,
		GoogleStadia = 19,
		SonyPSN = 18,
		XboxPairwiseID = 17,
		SteamID = 16,
		Invalid = 0
	},
	ESteamNetworkingFakeIPType = {
		LocalIPv4 = 3,
		Invalid = 0,
		NotFake = 1,
		GlobalIPv4 = 2
	},
	ESteamNetworkingConnectionState = {
		Connected = 3,
		None = 0,
		Dead = -3,
		Linger = -2,
		FinWait = -1,
		ProblemDetectedLocally = 5,
		ClosedByPeer = 4,
		FindingRoute = 2,
		Connecting = 1
	},
	ESteamNetworkingConfigScope = {
		Connection = 4,
		ListenSocket = 3,
		SocketsInterface = 2,
		Global = 1
	},
	ESteamNetworkingConfigDataType = {
		Float = 3,
		Int64 = 2,
		Int32 = 1,
		Ptr = 5,
		String = 4
	},
	ESteamNetworkingConfigValue = {
		LocalVirtualPort = 38,
		SymmetricConnect = 37,
		Unencrypted = 34,
		MTU_DataSize = 33,
		MTU_PacketSize = 32,
		IP_AllowWithoutAuth = 23,
		NagleTime = 12,
		Callback_ConnectionStatusChanged = 201,
		FakeRateLimit_Recv_Burst = 45,
		FakeRateLimit_Recv_Rate = 44,
		FakeRateLimit_Send_Burst = 43,
		FakeRateLimit_Send_Rate = 42,
		PacketTraceMaxBytes = 41,
		FakePacketDup_TimeMax = 28,
		FakePacketDup_Recv = 27,
		FakePacketDup_Send = 26,
		FakePacketReorder_Time = 8,
		FakePacketReorder_Recv = 7,
		FakePacketReorder_Send = 6,
		FakePacketLag_Recv = 5,
		FakePacketLag_Send = 4,
		FakePacketLoss_Recv = 3,
		SendRateMax = 11,
		SendRateMin = 10,
		ConnectionUserData = 40,
		SendBufferSize = 9,
		TimeoutConnected = 25,
		TimeoutInitial = 24,
		Invalid = 0,
		Callback_AuthStatusChanged = 202,
		Callback_RelayNetworkStatusChanged = 203,
		Callback_MessagesSessionRequest = 204,
		Callback_MessagesSessionFailed = 205,
		Callback_CreateConnectionSignaling = 206,
		Callback_FakeIPResult = 207,
		P2P_STUN_ServerList = 103,
		P2P_Transport_ICE_Enable = 104,
		P2P_Transport_ICE_Penalty = 105,
		P2P_Transport_SDR_Penalty = 106,
		DELETED_EnumerateDevVars = 35,
		LogLevel_SDRRelayPings = 18,
		LogLevel_P2PRendezvous = 17,
		LogLevel_PacketGaps = 16,
		LogLevel_Message = 15,
		LogLevel_PacketDecode = 14,
		LogLevel_AckRTT = 13,
		SDRClient_FakeClusterPing = 36,
		SDRClient_ForceProxyAddr = 31,
		SDRClient_DebugTicketAddress = 30,
		SDRClient_ForceRelayCluster = 29,
		SDRClient_SingleSocket = 22,
		SDRClient_MinPingsBeforePingAccurate = 21,
		SDRClient_ConsecutitivePingTimeoutsFail = 20,
		SDRClient_ConsecutitivePingTimeoutsFailInitial = 19,
		P2P_Transport_ICE_Implementation = 110,
		P2P_TURN_PassList = 109,
		P2P_TURN_UserList = 108,
		P2P_TURN_ServerList = 107,
		FakePacketLoss_Send = 2,
		EnableDiagnosticsUI = 46,
		DualWifi_Enable = 39
	},
	ESteamNetworkingGetConfigValueResult = {
		BadValue = -1,
		BufferTooSmall = -3,
		OK = 1,
		OKInherited = 2,
		BadScopeObj = -2
	},
	ESteamNetworkingSocketsDebugOutputType = {
		Verbose = 6,
		Msg = 5,
		Warning = 4,
		Important = 3,
		Bug = 1,
		Error = 2,
		None = 0,
		Everything = 8,
		Debug = 7
	},
	EHTMLMouseButton = {
		Left = 0,
		Middle = 2,
		Right = 1
	},
	EHTMLKeyModifiers = {
		AltDown = 1,
		ShiftDown = 4,
		None = 0,
		CtrlDown = 2
	},
	PlayerAcceptState_t = {
		PlayerAccepted = 1,
		Unknown = 0,
		PlayerDeclined = 2
	}
}

for iter_0_0, iter_0_1 in var_0_22(var_0_64) do
	local var_0_65 = {
		__index = {}
	}

	for iter_0_2, iter_0_3 in var_0_22(iter_0_1) do
		var_0_65.__index[var_0_14(iter_0_2)] = iter_0_3
		var_0_65.__index[var_0_15(iter_0_2)] = iter_0_3
		var_0_65.__index[iter_0_3] = iter_0_2
	end

	var_0_21(iter_0_1, var_0_65)

	var_0_61[iter_0_0] = iter_0_1
end

local var_0_66 = {}

for iter_0_4, iter_0_5 in var_0_22(var_0_66) do
	var_0_61[iter_0_4] = iter_0_5
end

if not var_0_55("SteamID") then
	var_0_3("\t\ttypedef union {\n\t\t\tuint64_t steamid64;\n\t\t\tstruct {\n\t\t\t  uint32_t accountid : 32;\n\t\t\t  unsigned int instance : 20;\n\t\t\t  unsigned int type : 4;\n\t\t\t  unsigned int universe : 8;\n\t\t\t};\n\t\t\tstruct {\n\t\t\t  uint32_t low;\n\t\t\t  uint32_t high;\n\t\t\t};\n\t\t} __attribute__((packed)) SteamID;\n\t")
end

var_0_18(var_0_5("SteamID") == 8)

local var_0_67
local var_0_68 = var_0_4("SteamID")
local var_0_69 = var_0_64.EAccountType
local var_0_70 = var_0_64.EChatSteamIDInstanceFlags
local var_0_71 = {
	[var_0_69.INVALID] = "I",
	[var_0_69.INDIVIDUAL] = "U",
	[var_0_69.MULTISEAT] = "M",
	[var_0_69.GAMESERVER] = "G",
	[var_0_69.ANONGAMESERVER] = "A",
	[var_0_69.PENDING] = "P",
	[var_0_69.CONTENTSERVER] = "C",
	[var_0_69.CLAN] = "g",
	[var_0_69.CHAT] = "T",
	[var_0_69.ANONUSER] = "a"
}
local var_0_72 = {
	["5"] = "h",
	["4"] = "g",
	f = "w",
	["3"] = "f",
	d = "t",
	["2"] = "d",
	c = "r",
	["1"] = "c",
	b = "q",
	["0"] = "b",
	a = "p",
	["8"] = "m",
	["7"] = "k",
	e = "v",
	["6"] = "j",
	["9"] = "n"
}
local var_0_73 = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
local var_0_74 = {}
local var_0_75 = {}

for iter_0_6 = 1, 32 do
	local var_0_76 = var_0_73:sub(iter_0_6, iter_0_6)

	var_0_74[iter_0_6 - 1] = var_0_76
	var_0_75[var_0_76] = iter_0_6 - 1
end

local var_0_77 = "[" .. var_0_73 .. "]"
local var_0_78 = {}

for iter_0_7, iter_0_8 in var_0_22(var_0_71) do
	var_0_78[iter_0_8] = iter_0_7
end

local var_0_79 = 1
local var_0_80 = var_0_70.FlagClan
local var_0_81 = var_0_70.FlagLobby
local var_0_82 = var_0_69.INVALID
local var_0_83 = var_0_69.INDIVIDUAL
local var_0_84 = var_0_69.GAMESERVER
local var_0_85 = var_0_69.ANONGAMESERVER
local var_0_86 = var_0_69.MULTISEAT
local var_0_87 = var_0_69.CLAN
local var_0_88 = var_0_69.CHAT
local var_0_89 = var_0_69.MAX
local var_0_90 = "^765(" .. string.rep("%d", 14) .. ")$"
local var_0_91 = "^STEAM_([012345]):([01]):(%d+)$"
local var_0_92 = "^%[(%a):([012345]):(%d+)%]$"
local var_0_93 = "^%[(%a):([012345]):(%d+):(%d+)%]$"
local var_0_94 = "^(" .. string.rep(var_0_77, 5) .. ")%-(" .. string.rep(var_0_77, 4) .. ")$"

local function var_0_95(arg_11_0)
	return var_0_10(var_0_19(arg_11_0.steamid64), 1, -4)
end

local function var_0_96(arg_12_0, arg_12_1)
	if arg_12_0.type ~= var_0_83 then
		return var_0_26("Cannot render non-individual ID as Steam2")
	end

	local var_12_0 = arg_12_0.universe

	if (arg_12_1 or arg_12_1 == nil) and var_12_0 == 1 then
		var_12_0 = 0
	end

	return var_0_16("STEAM_%d:%d:%d", var_12_0, var_0_36(arg_12_0.accountid, 1), var_0_33(arg_12_0.accountid / 2))
end

local function var_0_97(arg_13_0)
	local var_13_0
	local var_13_1 = var_0_36(arg_13_0.instance, var_0_80) == var_0_80 and "c" or var_0_36(arg_13_0.instance, var_0_81) == var_0_81 and "L" or var_0_71[arg_13_0.type] or "i"
	local var_13_2 = arg_13_0.type == var_0_85 or arg_13_0.type == var_0_86 or arg_13_0.type == var_0_83 and arg_13_0.instance ~= var_0_79

	return var_0_16("[%s:%d:%d%s]", var_13_1, arg_13_0.universe, arg_13_0.accountid, var_13_2 and ":" .. arg_13_0.instance or "")
end

local function var_0_98(arg_14_0)
	if arg_14_0.type ~= var_0_82 and arg_14_0.type ~= var_0_83 then
		return var_0_26("Cannot only render individual / invalid ID as Steam Invite")
	end

	local var_14_0 = var_0_11(var_0_16("%x", arg_14_0.accountid), ".", function(arg_15_0)
		return var_0_72[arg_15_0] or arg_15_0
	end)
	local var_14_1 = var_0_9(var_14_0)

	if var_14_1 > 3 then
		local var_14_2 = var_0_33(var_14_1 / 2)

		return var_0_16("%s-%s", var_0_10(var_14_0, 1, var_14_2), var_0_10(var_14_0, var_14_2 + 1, -1))
	end

	return var_14_0
end

local function var_0_99(arg_16_0)
	if arg_16_0.type ~= var_0_82 and arg_16_0.type ~= var_0_83 then
		return var_0_26("Cannot only render individual / invalid ID as Friend Code")
	end

	local var_16_0 = var_0_45(1, var_0_37(arg_16_0.accountid, 4851299628236144640ULL))
	local var_16_1 = var_0_7(var_0_2("const char*", var_16_0), 8)
	local var_16_2 = var_0_41(var_16_1)

	var_0_8(var_0_2("void*", var_16_0), var_16_2, 4)

	local var_16_3 = var_16_0[0]
	local var_16_4 = 0ULL

	for iter_16_0 = 0, 7 do
		local var_16_5 = var_0_20(var_0_36(var_0_38(arg_16_0.steamid64, iter_16_0 * 4), 15))
		local var_16_6 = var_0_20(var_0_36(var_0_38(var_16_3, iter_16_0), 1))
		local var_16_7 = var_0_37(var_0_39(var_16_4, 4), var_16_5)

		var_16_4 = var_0_37(var_0_39(var_0_38(var_16_4, 28), 32), var_16_7)
		var_16_4 = var_0_37(var_0_39(var_0_38(var_16_4, 31), 32), var_0_37(var_0_39(var_16_7, 1), var_16_6))
	end

	local var_16_8 = var_0_40(var_16_4)
	local var_16_9 = ""

	for iter_16_1 = 0, 8 do
		if iter_16_1 == 5 then
			var_16_9 = var_16_9 .. "-"
		end

		var_16_9 = var_16_9 .. var_0_74[var_0_20(var_0_36(var_0_38(var_16_8, 20 + iter_16_1 * 5), 31))]
	end

	return var_16_9
end

local function var_0_100(arg_17_0)
	if arg_17_0.type <= var_0_82 or arg_17_0.type >= var_0_89 then
		return false
	end

	if arg_17_0.universe <= 0 or arg_17_0.universe > 4 then
		return false
	end

	if arg_17_0.type == var_0_83 and (arg_17_0.accountid == 0 or arg_17_0.instance > 4) then
		return false
	end

	if arg_17_0.type == var_0_87 and (arg_17_0.accountid == 0 or arg_17_0.instance ~= 0) then
		return false
	end

	if arg_17_0.type == var_0_84 and arg_17_0.accountid == 0 then
		return false
	end

	return true
end

local function var_0_101(arg_18_0, arg_18_1)
	local var_18_0 = var_0_7(var_0_2("const char*", var_0_45(1, arg_18_0.steamid64)), 8)

	if arg_18_1 then
		var_18_0 = var_0_17(var_18_0)
	end

	return var_18_0
end

local function var_0_102(arg_19_0, arg_19_1)
	if not var_0_6(var_0_68, arg_19_0) then
		arg_19_0, arg_19_1 = arg_19_1, arg_19_0
	end

	local var_19_0 = var_0_27(arg_19_1)

	if not var_0_6(var_0_68, arg_19_0) then
		return var_0_27(arg_19_0) == "nil" and var_19_0 == "nil"
	end

	if var_19_0 == "nil" then
		return false
	elseif var_19_0 == "cdata" and var_0_6(var_0_68, arg_19_1) then
		return arg_19_0.steamid64 == arg_19_1.steamid64
	elseif (var_19_0 == "number" or var_19_0 == "cdata") and (arg_19_0.accountid == arg_19_1 or arg_19_0.steamid64 == arg_19_1) then
		return true
	end

	return arg_19_0.steamid64 == var_0_67(arg_19_1).steamid64
end

var_0_24(var_0_0.metatype, var_0_68, {
	__index = {
		is_valid = var_0_100,
		render_steam2 = var_0_96,
		render_steam3 = var_0_97,
		render_steam64 = var_0_95,
		render_steam_invite = var_0_98,
		render_friend_code = var_0_99,
		pack = var_0_101
	},
	__tostring = var_0_95,
	__eq = var_0_102
})

function var_0_67(arg_20_0)
	if var_0_6(var_0_68, arg_20_0) then
		return arg_20_0
	elseif var_0_6(var_0_43, arg_20_0) and arg_20_0 > var_0_44 then
		return var_0_68(arg_20_0)
	end

	local var_20_0 = var_0_27(arg_20_0)

	if var_20_0 == "string" then
		local var_20_1 = var_0_12(arg_20_0, var_0_90)

		if var_20_1 ~= nil then
			return var_0_68(76500000000000000ULL + var_0_20(var_20_1))
		end

		local var_20_2, var_20_3, var_20_4 = var_0_12(arg_20_0, var_0_91)

		if var_20_2 ~= nil then
			local var_20_5 = var_0_68()

			var_20_5.universe = var_20_2 == "0" and 1 or var_0_20(var_20_2)
			var_20_5.type = var_0_83
			var_20_5.instance = var_0_79
			var_20_5.accountid = var_0_20(var_20_4) * 2 + var_20_3

			return var_20_5
		end

		local var_20_6, var_20_7, var_20_8, var_20_9 = var_0_12(arg_20_0, var_0_92)

		if var_20_6 ~= nil then
			if var_20_6 == "U" then
				var_20_9 = var_0_79
			else
				var_20_9 = 0
			end
		else
			var_20_6, var_20_7, var_20_8, var_20_9 = var_0_12(arg_20_0, var_0_93)
		end

		if var_20_6 ~= nil then
			local var_20_10 = var_0_68()

			var_20_10.universe = var_0_20(var_20_7)
			var_20_10.instance = var_0_20(var_20_9)
			var_20_10.accountid = var_0_20(var_20_8)

			if var_20_6 == "c" then
				var_20_10.instance = var_0_37(var_20_10.instance, var_0_80)
				var_20_10.type = var_0_88
			elseif var_20_6 == "L" then
				var_20_10.instance = var_0_37(var_20_10.instance, var_0_81)
				var_20_10.type = var_0_88
			else
				var_20_10.type = var_0_78[var_20_6] or 0
			end

			return var_20_10
		end

		local var_20_11, var_20_12 = var_0_12(arg_20_0, var_0_94)

		if var_20_11 ~= nil then
			local var_20_13 = "AAAA" .. var_20_11 .. var_20_12
			local var_20_14 = 0ULL
			local var_20_15 = 0

			for iter_20_0 in var_0_13(var_20_13, ".") do
				local var_20_16 = var_0_2(var_0_43, var_0_75[iter_20_0])

				var_20_14 = var_0_37(var_20_14, var_0_39(var_20_16, var_20_15 * 5))
				var_20_15 = var_20_15 + 1
			end

			local var_20_17 = var_0_40(var_20_14)
			local var_20_18 = var_0_68()

			for iter_20_1 = 0, 7 do
				var_20_17 = var_0_38(var_20_17, 1)

				local var_20_19 = var_0_36(var_20_17, 15)

				var_20_17 = var_0_38(var_20_17, 4)
				var_20_18.accountid = var_0_37(var_0_39(var_20_18.accountid, 4), var_20_19)
			end

			var_20_18.type = var_0_83
			var_20_18.universe = 1
			var_20_18.instance = 1

			return var_20_18
		end
	elseif var_20_0 == "number" and arg_20_0 > 0 then
		return var_0_68(var_0_44 + arg_20_0)
	end

	return nil
end

var_0_56("SteamIPAddress_t", "\ttypedef struct {\n\t\tuint8_t m_rgubIPv6[16];\n\t\tint m_eType;\n\t} SteamIPAddress_t;\n")
var_0_56("FriendGameInfo_t", "\ttypedef struct {\n\t\tuint64_t m_gameID;\n\t\tuint32_t m_unGameIP;\n\t\tuint16_t m_usGamePort;\n\t\tuint16_t m_usQueryPort;\n\t\tSteamID m_steamIDLobby;\n\t} FriendGameInfo_t;\n")
var_0_56("MatchMakingKeyValuePair_t", "\ttypedef struct {\n\t\tchar m_szKey[256];\n\t\tchar m_szValue[256];\n\t} MatchMakingKeyValuePair_t;\n")
var_0_56("servernetadr_t", "\ttypedef struct {\n\t\tuint16_t m_usConnectionPort;\n\t\tuint16_t m_usQueryPort;\n\t\tuint32_t m_unIP;\n\t} servernetadr_t;\n")
var_0_56("gameserveritem_t", "\ttypedef struct {\n\t\tservernetadr_t m_NetAdr;\n\t\tint m_nPing;\n\t\tbool m_bHadSuccessfulResponse;\n\t\tbool m_bDoNotRefresh;\n\t\tchar m_szGameDir[32];\n\t\tchar m_szMap[32];\n\t\tchar m_szGameDescription[64];\n\t\tuint32_t m_nAppID;\n\t\tint m_nPlayers;\n\t\tint m_nMaxPlayers;\n\t\tint m_nBotPlayers;\n\t\tbool m_bPassword;\n\t\tbool m_bSecure;\n\t\tuint32_t m_ulTimeLastPlayed;\n\t\tint m_nServerVersion;\n\t\tchar m_szServerName[64];\n\t\tchar m_szGameTags[128];\n\t\tSteamID m_steamID;\n\t} gameserveritem_t;\n")
var_0_56("SteamPartyBeaconLocation_t", "\ttypedef struct {\n\t\tint m_eType;\n\t\tuint64_t m_ulLocationID;\n\t} SteamPartyBeaconLocation_t;\n")
var_0_56("SteamParamStringArray_t", "\ttypedef struct {\n\t\tconst char ** m_ppStrings;\n\t\tint32_t m_nNumStrings;\n\t} SteamParamStringArray_t;\n")
var_0_56("LeaderboardEntry_t", "\ttypedef struct {\n\t\tSteamID m_steamIDUser;\n\t\tint32_t m_nGlobalRank;\n\t\tint32_t m_nScore;\n\t\tint32_t m_cDetails;\n\t\tuint64_t m_hUGC;\n\t} LeaderboardEntry_t;\n")
var_0_56("P2PSessionState_t", "\ttypedef struct {\n\t\tuint8_t m_bConnectionActive;\n\t\tuint8_t m_bConnecting;\n\t\tuint8_t m_eP2PSessionError;\n\t\tuint8_t m_bUsingRelay;\n\t\tint32_t m_nBytesQueuedForSend;\n\t\tint32_t m_nPacketsQueuedForSend;\n\t\tuint32_t m_nRemoteIP;\n\t\tuint16_t m_nRemotePort;\n\t} P2PSessionState_t;\n")
var_0_56("InputAnalogActionData_t", "\ttypedef struct {\n\t\tint eMode;\n\t\tfloat x;\n\t\tfloat y;\n\t\tbool bActive;\n\t} InputAnalogActionData_t;\n")
var_0_56("InputDigitalActionData_t", "\ttypedef struct {\n\t\tbool bState;\n\t\tbool bActive;\n\t} InputDigitalActionData_t;\n")
var_0_56("InputMotionData_t", "\ttypedef struct {\n\t\tfloat rotQuatX;\n\t\tfloat rotQuatY;\n\t\tfloat rotQuatZ;\n\t\tfloat rotQuatW;\n\t\tfloat posAccelX;\n\t\tfloat posAccelY;\n\t\tfloat posAccelZ;\n\t\tfloat rotVelX;\n\t\tfloat rotVelY;\n\t\tfloat rotVelZ;\n\t} InputMotionData_t;\n")
var_0_56("SteamUGCDetails_t", "\ttypedef struct {\n\t\tuint64_t m_nPublishedFileId;\n\t\tint m_eResult;\n\t\tint m_eFileType;\n\t\tunsigned int m_nCreatorAppID;\n\t\tunsigned int m_nConsumerAppID;\n\t\tchar m_rgchTitle[129];\n\t\tchar m_rgchDescription[8000];\n\t\tuint64_t m_ulSteamIDOwner;\n\t\tuint32_t m_rtimeCreated;\n\t\tuint32_t m_rtimeUpdated;\n\t\tuint32_t m_rtimeAddedToUserList;\n\t\tint m_eVisibility;\n\t\tbool m_bBanned;\n\t\tbool m_bAcceptedForUse;\n\t\tbool m_bTagsTruncated;\n\t\tchar m_rgchTags[1025];\n\t\tuint64_t m_hFile;\n\t\tuint64_t m_hPreviewFile;\n\t\tchar m_pchFileName[260];\n\t\tint32_t m_nFileSize;\n\t\tint32_t m_nPreviewFileSize;\n\t\tchar m_rgchURL[256];\n\t\tuint32_t m_unVotesUp;\n\t\tuint32_t m_unVotesDown;\n\t\tfloat m_flScore;\n\t\tuint32_t m_unNumChildren;\n\t} SteamUGCDetails_t;\n")
var_0_56("SteamItemDetails_t", "\ttypedef struct {\n\t\tuint64_t m_itemId;\n\t\tint m_iDefinition;\n\t\tuint16_t m_unQuantity;\n\t\tuint16_t m_unFlags;\n\t} SteamItemDetails_t;\n")
var_0_56("SteamNetworkingIPAddr", "\ttypedef struct {\n\t\tuint8_t m_ipv6[16];\n\t\tuint16_t m_port;\n\t} SteamNetworkingIPAddr;\n")
var_0_56("SteamNetworkingIdentity", "\ttypedef struct {\n\t\tint m_eType;\n\t\tint m_cbSize;\n\t\tchar m_szUnknownRawString[128];\n\t} SteamNetworkingIdentity;\n")
var_0_56("SteamNetConnectionInfo_t", "\ttypedef struct {\n\t\tSteamNetworkingIdentity m_identityRemote;\n\t\tint64_t m_nUserData;\n\t\tunsigned int m_hListenSocket;\n\t\tSteamNetworkingIPAddr m_addrRemote;\n\t\tuint16_t m__pad1;\n\t\tunsigned int m_idPOPRemote;\n\t\tunsigned int m_idPOPRelay;\n\t\tint m_eState;\n\t\tint m_eEndReason;\n\t\tchar m_szEndDebug[128];\n\t\tchar m_szConnectionDescription[128];\n\t\tint m_nFlags;\n\t\tuint32_t reserved[63];\n\t} SteamNetConnectionInfo_t;\n")
var_0_56("SteamNetConnectionRealTimeStatus_t", "\ttypedef struct {\n\t\tint m_eState;\n\t\tint m_nPing;\n\t\tfloat m_flConnectionQualityLocal;\n\t\tfloat m_flConnectionQualityRemote;\n\t\tfloat m_flOutPacketsPerSec;\n\t\tfloat m_flOutBytesPerSec;\n\t\tfloat m_flInPacketsPerSec;\n\t\tfloat m_flInBytesPerSec;\n\t\tint m_nSendRateBytesPerSecond;\n\t\tint m_cbPendingUnreliable;\n\t\tint m_cbPendingReliable;\n\t\tint m_cbSentUnackedReliable;\n\t\tlong long m_usecQueueTime;\n\t\tuint32_t reserved[16];\n\t} SteamNetConnectionRealTimeStatus_t;\n")
var_0_56("SteamNetConnectionRealTimeLaneStatus_t", "\ttypedef struct {\n\t\tint m_cbPendingUnreliable;\n\t\tint m_cbPendingReliable;\n\t\tint m_cbSentUnackedReliable;\n\t\tint _reservePad1;\n\t\tlong long m_usecQueueTime;\n\t\tuint32_t reserved[10];\n\t} SteamNetConnectionRealTimeLaneStatus_t;\n")
var_0_56("SteamNetworkingMessage_t", "\ttypedef struct _SteamNetworkingMessage_t {\n\t\tvoid * m_pData;\n\t\tint m_cbSize;\n\t\tunsigned int m_conn;\n\t\tSteamNetworkingIdentity m_identityPeer;\n\t\tint64_t m_nConnUserData;\n\t\tlong long m_usecTimeReceived;\n\t\tint64_t m_nMessageNumber;\n\t\tvoid (__thiscall * m_pfnFreeData)(struct _SteamNetworkingMessage_t *);\n\t\tvoid (__thiscall * m_pfnRelease)(struct _SteamNetworkingMessage_t *);\n\t\tint m_nChannel;\n\t\tint m_nFlags;\n\t\tint64_t m_nUserData;\n\t\tuint16_t m_idxLane;\n\t\tuint16_t _pad1__;\n\t} SteamNetworkingMessage_t;\n")
var_0_56("SteamNetworkPingLocation_t", "\ttypedef struct {\n\t\tuint8_t m_data[512];\n\t} SteamNetworkPingLocation_t;\n")
var_0_56("SteamNetworkingConfigValue_t", "\ttypedef struct {\n\t\tint m_eValue;\n\t\tint m_eDataType;\n\t\tint64_t m_int64;\n\t} SteamNetworkingConfigValue_t;\n")
var_0_56("SteamDatagramHostedAddress", "\ttypedef struct {\n\t\tint m_cbSize;\n\t\tchar m_data[128];\n\t} SteamDatagramHostedAddress;\n")
var_0_56("SteamDatagramGameCoordinatorServerLogin", "\ttypedef struct {\n\t\tSteamNetworkingIdentity m_identity;\n\t\tSteamDatagramHostedAddress m_routing;\n\t\tunsigned int m_nAppID;\n\t\tunsigned int m_rtime;\n\t\tint m_cbAppData;\n\t\tchar m_appData[2048];\n\t} SteamDatagramGameCoordinatorServerLogin;\n")
var_0_56("SteamNetAuthenticationStatus_t", "\ttypedef struct {\n\t\tint m_eAvail;\n\t\tchar m_debugMsg[256];\n\t} SteamNetAuthenticationStatus_t;\n")
var_0_56("SteamNetworkingFakeIPResult_t", "\ttypedef struct {\n\t\tint m_eResult;\n\t\tSteamNetworkingIdentity m_identity;\n\t\tuint32_t m_unIP;\n\t\tuint16_t m_unPorts[8];\n\t} SteamNetworkingFakeIPResult_t;\n")
var_0_56("SteamRelayNetworkStatus_t", "\ttypedef struct {\n\t\tint m_eAvail;\n\t\tint m_bPingMeasurementInProgress;\n\t\tint m_eAvailNetworkConfig;\n\t\tint m_eAvailAnyRelay;\n\t\tchar m_debugMsg[256];\n\t} SteamRelayNetworkStatus_t;\n")
var_0_56("SteamNetConnectionStatusChangedCallback_t", "\ttypedef struct {\n\t\tunsigned int m_hConn;\n\t\tSteamNetConnectionInfo_t m_info;\n\t\tint m_eOldState;\n\t} SteamNetConnectionStatusChangedCallback_t;\n")
var_0_56("SteamNetworkingMessagesSessionRequest_t", "\ttypedef struct {\n\t\tSteamNetworkingIdentity m_identityRemote;\n\t} SteamNetworkingMessagesSessionRequest_t;\n")
var_0_56("SteamNetworkingMessagesSessionFailed_t", "\ttypedef struct {\n\t\tSteamNetConnectionInfo_t m_info;\n\t} SteamNetworkingMessagesSessionFailed_t;\n")
var_0_56("SteamDatagramRelayAuthTicket", "\ttypedef struct {\n\t\tSteamNetworkingIdentity m_identityGameserver;\n\t\tSteamNetworkingIdentity m_identityAuthorizedClient;\n\t\tuint32_t m_unPublicIP;\n\t\tuint32_t m_rtimeTicketExpiry;\n\t\tSteamDatagramHostedAddress m_routing;\n\t\tuint32_t m_nAppID;\n\t\tint m_nRestrictToVirtualPort;\n\t\tint m_nExtraFields;\n\n\t\tstruct {\n\t\t\tenum EType\n\t\t\t{\n\t\t\t\tk_EType_String,\n\t\t\t\tk_EType_Int,\n\t\t\t\tk_EType_Fixed64,\n\t\t\t};\n\t\t\tint m_eType;\n\t\t\tchar m_szName[28];\n\n\t\t\tunion {\n\t\t\t\tchar m_szStringValue[128];\n\t\t\t\tint64_t m_nIntValue;\n\t\t\t\tuint64_t m_nFixed64Value;\n\t\t\t};\n\t\t} m_vecExtraFields[ 16 ];\n\n\t} SteamDatagramRelayAuthTicket;\n")

local var_0_103 = {
	SteamIPAddress_t = var_0_4("SteamIPAddress_t"),
	SteamIPAddress_t_arr = var_0_4("SteamIPAddress_t [?]"),
	FriendGameInfo_t = var_0_4("FriendGameInfo_t"),
	FriendGameInfo_t_arr = var_0_4("FriendGameInfo_t [?]"),
	MatchMakingKeyValuePair_t = var_0_4("MatchMakingKeyValuePair_t"),
	MatchMakingKeyValuePair_t_arr = var_0_4("MatchMakingKeyValuePair_t [?]"),
	servernetadr_t = var_0_4("servernetadr_t"),
	servernetadr_t_arr = var_0_4("servernetadr_t [?]"),
	gameserveritem_t = var_0_4("gameserveritem_t"),
	gameserveritem_t_arr = var_0_4("gameserveritem_t [?]"),
	SteamPartyBeaconLocation_t = var_0_4("SteamPartyBeaconLocation_t"),
	SteamPartyBeaconLocation_t_arr = var_0_4("SteamPartyBeaconLocation_t [?]"),
	SteamParamStringArray_t = var_0_4("SteamParamStringArray_t"),
	SteamParamStringArray_t_arr = var_0_4("SteamParamStringArray_t [?]"),
	LeaderboardEntry_t = var_0_4("LeaderboardEntry_t"),
	LeaderboardEntry_t_arr = var_0_4("LeaderboardEntry_t [?]"),
	P2PSessionState_t = var_0_4("P2PSessionState_t"),
	P2PSessionState_t_arr = var_0_4("P2PSessionState_t [?]"),
	InputAnalogActionData_t = var_0_4("InputAnalogActionData_t"),
	InputAnalogActionData_t_arr = var_0_4("InputAnalogActionData_t [?]"),
	InputDigitalActionData_t = var_0_4("InputDigitalActionData_t"),
	InputDigitalActionData_t_arr = var_0_4("InputDigitalActionData_t [?]"),
	InputMotionData_t = var_0_4("InputMotionData_t"),
	InputMotionData_t_arr = var_0_4("InputMotionData_t [?]"),
	SteamUGCDetails_t = var_0_4("SteamUGCDetails_t"),
	SteamUGCDetails_t_arr = var_0_4("SteamUGCDetails_t [?]"),
	SteamItemDetails_t = var_0_4("SteamItemDetails_t"),
	SteamItemDetails_t_arr = var_0_4("SteamItemDetails_t [?]"),
	SteamNetworkingIPAddr = var_0_4("SteamNetworkingIPAddr"),
	SteamNetworkingIPAddr_arr = var_0_4("SteamNetworkingIPAddr [?]"),
	SteamNetworkingIdentity = var_0_4("SteamNetworkingIdentity"),
	SteamNetworkingIdentity_arr = var_0_4("SteamNetworkingIdentity [?]"),
	SteamNetConnectionInfo_t = var_0_4("SteamNetConnectionInfo_t"),
	SteamNetConnectionInfo_t_arr = var_0_4("SteamNetConnectionInfo_t [?]"),
	SteamNetConnectionRealTimeStatus_t = var_0_4("SteamNetConnectionRealTimeStatus_t"),
	SteamNetConnectionRealTimeStatus_t_arr = var_0_4("SteamNetConnectionRealTimeStatus_t [?]"),
	SteamNetConnectionRealTimeLaneStatus_t = var_0_4("SteamNetConnectionRealTimeLaneStatus_t"),
	SteamNetConnectionRealTimeLaneStatus_t_arr = var_0_4("SteamNetConnectionRealTimeLaneStatus_t [?]"),
	SteamNetworkingMessage_t = var_0_4("SteamNetworkingMessage_t"),
	SteamNetworkingMessage_t_arr = var_0_4("SteamNetworkingMessage_t [?]"),
	SteamNetworkPingLocation_t = var_0_4("SteamNetworkPingLocation_t"),
	SteamNetworkPingLocation_t_arr = var_0_4("SteamNetworkPingLocation_t [?]"),
	SteamNetworkingConfigValue_t = var_0_4("SteamNetworkingConfigValue_t"),
	SteamNetworkingConfigValue_t_arr = var_0_4("SteamNetworkingConfigValue_t [?]"),
	SteamDatagramHostedAddress = var_0_4("SteamDatagramHostedAddress"),
	SteamDatagramHostedAddress_arr = var_0_4("SteamDatagramHostedAddress [?]"),
	SteamDatagramGameCoordinatorServerLogin = var_0_4("SteamDatagramGameCoordinatorServerLogin"),
	SteamDatagramGameCoordinatorServerLogin_arr = var_0_4("SteamDatagramGameCoordinatorServerLogin [?]"),
	SteamNetAuthenticationStatus_t = var_0_4("SteamNetAuthenticationStatus_t"),
	SteamNetAuthenticationStatus_t_arr = var_0_4("SteamNetAuthenticationStatus_t [?]"),
	SteamNetworkingFakeIPResult_t = var_0_4("SteamNetworkingFakeIPResult_t"),
	SteamNetworkingFakeIPResult_t_arr = var_0_4("SteamNetworkingFakeIPResult_t [?]"),
	SteamRelayNetworkStatus_t = var_0_4("SteamRelayNetworkStatus_t"),
	SteamRelayNetworkStatus_t_arr = var_0_4("SteamRelayNetworkStatus_t [?]"),
	SteamNetConnectionStatusChangedCallback_t = var_0_4("SteamNetConnectionStatusChangedCallback_t"),
	SteamNetConnectionStatusChangedCallback_t_arr = var_0_4("SteamNetConnectionStatusChangedCallback_t [?]"),
	SteamNetworkingMessagesSessionRequest_t = var_0_4("SteamNetworkingMessagesSessionRequest_t"),
	SteamNetworkingMessagesSessionRequest_t_arr = var_0_4("SteamNetworkingMessagesSessionRequest_t [?]"),
	SteamNetworkingMessagesSessionFailed_t = var_0_4("SteamNetworkingMessagesSessionFailed_t"),
	SteamNetworkingMessagesSessionFailed_t_arr = var_0_4("SteamNetworkingMessagesSessionFailed_t [?]")
}

for iter_0_9, iter_0_10 in var_0_22(var_0_103) do
	var_0_61[iter_0_9] = iter_0_10
end

local var_0_104 = {
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
local var_0_105 = var_0_2("uintptr_t**", var_0_52("client_panorama.dll", "\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC̃=\xCC\xCC\xCC\xCC\xCC\x0F\x84", "uintptr_t", 1, 1))
local var_0_106 = {}

for iter_0_11, iter_0_12 in var_0_23(var_0_104) do
	var_0_106[iter_0_12] = var_0_105[iter_0_11 - 1][0]
	var_0_106[iter_0_12:gsub("%d+$", "")] = var_0_105[iter_0_11 - 1][0]
end

local var_0_107 = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC̅\xC0t\v") or var_0_26("Couldn't find signature #1")
local var_0_108 = client.find_signature("engine.dll", "\xFF\x15\xCC\xCC\xCC̣\xCC\xCC\xCC\xCC\xEB\x05") or var_0_26("Couldn't find signature #2")
local var_0_109 = client.find_signature("engine.dll", "\xFF\xE1")
local var_0_110 = var_0_2("uint32_t**", var_0_2("uint32_t", var_0_108) + 2)[0][0]
local var_0_111 = var_0_2("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", var_0_109)
local var_0_112 = var_0_2("uint32_t**", var_0_2("uint32_t", var_0_107) + 2)[0][0]
local var_0_113 = var_0_2("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", var_0_109)

local function var_0_114(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = var_0_113(var_0_112, 0, arg_21_0)

	if var_21_0 == 0 then
		return
	end

	local var_21_1 = var_0_111(var_0_110, 0, var_21_0, arg_21_1)

	if var_21_1 == 0 then
		return
	end

	local var_21_2 = var_0_2(var_0_4(arg_21_2), var_0_109)

	return function(...)
		return var_21_2(var_21_1, 0, ...)
	end
end

local var_0_115 = 10
local var_0_116 = {}

function var_0_116.__call(arg_23_0, arg_23_1, arg_23_2)
	if var_0_27(arg_23_1) == "function" then
		arg_23_1, arg_23_2 = arg_23_2, arg_23_1
	end

	return var_0_21({
		var_0_20(arg_23_1) or var_0_115,
		arg_23_2
	}, var_0_116)
end

var_0_61.await = var_0_116.__call()

local function var_0_117(arg_24_0)
	local var_24_0 = var_0_27(arg_24_0)

	return var_24_0 == "function" or var_24_0 == "table" and getmetatable(arg_24_0) == var_0_116
end

local var_0_118 = {
	[101] = {},
	[102] = {
		fields = {
			"m_eResult",
			"m_bStillRetrying"
		},
		fields_alt = {
			"result",
			"still_retrying"
		},
		types = {
			"int",
			"bool"
		}
	},
	[103] = {
		fields = {
			"m_eResult"
		},
		fields_alt = {
			"result"
		},
		types = {
			"int"
		}
	},
	[113] = {
		fields = {
			"m_uAppID",
			"m_unGameServerIP",
			"m_usGameServerPort",
			"m_bSecure",
			"m_uReason"
		},
		fields_alt = {
			"appid",
			"game_server_ip",
			"game_server_port",
			"secure",
			"reason"
		},
		types = {
			"uint32_t",
			"uint32_t",
			"uint16_t",
			"uint16_t",
			"uint32_t"
		}
	},
	[115] = {
		fields = {
			"m_bSecure"
		},
		fields_alt = {
			"secure"
		},
		types = {
			"bool"
		}
	},
	[117] = {
		fields = {
			"m_eFailureType"
		},
		fields_alt = {
			"failure_type"
		},
		types = {
			"uint8_t"
		}
	},
	[125] = {},
	[143] = {
		fields = {
			"m_SteamID",
			"m_eAuthSessionResponse",
			"m_OwnerSteamID"
		},
		fields_alt = {
			"steamid",
			"auth_session_response",
			"owner_steamid"
		},
		types = {
			"SteamID",
			"int",
			"SteamID"
		}
	},
	[152] = {
		fields = {
			"m_unAppID",
			"m_ulOrderID",
			"m_bAuthorized"
		},
		fields_alt = {
			"appid",
			"order_id",
			"authorized"
		},
		types = {
			"uint32_t",
			"uint64_t",
			"bool"
		}
	},
	[163] = {
		fields = {
			"m_hAuthTicket",
			"m_eResult"
		},
		fields_alt = {
			"auth_ticket",
			"result"
		},
		types = {
			"unsigned int",
			"int"
		}
	},
	[164] = {
		fields = {
			"m_szURL"
		},
		fields_alt = {
			"url"
		},
		types = {
			"char [256]"
		}
	},
	[201] = {
		fields = {
			"m_SteamID",
			"m_OwnerSteamID"
		},
		fields_alt = {
			"steamid",
			"owner_steamid"
		},
		types = {
			"SteamID",
			"SteamID"
		}
	},
	[202] = {
		fields = {
			"m_SteamID",
			"m_eDenyReason",
			"m_rgchOptionalText"
		},
		fields_alt = {
			"steamid",
			"deny_reason",
			"optional_text"
		},
		types = {
			"SteamID",
			"int",
			"char [128]"
		}
	},
	[203] = {
		fields = {
			"m_SteamID",
			"m_eDenyReason"
		},
		fields_alt = {
			"steamid",
			"deny_reason"
		},
		types = {
			"SteamID",
			"int"
		}
	},
	[206] = {
		fields = {
			"m_SteamID",
			"m_pchAchievement",
			"m_bUnlocked"
		},
		fields_alt = {
			"steamid",
			"achievement",
			"unlocked"
		},
		types = {
			"SteamID",
			"char [128]",
			"bool"
		}
	},
	[207] = {
		fields = {
			"m_eResult",
			"m_nRank",
			"m_unTotalConnects",
			"m_unTotalMinutesPlayed"
		},
		fields_alt = {
			"result",
			"rank",
			"total_connects",
			"total_minutes_played"
		},
		types = {
			"int",
			"int32_t",
			"uint32_t",
			"uint32_t"
		}
	},
	[208] = {
		fields = {
			"m_SteamIDUser",
			"m_SteamIDGroup",
			"m_bMember",
			"m_bOfficer"
		},
		fields_alt = {
			"steamid_user",
			"steamid_group",
			"member",
			"officer"
		},
		types = {
			"SteamID",
			"SteamID",
			"bool",
			"bool"
		}
	},
	[304] = {
		fields = {
			"m_ulSteamID",
			"m_nChangeFlags"
		},
		fields_alt = {
			"steamid",
			"change_flags"
		},
		types = {
			"SteamID",
			"int"
		}
	},
	[331] = {
		fields = {
			"m_bActive"
		},
		fields_alt = {
			"active"
		},
		types = {
			"bool"
		}
	},
	[332] = {
		fields = {
			"m_rgchServer",
			"m_rgchPassword"
		},
		fields_alt = {
			"server",
			"password"
		},
		types = {
			"char [64]",
			"char [64]"
		}
	},
	[333] = {
		fields = {
			"m_steamIDLobby",
			"m_steamIDFriend"
		},
		fields_alt = {
			"steamid_lobby",
			"steamid_friend"
		},
		types = {
			"SteamID",
			"SteamID"
		}
	},
	[334] = {
		fields = {
			"m_steamID",
			"m_iImage",
			"m_iWide",
			"m_iTall"
		},
		fields_alt = {
			"steamid",
			"image",
			"wide",
			"tall"
		},
		types = {
			"SteamID",
			"int",
			"int",
			"int"
		}
	},
	[336] = {
		fields = {
			"m_steamIDFriend",
			"m_nAppID"
		},
		fields_alt = {
			"steamid_friend",
			"appid"
		},
		types = {
			"SteamID",
			"unsigned int"
		}
	},
	[337] = {
		fields = {
			"m_steamIDFriend",
			"m_rgchConnect"
		},
		fields_alt = {
			"steamid_friend",
			"connect"
		},
		types = {
			"SteamID",
			"char [256]"
		}
	},
	[338] = {
		fields = {
			"m_steamIDClanChat",
			"m_steamIDUser",
			"m_iMessageID"
		},
		fields_alt = {
			"steamid_clan_chat",
			"steamid_user",
			"message_id"
		},
		types = {
			"SteamID",
			"SteamID",
			"int"
		}
	},
	[339] = {
		fields = {
			"m_steamIDClanChat",
			"m_steamIDUser"
		},
		fields_alt = {
			"steamid_clan_chat",
			"steamid_user"
		},
		types = {
			"SteamID",
			"SteamID"
		}
	},
	[340] = {
		fields = {
			"m_steamIDClanChat",
			"m_steamIDUser",
			"m_bKicked",
			"m_bDropped"
		},
		fields_alt = {
			"steamid_clan_chat",
			"steamid_user",
			"kicked",
			"dropped"
		},
		types = {
			"SteamID",
			"SteamID",
			"bool",
			"bool"
		}
	},
	[343] = {
		fields = {
			"m_steamIDUser",
			"m_iMessageID"
		},
		fields_alt = {
			"steamid_user",
			"message_id"
		},
		types = {
			"SteamID",
			"int"
		}
	},
	[348] = {},
	[349] = {
		fields = {
			"rgchURI"
		},
		fields_alt = {
			"uri"
		},
		types = {
			"char [1024]"
		}
	},
	[350] = {
		fields = {
			"m_steamID"
		},
		fields_alt = {
			"steamid"
		},
		types = {
			"SteamID"
		}
	},
	[502] = {
		fields = {
			"m_nIP",
			"m_nQueryPort",
			"m_nConnPort",
			"m_nAppID",
			"m_nFlags",
			"m_bAdd",
			"m_unAccountId"
		},
		fields_alt = {
			"ip",
			"query_port",
			"conn_port",
			"appid",
			"flags",
			"add",
			"account_id"
		},
		types = {
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"bool",
			"unsigned int"
		}
	},
	[503] = {
		fields = {
			"m_ulSteamIDUser",
			"m_ulSteamIDLobby",
			"m_ulGameID"
		},
		fields_alt = {
			"steamid_user",
			"steamid_lobby",
			"game_id"
		},
		types = {
			"SteamID",
			"SteamID",
			"uint64_t"
		}
	},
	[505] = {
		fields = {
			"m_ulSteamIDLobby",
			"m_ulSteamIDMember",
			"m_bSuccess"
		},
		fields_alt = {
			"steamid_lobby",
			"steamid_member",
			"success"
		},
		types = {
			"SteamID",
			"SteamID",
			"bool"
		}
	},
	[506] = {
		fields = {
			"m_ulSteamIDLobby",
			"m_ulSteamIDUserChanged",
			"m_ulSteamIDMakingChange",
			"m_rgfChatMemberStateChange"
		},
		fields_alt = {
			"steamid_lobby",
			"steamid_user_changed",
			"steamid_making_change",
			"chat_member_state_change"
		},
		types = {
			"SteamID",
			"SteamID",
			"SteamID",
			"uint32_t"
		}
	},
	[507] = {
		fields = {
			"m_ulSteamIDLobby",
			"m_ulSteamIDUser",
			"m_eChatEntryType",
			"m_iChatID"
		},
		fields_alt = {
			"steamid_lobby",
			"steamid_user",
			"chat_entry_type",
			"chat_id"
		},
		types = {
			"SteamID",
			"SteamID",
			"uint8_t",
			"uint32_t"
		}
	},
	[509] = {
		fields = {
			"m_ulSteamIDLobby",
			"m_ulSteamIDGameServer",
			"m_unIP",
			"m_usPort"
		},
		fields_alt = {
			"steamid_lobby",
			"steamid_game_server",
			"ip",
			"port"
		},
		types = {
			"SteamID",
			"SteamID",
			"uint32_t",
			"uint16_t"
		}
	},
	[512] = {
		fields = {
			"m_ulSteamIDLobby",
			"m_ulSteamIDAdmin",
			"m_bKickedDueToDisconnect"
		},
		fields_alt = {
			"steamid_lobby",
			"steamid_admin",
			"kicked_due_to_disconnect"
		},
		types = {
			"SteamID",
			"SteamID",
			"bool"
		}
	},
	[515] = {
		fields = {
			"m_bGameBootInviteExists",
			"m_steamIDLobby"
		},
		fields_alt = {
			"game_boot_invite_exists",
			"steamid_lobby"
		},
		types = {
			"bool",
			"SteamID"
		}
	},
	[516] = {
		fields = {
			"m_eResult"
		},
		fields_alt = {
			"result"
		},
		types = {
			"int"
		}
	},
	[701] = {},
	[702] = {
		fields = {
			"m_nMinutesBatteryLeft"
		},
		fields_alt = {
			"minutes_battery_left"
		},
		types = {
			"uint8_t"
		}
	},
	[703] = {
		fields = {
			"m_hAsyncCall",
			"m_iCallback",
			"m_cubParam"
		},
		fields_alt = {
			"async_call",
			"callback",
			"param"
		},
		types = {
			"uint64_t",
			"int",
			"uint32_t"
		}
	},
	[704] = {},
	[714] = {
		fields = {
			"m_bSubmitted",
			"m_unSubmittedText"
		},
		fields_alt = {
			"submitted",
			"submitted_text"
		},
		types = {
			"bool",
			"uint32_t"
		}
	},
	[736] = {},
	[738] = {},
	[1005] = {
		fields = {
			"m_nAppID"
		},
		fields_alt = {
			"appid"
		},
		types = {
			"unsigned int"
		}
	},
	[1008] = {
		fields = {
			"m_eResult",
			"m_unPackageRegistered"
		},
		fields_alt = {
			"result",
			"package_registered"
		},
		types = {
			"int",
			"uint32_t"
		}
	},
	[1014] = {},
	[1021] = {
		fields = {
			"m_eResult",
			"m_nAppID",
			"m_cchKeyLength",
			"m_rgchKey"
		},
		fields_alt = {
			"result",
			"appid",
			"key_length",
			"key"
		},
		types = {
			"int",
			"uint32_t",
			"uint32_t",
			"char [240]"
		}
	},
	[1030] = {
		fields = {
			"m_unAppID",
			"m_bIsOffline",
			"m_unSecondsAllowed",
			"m_unSecondsPlayed"
		},
		fields_alt = {
			"appid",
			"is_offline",
			"seconds_allowed",
			"seconds_played"
		},
		types = {
			"unsigned int",
			"bool",
			"uint32_t",
			"uint32_t"
		}
	},
	[1101] = {
		fields = {
			"m_nGameID",
			"m_eResult",
			"m_steamIDUser"
		},
		fields_alt = {
			"game_id",
			"result",
			"steamid_user"
		},
		types = {
			"uint64_t",
			"int",
			"SteamID"
		}
	},
	[1102] = {
		fields = {
			"m_nGameID",
			"m_eResult"
		},
		fields_alt = {
			"game_id",
			"result"
		},
		types = {
			"uint64_t",
			"int"
		}
	},
	[1103] = {
		fields = {
			"m_nGameID",
			"m_bGroupAchievement",
			"m_rgchAchievementName",
			"m_nCurProgress",
			"m_nMaxProgress"
		},
		fields_alt = {
			"game_id",
			"group_achievement",
			"achievement_name",
			"cur_progress",
			"max_progress"
		},
		types = {
			"uint64_t",
			"bool",
			"char [128]",
			"uint32_t",
			"uint32_t"
		}
	},
	[1108] = {
		fields = {
			"m_steamIDUser"
		},
		fields_alt = {
			"steamid_user"
		},
		types = {
			"SteamID"
		}
	},
	[1109] = {
		fields = {
			"m_nGameID",
			"m_rgchAchievementName",
			"m_bAchieved",
			"m_nIconHandle"
		},
		fields_alt = {
			"game_id",
			"achievement_name",
			"achieved",
			"icon_handle"
		},
		types = {
			"uint64_t",
			"char [128]",
			"bool",
			"int"
		}
	},
	[1112] = {
		fields = {
			"m_nGameID",
			"m_eResult",
			"m_ulRequiredDiskSpace"
		},
		fields_alt = {
			"game_id",
			"result",
			"required_disk_space"
		},
		types = {
			"uint64_t",
			"int",
			"uint64_t"
		}
	},
	[1201] = {
		fields = {
			"m_hSocket",
			"m_hListenSocket",
			"m_steamIDRemote",
			"m_eSNetSocketState"
		},
		fields_alt = {
			"socket",
			"listen_socket",
			"steamid_remote",
			"snet_socket_state"
		},
		types = {
			"unsigned int",
			"unsigned int",
			"SteamID",
			"int"
		}
	},
	[1202] = {
		fields = {
			"m_steamIDRemote"
		},
		fields_alt = {
			"steamid_remote"
		},
		types = {
			"SteamID"
		}
	},
	[1203] = {
		fields = {
			"m_steamIDRemote",
			"m_eP2PSessionError"
		},
		fields_alt = {
			"steamid_remote",
			"p2p_session_error"
		},
		types = {
			"SteamID",
			"uint8_t"
		}
	},
	[1221] = {
		fields = {
			"m_hConn",
			"m_info",
			"m_eOldState"
		},
		fields_alt = {
			"conn",
			"info",
			"old_state"
		},
		types = {
			"unsigned int",
			"SteamNetConnectionInfo_t",
			"int"
		}
	},
	[1222] = {
		fields = {
			"m_eAvail",
			"m_debugMsg"
		},
		fields_alt = {
			"avail",
			"debug_msg"
		},
		types = {
			"int",
			"char [256]"
		}
	},
	[1223] = {
		fields = {
			"m_eResult",
			"m_identity",
			"m_unIP",
			"m_unPorts"
		},
		fields_alt = {
			"result",
			"identity",
			"ip",
			"ports"
		},
		types = {
			"int",
			"SteamNetworkingIdentity",
			"uint32_t",
			"uint16_t [8]"
		}
	},
	[1251] = {
		fields = {
			"m_identityRemote"
		},
		fields_alt = {
			"identity_remote"
		},
		types = {
			"SteamNetworkingIdentity"
		}
	},
	[1252] = {
		fields = {
			"m_info"
		},
		fields_alt = {
			"info"
		},
		types = {
			"SteamNetConnectionInfo_t"
		}
	},
	[1281] = {
		fields = {
			"m_eAvail",
			"m_bPingMeasurementInProgress",
			"m_eAvailNetworkConfig",
			"m_eAvailAnyRelay",
			"m_debugMsg"
		},
		fields_alt = {
			"avail",
			"ping_measurement_in_progress",
			"avail_network_config",
			"avail_any_relay",
			"debug_msg"
		},
		types = {
			"int",
			"int",
			"int",
			"int",
			"char [256]"
		}
	},
	[1309] = {
		fields = {
			"m_eResult",
			"m_nPublishedFileId",
			"m_bUserNeedsToAcceptWorkshopLegalAgreement"
		},
		fields_alt = {
			"result",
			"published_file_id",
			"user_needs_to_accept_workshop_legal_agreement"
		},
		types = {
			"int",
			"uint64_t",
			"bool"
		}
	},
	[1321] = {
		fields = {
			"m_nPublishedFileId",
			"m_nAppID"
		},
		fields_alt = {
			"published_file_id",
			"appid"
		},
		types = {
			"uint64_t",
			"unsigned int"
		}
	},
	[1322] = {
		fields = {
			"m_nPublishedFileId",
			"m_nAppID"
		},
		fields_alt = {
			"published_file_id",
			"appid"
		},
		types = {
			"uint64_t",
			"unsigned int"
		}
	},
	[1323] = {
		fields = {
			"m_nPublishedFileId",
			"m_nAppID"
		},
		fields_alt = {
			"published_file_id",
			"appid"
		},
		types = {
			"uint64_t",
			"unsigned int"
		}
	},
	[1325] = {
		fields = {
			"m_eResult",
			"m_nPublishedFileId",
			"m_eVote"
		},
		fields_alt = {
			"result",
			"published_file_id",
			"vote"
		},
		types = {
			"int",
			"uint64_t",
			"int"
		}
	},
	[1326] = {
		fields = {
			"m_eResult",
			"m_nResultsReturned",
			"m_nTotalResultCount",
			"m_rgPublishedFileId"
		},
		fields_alt = {
			"result",
			"results_returned",
			"total_result_count",
			"published_file_id"
		},
		types = {
			"int",
			"int32_t",
			"int32_t",
			"uint64_t [50]"
		}
	},
	[1330] = {
		fields = {
			"m_nPublishedFileId",
			"m_nAppID",
			"m_ulUnused"
		},
		fields_alt = {
			"published_file_id",
			"appid",
			"unused"
		},
		types = {
			"uint64_t",
			"unsigned int",
			"uint64_t"
		}
	},
	[1333] = {},
	[2101] = {
		fields = {
			"m_hRequest",
			"m_ulContextValue",
			"m_bRequestSuccessful",
			"m_eStatusCode",
			"m_unBodySize"
		},
		fields_alt = {
			"request",
			"context_value",
			"request_successful",
			"status_code",
			"body_size"
		},
		types = {
			"unsigned int",
			"uint64_t",
			"bool",
			"int",
			"uint32_t"
		}
	},
	[2102] = {
		fields = {
			"m_hRequest",
			"m_ulContextValue"
		},
		fields_alt = {
			"request",
			"context_value"
		},
		types = {
			"unsigned int",
			"uint64_t"
		}
	},
	[2103] = {
		fields = {
			"m_hRequest",
			"m_ulContextValue",
			"m_cOffset",
			"m_cBytesReceived"
		},
		fields_alt = {
			"request",
			"context_value",
			"offset",
			"bytes_received"
		},
		types = {
			"unsigned int",
			"uint64_t",
			"uint32_t",
			"uint32_t"
		}
	},
	[2301] = {
		fields = {
			"m_hLocal",
			"m_eResult"
		},
		fields_alt = {
			"local",
			"result"
		},
		types = {
			"unsigned int",
			"int"
		}
	},
	[2302] = {},
	[2801] = {
		fields = {
			"m_ulConnectedDeviceHandle"
		},
		fields_alt = {
			"connected_device_handle"
		},
		types = {
			"uint64_t"
		}
	},
	[2802] = {
		fields = {
			"m_ulDisconnectedDeviceHandle"
		},
		fields_alt = {
			"disconnected_device_handle"
		},
		types = {
			"uint64_t"
		}
	},
	[2803] = {
		fields = {
			"m_unAppID",
			"m_ulDeviceHandle",
			"m_ulMappingCreator",
			"m_unMajorRevision",
			"m_unMinorRevision",
			"m_bUsesSteamInputAPI",
			"m_bUsesGamepadAPI"
		},
		fields_alt = {
			"appid",
			"device_handle",
			"mapping_creator",
			"major_revision",
			"minor_revision",
			"uses_steam_input_api",
			"uses_gamepad_api"
		},
		types = {
			"unsigned int",
			"uint64_t",
			"SteamID",
			"uint32_t",
			"uint32_t",
			"bool",
			"bool"
		}
	},
	[3405] = {
		fields = {
			"m_unAppID",
			"m_nPublishedFileId"
		},
		fields_alt = {
			"appid",
			"published_file_id"
		},
		types = {
			"unsigned int",
			"uint64_t"
		}
	},
	[3406] = {
		fields = {
			"m_unAppID",
			"m_nPublishedFileId",
			"m_eResult"
		},
		fields_alt = {
			"appid",
			"published_file_id",
			"result"
		},
		types = {
			"unsigned int",
			"uint64_t",
			"int"
		}
	},
	[3418] = {
		fields = {
			"m_nAppID"
		},
		fields_alt = {
			"appid"
		},
		types = {
			"unsigned int"
		}
	},
	[3901] = {
		fields = {
			"m_nAppID",
			"m_iInstallFolderIndex"
		},
		fields_alt = {
			"appid",
			"install_folder_index"
		},
		types = {
			"unsigned int",
			"int"
		}
	},
	[3902] = {
		fields = {
			"m_nAppID",
			"m_iInstallFolderIndex"
		},
		fields_alt = {
			"appid",
			"install_folder_index"
		},
		types = {
			"unsigned int",
			"int"
		}
	},
	[4001] = {},
	[4002] = {
		fields = {
			"m_flNewVolume"
		},
		fields_alt = {
			"new_volume"
		},
		types = {
			"float"
		}
	},
	[4011] = {
		fields = {
			"m_flNewVolume"
		},
		fields_alt = {
			"new_volume"
		},
		types = {
			"float"
		}
	},
	[4012] = {
		fields = {
			"nID"
		},
		fields_alt = {
			"id"
		},
		types = {
			"int"
		}
	},
	[4013] = {
		fields = {
			"nID"
		},
		fields_alt = {
			"id"
		},
		types = {
			"int"
		}
	},
	[4101] = {},
	[4102] = {},
	[4103] = {},
	[4104] = {},
	[4105] = {},
	[4106] = {},
	[4107] = {},
	[4108] = {},
	[4109] = {
		fields = {
			"m_bShuffled"
		},
		fields_alt = {
			"shuffled"
		},
		types = {
			"bool"
		}
	},
	[4110] = {
		fields = {
			"m_bLooped"
		},
		fields_alt = {
			"looped"
		},
		types = {
			"bool"
		}
	},
	[4114] = {
		fields = {
			"m_nPlayingRepeatStatus"
		},
		fields_alt = {
			"playing_repeat_status"
		},
		types = {
			"int"
		}
	},
	[4502] = {
		fields = {
			"unBrowserHandle",
			"pBGRA",
			"unWide",
			"unTall",
			"unUpdateX",
			"unUpdateY",
			"unUpdateWide",
			"unUpdateTall",
			"unScrollX",
			"unScrollY",
			"flPageScale",
			"unPageSerial"
		},
		fields_alt = {
			"browser_handle",
			"bgra",
			"wide",
			"tall",
			"update_x",
			"update_y",
			"update_wide",
			"update_tall",
			"scroll_x",
			"scroll_y",
			"page_scale",
			"page_serial"
		},
		types = {
			"unsigned int",
			"const char *",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"float",
			"uint32_t"
		}
	},
	[4503] = {
		fields = {
			"unBrowserHandle",
			"pchURL",
			"pchTarget",
			"pchPostData",
			"bIsRedirect"
		},
		fields_alt = {
			"browser_handle",
			"url",
			"target",
			"post_data",
			"is_redirect"
		},
		types = {
			"unsigned int",
			"const char *",
			"const char *",
			"const char *",
			"bool"
		},
		string_fields = {
			"pchURL",
			"pchTarget",
			"pchPostData"
		}
	},
	[4504] = {
		fields = {
			"unBrowserHandle"
		},
		fields_alt = {
			"browser_handle"
		},
		types = {
			"unsigned int"
		}
	},
	[4505] = {
		fields = {
			"unBrowserHandle",
			"pchURL",
			"pchPostData",
			"bIsRedirect",
			"pchPageTitle",
			"bNewNavigation"
		},
		fields_alt = {
			"browser_handle",
			"url",
			"post_data",
			"is_redirect",
			"page_title",
			"new_navigation"
		},
		types = {
			"unsigned int",
			"const char *",
			"const char *",
			"bool",
			"const char *",
			"bool"
		},
		string_fields = {
			"pchURL",
			"pchPostData",
			"pchPageTitle"
		}
	},
	[4506] = {
		fields = {
			"unBrowserHandle",
			"pchURL",
			"pchPageTitle"
		},
		fields_alt = {
			"browser_handle",
			"url",
			"page_title"
		},
		types = {
			"unsigned int",
			"const char *",
			"const char *"
		},
		string_fields = {
			"pchURL",
			"pchPageTitle"
		}
	},
	[4507] = {
		fields = {
			"unBrowserHandle",
			"pchURL"
		},
		fields_alt = {
			"browser_handle",
			"url"
		},
		types = {
			"unsigned int",
			"const char *"
		},
		string_fields = {
			"pchURL"
		}
	},
	[4508] = {
		fields = {
			"unBrowserHandle",
			"pchTitle"
		},
		fields_alt = {
			"browser_handle",
			"title"
		},
		types = {
			"unsigned int",
			"const char *"
		},
		string_fields = {
			"pchTitle"
		}
	},
	[4509] = {
		fields = {
			"unBrowserHandle",
			"unResults",
			"unCurrentMatch"
		},
		fields_alt = {
			"browser_handle",
			"results",
			"current_match"
		},
		types = {
			"unsigned int",
			"uint32_t",
			"uint32_t"
		}
	},
	[4510] = {
		fields = {
			"unBrowserHandle",
			"bCanGoBack",
			"bCanGoForward"
		},
		fields_alt = {
			"browser_handle",
			"can_go_back",
			"can_go_forward"
		},
		types = {
			"unsigned int",
			"bool",
			"bool"
		}
	},
	[4511] = {
		fields = {
			"unBrowserHandle",
			"unScrollMax",
			"unScrollCurrent",
			"flPageScale",
			"bVisible",
			"unPageSize"
		},
		fields_alt = {
			"browser_handle",
			"scroll_max",
			"scroll_current",
			"page_scale",
			"visible",
			"page_size"
		},
		types = {
			"unsigned int",
			"uint32_t",
			"uint32_t",
			"float",
			"bool",
			"uint32_t"
		}
	},
	[4512] = {
		fields = {
			"unBrowserHandle",
			"unScrollMax",
			"unScrollCurrent",
			"flPageScale",
			"bVisible",
			"unPageSize"
		},
		fields_alt = {
			"browser_handle",
			"scroll_max",
			"scroll_current",
			"page_scale",
			"visible",
			"page_size"
		},
		types = {
			"unsigned int",
			"uint32_t",
			"uint32_t",
			"float",
			"bool",
			"uint32_t"
		}
	},
	[4513] = {
		fields = {
			"unBrowserHandle",
			"x",
			"y",
			"pchURL",
			"bInput",
			"bLiveLink"
		},
		fields_alt = {
			"browser_handle",
			"x",
			"y",
			"url",
			"input",
			"live_link"
		},
		types = {
			"unsigned int",
			"uint32_t",
			"uint32_t",
			"const char *",
			"bool",
			"bool"
		},
		string_fields = {
			"pchURL"
		}
	},
	[4514] = {
		fields = {
			"unBrowserHandle",
			"pchMessage"
		},
		fields_alt = {
			"browser_handle",
			"message"
		},
		types = {
			"unsigned int",
			"const char *"
		},
		string_fields = {
			"pchMessage"
		}
	},
	[4515] = {
		fields = {
			"unBrowserHandle",
			"pchMessage"
		},
		fields_alt = {
			"browser_handle",
			"message"
		},
		types = {
			"unsigned int",
			"const char *"
		},
		string_fields = {
			"pchMessage"
		}
	},
	[4516] = {
		fields = {
			"unBrowserHandle",
			"pchTitle",
			"pchInitialFile"
		},
		fields_alt = {
			"browser_handle",
			"title",
			"initial_file"
		},
		types = {
			"unsigned int",
			"const char *",
			"const char *"
		},
		string_fields = {
			"pchTitle",
			"pchInitialFile"
		}
	},
	[4521] = {
		fields = {
			"unBrowserHandle",
			"pchURL",
			"unX",
			"unY",
			"unWide",
			"unTall",
			"unNewWindow_BrowserHandle_IGNORE"
		},
		fields_alt = {
			"browser_handle",
			"url",
			"x",
			"y",
			"wide",
			"tall",
			"new_window_browser_handle"
		},
		types = {
			"unsigned int",
			"const char *",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"uint32_t",
			"unsigned int"
		},
		string_fields = {
			"pchURL"
		}
	},
	[4522] = {
		fields = {
			"unBrowserHandle",
			"eMouseCursor"
		},
		fields_alt = {
			"browser_handle",
			"mouse_cursor"
		},
		types = {
			"unsigned int",
			"uint32_t"
		}
	},
	[4523] = {
		fields = {
			"unBrowserHandle",
			"pchMsg"
		},
		fields_alt = {
			"browser_handle",
			"msg"
		},
		types = {
			"unsigned int",
			"const char *"
		},
		string_fields = {
			"pchMsg"
		}
	},
	[4524] = {
		fields = {
			"unBrowserHandle",
			"pchMsg"
		},
		fields_alt = {
			"browser_handle",
			"msg"
		},
		types = {
			"unsigned int",
			"const char *"
		},
		string_fields = {
			"pchMsg"
		}
	},
	[4525] = {
		fields = {
			"unBrowserHandle",
			"pchMsg"
		},
		fields_alt = {
			"browser_handle",
			"msg"
		},
		types = {
			"unsigned int",
			"const char *"
		},
		string_fields = {
			"pchMsg"
		}
	},
	[4526] = {
		fields = {
			"unBrowserHandle"
		},
		fields_alt = {
			"browser_handle"
		},
		types = {
			"unsigned int"
		}
	},
	[4527] = {
		fields = {
			"unBrowserHandle",
			"unOldBrowserHandle"
		},
		fields_alt = {
			"browser_handle",
			"old_browser_handle"
		},
		types = {
			"unsigned int",
			"unsigned int"
		}
	},
	[4611] = {
		fields = {
			"m_eResult",
			"m_unVideoAppID",
			"m_rgchURL"
		},
		fields_alt = {
			"result",
			"video_appid",
			"url"
		},
		types = {
			"int",
			"unsigned int",
			"char [256]"
		}
	},
	[4624] = {
		fields = {
			"m_eResult",
			"m_unVideoAppID"
		},
		fields_alt = {
			"result",
			"video_appid"
		},
		types = {
			"int",
			"unsigned int"
		}
	},
	[4700] = {
		fields = {
			"m_handle",
			"m_result"
		},
		fields_alt = {
			"handle",
			"result"
		},
		types = {
			"int",
			"int"
		}
	},
	[4701] = {
		fields = {
			"m_handle"
		},
		fields_alt = {
			"handle"
		},
		types = {
			"int"
		}
	},
	[4702] = {},
	[5001] = {},
	[5201] = {
		fields = {
			"m_ullSearchID",
			"m_eResult",
			"m_lobbyID",
			"m_steamIDEndedSearch",
			"m_nSecondsRemainingEstimate",
			"m_cPlayersSearching"
		},
		fields_alt = {
			"search_id",
			"result",
			"lobby_id",
			"steamid_ended_search",
			"seconds_remaining_estimate",
			"players_searching"
		},
		types = {
			"uint64_t",
			"int",
			"SteamID",
			"SteamID",
			"int32_t",
			"int32_t"
		}
	},
	[5202] = {
		fields = {
			"m_ullSearchID",
			"m_eResult",
			"m_nCountPlayersInGame",
			"m_nCountAcceptedGame",
			"m_steamIDHost",
			"m_bFinalCallback"
		},
		fields_alt = {
			"search_id",
			"result",
			"count_players_in_game",
			"count_accepted_game",
			"steamid_host",
			"final_callback"
		},
		types = {
			"uint64_t",
			"int",
			"int32_t",
			"int32_t",
			"SteamID",
			"bool"
		}
	},
	[5211] = {
		fields = {
			"m_eResult",
			"m_ullSearchID"
		},
		fields_alt = {
			"result",
			"search_id"
		},
		types = {
			"int",
			"uint64_t"
		}
	},
	[5212] = {
		fields = {
			"m_eResult",
			"m_ullSearchID",
			"m_SteamIDPlayerFound",
			"m_SteamIDLobby",
			"m_ePlayerAcceptState",
			"m_nPlayerIndex",
			"m_nTotalPlayersFound",
			"m_nTotalPlayersAcceptedGame",
			"m_nSuggestedTeamIndex",
			"m_ullUniqueGameID"
		},
		fields_alt = {
			"result",
			"search_id",
			"steamid_player_found",
			"steamid_lobby",
			"player_accept_state",
			"player_index",
			"total_players_found",
			"total_players_accepted_game",
			"suggested_team_index",
			"unique_game_id"
		},
		types = {
			"int",
			"uint64_t",
			"SteamID",
			"SteamID",
			"int",
			"int32_t",
			"int32_t",
			"int32_t",
			"int32_t",
			"uint64_t"
		}
	},
	[5213] = {
		fields = {
			"m_eResult",
			"m_ullSearchID",
			"m_ullUniqueGameID"
		},
		fields_alt = {
			"result",
			"search_id",
			"unique_game_id"
		},
		types = {
			"int",
			"uint64_t",
			"uint64_t"
		}
	},
	[5214] = {
		fields = {
			"m_eResult",
			"ullUniqueGameID",
			"steamIDPlayer"
		},
		fields_alt = {
			"result",
			"unique_game_id",
			"steamid_player"
		},
		types = {
			"int",
			"uint64_t",
			"SteamID"
		}
	},
	[5215] = {
		fields = {
			"m_eResult",
			"ullUniqueGameID"
		},
		fields_alt = {
			"result",
			"unique_game_id"
		},
		types = {
			"int",
			"uint64_t"
		}
	},
	[5303] = {
		fields = {
			"m_ulBeaconID",
			"m_steamIDJoiner"
		},
		fields_alt = {
			"beacon_id",
			"steamid_joiner"
		},
		types = {
			"uint64_t",
			"SteamID"
		}
	},
	[5305] = {},
	[5306] = {},
	[5701] = {
		fields = {
			"m_unSessionID"
		},
		fields_alt = {
			"session_id"
		},
		types = {
			"unsigned int"
		}
	},
	[5702] = {
		fields = {
			"m_unSessionID"
		},
		fields_alt = {
			"session_id"
		},
		types = {
			"unsigned int"
		}
	}
}
local var_0_119 = {
	musicplayerwillquit = 4104,
	musicplayerremotetofront = 4103,
	musicplayerremotewilldeactivate = 4102,
	musicplayerremotewillactivate = 4101,
	volumehaschanged = 4002,
	playbackstatushaschanged = 4001,
	screenshotrequested = 2302,
	screenshotready = 2301,
	socketstatuscallback = 1201,
	p2psessionconnectfail = 1203,
	p2psessionrequest = 1202,
	timedtrialstatus = 1030,
	appproofofpurchasekeyresponse = 1021,
	newurllaunchparameters = 1014,
	registeractivationcoderesponse = 1008,
	dlcinstalled = 1005,
	ps3trophiesinstalled = 1112,
	userachievementiconfetched = 1109,
	userstatsunloaded = 1108,
	userachievementstored = 1103,
	userstatsstored = 1102,
	userstatsreceived = 1101,
	remotestoragelocalfilechange = 1333,
	remotestoragepublishedfileupdated = 1330,
	remotestorageenumerateusersharedworkshopfilesresult = 1326,
	remotestorageuservotedetails = 1325,
	remotestoragepublishedfiledeleted = 1323,
	remotestoragepublishedfileunsubscribed = 1322,
	remotestoragepublishedfilesubscribed = 1321,
	remotestoragepublishfileresult = 1309,
	activebeaconsupdated = 5306,
	availablebeaconlocationsupdated = 5305,
	reservationnotificationcallback = 5303,
	endgameresultcallback = 5215,
	submitplayerresultresultcallback = 5214,
	requestplayersforgamefinalresultcallback = 5213,
	requestplayersforgameresultcallback = 5212,
	requestplayersforgameprogresscallback = 5211,
	searchforgameresultcallback = 5202,
	searchforgameprogresscallback = 5201,
	favoriteslistaccountsupdated = 516,
	psngamebootinviteresult = 515,
	lobbykicked = 512,
	lobbygamecreated = 509,
	lobbychatmsg = 507,
	lobbychatupdate = 506,
	lobbydataupdate = 505,
	lobbyinvite = 503,
	favoriteslistchanged = 502,
	floatinggamepadtextinputdismissed = 738,
	appresumingfromsuspend = 736,
	gamepadtextinputdismissed = 714,
	steamshutdown = 704,
	steamapicallcompleted = 703,
	lowbatterypower = 702,
	ipcountry = 701,
	equippedprofileitemschanged = 350,
	overlaybrowserprotocolnavigation = 349,
	unreadchatmessageschanged = 348,
	gameconnectedfriendchatmsg = 343,
	gameconnectedchatleave = 340,
	gameconnectedchatjoin = 339,
	gameconnectedclanchatmsg = 338,
	gamerichpresencejoinrequested = 337,
	friendrichpresenceupdate = 336,
	avatarimageloaded = 334,
	gamelobbyjoinrequested = 333,
	gameserverchangerequested = 332,
	gameoverlayactivated = 331,
	personastatechange = 304,
	gamewebcallback = 164,
	getauthsessionticketresponse = 163,
	microtxnauthorizationresponse = 152,
	validateauthticketresponse = 143,
	licensesupdated = 125,
	ipcfailure = 117,
	clientgameserverdeny = 113,
	steamserversdisconnected = 103,
	steamserverconnectfailure = 102,
	steamserversconnected = 101,
	steamnetworkingfakeipresult = 1223,
	gsstatsunloaded = 1108,
	gsclientgroupstatus = 208,
	gsgameplaystats = 207,
	gspolicyresponse = 115,
	gsclientachievementstatus = 206,
	gsclientkick = 203,
	gsclientdeny = 202,
	gsclientapprove = 201,
	steamrelaynetworkstatus = 1281,
	steamnetauthenticationstatus = 1222,
	steamnetconnectionstatuschangedcallback = 1221,
	steamnetworkingmessagessessionfailed = 1252,
	steamnetworkingmessagessessionrequest = 1251,
	steamremoteplaysessiondisconnected = 5702,
	steamremoteplaysessionconnected = 5701,
	steamparentalsettingschanged = 5001,
	getopfsettingsresult = 4624,
	getvideourlresult = 4611,
	steaminventorydefinitionupdate = 4702,
	steaminventoryfullupdate = 4701,
	steaminventoryresultready = 4700,
	html_browserrestarted = 4527,
	html_hidetooltip = 4526,
	html_updatetooltip = 4525,
	html_showtooltip = 4524,
	html_statustext = 4523,
	html_setcursor = 4522,
	html_newwindow = 4521,
	html_fileopendialog = 4516,
	html_jsconfirm = 4515,
	html_jsalert = 4514,
	html_linkatposition = 4513,
	html_verticalscroll = 4512,
	html_horizontalscroll = 4511,
	html_cangobackandforward = 4510,
	html_searchresults = 4509,
	html_changedtitle = 4508,
	html_openlinkinnewtab = 4507,
	html_finishedrequest = 4506,
	html_urlchanged = 4505,
	html_closebrowser = 4504,
	html_startrequest = 4503,
	html_needspaint = 4502,
	steamappuninstalled = 3902,
	steamappinstalled = 3901,
	usersubscribeditemslistchanged = 3418,
	downloaditemresult = 3406,
	iteminstalled = 3405,
	steaminputconfigurationloaded = 2803,
	steaminputdevicedisconnected = 2802,
	steaminputdeviceconnected = 2801,
	httprequestdatareceived = 2103,
	httprequestheadersreceived = 2102,
	httprequestcompleted = 2101,
	musicplayerwantsplayingrepeatstatus = 4114,
	musicplayerselectsplaylistentry = 4013,
	musicplayerselectsqueueentry = 4012,
	musicplayerwantsvolume = 4011,
	musicplayerwantslooped = 4110,
	musicplayerwantsshuffled = 4109,
	musicplayerwantsplaynext = 4108,
	musicplayerwantsplayprevious = 4107,
	musicplayerwantspause = 4106,
	musicplayerwantsplay = 4105
}

if not var_0_24(var_0_5, "SteamAPICall_t") then
	var_0_3("\t\ttypedef uint64_t SteamAPICall_t;\n\n\t\tstruct SteamAPI_callback_base_vtbl {\n\t\t\tvoid(__thiscall *run1)(struct SteamAPI_callback_base *, void *, bool, uint64_t);\n\t\t\tvoid(__thiscall *run2)(struct SteamAPI_callback_base *, void *);\n\t\t\tint(__thiscall *get_size)(struct SteamAPI_callback_base *);\n\t\t};\n\n\t\tstruct SteamAPI_callback_base {\n\t\t\tstruct SteamAPI_callback_base_vtbl *vtbl;\n\t\t\tuint8_t flags;\n\t\t\tint id;\n\t\t\tuint64_t api_call_handle;\n\t\t\tstruct SteamAPI_callback_base_vtbl vtbl_storage[1];\n\t\t};\n\t")
end

local var_0_120 = var_0_64.ESteamAPICallFailure
local var_0_121
local var_0_122
local var_0_123
local var_0_124
local var_0_125 = var_0_106.ISteamUtils
local var_0_126 = var_0_53(var_0_125, 12, "int(__thiscall*)(void*, SteamAPICall_t)")
local var_0_127 = var_0_53(var_0_125, 11, "bool(__thiscall*)(void*, SteamAPICall_t, bool*)")

local function var_0_128(arg_25_0)
	return var_0_126(var_0_125, arg_25_0)
end

local var_0_129 = var_0_50(1)

local function var_0_130(arg_26_0)
	return var_0_127(var_0_125, arg_26_0, var_0_129), var_0_129[0]
end

local var_0_131 = var_0_4("struct SteamAPI_callback_base")
local var_0_132 = var_0_5(var_0_131)
local var_0_133 = var_0_4("struct SteamAPI_callback_base[1]")
local var_0_134 = var_0_4("struct SteamAPI_callback_base*")
local var_0_135 = {}
local var_0_136 = {}
local var_0_137 = {}
local var_0_138 = {}
local var_0_139 = var_0_58("[steamworks] callback failed: ")

local function var_0_140(arg_27_0, arg_27_1, arg_27_2)
	arg_27_2 = arg_27_2 and (var_0_120[var_0_128(arg_27_0.api_call_handle)] or true)
	arg_27_0.api_call_handle = 0

	local var_27_0 = var_0_54(arg_27_0)
	local var_27_1 = var_0_135[var_27_0]

	if var_27_1 ~= nil then
		local var_27_2 = var_0_136[var_27_0]

		if var_27_2 ~= nil then
			if arg_27_1 ~= nil then
				arg_27_1 = var_0_2(var_27_2.struct, arg_27_1)
			end

			local var_27_3 = var_0_57(arg_27_1, var_27_2.keys, var_27_2.string_keys_lookup)

			if arg_27_2 ~= false then
				var_27_3.io_failure = arg_27_2
			end

			var_0_25(var_27_1, var_0_28, var_27_3)
		else
			var_0_25(var_27_1, var_0_28, arg_27_1, arg_27_2)
		end
	end

	if var_0_137[var_27_0] ~= nil then
		var_0_135[var_27_0] = nil
		var_0_136[var_27_0] = nil
		var_0_137[var_27_0] = nil
	end
end

local function var_0_141(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if arg_28_3 == arg_28_0.api_call_handle then
		var_0_25(var_0_140, var_0_139, arg_28_0, arg_28_1, arg_28_2)
	end
end

local function var_0_142(arg_29_0, arg_29_1)
	var_0_25(var_0_140, var_0_139, arg_29_0, arg_29_1, false)
end

local function var_0_143()
	return var_0_132
end

local function var_0_144(arg_31_0)
	if arg_31_0.api_call_handle ~= 0 then
		var_0_122(arg_31_0, arg_31_0.api_call_handle)

		arg_31_0.api_call_handle = 0

		local var_31_0 = var_0_54(arg_31_0)

		var_0_135[var_31_0] = nil
		var_0_136[var_31_0] = nil
		var_0_137[var_31_0] = nil
	end
end

var_0_24(var_0_0.metatype, var_0_131, {
	__gc = var_0_144,
	__index = {
		cancel = var_0_144
	}
})

local var_0_145 = var_0_2("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", var_0_141)
local var_0_146 = var_0_2("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", var_0_142)
local var_0_147 = var_0_2("int(__thiscall *)(struct SteamAPI_callback_base *)", var_0_143)
local var_0_148 = var_0_52("steam_api.dll", "U\x8B\xEC\x83=\xCC\xCC\xCC\xCC\xCC~\rh\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC]\xC3\xFFu\x10", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")

var_0_122 = var_0_52("steam_api.dll", "U\x8B\xEC\xFFu\x10\xFFu\f", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")

local var_0_149 = var_0_52("steam_api.dll", "U\x8B\xEC\x83=\xCC\xCC\xCC\xCC\xCC~\rh\xCC\xCC\xCC\xCC\xFF\x15\xCC\xCC\xCC\xCC]\xC3\xC7\x05", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
local var_0_150 = var_0_52("steam_api.dll", "U\x8B\xEC\x83\xEC\f\x80=\xCC\xCC\xCC\xCC\xCC\x0F\x84", "void(__cdecl*)(struct SteamAPI_callback_base *)")
local var_0_151 = var_0_52("steam_api.dll", "2Ƀ=\xCC\xCC\xCC\xCC\xCC", "void(__cdecl*)(void)")

local function var_0_152(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	var_0_18(arg_32_0 ~= 0)

	local var_32_0 = var_0_133()
	local var_32_1 = var_0_2(var_0_134, var_32_0)

	var_32_1.vtbl_storage[0].run1 = var_0_145
	var_32_1.vtbl_storage[0].run2 = var_0_146
	var_32_1.vtbl_storage[0].get_size = var_0_147
	var_32_1.vtbl = var_32_1.vtbl_storage
	var_32_1.api_call_handle = arg_32_0
	var_32_1.id = arg_32_2

	local var_32_2 = arg_32_0
	local var_32_3 = false
	local var_32_4 = var_0_27(arg_32_1) == "table" and getmetatable(arg_32_1) == var_0_116 and arg_32_1 or nil

	if var_32_4 then
		jit.off(true, true)

		var_32_2 = nil

		local var_32_5 = var_0_27(var_32_4[2]) == "function" and var_32_4[2] or nil

		function arg_32_1(arg_33_0)
			if var_32_3 and var_32_5 ~= nil then
				var_0_25(var_32_5, var_0_28, arg_33_0)
			end

			var_32_2 = arg_33_0
		end
	end

	local var_32_6 = var_0_54(var_32_1)

	var_0_135[var_32_6] = arg_32_1
	var_0_136[var_32_6] = arg_32_3
	var_0_137[var_32_6] = var_32_0

	var_0_148(var_32_1, arg_32_0)

	if var_32_4 then
		local var_32_7 = var_0_30() + var_0_34(999, var_0_35(0, var_0_20(var_32_4[1]) or var_0_115))

		while true do
			if var_32_2 ~= nil or var_32_7 < var_0_30() then
				break
			end

			var_0_151()
		end

		var_32_3 = true
	end

	return var_32_2
end

local var_0_153 = {}

local function var_0_154(arg_34_0, arg_34_1)
	local var_34_0 = var_0_118[arg_34_0]
	local var_34_1 = {}
	local var_34_2 = var_34_0.fields or {}
	local var_34_3 = var_34_0.fields_alt or {}
	local var_34_4 = {}

	for iter_34_0, iter_34_1 in var_0_23(var_34_0.string_fields or {}) do
		var_34_1[iter_34_1] = true
	end

	local var_34_5 = "struct {"

	for iter_34_2, iter_34_3 in var_0_23(var_34_2) do
		local var_34_6, var_34_7 = var_0_12(var_34_0.types[iter_34_2], "^(.*)(%[.*%])$")

		if var_34_6 ~= nil then
			var_34_5 = var_34_5 .. var_34_6 .. " " .. iter_34_3 .. var_34_7 .. "; "
		else
			var_34_5 = var_34_5 .. var_34_0.types[iter_34_2] .. " " .. iter_34_3 .. "; "
		end

		var_34_4[iter_34_3] = var_34_3[iter_34_2] or true
	end

	local var_34_8 = var_34_5 .. "} *"
	local var_34_9 = var_0_4(var_34_8)

	return function(arg_35_0, arg_35_1)
		if arg_35_0 ~= nil then
			arg_35_0 = var_0_2(var_34_9, arg_35_0)
		end

		local var_35_0 = var_0_57(arg_35_0, var_34_4, var_34_1)

		if arg_35_1 ~= false then
			var_35_0.io_failure = arg_35_1
		end

		for iter_35_0, iter_35_1 in var_0_23(arg_34_1) do
			var_0_25(iter_35_1, var_0_28, var_35_0)
		end
	end
end

local function var_0_155(arg_36_0, arg_36_1)
	if var_0_27(arg_36_0) == "string" and var_0_119[var_0_14(var_0_11(arg_36_0, "_t$", ""))] ~= nil then
		arg_36_0 = var_0_119[var_0_14(var_0_11(arg_36_0, "_t$", ""))]
	end

	if var_0_118[arg_36_0] == nil then
		return var_0_26("Invalid Steam callback")
	end

	if var_0_153[arg_36_0] == nil then
		var_0_18(var_0_138[arg_36_0] == nil)

		var_0_153[arg_36_0] = {}

		local var_36_0 = var_0_133()
		local var_36_1 = var_0_2(var_0_134, var_36_0)

		var_36_1.vtbl_storage[0].run1 = var_0_145
		var_36_1.vtbl_storage[0].run2 = var_0_146
		var_36_1.vtbl_storage[0].get_size = var_0_147
		var_36_1.vtbl = var_36_1.vtbl_storage
		var_36_1.api_call_handle = 0
		var_36_1.id = arg_36_0

		local var_36_2 = var_0_54(var_36_1)

		var_0_135[var_36_2] = var_0_154(arg_36_0, var_0_153[arg_36_0])
		var_0_138[arg_36_0] = var_36_0

		var_0_149(var_36_1, arg_36_0)
	else
		for iter_36_0, iter_36_1 in var_0_23(var_0_153[arg_36_0]) do
			if iter_36_1 == arg_36_1 then
				return false
			end
		end
	end

	var_0_31(var_0_153[arg_36_0], arg_36_1)

	return true
end

var_0_61.set_callback = var_0_155

local function var_0_156(arg_37_0, arg_37_1)
	if var_0_27(arg_37_0) == "string" and var_0_119[var_0_14(var_0_11(arg_37_0, "_t$", ""))] ~= nil then
		arg_37_0 = var_0_119[var_0_14(var_0_11(arg_37_0, "_t$", ""))]
	end

	if var_0_118[arg_37_0] == nil then
		return var_0_26("Invalid Steam callback")
	end

	if var_0_153[arg_37_0] == nil then
		return false
	end

	for iter_37_0, iter_37_1 in var_0_23(var_0_153[arg_37_0]) do
		if iter_37_1 == arg_37_1 then
			var_0_32(var_0_153[arg_37_0], iter_37_0)

			break
		end
	end

	if #var_0_153[arg_37_0] == 0 then
		local var_37_0 = var_0_138[arg_37_0]
		local var_37_1 = var_0_2(var_0_134, var_37_0)

		var_0_150(var_37_1)

		var_0_153[arg_37_0] = nil
		var_0_138[arg_37_0] = nil

		local var_37_2 = var_0_54(var_37_1)

		var_0_135[var_37_2] = nil
	end

	return true
end

var_0_61.unset_callback = var_0_156

function var_0_61.await_callback(arg_38_0, arg_38_1, arg_38_2)
	if var_0_27(arg_38_0) == "string" and var_0_119[var_0_14(var_0_11(arg_38_0, "_t$", ""))] ~= nil then
		arg_38_0 = var_0_119[var_0_14(var_0_11(arg_38_0, "_t$", ""))]
	end

	if var_0_118[arg_38_0] == nil then
		return var_0_26("Invalid Steam callback")
	end

	local var_38_0 = false

	if arg_38_2 ~= nil then
		var_38_0 = var_0_155(arg_38_0, arg_38_2)
	end

	if var_38_0 then
		var_0_156(arg_38_0, arg_38_2)
	end
end

local function var_0_157(arg_39_0)
	return function(arg_40_0, ...)
		local var_40_0 = arg_39_0[var_0_54(arg_40_0)]

		if var_40_0 ~= nil then
			var_0_25(var_40_0, var_0_28, arg_40_0, ...)
		end
	end
end

local function var_0_158(arg_41_0, arg_41_1)
	return var_0_67(arg_41_0) or var_0_26(arg_41_1, 3)
end

local function var_0_159(arg_42_0, arg_42_1)
	local var_42_0 = var_0_27(arg_42_0)

	if var_42_0 == "number" or var_42_0 == "string" then
		local var_42_1 = arg_42_1[arg_42_0]

		if var_42_1 ~= nil then
			return var_42_0 == "string" and var_42_1 or arg_42_0
		end
	end
end

local function var_0_160(arg_43_0, arg_43_1, arg_43_2)
	return var_0_159(arg_43_0, arg_43_1) or var_0_26(arg_43_2, 3)
end

local function var_0_161(arg_44_0)
	local var_44_0 = var_0_46(1, arg_44_0)
	local var_44_1 = var_0_2(var_0_49, var_44_0)

	return var_0_16("%d.%d.%d.%d", var_44_1[3], var_44_1[2], var_44_1[1], var_44_1[0])
end

local function var_0_162(arg_45_0)
	local var_45_0, var_45_1, var_45_2, var_45_3 = var_0_12(arg_45_0, "^(%d+)%.(%d+)%.(%d+)%.(%d+)$")

	if var_45_0 ~= nil then
		local var_45_4 = var_0_48(4, var_0_20(var_45_3), var_0_20(var_45_2), var_0_20(var_45_1), var_0_20(var_45_0))

		return var_0_2(var_0_47, var_45_4)[0]
	end
end

local function var_0_163(arg_46_0, arg_46_1)
	local var_46_0 = var_0_27(arg_46_0)

	if var_46_0 == "number" then
		return arg_46_0
	elseif var_46_0 == "string" then
		return var_0_162(arg_46_0) or var_0_26(arg_46_1, 3)
	end

	var_0_26(arg_46_1, 3)
end

var_0_61.SteamID = var_0_67
var_0_61.CSteamID = var_0_67
var_0_61.ipv4_parse = var_0_162
var_0_61.ipv4_tostring = var_0_161

local var_0_164 = var_0_4("FriendGameInfo_t [1]")
local var_0_165 = var_0_4("SteamID [1]")
local var_0_166 = var_0_4("bool [1]")
local var_0_167 = var_0_4("double [1]")
local var_0_168 = var_0_4("float [1]")
local var_0_169 = var_0_4("int32_t [1]")
local var_0_170 = var_0_4("int64_t [1]")
local var_0_171 = var_0_4("int [1]")
local var_0_172 = var_0_4("uint16_t [1]")
local var_0_173 = var_0_4("uint32_t [1]")
local var_0_174 = var_0_4("uint64_t [1]")
local var_0_175 = var_0_4("unsigned int [1]")
local var_0_176 = var_0_2("char*", var_0_29("client.dll", "\xFF\x15\xCC\xCC\xCC̋\xD8\xFF\x15") or var_0_26("Invalid SteamAPI_GetHSteamUser signature"))
local var_0_177 = var_0_2("int(__cdecl***)()", var_0_176 + 2)[0][0]
local var_0_178 = var_0_2("int(__cdecl***)()", var_0_176 + 10)[0][0]()
local var_0_179 = var_0_177()
local var_0_180 = {
	version = "SteamUser021",
	version_number = 21
}

function var_0_62.ISteamUser()
	local var_47_0 = vtable_bind("steamclient.dll", "SteamClient020", 5, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "SteamUser021")

	var_0_180.thisptr = var_47_0

	local var_47_1 = var_0_53(var_47_0, 0, "int(__thiscall*)(void*)")

	function var_0_180.GetHSteamUser()
		return var_47_1(var_47_0)
	end

	var_0_180.get_hsteamuser = var_0_180.GetHSteamUser

	local var_47_2 = var_0_53(var_47_0, 1, "bool(__thiscall*)(void*)")

	function var_0_180.BLoggedOn()
		return var_47_2(var_47_0)
	end

	var_0_180.logged_on = var_0_180.BLoggedOn

	local var_47_3 = var_0_53(var_47_0, 2, "void(__thiscall*)(void*, SteamID *)")

	function var_0_180.GetSteamID()
		local var_50_0 = var_0_165()

		var_47_3(var_47_0, var_50_0)

		return var_0_60(var_50_0)
	end

	var_0_180.get_steamid = var_0_180.GetSteamID

	local var_47_4 = var_0_53(var_47_0, 3, "int(__thiscall*)(void*, void *, int, SteamID, uint32_t, uint16_t, bool)")

	function var_0_180.InitiateGameConnection_DEPRECATED(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
		arg_51_2 = var_0_158(arg_51_2, "steamid_game_server is required")
		arg_51_3 = var_0_163(arg_51_3, "ip_server is required")

		return var_47_4(var_47_0, arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5)
	end

	var_0_180.initiate_game_connection_deprecated = var_0_180.InitiateGameConnection_DEPRECATED

	local var_47_5 = var_0_53(var_47_0, 4, "void(__thiscall*)(void*, uint32_t, uint16_t)")

	function var_0_180.TerminateGameConnection_DEPRECATED(arg_52_0, arg_52_1)
		arg_52_0 = var_0_163(arg_52_0, "ip_server is required")

		return var_47_5(var_47_0, arg_52_0, arg_52_1)
	end

	var_0_180.terminate_game_connection_deprecated = var_0_180.TerminateGameConnection_DEPRECATED

	local var_47_6 = var_0_53(var_47_0, 5, "void(__thiscall*)(void*, uint64_t, int, const char *)")

	function var_0_180.TrackAppUsageEvent(arg_53_0, arg_53_1, arg_53_2)
		return var_47_6(var_47_0, arg_53_0, arg_53_1, arg_53_2)
	end

	var_0_180.track_app_usage_event = var_0_180.TrackAppUsageEvent

	local var_47_7 = var_0_53(var_47_0, 6, "bool(__thiscall*)(void*, char *, int)")

	function var_0_180.GetUserDataFolder(arg_54_0, arg_54_1)
		return var_47_7(var_47_0, arg_54_0, arg_54_1)
	end

	var_0_180.get_user_data_folder = var_0_180.GetUserDataFolder

	local var_47_8 = var_0_53(var_47_0, 7, "void(__thiscall*)(void*)")

	function var_0_180.StartVoiceRecording()
		return var_47_8(var_47_0)
	end

	var_0_180.start_voice_recording = var_0_180.StartVoiceRecording

	local var_47_9 = var_0_53(var_47_0, 8, "void(__thiscall*)(void*)")

	function var_0_180.StopVoiceRecording()
		return var_47_9(var_47_0)
	end

	var_0_180.stop_voice_recording = var_0_180.StopVoiceRecording

	local var_47_10 = var_0_53(var_47_0, 9, "int(__thiscall*)(void*, uint32_t *, uint32_t *, uint32_t)")

	function var_0_180.GetAvailableVoice(arg_57_0, arg_57_1)
		local var_57_0 = var_0_173()

		return var_47_10(var_47_0, var_57_0, arg_57_0, arg_57_1), var_0_60(var_57_0)
	end

	var_0_180.get_available_voice = var_0_180.GetAvailableVoice

	local var_47_11 = var_0_53(var_47_0, 10, "int(__thiscall*)(void*, bool, void *, uint32_t, uint32_t *, bool, void *, uint32_t, uint32_t *, uint32_t)")

	function var_0_180.GetVoice(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5, arg_58_6, arg_58_7)
		local var_58_0 = var_0_173()

		return var_47_11(var_47_0, arg_58_0, arg_58_1, arg_58_2, var_58_0, arg_58_3, arg_58_4, arg_58_5, arg_58_6, arg_58_7), var_0_60(var_58_0)
	end

	var_0_180.get_voice = var_0_180.GetVoice

	local var_47_12 = var_0_53(var_47_0, 11, "int(__thiscall*)(void*, const void *, uint32_t, void *, uint32_t, uint32_t *, uint32_t)")

	function var_0_180.DecompressVoice(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
		local var_59_0 = var_0_173()

		return var_47_12(var_47_0, arg_59_0, arg_59_1, arg_59_2, arg_59_3, var_59_0, arg_59_4), var_0_60(var_59_0)
	end

	var_0_180.decompress_voice = var_0_180.DecompressVoice

	local var_47_13 = var_0_53(var_47_0, 12, "uint32_t(__thiscall*)(void*)")

	function var_0_180.GetVoiceOptimalSampleRate()
		return var_47_13(var_47_0)
	end

	var_0_180.get_voice_optimal_sample_rate = var_0_180.GetVoiceOptimalSampleRate

	local var_47_14 = var_0_53(var_47_0, 13, "unsigned int(__thiscall*)(void*, void *, int, uint32_t *)")

	function var_0_180.GetAuthSessionTicket(arg_61_0, arg_61_1)
		local var_61_0 = var_0_173()

		return var_47_14(var_47_0, arg_61_0, arg_61_1, var_61_0), var_0_60(var_61_0)
	end

	var_0_180.get_auth_session_ticket = var_0_180.GetAuthSessionTicket

	local var_47_15 = var_0_53(var_47_0, 14, "int(__thiscall*)(void*, const void *, int, SteamID)")

	function var_0_180.BeginAuthSession(arg_62_0, arg_62_1, arg_62_2)
		arg_62_2 = var_0_158(arg_62_2, "steamid is required")

		return var_47_15(var_47_0, arg_62_0, arg_62_1, arg_62_2)
	end

	var_0_180.begin_auth_session = var_0_180.BeginAuthSession

	local var_47_16 = var_0_53(var_47_0, 15, "void(__thiscall*)(void*, SteamID)")

	function var_0_180.EndAuthSession(arg_63_0)
		arg_63_0 = var_0_158(arg_63_0, "steamid is required")

		return var_47_16(var_47_0, arg_63_0)
	end

	var_0_180.end_auth_session = var_0_180.EndAuthSession

	local var_47_17 = var_0_53(var_47_0, 16, "void(__thiscall*)(void*, unsigned int)")

	function var_0_180.CancelAuthTicket(arg_64_0)
		return var_47_17(var_47_0, arg_64_0)
	end

	var_0_180.cancel_auth_ticket = var_0_180.CancelAuthTicket

	local var_47_18 = var_0_53(var_47_0, 17, "int(__thiscall*)(void*, SteamID, unsigned int)")

	function var_0_180.UserHasLicenseForApp(arg_65_0, arg_65_1)
		arg_65_0 = var_0_158(arg_65_0, "steamid is required")

		return var_47_18(var_47_0, arg_65_0, arg_65_1)
	end

	var_0_180.user_has_license_for_app = var_0_180.UserHasLicenseForApp

	local var_47_19 = var_0_53(var_47_0, 18, "bool(__thiscall*)(void*)")

	function var_0_180.BIsBehindNAT()
		return var_47_19(var_47_0)
	end

	var_0_180.is_behind_nat = var_0_180.BIsBehindNAT

	local var_47_20 = var_0_53(var_47_0, 19, "void(__thiscall*)(void*, SteamID, uint32_t, uint16_t)")

	function var_0_180.AdvertiseGame(arg_67_0, arg_67_1, arg_67_2)
		arg_67_0 = var_0_158(arg_67_0, "steamid_game_server is required")
		arg_67_1 = var_0_163(arg_67_1, "ip_server is required")

		return var_47_20(var_47_0, arg_67_0, arg_67_1, arg_67_2)
	end

	var_0_180.advertise_game = var_0_180.AdvertiseGame

	local var_47_21 = var_0_53(var_47_0, 20, "uint64_t(__thiscall*)(void*, void *, int)")
	local var_47_22 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result"
		}
	}

	function var_0_180.RequestEncryptedAppTicket(arg_68_0, arg_68_1, arg_68_2)
		if arg_68_2 ~= nil and not var_0_117(arg_68_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_68_0 = var_47_21(var_47_0, arg_68_0, arg_68_1)

		if arg_68_2 ~= nil then
			var_68_0 = var_0_152(var_68_0, arg_68_2, 154, var_47_22)
		end

		return var_68_0
	end

	var_0_180.request_encrypted_app_ticket = var_0_180.RequestEncryptedAppTicket

	local var_47_23 = var_0_53(var_47_0, 21, "bool(__thiscall*)(void*, void *, int, uint32_t *)")

	function var_0_180.GetEncryptedAppTicket(arg_69_0, arg_69_1)
		local var_69_0 = var_0_173()

		return var_47_23(var_47_0, arg_69_0, arg_69_1, var_69_0), var_0_60(var_69_0)
	end

	var_0_180.get_encrypted_app_ticket = var_0_180.GetEncryptedAppTicket

	local var_47_24 = var_0_53(var_47_0, 22, "int(__thiscall*)(void*, int, bool)")

	function var_0_180.GetGameBadgeLevel(arg_70_0, arg_70_1)
		return var_47_24(var_47_0, arg_70_0, arg_70_1)
	end

	var_0_180.get_game_badge_level = var_0_180.GetGameBadgeLevel

	local var_47_25 = var_0_53(var_47_0, 23, "int(__thiscall*)(void*)")

	function var_0_180.GetPlayerSteamLevel()
		return var_47_25(var_47_0)
	end

	var_0_180.get_player_steam_level = var_0_180.GetPlayerSteamLevel

	local var_47_26 = var_0_53(var_47_0, 24, "uint64_t(__thiscall*)(void*, const char *)")
	local var_47_27 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tchar m_szURL[512];\n\t\t\t} *\n\t\t"),
		keys = {
			m_szURL = "url"
		}
	}

	function var_0_180.RequestStoreAuthURL(arg_72_0, arg_72_1)
		if arg_72_1 ~= nil and not var_0_117(arg_72_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_72_0 = var_47_26(var_47_0, arg_72_0)

		if arg_72_1 ~= nil then
			var_72_0 = var_0_152(var_72_0, arg_72_1, 165, var_47_27)
		end

		return var_72_0
	end

	var_0_180.request_store_auth_url = var_0_180.RequestStoreAuthURL

	local var_47_28 = var_0_53(var_47_0, 25, "bool(__thiscall*)(void*)")

	function var_0_180.BIsPhoneVerified()
		return var_47_28(var_47_0)
	end

	var_0_180.is_phone_verified = var_0_180.BIsPhoneVerified

	local var_47_29 = var_0_53(var_47_0, 26, "bool(__thiscall*)(void*)")

	function var_0_180.BIsTwoFactorEnabled()
		return var_47_29(var_47_0)
	end

	var_0_180.is_two_factor_enabled = var_0_180.BIsTwoFactorEnabled

	local var_47_30 = var_0_53(var_47_0, 27, "bool(__thiscall*)(void*)")

	function var_0_180.BIsPhoneIdentifying()
		return var_47_30(var_47_0)
	end

	var_0_180.is_phone_identifying = var_0_180.BIsPhoneIdentifying

	local var_47_31 = var_0_53(var_47_0, 28, "bool(__thiscall*)(void*)")

	function var_0_180.BIsPhoneRequiringVerification()
		return var_47_31(var_47_0)
	end

	var_0_180.is_phone_requiring_verification = var_0_180.BIsPhoneRequiringVerification

	local var_47_32 = var_0_53(var_47_0, 29, "uint64_t(__thiscall*)(void*)")
	local var_47_33 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tbool m_bAllowed;\n\t\t\t\tint m_eNotAllowedReason;\n\t\t\t\tunsigned int m_rtAllowedAtTime;\n\t\t\t\tint m_cdaySteamGuardRequiredDays;\n\t\t\t\tint m_cdayNewDeviceCooldown;\n\t\t\t} *\n\t\t"),
		keys = {
			m_cdayNewDeviceCooldown = "new_device_cooldown",
			m_eNotAllowedReason = "not_allowed_reason",
			m_bAllowed = "allowed",
			m_cdaySteamGuardRequiredDays = "steam_guard_required_days",
			m_rtAllowedAtTime = "allowed_at_time"
		}
	}

	function var_0_180.GetMarketEligibility(arg_77_0)
		if arg_77_0 ~= nil and not var_0_117(arg_77_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_77_0 = var_47_32(var_47_0)

		if arg_77_0 ~= nil then
			var_77_0 = var_0_152(var_77_0, arg_77_0, 166, var_47_33)
		end

		return var_77_0
	end

	var_0_180.get_market_eligibility = var_0_180.GetMarketEligibility

	local var_47_34 = var_0_53(var_47_0, 30, "uint64_t(__thiscall*)(void*)")
	local var_47_35 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tunsigned int m_appid;\n\t\t\t\tbool m_bApplicable;\n\t\t\t\tint32_t m_csecsLast5h;\n\t\t\t\tint m_progress;\n\t\t\t\tint m_notification;\n\t\t\t\tint32_t m_csecsToday;\n\t\t\t\tint32_t m_csecsRemaining;\n\t\t\t} *\n\t\t"),
		keys = {
			m_csecsToday = "today",
			m_csecsLast5h = "last5h",
			m_csecsRemaining = "remaining",
			m_bApplicable = "applicable",
			m_appid = "appid",
			m_notification = "notification",
			m_eResult = "result",
			m_progress = "progress"
		}
	}

	function var_0_180.GetDurationControl(arg_78_0)
		if arg_78_0 ~= nil and not var_0_117(arg_78_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_78_0 = var_47_34(var_47_0)

		if arg_78_0 ~= nil then
			var_78_0 = var_0_152(var_78_0, arg_78_0, 167, var_47_35)
		end

		return var_78_0
	end

	var_0_180.get_duration_control = var_0_180.GetDurationControl

	local var_47_36 = var_0_53(var_47_0, 31, "bool(__thiscall*)(void*, int)")

	function var_0_180.BSetDurationControlOnlineState(arg_79_0)
		arg_79_0 = var_0_160(arg_79_0, var_0_64.EDurationControlOnlineState, "new_state is required")

		return var_47_36(var_47_0, arg_79_0)
	end

	var_0_180.set_duration_control_online_state = var_0_180.BSetDurationControlOnlineState

	return var_0_180
end

local var_0_181 = {
	version = "SteamFriends017",
	version_number = 17
}

function var_0_62.ISteamFriends()
	local var_80_0 = vtable_bind("steamclient.dll", "SteamClient020", 8, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "SteamFriends017")

	var_0_181.thisptr = var_80_0

	local var_80_1 = var_0_53(var_80_0, 0, "const char *(__thiscall*)(void*)")

	function var_0_181.GetPersonaName()
		local var_81_0 = var_80_1(var_80_0)

		return var_81_0 ~= nil and var_0_7(var_81_0) or nil
	end

	var_0_181.get_persona_name = var_0_181.GetPersonaName

	local var_80_2 = var_0_53(var_80_0, 1, "uint64_t(__thiscall*)(void*, const char *)")
	local var_80_3 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tbool m_bSuccess;\n\t\t\t\tbool m_bLocalSuccess;\n\t\t\t\tint m_result;\n\t\t\t} *\n\t\t"),
		keys = {
			m_result = "result",
			m_bSuccess = "success",
			m_bLocalSuccess = "local_success"
		}
	}

	function var_0_181.SetPersonaName(arg_82_0, arg_82_1)
		if arg_82_1 ~= nil and not var_0_117(arg_82_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_82_0 = var_80_2(var_80_0, arg_82_0)

		if arg_82_1 ~= nil then
			var_82_0 = var_0_152(var_82_0, arg_82_1, 347, var_80_3)
		end

		return var_82_0
	end

	var_0_181.set_persona_name = var_0_181.SetPersonaName

	local var_80_4 = var_0_53(var_80_0, 2, "int(__thiscall*)(void*)")

	function var_0_181.GetPersonaState()
		return var_80_4(var_80_0)
	end

	var_0_181.get_persona_state = var_0_181.GetPersonaState

	local var_80_5 = var_0_53(var_80_0, 3, "int(__thiscall*)(void*, int)")

	function var_0_181.GetFriendCount(arg_84_0)
		arg_84_0 = var_0_160(arg_84_0, var_0_64.EFriendFlags, "friend_flags is required")

		return var_80_5(var_80_0, arg_84_0)
	end

	var_0_181.get_friend_count = var_0_181.GetFriendCount

	local var_80_6 = var_0_53(var_80_0, 4, "void(__thiscall*)(void*, SteamID *, int, int)")

	function var_0_181.GetFriendByIndex(arg_85_0, arg_85_1)
		arg_85_1 = var_0_160(arg_85_1, var_0_64.EFriendFlags, "friend_flags is required")

		local var_85_0 = var_0_165()

		var_80_6(var_80_0, var_85_0, arg_85_0, arg_85_1)

		return var_0_60(var_85_0)
	end

	var_0_181.get_friend_by_index = var_0_181.GetFriendByIndex

	local var_80_7 = var_0_53(var_80_0, 5, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendRelationship(arg_86_0)
		arg_86_0 = var_0_158(arg_86_0, "steamid_friend is required")

		return var_80_7(var_80_0, arg_86_0)
	end

	var_0_181.get_friend_relationship = var_0_181.GetFriendRelationship

	local var_80_8 = var_0_53(var_80_0, 6, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendPersonaState(arg_87_0)
		arg_87_0 = var_0_158(arg_87_0, "steamid_friend is required")

		return var_80_8(var_80_0, arg_87_0)
	end

	var_0_181.get_friend_persona_state = var_0_181.GetFriendPersonaState

	local var_80_9 = var_0_53(var_80_0, 7, "const char *(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendPersonaName(arg_88_0)
		arg_88_0 = var_0_158(arg_88_0, "steamid_friend is required")

		local var_88_0 = var_80_9(var_80_0, arg_88_0)

		return var_88_0 ~= nil and var_0_7(var_88_0) or nil
	end

	var_0_181.get_friend_persona_name = var_0_181.GetFriendPersonaName

	local var_80_10 = var_0_53(var_80_0, 8, "bool(__thiscall*)(void*, SteamID, FriendGameInfo_t *)")

	function var_0_181.GetFriendGamePlayed(arg_89_0)
		arg_89_0 = var_0_158(arg_89_0, "steamid_friend is required")

		local var_89_0 = var_0_164()

		return var_80_10(var_80_0, arg_89_0, var_89_0), var_0_60(var_89_0)
	end

	var_0_181.get_friend_game_played = var_0_181.GetFriendGamePlayed

	local var_80_11 = var_0_53(var_80_0, 9, "const char *(__thiscall*)(void*, SteamID, int)")

	function var_0_181.GetFriendPersonaNameHistory(arg_90_0, arg_90_1)
		arg_90_0 = var_0_158(arg_90_0, "steamid_friend is required")

		local var_90_0 = var_80_11(var_80_0, arg_90_0, arg_90_1)

		return var_90_0 ~= nil and var_0_7(var_90_0) or nil
	end

	var_0_181.get_friend_persona_name_history = var_0_181.GetFriendPersonaNameHistory

	local var_80_12 = var_0_53(var_80_0, 10, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendSteamLevel(arg_91_0)
		arg_91_0 = var_0_158(arg_91_0, "steamid_friend is required")

		return var_80_12(var_80_0, arg_91_0)
	end

	var_0_181.get_friend_steam_level = var_0_181.GetFriendSteamLevel

	local var_80_13 = var_0_53(var_80_0, 11, "const char *(__thiscall*)(void*, SteamID)")

	function var_0_181.GetPlayerNickname(arg_92_0)
		arg_92_0 = var_0_158(arg_92_0, "steamid_player is required")

		local var_92_0 = var_80_13(var_80_0, arg_92_0)

		return var_92_0 ~= nil and var_0_7(var_92_0) or nil
	end

	var_0_181.get_player_nickname = var_0_181.GetPlayerNickname

	local var_80_14 = var_0_53(var_80_0, 12, "int(__thiscall*)(void*)")

	function var_0_181.GetFriendsGroupCount()
		return var_80_14(var_80_0)
	end

	var_0_181.get_friends_group_count = var_0_181.GetFriendsGroupCount

	local var_80_15 = var_0_53(var_80_0, 13, "short(__thiscall*)(void*, int)")

	function var_0_181.GetFriendsGroupIDByIndex(arg_94_0)
		return var_80_15(var_80_0, arg_94_0)
	end

	var_0_181.get_friends_group_id_by_index = var_0_181.GetFriendsGroupIDByIndex

	local var_80_16 = var_0_53(var_80_0, 14, "const char *(__thiscall*)(void*, short)")

	function var_0_181.GetFriendsGroupName(arg_95_0)
		local var_95_0 = var_80_16(var_80_0, arg_95_0)

		return var_95_0 ~= nil and var_0_7(var_95_0) or nil
	end

	var_0_181.get_friends_group_name = var_0_181.GetFriendsGroupName

	local var_80_17 = var_0_53(var_80_0, 15, "int(__thiscall*)(void*, short)")

	function var_0_181.GetFriendsGroupMembersCount(arg_96_0)
		return var_80_17(var_80_0, arg_96_0)
	end

	var_0_181.get_friends_group_members_count = var_0_181.GetFriendsGroupMembersCount

	local var_80_18 = var_0_53(var_80_0, 16, "void(__thiscall*)(void*, short, SteamID *, int)")

	function var_0_181.GetFriendsGroupMembersList(arg_97_0, arg_97_1, arg_97_2)
		return var_80_18(var_80_0, arg_97_0, arg_97_1, arg_97_2)
	end

	var_0_181.get_friends_group_members_list = var_0_181.GetFriendsGroupMembersList

	local var_80_19 = var_0_53(var_80_0, 17, "bool(__thiscall*)(void*, SteamID, int)")

	function var_0_181.HasFriend(arg_98_0, arg_98_1)
		arg_98_0 = var_0_158(arg_98_0, "steamid_friend is required")
		arg_98_1 = var_0_160(arg_98_1, var_0_64.EFriendFlags, "friend_flags is required")

		return var_80_19(var_80_0, arg_98_0, arg_98_1)
	end

	var_0_181.has_friend = var_0_181.HasFriend

	local var_80_20 = var_0_53(var_80_0, 18, "int(__thiscall*)(void*)")

	function var_0_181.GetClanCount()
		return var_80_20(var_80_0)
	end

	var_0_181.get_clan_count = var_0_181.GetClanCount

	local var_80_21 = var_0_53(var_80_0, 19, "void(__thiscall*)(void*, SteamID *, int)")

	function var_0_181.GetClanByIndex(arg_100_0)
		local var_100_0 = var_0_165()

		var_80_21(var_80_0, var_100_0, arg_100_0)

		return var_0_60(var_100_0)
	end

	var_0_181.get_clan_by_index = var_0_181.GetClanByIndex

	local var_80_22 = var_0_53(var_80_0, 20, "const char *(__thiscall*)(void*, SteamID)")

	function var_0_181.GetClanName(arg_101_0)
		arg_101_0 = var_0_158(arg_101_0, "steamid_clan is required")

		local var_101_0 = var_80_22(var_80_0, arg_101_0)

		return var_101_0 ~= nil and var_0_7(var_101_0) or nil
	end

	var_0_181.get_clan_name = var_0_181.GetClanName

	local var_80_23 = var_0_53(var_80_0, 21, "const char *(__thiscall*)(void*, SteamID)")

	function var_0_181.GetClanTag(arg_102_0)
		arg_102_0 = var_0_158(arg_102_0, "steamid_clan is required")

		local var_102_0 = var_80_23(var_80_0, arg_102_0)

		return var_102_0 ~= nil and var_0_7(var_102_0) or nil
	end

	var_0_181.get_clan_tag = var_0_181.GetClanTag

	local var_80_24 = var_0_53(var_80_0, 22, "bool(__thiscall*)(void*, SteamID, int *, int *, int *)")

	function var_0_181.GetClanActivityCounts(arg_103_0)
		arg_103_0 = var_0_158(arg_103_0, "steamid_clan is required")

		local var_103_0 = var_0_171()
		local var_103_1 = var_0_171()
		local var_103_2 = var_0_171()

		return var_80_24(var_80_0, arg_103_0, var_103_0, var_103_1, var_103_2), var_0_60(var_103_0), var_0_60(var_103_1), var_0_60(var_103_2)
	end

	var_0_181.get_clan_activity_counts = var_0_181.GetClanActivityCounts

	local var_80_25 = var_0_53(var_80_0, 23, "uint64_t(__thiscall*)(void*, SteamID *, int)")
	local var_80_26 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tbool m_bSuccess;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bSuccess = "success"
		}
	}

	function var_0_181.DownloadClanActivityCounts(arg_104_0, arg_104_1, arg_104_2)
		if arg_104_2 ~= nil and not var_0_117(arg_104_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_104_0 = var_80_25(var_80_0, arg_104_0, arg_104_1)

		if arg_104_2 ~= nil then
			var_104_0 = var_0_152(var_104_0, arg_104_2, 341, var_80_26)
		end

		return var_104_0
	end

	var_0_181.download_clan_activity_counts = var_0_181.DownloadClanActivityCounts

	local var_80_27 = var_0_53(var_80_0, 24, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendCountFromSource(arg_105_0)
		arg_105_0 = var_0_158(arg_105_0, "steamid_source is required")

		return var_80_27(var_80_0, arg_105_0)
	end

	var_0_181.get_friend_count_from_source = var_0_181.GetFriendCountFromSource

	local var_80_28 = var_0_53(var_80_0, 25, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function var_0_181.GetFriendFromSourceByIndex(arg_106_0, arg_106_1)
		arg_106_0 = var_0_158(arg_106_0, "steamid_source is required")

		local var_106_0 = var_0_165()

		var_80_28(var_80_0, var_106_0, arg_106_0, arg_106_1)

		return var_0_60(var_106_0)
	end

	var_0_181.get_friend_from_source_by_index = var_0_181.GetFriendFromSourceByIndex

	local var_80_29 = var_0_53(var_80_0, 26, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function var_0_181.IsUserInSource(arg_107_0, arg_107_1)
		arg_107_0 = var_0_158(arg_107_0, "steamid_user is required")
		arg_107_1 = var_0_158(arg_107_1, "steamid_source is required")

		return var_80_29(var_80_0, arg_107_0, arg_107_1)
	end

	var_0_181.is_user_in_source = var_0_181.IsUserInSource

	local var_80_30 = var_0_53(var_80_0, 27, "void(__thiscall*)(void*, SteamID, bool)")

	function var_0_181.SetInGameVoiceSpeaking(arg_108_0, arg_108_1)
		arg_108_0 = var_0_158(arg_108_0, "steamid_user is required")

		return var_80_30(var_80_0, arg_108_0, arg_108_1)
	end

	var_0_181.set_in_game_voice_speaking = var_0_181.SetInGameVoiceSpeaking

	local var_80_31 = var_0_53(var_80_0, 28, "void(__thiscall*)(void*, const char *)")

	function var_0_181.ActivateGameOverlay(arg_109_0)
		return var_80_31(var_80_0, arg_109_0)
	end

	var_0_181.activate_game_overlay = var_0_181.ActivateGameOverlay

	local var_80_32 = var_0_53(var_80_0, 29, "void(__thiscall*)(void*, const char *, SteamID)")

	function var_0_181.ActivateGameOverlayToUser(arg_110_0, arg_110_1)
		arg_110_1 = var_0_158(arg_110_1, "steamid is required")

		return var_80_32(var_80_0, arg_110_0, arg_110_1)
	end

	var_0_181.activate_game_overlay_to_user = var_0_181.ActivateGameOverlayToUser

	local var_80_33 = var_0_53(var_80_0, 30, "void(__thiscall*)(void*, const char *, int)")

	function var_0_181.ActivateGameOverlayToWebPage(arg_111_0, arg_111_1)
		arg_111_1 = var_0_160(arg_111_1, var_0_64.EActivateGameOverlayToWebPageMode, "mode is required")

		return var_80_33(var_80_0, arg_111_0, arg_111_1)
	end

	var_0_181.activate_game_overlay_to_web_page = var_0_181.ActivateGameOverlayToWebPage

	local var_80_34 = var_0_53(var_80_0, 31, "void(__thiscall*)(void*, unsigned int, int)")

	function var_0_181.ActivateGameOverlayToStore(arg_112_0, arg_112_1)
		arg_112_1 = var_0_160(arg_112_1, var_0_64.EOverlayToStoreFlag, "flag is required")

		return var_80_34(var_80_0, arg_112_0, arg_112_1)
	end

	var_0_181.activate_game_overlay_to_store = var_0_181.ActivateGameOverlayToStore

	local var_80_35 = var_0_53(var_80_0, 32, "void(__thiscall*)(void*, SteamID)")

	function var_0_181.SetPlayedWith(arg_113_0)
		arg_113_0 = var_0_158(arg_113_0, "steamid_user_played_with is required")

		return var_80_35(var_80_0, arg_113_0)
	end

	var_0_181.set_played_with = var_0_181.SetPlayedWith

	local var_80_36 = var_0_53(var_80_0, 33, "void(__thiscall*)(void*, SteamID)")

	function var_0_181.ActivateGameOverlayInviteDialog(arg_114_0)
		arg_114_0 = var_0_158(arg_114_0, "steamid_lobby is required")

		return var_80_36(var_80_0, arg_114_0)
	end

	var_0_181.activate_game_overlay_invite_dialog = var_0_181.ActivateGameOverlayInviteDialog

	local var_80_37 = var_0_53(var_80_0, 34, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetSmallFriendAvatar(arg_115_0)
		arg_115_0 = var_0_158(arg_115_0, "steamid_friend is required")

		return var_80_37(var_80_0, arg_115_0)
	end

	var_0_181.get_small_friend_avatar = var_0_181.GetSmallFriendAvatar

	local var_80_38 = var_0_53(var_80_0, 35, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetMediumFriendAvatar(arg_116_0)
		arg_116_0 = var_0_158(arg_116_0, "steamid_friend is required")

		return var_80_38(var_80_0, arg_116_0)
	end

	var_0_181.get_medium_friend_avatar = var_0_181.GetMediumFriendAvatar

	local var_80_39 = var_0_53(var_80_0, 36, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetLargeFriendAvatar(arg_117_0)
		arg_117_0 = var_0_158(arg_117_0, "steamid_friend is required")

		return var_80_39(var_80_0, arg_117_0)
	end

	var_0_181.get_large_friend_avatar = var_0_181.GetLargeFriendAvatar

	local var_80_40 = var_0_53(var_80_0, 37, "bool(__thiscall*)(void*, SteamID, bool)")

	function var_0_181.RequestUserInformation(arg_118_0, arg_118_1)
		arg_118_0 = var_0_158(arg_118_0, "steamid_user is required")

		return var_80_40(var_80_0, arg_118_0, arg_118_1)
	end

	var_0_181.request_user_information = var_0_181.RequestUserInformation

	local var_80_41 = var_0_53(var_80_0, 38, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_80_42 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tSteamID m_steamIDClan;\n\t\t\t\tint m_cOfficers;\n\t\t\t\tbool m_bSuccess;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bSuccess = "success",
			m_cOfficers = "officers",
			m_steamIDClan = "steamid_clan"
		}
	}

	function var_0_181.RequestClanOfficerList(arg_119_0, arg_119_1)
		arg_119_0 = var_0_158(arg_119_0, "steamid_clan is required")

		if arg_119_1 ~= nil and not var_0_117(arg_119_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_119_0 = var_80_41(var_80_0, arg_119_0)

		if arg_119_1 ~= nil then
			var_119_0 = var_0_152(var_119_0, arg_119_1, 335, var_80_42)
		end

		return var_119_0
	end

	var_0_181.request_clan_officer_list = var_0_181.RequestClanOfficerList

	local var_80_43 = var_0_53(var_80_0, 39, "void(__thiscall*)(void*, SteamID *, SteamID)")

	function var_0_181.GetClanOwner(arg_120_0)
		arg_120_0 = var_0_158(arg_120_0, "steamid_clan is required")

		local var_120_0 = var_0_165()

		var_80_43(var_80_0, var_120_0, arg_120_0)

		return var_0_60(var_120_0)
	end

	var_0_181.get_clan_owner = var_0_181.GetClanOwner

	local var_80_44 = var_0_53(var_80_0, 40, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetClanOfficerCount(arg_121_0)
		arg_121_0 = var_0_158(arg_121_0, "steamid_clan is required")

		return var_80_44(var_80_0, arg_121_0)
	end

	var_0_181.get_clan_officer_count = var_0_181.GetClanOfficerCount

	local var_80_45 = var_0_53(var_80_0, 41, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function var_0_181.GetClanOfficerByIndex(arg_122_0, arg_122_1)
		arg_122_0 = var_0_158(arg_122_0, "steamid_clan is required")

		local var_122_0 = var_0_165()

		var_80_45(var_80_0, var_122_0, arg_122_0, arg_122_1)

		return var_0_60(var_122_0)
	end

	var_0_181.get_clan_officer_by_index = var_0_181.GetClanOfficerByIndex

	local var_80_46 = var_0_53(var_80_0, 42, "uint32_t(__thiscall*)(void*)")

	function var_0_181.GetUserRestrictions()
		return var_80_46(var_80_0)
	end

	var_0_181.get_user_restrictions = var_0_181.GetUserRestrictions

	local var_80_47 = var_0_53(var_80_0, 43, "bool(__thiscall*)(void*, const char *, const char *)")

	function var_0_181.SetRichPresence(arg_124_0, arg_124_1)
		return var_80_47(var_80_0, arg_124_0, arg_124_1)
	end

	var_0_181.set_rich_presence = var_0_181.SetRichPresence

	local var_80_48 = var_0_53(var_80_0, 44, "void(__thiscall*)(void*)")

	function var_0_181.ClearRichPresence()
		return var_80_48(var_80_0)
	end

	var_0_181.clear_rich_presence = var_0_181.ClearRichPresence

	local var_80_49 = var_0_53(var_80_0, 45, "const char *(__thiscall*)(void*, SteamID, const char *)")

	function var_0_181.GetFriendRichPresence(arg_126_0, arg_126_1)
		arg_126_0 = var_0_158(arg_126_0, "steamid_friend is required")

		local var_126_0 = var_80_49(var_80_0, arg_126_0, arg_126_1)

		return var_126_0 ~= nil and var_0_7(var_126_0) or nil
	end

	var_0_181.get_friend_rich_presence = var_0_181.GetFriendRichPresence

	local var_80_50 = var_0_53(var_80_0, 46, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendRichPresenceKeyCount(arg_127_0)
		arg_127_0 = var_0_158(arg_127_0, "steamid_friend is required")

		return var_80_50(var_80_0, arg_127_0)
	end

	var_0_181.get_friend_rich_presence_key_count = var_0_181.GetFriendRichPresenceKeyCount

	local var_80_51 = var_0_53(var_80_0, 47, "const char *(__thiscall*)(void*, SteamID, int)")

	function var_0_181.GetFriendRichPresenceKeyByIndex(arg_128_0, arg_128_1)
		arg_128_0 = var_0_158(arg_128_0, "steamid_friend is required")

		local var_128_0 = var_80_51(var_80_0, arg_128_0, arg_128_1)

		return var_128_0 ~= nil and var_0_7(var_128_0) or nil
	end

	var_0_181.get_friend_rich_presence_key_by_index = var_0_181.GetFriendRichPresenceKeyByIndex

	local var_80_52 = var_0_53(var_80_0, 48, "void(__thiscall*)(void*, SteamID)")

	function var_0_181.RequestFriendRichPresence(arg_129_0)
		arg_129_0 = var_0_158(arg_129_0, "steamid_friend is required")

		return var_80_52(var_80_0, arg_129_0)
	end

	var_0_181.request_friend_rich_presence = var_0_181.RequestFriendRichPresence

	local var_80_53 = var_0_53(var_80_0, 49, "bool(__thiscall*)(void*, SteamID, const char *)")

	function var_0_181.InviteUserToGame(arg_130_0, arg_130_1)
		arg_130_0 = var_0_158(arg_130_0, "steamid_friend is required")

		return var_80_53(var_80_0, arg_130_0, arg_130_1)
	end

	var_0_181.invite_user_to_game = var_0_181.InviteUserToGame

	local var_80_54 = var_0_53(var_80_0, 50, "int(__thiscall*)(void*)")

	function var_0_181.GetCoplayFriendCount()
		return var_80_54(var_80_0)
	end

	var_0_181.get_coplay_friend_count = var_0_181.GetCoplayFriendCount

	local var_80_55 = var_0_53(var_80_0, 51, "void(__thiscall*)(void*, SteamID *, int)")

	function var_0_181.GetCoplayFriend(arg_132_0)
		local var_132_0 = var_0_165()

		var_80_55(var_80_0, var_132_0, arg_132_0)

		return var_0_60(var_132_0)
	end

	var_0_181.get_coplay_friend = var_0_181.GetCoplayFriend

	local var_80_56 = var_0_53(var_80_0, 52, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendCoplayTime(arg_133_0)
		arg_133_0 = var_0_158(arg_133_0, "steamid_friend is required")

		return var_80_56(var_80_0, arg_133_0)
	end

	var_0_181.get_friend_coplay_time = var_0_181.GetFriendCoplayTime

	local var_80_57 = var_0_53(var_80_0, 53, "unsigned int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetFriendCoplayGame(arg_134_0)
		arg_134_0 = var_0_158(arg_134_0, "steamid_friend is required")

		return var_80_57(var_80_0, arg_134_0)
	end

	var_0_181.get_friend_coplay_game = var_0_181.GetFriendCoplayGame

	local var_80_58 = var_0_53(var_80_0, 54, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_80_59 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tSteamID m_steamIDClanChat;\n\t\t\t\tint m_eChatRoomEnterResponse;\n\t\t\t} *\n\t\t"),
		keys = {
			m_steamIDClanChat = "steamid_clan_chat",
			m_eChatRoomEnterResponse = "chat_room_enter_response"
		}
	}

	function var_0_181.JoinClanChatRoom(arg_135_0, arg_135_1)
		arg_135_0 = var_0_158(arg_135_0, "steamid_clan is required")

		if arg_135_1 ~= nil and not var_0_117(arg_135_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_135_0 = var_80_58(var_80_0, arg_135_0)

		if arg_135_1 ~= nil then
			var_135_0 = var_0_152(var_135_0, arg_135_1, 342, var_80_59)
		end

		return var_135_0
	end

	var_0_181.join_clan_chat_room = var_0_181.JoinClanChatRoom

	local var_80_60 = var_0_53(var_80_0, 55, "bool(__thiscall*)(void*, SteamID)")

	function var_0_181.LeaveClanChatRoom(arg_136_0)
		arg_136_0 = var_0_158(arg_136_0, "steamid_clan is required")

		return var_80_60(var_80_0, arg_136_0)
	end

	var_0_181.leave_clan_chat_room = var_0_181.LeaveClanChatRoom

	local var_80_61 = var_0_53(var_80_0, 56, "int(__thiscall*)(void*, SteamID)")

	function var_0_181.GetClanChatMemberCount(arg_137_0)
		arg_137_0 = var_0_158(arg_137_0, "steamid_clan is required")

		return var_80_61(var_80_0, arg_137_0)
	end

	var_0_181.get_clan_chat_member_count = var_0_181.GetClanChatMemberCount

	local var_80_62 = var_0_53(var_80_0, 57, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function var_0_181.GetChatMemberByIndex(arg_138_0, arg_138_1)
		arg_138_0 = var_0_158(arg_138_0, "steamid_clan is required")

		local var_138_0 = var_0_165()

		var_80_62(var_80_0, var_138_0, arg_138_0, arg_138_1)

		return var_0_60(var_138_0)
	end

	var_0_181.get_chat_member_by_index = var_0_181.GetChatMemberByIndex

	local var_80_63 = var_0_53(var_80_0, 58, "bool(__thiscall*)(void*, SteamID, const char *)")

	function var_0_181.SendClanChatMessage(arg_139_0, arg_139_1)
		arg_139_0 = var_0_158(arg_139_0, "steamid_clan_chat is required")

		return var_80_63(var_80_0, arg_139_0, arg_139_1)
	end

	var_0_181.send_clan_chat_message = var_0_181.SendClanChatMessage

	local var_80_64 = var_0_53(var_80_0, 59, "int(__thiscall*)(void*, SteamID, int, void *, int, int *, SteamID *)")

	function var_0_181.GetClanChatMessage(arg_140_0, arg_140_1, arg_140_2, arg_140_3)
		arg_140_0 = var_0_158(arg_140_0, "steamid_clan_chat is required")

		local var_140_0 = var_0_171()
		local var_140_1 = var_0_165()

		return var_80_64(var_80_0, arg_140_0, arg_140_1, arg_140_2, arg_140_3, var_140_0, var_140_1), var_0_60(var_140_0), var_0_60(var_140_1)
	end

	var_0_181.get_clan_chat_message = var_0_181.GetClanChatMessage

	local var_80_65 = var_0_53(var_80_0, 60, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function var_0_181.IsClanChatAdmin(arg_141_0, arg_141_1)
		arg_141_0 = var_0_158(arg_141_0, "steamid_clan_chat is required")
		arg_141_1 = var_0_158(arg_141_1, "steamid_user is required")

		return var_80_65(var_80_0, arg_141_0, arg_141_1)
	end

	var_0_181.is_clan_chat_admin = var_0_181.IsClanChatAdmin

	local var_80_66 = var_0_53(var_80_0, 61, "bool(__thiscall*)(void*, SteamID)")

	function var_0_181.IsClanChatWindowOpenInSteam(arg_142_0)
		arg_142_0 = var_0_158(arg_142_0, "steamid_clan_chat is required")

		return var_80_66(var_80_0, arg_142_0)
	end

	var_0_181.is_clan_chat_window_open_in_steam = var_0_181.IsClanChatWindowOpenInSteam

	local var_80_67 = var_0_53(var_80_0, 62, "bool(__thiscall*)(void*, SteamID)")

	function var_0_181.OpenClanChatWindowInSteam(arg_143_0)
		arg_143_0 = var_0_158(arg_143_0, "steamid_clan_chat is required")

		return var_80_67(var_80_0, arg_143_0)
	end

	var_0_181.open_clan_chat_window_in_steam = var_0_181.OpenClanChatWindowInSteam

	local var_80_68 = var_0_53(var_80_0, 63, "bool(__thiscall*)(void*, SteamID)")

	function var_0_181.CloseClanChatWindowInSteam(arg_144_0)
		arg_144_0 = var_0_158(arg_144_0, "steamid_clan_chat is required")

		return var_80_68(var_80_0, arg_144_0)
	end

	var_0_181.close_clan_chat_window_in_steam = var_0_181.CloseClanChatWindowInSteam

	local var_80_69 = var_0_53(var_80_0, 64, "bool(__thiscall*)(void*, bool)")

	function var_0_181.SetListenForFriendsMessages(arg_145_0)
		return var_80_69(var_80_0, arg_145_0)
	end

	var_0_181.set_listen_for_friends_messages = var_0_181.SetListenForFriendsMessages

	local var_80_70 = var_0_53(var_80_0, 65, "bool(__thiscall*)(void*, SteamID, const char *)")

	function var_0_181.ReplyToFriendMessage(arg_146_0, arg_146_1)
		arg_146_0 = var_0_158(arg_146_0, "steamid_friend is required")

		return var_80_70(var_80_0, arg_146_0, arg_146_1)
	end

	var_0_181.reply_to_friend_message = var_0_181.ReplyToFriendMessage

	local var_80_71 = var_0_53(var_80_0, 66, "int(__thiscall*)(void*, SteamID, int, void *, int, int *)")

	function var_0_181.GetFriendMessage(arg_147_0, arg_147_1, arg_147_2, arg_147_3)
		arg_147_0 = var_0_158(arg_147_0, "steamid_friend is required")

		local var_147_0 = var_0_171()

		return var_80_71(var_80_0, arg_147_0, arg_147_1, arg_147_2, arg_147_3, var_147_0), var_0_60(var_147_0)
	end

	var_0_181.get_friend_message = var_0_181.GetFriendMessage

	local var_80_72 = var_0_53(var_80_0, 67, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_80_73 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_steamID;\n\t\t\t\tint m_nCount;\n\t\t\t} *\n\t\t"),
		keys = {
			m_steamID = "steamid",
			m_nCount = "count",
			m_eResult = "result"
		}
	}

	function var_0_181.GetFollowerCount(arg_148_0, arg_148_1)
		arg_148_0 = var_0_158(arg_148_0, "steamid is required")

		if arg_148_1 ~= nil and not var_0_117(arg_148_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_148_0 = var_80_72(var_80_0, arg_148_0)

		if arg_148_1 ~= nil then
			var_148_0 = var_0_152(var_148_0, arg_148_1, 344, var_80_73)
		end

		return var_148_0
	end

	var_0_181.get_follower_count = var_0_181.GetFollowerCount

	local var_80_74 = var_0_53(var_80_0, 68, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_80_75 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_steamID;\n\t\t\t\tbool m_bIsFollowing;\n\t\t\t} *\n\t\t"),
		keys = {
			m_steamID = "steamid",
			m_bIsFollowing = "is_following",
			m_eResult = "result"
		}
	}

	function var_0_181.IsFollowing(arg_149_0, arg_149_1)
		arg_149_0 = var_0_158(arg_149_0, "steamid is required")

		if arg_149_1 ~= nil and not var_0_117(arg_149_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_149_0 = var_80_74(var_80_0, arg_149_0)

		if arg_149_1 ~= nil then
			var_149_0 = var_0_152(var_149_0, arg_149_1, 345, var_80_75)
		end

		return var_149_0
	end

	var_0_181.is_following = var_0_181.IsFollowing

	local var_80_76 = var_0_53(var_80_0, 69, "uint64_t(__thiscall*)(void*, uint32_t)")
	local var_80_77 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_rgSteamID[50];\n\t\t\t\tint32_t m_nResultsReturned;\n\t\t\t\tint32_t m_nTotalResultCount;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nTotalResultCount = "total_result_count",
			m_rgSteamID = "steamid",
			m_eResult = "result",
			m_nResultsReturned = "results_returned"
		}
	}

	function var_0_181.EnumerateFollowingList(arg_150_0, arg_150_1)
		if arg_150_1 ~= nil and not var_0_117(arg_150_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_150_0 = var_80_76(var_80_0, arg_150_0)

		if arg_150_1 ~= nil then
			var_150_0 = var_0_152(var_150_0, arg_150_1, 346, var_80_77)
		end

		return var_150_0
	end

	var_0_181.enumerate_following_list = var_0_181.EnumerateFollowingList

	local var_80_78 = var_0_53(var_80_0, 70, "bool(__thiscall*)(void*, SteamID)")

	function var_0_181.IsClanPublic(arg_151_0)
		arg_151_0 = var_0_158(arg_151_0, "steamid_clan is required")

		return var_80_78(var_80_0, arg_151_0)
	end

	var_0_181.is_clan_public = var_0_181.IsClanPublic

	local var_80_79 = var_0_53(var_80_0, 71, "bool(__thiscall*)(void*, SteamID)")

	function var_0_181.IsClanOfficialGameGroup(arg_152_0)
		arg_152_0 = var_0_158(arg_152_0, "steamid_clan is required")

		return var_80_79(var_80_0, arg_152_0)
	end

	var_0_181.is_clan_official_game_group = var_0_181.IsClanOfficialGameGroup

	local var_80_80 = var_0_53(var_80_0, 72, "int(__thiscall*)(void*)")

	function var_0_181.GetNumChatsWithUnreadPriorityMessages()
		return var_80_80(var_80_0)
	end

	var_0_181.get_num_chats_with_unread_priority_messages = var_0_181.GetNumChatsWithUnreadPriorityMessages

	local var_80_81 = var_0_53(var_80_0, 73, "void(__thiscall*)(void*, SteamID)")

	function var_0_181.ActivateGameOverlayRemotePlayTogetherInviteDialog(arg_154_0)
		arg_154_0 = var_0_158(arg_154_0, "steamid_lobby is required")

		return var_80_81(var_80_0, arg_154_0)
	end

	var_0_181.activate_game_overlay_remote_play_together_invite_dialog = var_0_181.ActivateGameOverlayRemotePlayTogetherInviteDialog

	local var_80_82 = var_0_53(var_80_0, 74, "bool(__thiscall*)(void*, const char *)")

	function var_0_181.RegisterProtocolInOverlayBrowser(arg_155_0)
		return var_80_82(var_80_0, arg_155_0)
	end

	var_0_181.register_protocol_in_overlay_browser = var_0_181.RegisterProtocolInOverlayBrowser

	local var_80_83 = var_0_53(var_80_0, 75, "void(__thiscall*)(void*, const char *)")

	function var_0_181.ActivateGameOverlayInviteDialogConnectString(arg_156_0)
		return var_80_83(var_80_0, arg_156_0)
	end

	var_0_181.activate_game_overlay_invite_dialog_connect_string = var_0_181.ActivateGameOverlayInviteDialogConnectString

	local var_80_84 = var_0_53(var_80_0, 76, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_80_85 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_steamID;\n\t\t\t\tbool m_bHasAnimatedAvatar;\n\t\t\t\tbool m_bHasAvatarFrame;\n\t\t\t\tbool m_bHasProfileModifier;\n\t\t\t\tbool m_bHasProfileBackground;\n\t\t\t\tbool m_bHasMiniProfileBackground;\n\t\t\t} *\n\t\t"),
		keys = {
			m_steamID = "steamid",
			m_bHasProfileModifier = "has_profile_modifier",
			m_bHasAvatarFrame = "has_avatar_frame",
			m_bHasProfileBackground = "has_profile_background",
			m_bHasAnimatedAvatar = "has_animated_avatar",
			m_bHasMiniProfileBackground = "has_mini_profile_background",
			m_eResult = "result"
		}
	}

	function var_0_181.RequestEquippedProfileItems(arg_157_0, arg_157_1)
		arg_157_0 = var_0_158(arg_157_0, "steamid is required")

		if arg_157_1 ~= nil and not var_0_117(arg_157_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_157_0 = var_80_84(var_80_0, arg_157_0)

		if arg_157_1 ~= nil then
			var_157_0 = var_0_152(var_157_0, arg_157_1, 351, var_80_85)
		end

		return var_157_0
	end

	var_0_181.request_equipped_profile_items = var_0_181.RequestEquippedProfileItems

	local var_80_86 = var_0_53(var_80_0, 77, "bool(__thiscall*)(void*, SteamID, int)")

	function var_0_181.BHasEquippedProfileItem(arg_158_0, arg_158_1)
		arg_158_0 = var_0_158(arg_158_0, "steamid is required")
		arg_158_1 = var_0_160(arg_158_1, var_0_64.ECommunityProfileItemType, "item_type is required")

		return var_80_86(var_80_0, arg_158_0, arg_158_1)
	end

	var_0_181.has_equipped_profile_item = var_0_181.BHasEquippedProfileItem

	local var_80_87 = var_0_53(var_80_0, 78, "const char *(__thiscall*)(void*, SteamID, int, int)")

	function var_0_181.GetProfileItemPropertyString(arg_159_0, arg_159_1, arg_159_2)
		arg_159_0 = var_0_158(arg_159_0, "steamid is required")
		arg_159_1 = var_0_160(arg_159_1, var_0_64.ECommunityProfileItemType, "item_type is required")
		arg_159_2 = var_0_160(arg_159_2, var_0_64.ECommunityProfileItemProperty, "prop is required")

		local var_159_0 = var_80_87(var_80_0, arg_159_0, arg_159_1, arg_159_2)

		return var_159_0 ~= nil and var_0_7(var_159_0) or nil
	end

	var_0_181.get_profile_item_property_string = var_0_181.GetProfileItemPropertyString

	local var_80_88 = var_0_53(var_80_0, 79, "uint32_t(__thiscall*)(void*, SteamID, int, int)")

	function var_0_181.GetProfileItemPropertyUint(arg_160_0, arg_160_1, arg_160_2)
		arg_160_0 = var_0_158(arg_160_0, "steamid is required")
		arg_160_1 = var_0_160(arg_160_1, var_0_64.ECommunityProfileItemType, "item_type is required")
		arg_160_2 = var_0_160(arg_160_2, var_0_64.ECommunityProfileItemProperty, "prop is required")

		return var_80_88(var_80_0, arg_160_0, arg_160_1, arg_160_2)
	end

	var_0_181.get_profile_item_property_uint = var_0_181.GetProfileItemPropertyUint

	return var_0_181
end

local var_0_182 = {
	version = "SteamUtils010",
	version_number = 10
}

function var_0_62.ISteamUtils()
	local var_161_0 = vtable_bind("steamclient.dll", "SteamClient020", 9, "void*(__thiscall*)(void*, int, const char *)")(var_0_178, "SteamUtils010")

	var_0_182.thisptr = var_161_0

	local var_161_1 = var_0_53(var_161_0, 0, "uint32_t(__thiscall*)(void*)")

	function var_0_182.GetSecondsSinceAppActive()
		return var_161_1(var_161_0)
	end

	var_0_182.get_seconds_since_app_active = var_0_182.GetSecondsSinceAppActive

	local var_161_2 = var_0_53(var_161_0, 1, "uint32_t(__thiscall*)(void*)")

	function var_0_182.GetSecondsSinceComputerActive()
		return var_161_2(var_161_0)
	end

	var_0_182.get_seconds_since_computer_active = var_0_182.GetSecondsSinceComputerActive

	local var_161_3 = var_0_53(var_161_0, 2, "int(__thiscall*)(void*)")

	function var_0_182.GetConnectedUniverse()
		return var_161_3(var_161_0)
	end

	var_0_182.get_connected_universe = var_0_182.GetConnectedUniverse

	local var_161_4 = var_0_53(var_161_0, 3, "uint32_t(__thiscall*)(void*)")

	function var_0_182.GetServerRealTime()
		return var_161_4(var_161_0)
	end

	var_0_182.get_server_real_time = var_0_182.GetServerRealTime

	local var_161_5 = var_0_53(var_161_0, 4, "const char *(__thiscall*)(void*)")

	function var_0_182.GetIPCountry()
		local var_166_0 = var_161_5(var_161_0)

		return var_166_0 ~= nil and var_0_7(var_166_0) or nil
	end

	var_0_182.get_ip_country = var_0_182.GetIPCountry

	local var_161_6 = var_0_53(var_161_0, 5, "bool(__thiscall*)(void*, int, uint32_t *, uint32_t *)")

	function var_0_182.GetImageSize(arg_167_0)
		local var_167_0 = var_0_173()
		local var_167_1 = var_0_173()

		return var_161_6(var_161_0, arg_167_0, var_167_0, var_167_1), var_0_60(var_167_0), var_0_60(var_167_1)
	end

	var_0_182.get_image_size = var_0_182.GetImageSize

	local var_161_7 = var_0_53(var_161_0, 6, "bool(__thiscall*)(void*, int, uint8_t *, int)")

	function var_0_182.GetImageRGBA(arg_168_0, arg_168_1, arg_168_2)
		return var_161_7(var_161_0, arg_168_0, arg_168_1, arg_168_2)
	end

	var_0_182.get_image_rgba = var_0_182.GetImageRGBA

	local var_161_8 = var_0_53(var_161_0, 8, "uint8_t(__thiscall*)(void*)")

	function var_0_182.GetCurrentBatteryPower()
		return var_161_8(var_161_0)
	end

	var_0_182.get_current_battery_power = var_0_182.GetCurrentBatteryPower

	local var_161_9 = var_0_53(var_161_0, 9, "uint32_t(__thiscall*)(void*)")

	function var_0_182.GetAppID()
		return var_161_9(var_161_0)
	end

	var_0_182.get_appid = var_0_182.GetAppID

	local var_161_10 = var_0_53(var_161_0, 10, "void(__thiscall*)(void*, int)")

	function var_0_182.SetOverlayNotificationPosition(arg_171_0)
		arg_171_0 = var_0_160(arg_171_0, var_0_64.ENotificationPosition, "notification_position is required")

		return var_161_10(var_161_0, arg_171_0)
	end

	var_0_182.set_overlay_notification_position = var_0_182.SetOverlayNotificationPosition

	local var_161_11 = var_0_53(var_161_0, 11, "bool(__thiscall*)(void*, uint64_t, bool *)")

	function var_0_182.IsAPICallCompleted(arg_172_0)
		local var_172_0 = var_0_166()

		return var_161_11(var_161_0, arg_172_0, var_172_0), var_0_60(var_172_0)
	end

	var_0_182.is_api_call_completed = var_0_182.IsAPICallCompleted

	local var_161_12 = var_0_53(var_161_0, 12, "int(__thiscall*)(void*, uint64_t)")

	function var_0_182.GetAPICallFailureReason(arg_173_0)
		return var_161_12(var_161_0, arg_173_0)
	end

	var_0_182.get_api_call_failure_reason = var_0_182.GetAPICallFailureReason

	local var_161_13 = var_0_53(var_161_0, 13, "bool(__thiscall*)(void*, uint64_t, void *, int, int, bool *)")

	function var_0_182.GetAPICallResult(arg_174_0, arg_174_1, arg_174_2, arg_174_3)
		local var_174_0 = var_0_166()

		return var_161_13(var_161_0, arg_174_0, arg_174_1, arg_174_2, arg_174_3, var_174_0), var_0_60(var_174_0)
	end

	var_0_182.get_api_call_result = var_0_182.GetAPICallResult

	local var_161_14 = var_0_53(var_161_0, 15, "uint32_t(__thiscall*)(void*)")

	function var_0_182.GetIPCCallCount()
		return var_161_14(var_161_0)
	end

	var_0_182.get_ipc_call_count = var_0_182.GetIPCCallCount

	local var_161_15 = var_0_53(var_161_0, 16, "void(__thiscall*)(void*, void*(__cdecl*)(int, const char*))")

	function var_0_182.SetWarningMessageHook(arg_176_0)
		return var_161_15(var_161_0, arg_176_0)
	end

	var_0_182.set_warning_message_hook = var_0_182.SetWarningMessageHook

	local var_161_16 = var_0_53(var_161_0, 17, "bool(__thiscall*)(void*)")

	function var_0_182.IsOverlayEnabled()
		return var_161_16(var_161_0)
	end

	var_0_182.is_overlay_enabled = var_0_182.IsOverlayEnabled

	local var_161_17 = var_0_53(var_161_0, 18, "bool(__thiscall*)(void*)")

	function var_0_182.BOverlayNeedsPresent()
		return var_161_17(var_161_0)
	end

	var_0_182.overlay_needs_present = var_0_182.BOverlayNeedsPresent

	local var_161_18 = var_0_53(var_161_0, 19, "uint64_t(__thiscall*)(void*, const char *)")
	local var_161_19 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eCheckFileSignature;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eCheckFileSignature = "check_file_signature"
		}
	}

	function var_0_182.CheckFileSignature(arg_179_0, arg_179_1)
		if arg_179_1 ~= nil and not var_0_117(arg_179_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_179_0 = var_161_18(var_161_0, arg_179_0)

		if arg_179_1 ~= nil then
			var_179_0 = var_0_152(var_179_0, arg_179_1, 705, var_161_19)
		end

		return var_179_0
	end

	var_0_182.check_file_signature = var_0_182.CheckFileSignature

	local var_161_20 = var_0_53(var_161_0, 20, "bool(__thiscall*)(void*, int, int, const char *, uint32_t, const char *)")

	function var_0_182.ShowGamepadTextInput(arg_180_0, arg_180_1, arg_180_2, arg_180_3, arg_180_4)
		arg_180_0 = var_0_160(arg_180_0, var_0_64.EGamepadTextInputMode, "input_mode is required")
		arg_180_1 = var_0_160(arg_180_1, var_0_64.EGamepadTextInputLineMode, "line_input_mode is required")

		return var_161_20(var_161_0, arg_180_0, arg_180_1, arg_180_2, arg_180_3, arg_180_4)
	end

	var_0_182.show_gamepad_text_input = var_0_182.ShowGamepadTextInput

	local var_161_21 = var_0_53(var_161_0, 21, "uint32_t(__thiscall*)(void*)")

	function var_0_182.GetEnteredGamepadTextLength()
		return var_161_21(var_161_0)
	end

	var_0_182.get_entered_gamepad_text_length = var_0_182.GetEnteredGamepadTextLength

	local var_161_22 = var_0_53(var_161_0, 22, "bool(__thiscall*)(void*, char *, uint32_t)")

	function var_0_182.GetEnteredGamepadTextInput(arg_182_0, arg_182_1)
		return var_161_22(var_161_0, arg_182_0, arg_182_1)
	end

	var_0_182.get_entered_gamepad_text_input = var_0_182.GetEnteredGamepadTextInput

	local var_161_23 = var_0_53(var_161_0, 23, "const char *(__thiscall*)(void*)")

	function var_0_182.GetSteamUILanguage()
		local var_183_0 = var_161_23(var_161_0)

		return var_183_0 ~= nil and var_0_7(var_183_0) or nil
	end

	var_0_182.get_steam_ui_language = var_0_182.GetSteamUILanguage

	local var_161_24 = var_0_53(var_161_0, 24, "bool(__thiscall*)(void*)")

	function var_0_182.IsSteamRunningInVR()
		return var_161_24(var_161_0)
	end

	var_0_182.is_steam_running_in_vr = var_0_182.IsSteamRunningInVR

	local var_161_25 = var_0_53(var_161_0, 25, "void(__thiscall*)(void*, int, int)")

	function var_0_182.SetOverlayNotificationInset(arg_185_0, arg_185_1)
		return var_161_25(var_161_0, arg_185_0, arg_185_1)
	end

	var_0_182.set_overlay_notification_inset = var_0_182.SetOverlayNotificationInset

	local var_161_26 = var_0_53(var_161_0, 26, "bool(__thiscall*)(void*)")

	function var_0_182.IsSteamInBigPictureMode()
		return var_161_26(var_161_0)
	end

	var_0_182.is_steam_in_big_picture_mode = var_0_182.IsSteamInBigPictureMode

	local var_161_27 = var_0_53(var_161_0, 27, "void(__thiscall*)(void*)")

	function var_0_182.StartVRDashboard()
		return var_161_27(var_161_0)
	end

	var_0_182.start_vr_dashboard = var_0_182.StartVRDashboard

	local var_161_28 = var_0_53(var_161_0, 28, "bool(__thiscall*)(void*)")

	function var_0_182.IsVRHeadsetStreamingEnabled()
		return var_161_28(var_161_0)
	end

	var_0_182.is_vr_headset_streaming_enabled = var_0_182.IsVRHeadsetStreamingEnabled

	local var_161_29 = var_0_53(var_161_0, 29, "void(__thiscall*)(void*, bool)")

	function var_0_182.SetVRHeadsetStreamingEnabled(arg_189_0)
		return var_161_29(var_161_0, arg_189_0)
	end

	var_0_182.set_vr_headset_streaming_enabled = var_0_182.SetVRHeadsetStreamingEnabled

	local var_161_30 = var_0_53(var_161_0, 30, "bool(__thiscall*)(void*)")

	function var_0_182.IsSteamChinaLauncher()
		return var_161_30(var_161_0)
	end

	var_0_182.is_steam_china_launcher = var_0_182.IsSteamChinaLauncher

	local var_161_31 = var_0_53(var_161_0, 31, "bool(__thiscall*)(void*, uint32_t)")

	function var_0_182.InitFilterText(arg_191_0)
		return var_161_31(var_161_0, arg_191_0)
	end

	var_0_182.init_filter_text = var_0_182.InitFilterText

	local var_161_32 = var_0_53(var_161_0, 32, "int(__thiscall*)(void*, int, SteamID, const char *, char *, uint32_t)")

	function var_0_182.FilterText(arg_192_0, arg_192_1, arg_192_2, arg_192_3, arg_192_4)
		arg_192_0 = var_0_160(arg_192_0, var_0_64.ETextFilteringContext, "context is required")
		arg_192_1 = var_0_158(arg_192_1, "source_steamid is required")

		return var_161_32(var_161_0, arg_192_0, arg_192_1, arg_192_2, arg_192_3, arg_192_4)
	end

	var_0_182.filter_text = var_0_182.FilterText

	local var_161_33 = var_0_53(var_161_0, 33, "int(__thiscall*)(void*, int)")

	function var_0_182.GetIPv6ConnectivityState(arg_193_0)
		arg_193_0 = var_0_160(arg_193_0, var_0_64.ESteamIPv6ConnectivityProtocol, "protocol is required")

		return var_161_33(var_161_0, arg_193_0)
	end

	var_0_182.get_ipv6_connectivity_state = var_0_182.GetIPv6ConnectivityState

	local var_161_34 = var_0_53(var_161_0, 34, "bool(__thiscall*)(void*)")

	function var_0_182.IsSteamRunningOnSteamDeck()
		return var_161_34(var_161_0)
	end

	var_0_182.is_steam_running_on_steam_deck = var_0_182.IsSteamRunningOnSteamDeck

	local var_161_35 = var_0_53(var_161_0, 35, "bool(__thiscall*)(void*, int, int, int, int, int)")

	function var_0_182.ShowFloatingGamepadTextInput(arg_195_0, arg_195_1, arg_195_2, arg_195_3, arg_195_4)
		arg_195_0 = var_0_160(arg_195_0, var_0_64.EFloatingGamepadTextInputMode, "keyboard_mode is required")

		return var_161_35(var_161_0, arg_195_0, arg_195_1, arg_195_2, arg_195_3, arg_195_4)
	end

	var_0_182.show_floating_gamepad_text_input = var_0_182.ShowFloatingGamepadTextInput

	local var_161_36 = var_0_53(var_161_0, 36, "void(__thiscall*)(void*, bool)")

	function var_0_182.SetGameLauncherMode(arg_196_0)
		return var_161_36(var_161_0, arg_196_0)
	end

	var_0_182.set_game_launcher_mode = var_0_182.SetGameLauncherMode

	local var_161_37 = var_0_53(var_161_0, 37, "bool(__thiscall*)(void*)")

	function var_0_182.DismissFloatingGamepadTextInput()
		return var_161_37(var_161_0)
	end

	var_0_182.dismiss_floating_gamepad_text_input = var_0_182.DismissFloatingGamepadTextInput

	return var_0_182
end

local var_0_183 = {
	version = "SteamMatchMaking009",
	version_number = 9
}

function var_0_62.ISteamMatchmaking()
	local var_198_0 = vtable_bind("steamclient.dll", "SteamClient020", 10, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "SteamMatchMaking009")

	var_0_183.thisptr = var_198_0

	local var_198_1 = var_0_53(var_198_0, 0, "int(__thiscall*)(void*)")

	function var_0_183.GetFavoriteGameCount()
		return var_198_1(var_198_0)
	end

	var_0_183.get_favorite_game_count = var_0_183.GetFavoriteGameCount

	local var_198_2 = var_0_53(var_198_0, 1, "bool(__thiscall*)(void*, int, unsigned int *, uint32_t *, uint16_t *, uint16_t *, uint32_t *, uint32_t *)")

	function var_0_183.GetFavoriteGame(arg_200_0)
		local var_200_0 = var_0_175()
		local var_200_1 = var_0_173()
		local var_200_2 = var_0_172()
		local var_200_3 = var_0_172()
		local var_200_4 = var_0_173()
		local var_200_5 = var_0_173()

		return var_198_2(var_198_0, arg_200_0, var_200_0, var_200_1, var_200_2, var_200_3, var_200_4, var_200_5), var_0_60(var_200_0), var_0_60(var_200_1), var_0_60(var_200_2), var_0_60(var_200_3), var_0_60(var_200_4), var_0_60(var_200_5)
	end

	var_0_183.get_favorite_game = var_0_183.GetFavoriteGame

	local var_198_3 = var_0_53(var_198_0, 2, "int(__thiscall*)(void*, unsigned int, uint32_t, uint16_t, uint16_t, uint32_t, uint32_t)")

	function var_0_183.AddFavoriteGame(arg_201_0, arg_201_1, arg_201_2, arg_201_3, arg_201_4, arg_201_5)
		return var_198_3(var_198_0, arg_201_0, arg_201_1, arg_201_2, arg_201_3, arg_201_4, arg_201_5)
	end

	var_0_183.add_favorite_game = var_0_183.AddFavoriteGame

	local var_198_4 = var_0_53(var_198_0, 3, "bool(__thiscall*)(void*, unsigned int, uint32_t, uint16_t, uint16_t, uint32_t)")

	function var_0_183.RemoveFavoriteGame(arg_202_0, arg_202_1, arg_202_2, arg_202_3, arg_202_4)
		return var_198_4(var_198_0, arg_202_0, arg_202_1, arg_202_2, arg_202_3, arg_202_4)
	end

	var_0_183.remove_favorite_game = var_0_183.RemoveFavoriteGame

	local var_198_5 = var_0_53(var_198_0, 4, "uint64_t(__thiscall*)(void*)")
	local var_198_6 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint32_t m_nLobbiesMatching;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nLobbiesMatching = "lobbies_matching"
		}
	}

	function var_0_183.RequestLobbyList(arg_203_0)
		if arg_203_0 ~= nil and not var_0_117(arg_203_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_203_0 = var_198_5(var_198_0)

		if arg_203_0 ~= nil then
			var_203_0 = var_0_152(var_203_0, arg_203_0, 510, var_198_6)
		end

		return var_203_0
	end

	var_0_183.request_lobby_list = var_0_183.RequestLobbyList

	local var_198_7 = var_0_53(var_198_0, 5, "void(__thiscall*)(void*, const char *, const char *, int)")

	function var_0_183.AddRequestLobbyListStringFilter(arg_204_0, arg_204_1, arg_204_2)
		arg_204_2 = var_0_160(arg_204_2, var_0_64.ELobbyComparison, "comparison_type is required")

		return var_198_7(var_198_0, arg_204_0, arg_204_1, arg_204_2)
	end

	var_0_183.add_request_lobby_list_string_filter = var_0_183.AddRequestLobbyListStringFilter

	local var_198_8 = var_0_53(var_198_0, 6, "void(__thiscall*)(void*, const char *, int, int)")

	function var_0_183.AddRequestLobbyListNumericalFilter(arg_205_0, arg_205_1, arg_205_2)
		arg_205_2 = var_0_160(arg_205_2, var_0_64.ELobbyComparison, "comparison_type is required")

		return var_198_8(var_198_0, arg_205_0, arg_205_1, arg_205_2)
	end

	var_0_183.add_request_lobby_list_numerical_filter = var_0_183.AddRequestLobbyListNumericalFilter

	local var_198_9 = var_0_53(var_198_0, 7, "void(__thiscall*)(void*, const char *, int)")

	function var_0_183.AddRequestLobbyListNearValueFilter(arg_206_0, arg_206_1)
		return var_198_9(var_198_0, arg_206_0, arg_206_1)
	end

	var_0_183.add_request_lobby_list_near_value_filter = var_0_183.AddRequestLobbyListNearValueFilter

	local var_198_10 = var_0_53(var_198_0, 8, "void(__thiscall*)(void*, int)")

	function var_0_183.AddRequestLobbyListFilterSlotsAvailable(arg_207_0)
		return var_198_10(var_198_0, arg_207_0)
	end

	var_0_183.add_request_lobby_list_filter_slots_available = var_0_183.AddRequestLobbyListFilterSlotsAvailable

	local var_198_11 = var_0_53(var_198_0, 9, "void(__thiscall*)(void*, int)")

	function var_0_183.AddRequestLobbyListDistanceFilter(arg_208_0)
		arg_208_0 = var_0_160(arg_208_0, var_0_64.ELobbyDistanceFilter, "lobby_distance_filter is required")

		return var_198_11(var_198_0, arg_208_0)
	end

	var_0_183.add_request_lobby_list_distance_filter = var_0_183.AddRequestLobbyListDistanceFilter

	local var_198_12 = var_0_53(var_198_0, 10, "void(__thiscall*)(void*, int)")

	function var_0_183.AddRequestLobbyListResultCountFilter(arg_209_0)
		return var_198_12(var_198_0, arg_209_0)
	end

	var_0_183.add_request_lobby_list_result_count_filter = var_0_183.AddRequestLobbyListResultCountFilter

	local var_198_13 = var_0_53(var_198_0, 11, "void(__thiscall*)(void*, SteamID)")

	function var_0_183.AddRequestLobbyListCompatibleMembersFilter(arg_210_0)
		arg_210_0 = var_0_158(arg_210_0, "steamid_lobby is required")

		return var_198_13(var_198_0, arg_210_0)
	end

	var_0_183.add_request_lobby_list_compatible_members_filter = var_0_183.AddRequestLobbyListCompatibleMembersFilter

	local var_198_14 = var_0_53(var_198_0, 12, "void(__thiscall*)(void*, SteamID *, int)")

	function var_0_183.GetLobbyByIndex(arg_211_0)
		local var_211_0 = var_0_165()

		var_198_14(var_198_0, var_211_0, arg_211_0)

		return var_0_60(var_211_0)
	end

	var_0_183.get_lobby_by_index = var_0_183.GetLobbyByIndex

	local var_198_15 = var_0_53(var_198_0, 13, "uint64_t(__thiscall*)(void*, int, int)")
	local var_198_16 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_ulSteamIDLobby;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_ulSteamIDLobby = "steamid_lobby"
		}
	}

	function var_0_183.CreateLobby(arg_212_0, arg_212_1, arg_212_2)
		arg_212_0 = var_0_160(arg_212_0, var_0_64.ELobbyType, "lobby_type is required")

		if arg_212_2 ~= nil and not var_0_117(arg_212_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_212_0 = var_198_15(var_198_0, arg_212_0, arg_212_1)

		if arg_212_2 ~= nil then
			var_212_0 = var_0_152(var_212_0, arg_212_2, 513, var_198_16)
		end

		return var_212_0
	end

	var_0_183.create_lobby = var_0_183.CreateLobby

	local var_198_17 = var_0_53(var_198_0, 14, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_198_18 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tSteamID m_ulSteamIDLobby;\n\t\t\t\tuint32_t m_rgfChatPermissions;\n\t\t\t\tbool m_bLocked;\n\t\t\t\tuint32_t m_EChatRoomEnterResponse;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bLocked = "locked",
			m_ulSteamIDLobby = "steamid_lobby",
			m_rgfChatPermissions = "chat_permissions",
			m_EChatRoomEnterResponse = "e_chat_room_enter_response"
		}
	}

	function var_0_183.JoinLobby(arg_213_0, arg_213_1)
		arg_213_0 = var_0_158(arg_213_0, "steamid_lobby is required")

		if arg_213_1 ~= nil and not var_0_117(arg_213_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_213_0 = var_198_17(var_198_0, arg_213_0)

		if arg_213_1 ~= nil then
			var_213_0 = var_0_152(var_213_0, arg_213_1, 504, var_198_18)
		end

		return var_213_0
	end

	var_0_183.join_lobby = var_0_183.JoinLobby

	local var_198_19 = var_0_53(var_198_0, 15, "void(__thiscall*)(void*, SteamID)")

	function var_0_183.LeaveLobby(arg_214_0)
		arg_214_0 = var_0_158(arg_214_0, "steamid_lobby is required")

		return var_198_19(var_198_0, arg_214_0)
	end

	var_0_183.leave_lobby = var_0_183.LeaveLobby

	local var_198_20 = var_0_53(var_198_0, 16, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function var_0_183.InviteUserToLobby(arg_215_0, arg_215_1)
		arg_215_0 = var_0_158(arg_215_0, "steamid_lobby is required")
		arg_215_1 = var_0_158(arg_215_1, "steamid_invitee is required")

		return var_198_20(var_198_0, arg_215_0, arg_215_1)
	end

	var_0_183.invite_user_to_lobby = var_0_183.InviteUserToLobby

	local var_198_21 = var_0_53(var_198_0, 17, "int(__thiscall*)(void*, SteamID)")

	function var_0_183.GetNumLobbyMembers(arg_216_0)
		arg_216_0 = var_0_158(arg_216_0, "steamid_lobby is required")

		return var_198_21(var_198_0, arg_216_0)
	end

	var_0_183.get_num_lobby_members = var_0_183.GetNumLobbyMembers

	local var_198_22 = var_0_53(var_198_0, 18, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function var_0_183.GetLobbyMemberByIndex(arg_217_0, arg_217_1)
		arg_217_0 = var_0_158(arg_217_0, "steamid_lobby is required")

		local var_217_0 = var_0_165()

		var_198_22(var_198_0, var_217_0, arg_217_0, arg_217_1)

		return var_0_60(var_217_0)
	end

	var_0_183.get_lobby_member_by_index = var_0_183.GetLobbyMemberByIndex

	local var_198_23 = var_0_53(var_198_0, 19, "const char *(__thiscall*)(void*, SteamID, const char *)")

	function var_0_183.GetLobbyData(arg_218_0, arg_218_1)
		arg_218_0 = var_0_158(arg_218_0, "steamid_lobby is required")

		local var_218_0 = var_198_23(var_198_0, arg_218_0, arg_218_1)

		return var_218_0 ~= nil and var_0_7(var_218_0) or nil
	end

	var_0_183.get_lobby_data = var_0_183.GetLobbyData

	local var_198_24 = var_0_53(var_198_0, 20, "bool(__thiscall*)(void*, SteamID, const char *, const char *)")

	function var_0_183.SetLobbyData(arg_219_0, arg_219_1, arg_219_2)
		arg_219_0 = var_0_158(arg_219_0, "steamid_lobby is required")

		return var_198_24(var_198_0, arg_219_0, arg_219_1, arg_219_2)
	end

	var_0_183.set_lobby_data = var_0_183.SetLobbyData

	local var_198_25 = var_0_53(var_198_0, 21, "int(__thiscall*)(void*, SteamID)")

	function var_0_183.GetLobbyDataCount(arg_220_0)
		arg_220_0 = var_0_158(arg_220_0, "steamid_lobby is required")

		return var_198_25(var_198_0, arg_220_0)
	end

	var_0_183.get_lobby_data_count = var_0_183.GetLobbyDataCount

	local var_198_26 = var_0_53(var_198_0, 22, "bool(__thiscall*)(void*, SteamID, int, char *, int, char *, int)")

	function var_0_183.GetLobbyDataByIndex(arg_221_0, arg_221_1, arg_221_2, arg_221_3, arg_221_4, arg_221_5)
		arg_221_0 = var_0_158(arg_221_0, "steamid_lobby is required")

		return var_198_26(var_198_0, arg_221_0, arg_221_1, arg_221_2, arg_221_3, arg_221_4, arg_221_5)
	end

	var_0_183.get_lobby_data_by_index = var_0_183.GetLobbyDataByIndex

	local var_198_27 = var_0_53(var_198_0, 23, "bool(__thiscall*)(void*, SteamID, const char *)")

	function var_0_183.DeleteLobbyData(arg_222_0, arg_222_1)
		arg_222_0 = var_0_158(arg_222_0, "steamid_lobby is required")

		return var_198_27(var_198_0, arg_222_0, arg_222_1)
	end

	var_0_183.delete_lobby_data = var_0_183.DeleteLobbyData

	local var_198_28 = var_0_53(var_198_0, 24, "const char *(__thiscall*)(void*, SteamID, SteamID, const char *)")

	function var_0_183.GetLobbyMemberData(arg_223_0, arg_223_1, arg_223_2)
		arg_223_0 = var_0_158(arg_223_0, "steamid_lobby is required")
		arg_223_1 = var_0_158(arg_223_1, "steamid_user is required")

		local var_223_0 = var_198_28(var_198_0, arg_223_0, arg_223_1, arg_223_2)

		return var_223_0 ~= nil and var_0_7(var_223_0) or nil
	end

	var_0_183.get_lobby_member_data = var_0_183.GetLobbyMemberData

	local var_198_29 = var_0_53(var_198_0, 25, "void(__thiscall*)(void*, SteamID, const char *, const char *)")

	function var_0_183.SetLobbyMemberData(arg_224_0, arg_224_1, arg_224_2)
		arg_224_0 = var_0_158(arg_224_0, "steamid_lobby is required")

		return var_198_29(var_198_0, arg_224_0, arg_224_1, arg_224_2)
	end

	var_0_183.set_lobby_member_data = var_0_183.SetLobbyMemberData

	local var_198_30 = var_0_53(var_198_0, 26, "bool(__thiscall*)(void*, SteamID, const void *, int)")

	function var_0_183.SendLobbyChatMsg(arg_225_0, arg_225_1, arg_225_2)
		arg_225_0 = var_0_158(arg_225_0, "steamid_lobby is required")

		return var_198_30(var_198_0, arg_225_0, arg_225_1, arg_225_2)
	end

	var_0_183.send_lobby_chat_msg = var_0_183.SendLobbyChatMsg

	local var_198_31 = var_0_53(var_198_0, 27, "int(__thiscall*)(void*, SteamID, int, SteamID *, void *, int, int *)")

	function var_0_183.GetLobbyChatEntry(arg_226_0, arg_226_1, arg_226_2, arg_226_3)
		arg_226_0 = var_0_158(arg_226_0, "steamid_lobby is required")

		local var_226_0 = var_0_165()
		local var_226_1 = var_0_171()

		return var_198_31(var_198_0, arg_226_0, arg_226_1, var_226_0, arg_226_2, arg_226_3, var_226_1), var_0_60(var_226_0), var_0_60(var_226_1)
	end

	var_0_183.get_lobby_chat_entry = var_0_183.GetLobbyChatEntry

	local var_198_32 = var_0_53(var_198_0, 28, "bool(__thiscall*)(void*, SteamID)")

	function var_0_183.RequestLobbyData(arg_227_0)
		arg_227_0 = var_0_158(arg_227_0, "steamid_lobby is required")

		return var_198_32(var_198_0, arg_227_0)
	end

	var_0_183.request_lobby_data = var_0_183.RequestLobbyData

	local var_198_33 = var_0_53(var_198_0, 29, "void(__thiscall*)(void*, SteamID, uint32_t, uint16_t, SteamID)")

	function var_0_183.SetLobbyGameServer(arg_228_0, arg_228_1, arg_228_2, arg_228_3)
		arg_228_0 = var_0_158(arg_228_0, "steamid_lobby is required")
		arg_228_1 = var_0_163(arg_228_1, "game_server_ip is required")
		arg_228_3 = var_0_158(arg_228_3, "steamid_game_server is required")

		return var_198_33(var_198_0, arg_228_0, arg_228_1, arg_228_2, arg_228_3)
	end

	var_0_183.set_lobby_game_server = var_0_183.SetLobbyGameServer

	local var_198_34 = var_0_53(var_198_0, 30, "bool(__thiscall*)(void*, SteamID, uint32_t *, uint16_t *, SteamID *)")

	function var_0_183.GetLobbyGameServer(arg_229_0)
		arg_229_0 = var_0_158(arg_229_0, "steamid_lobby is required")

		local var_229_0 = var_0_173()
		local var_229_1 = var_0_172()
		local var_229_2 = var_0_165()

		return var_198_34(var_198_0, arg_229_0, var_229_0, var_229_1, var_229_2), var_0_60(var_229_0), var_0_60(var_229_1), var_0_60(var_229_2)
	end

	var_0_183.get_lobby_game_server = var_0_183.GetLobbyGameServer

	local var_198_35 = var_0_53(var_198_0, 31, "bool(__thiscall*)(void*, SteamID, int)")

	function var_0_183.SetLobbyMemberLimit(arg_230_0, arg_230_1)
		arg_230_0 = var_0_158(arg_230_0, "steamid_lobby is required")

		return var_198_35(var_198_0, arg_230_0, arg_230_1)
	end

	var_0_183.set_lobby_member_limit = var_0_183.SetLobbyMemberLimit

	local var_198_36 = var_0_53(var_198_0, 32, "int(__thiscall*)(void*, SteamID)")

	function var_0_183.GetLobbyMemberLimit(arg_231_0)
		arg_231_0 = var_0_158(arg_231_0, "steamid_lobby is required")

		return var_198_36(var_198_0, arg_231_0)
	end

	var_0_183.get_lobby_member_limit = var_0_183.GetLobbyMemberLimit

	local var_198_37 = var_0_53(var_198_0, 33, "bool(__thiscall*)(void*, SteamID, int)")

	function var_0_183.SetLobbyType(arg_232_0, arg_232_1)
		arg_232_0 = var_0_158(arg_232_0, "steamid_lobby is required")
		arg_232_1 = var_0_160(arg_232_1, var_0_64.ELobbyType, "lobby_type is required")

		return var_198_37(var_198_0, arg_232_0, arg_232_1)
	end

	var_0_183.set_lobby_type = var_0_183.SetLobbyType

	local var_198_38 = var_0_53(var_198_0, 34, "bool(__thiscall*)(void*, SteamID, bool)")

	function var_0_183.SetLobbyJoinable(arg_233_0, arg_233_1)
		arg_233_0 = var_0_158(arg_233_0, "steamid_lobby is required")

		return var_198_38(var_198_0, arg_233_0, arg_233_1)
	end

	var_0_183.set_lobby_joinable = var_0_183.SetLobbyJoinable

	local var_198_39 = var_0_53(var_198_0, 35, "void(__thiscall*)(void*, SteamID *, SteamID)")

	function var_0_183.GetLobbyOwner(arg_234_0)
		arg_234_0 = var_0_158(arg_234_0, "steamid_lobby is required")

		local var_234_0 = var_0_165()

		var_198_39(var_198_0, var_234_0, arg_234_0)

		return var_0_60(var_234_0)
	end

	var_0_183.get_lobby_owner = var_0_183.GetLobbyOwner

	local var_198_40 = var_0_53(var_198_0, 36, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function var_0_183.SetLobbyOwner(arg_235_0, arg_235_1)
		arg_235_0 = var_0_158(arg_235_0, "steamid_lobby is required")
		arg_235_1 = var_0_158(arg_235_1, "steamid_new_owner is required")

		return var_198_40(var_198_0, arg_235_0, arg_235_1)
	end

	var_0_183.set_lobby_owner = var_0_183.SetLobbyOwner

	local var_198_41 = var_0_53(var_198_0, 37, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function var_0_183.SetLinkedLobby(arg_236_0, arg_236_1)
		arg_236_0 = var_0_158(arg_236_0, "steamid_lobby is required")
		arg_236_1 = var_0_158(arg_236_1, "steamid_lobby_dependent is required")

		return var_198_41(var_198_0, arg_236_0, arg_236_1)
	end

	var_0_183.set_linked_lobby = var_0_183.SetLinkedLobby

	return var_0_183
end

local var_0_184 = {}

var_0_61.ISteamMatchmakingServerListResponse = var_0_184

var_0_56("ISteamMatchmakingServerListResponse", "\t\ttypedef struct _ISteamMatchmakingServerListResponse {\n\t\t\tvoid* vtbl;\n\t\t\tstruct {\n\t\t\t\tvoid(__thiscall* ServerResponded)(void*, void *, int);\n\t\t\t\tvoid(__thiscall* ServerFailedToRespond)(void*, void *, int);\n\t\t\t\tvoid(__thiscall* RefreshComplete)(void*, void *, int);\n\t\t\t} vtbl_storage[1];\n\t\t} ISteamMatchmakingServerListResponse;\n\t")

local var_0_185 = var_0_4("struct _ISteamMatchmakingServerListResponse[1]")
local var_0_186 = var_0_4("struct _ISteamMatchmakingServerListResponse*")
local var_0_187
local var_0_188
local var_0_189 = {}

function var_0_184.new(arg_237_0)
	if var_0_27(arg_237_0) ~= "table" then
		return var_0_26("Invalid user_callbacks, expected table", 2)
	end

	if var_0_188 == nil then
		var_0_187 = {
			ServerResponded = {},
			ServerFailedToRespond = {},
			RefreshComplete = {}
		}
		var_0_188 = {
			ServerResponded = var_0_2(var_0_4("void(__thiscall*)(void*, void *, int)"), var_0_157(var_0_187.ServerResponded)),
			ServerFailedToRespond = var_0_2(var_0_4("void(__thiscall*)(void*, void *, int)"), var_0_157(var_0_187.ServerFailedToRespond)),
			RefreshComplete = var_0_2(var_0_4("void(__thiscall*)(void*, void *, int)"), var_0_157(var_0_187.RefreshComplete))
		}
	end

	for iter_237_0, iter_237_1 in var_0_22(arg_237_0) do
		if var_0_188[iter_237_0] == nil then
			return var_0_26("Unknown callback: " .. var_0_19(iter_237_0), 2)
		elseif var_0_27(iter_237_1) ~= "function" then
			return var_0_26(var_0_16("Invalid callback type for %s: %s", var_0_19(iter_237_0), var_0_27(iter_237_1)), 2)
		end
	end

	local var_237_0 = var_0_185()
	local var_237_1 = var_0_2(var_0_186, var_237_0)
	local var_237_2 = var_0_54(var_237_1)

	for iter_237_2, iter_237_3 in var_0_22(var_0_188) do
		if arg_237_0[iter_237_2] ~= nil then
			var_0_187[iter_237_2][var_237_2] = arg_237_0[iter_237_2]
		end
	end

	for iter_237_4, iter_237_5 in var_0_22(var_0_188) do
		var_237_1.vtbl_storage[0][iter_237_4] = iter_237_5
	end

	var_237_1.vtbl = var_237_1.vtbl_storage
	var_0_189[var_237_2] = var_237_0

	return var_237_1
end

local var_0_190 = {}

var_0_61.ISteamMatchmakingPingResponse = var_0_190

var_0_56("ISteamMatchmakingPingResponse", "\t\ttypedef struct _ISteamMatchmakingPingResponse {\n\t\t\tvoid* vtbl;\n\t\t\tstruct {\n\t\t\t\tvoid(__thiscall* ServerResponded)(void*, gameserveritem_t &);\n\t\t\t\tvoid(__thiscall* ServerFailedToRespond)(void*);\n\t\t\t} vtbl_storage[1];\n\t\t} ISteamMatchmakingPingResponse;\n\t")

local var_0_191 = var_0_4("struct _ISteamMatchmakingPingResponse[1]")
local var_0_192 = var_0_4("struct _ISteamMatchmakingPingResponse*")
local var_0_193
local var_0_194
local var_0_195 = {}

function var_0_190.new(arg_238_0)
	if var_0_27(arg_238_0) ~= "table" then
		return var_0_26("Invalid user_callbacks, expected table", 2)
	end

	if var_0_194 == nil then
		var_0_193 = {
			ServerResponded = {},
			ServerFailedToRespond = {}
		}
		var_0_194 = {
			ServerResponded = var_0_2(var_0_4("void(__thiscall*)(void*, gameserveritem_t &)"), var_0_157(var_0_193.ServerResponded)),
			ServerFailedToRespond = var_0_2(var_0_4("void(__thiscall*)(void*)"), var_0_157(var_0_193.ServerFailedToRespond))
		}
	end

	for iter_238_0, iter_238_1 in var_0_22(arg_238_0) do
		if var_0_194[iter_238_0] == nil then
			return var_0_26("Unknown callback: " .. var_0_19(iter_238_0), 2)
		elseif var_0_27(iter_238_1) ~= "function" then
			return var_0_26(var_0_16("Invalid callback type for %s: %s", var_0_19(iter_238_0), var_0_27(iter_238_1)), 2)
		end
	end

	local var_238_0 = var_0_191()
	local var_238_1 = var_0_2(var_0_192, var_238_0)
	local var_238_2 = var_0_54(var_238_1)

	for iter_238_2, iter_238_3 in var_0_22(var_0_194) do
		if arg_238_0[iter_238_2] ~= nil then
			var_0_193[iter_238_2][var_238_2] = arg_238_0[iter_238_2]
		end
	end

	for iter_238_4, iter_238_5 in var_0_22(var_0_194) do
		var_238_1.vtbl_storage[0][iter_238_4] = iter_238_5
	end

	var_238_1.vtbl = var_238_1.vtbl_storage
	var_0_195[var_238_2] = var_238_0

	return var_238_1
end

local var_0_196 = {}

var_0_61.ISteamMatchmakingPlayersResponse = var_0_196

var_0_56("ISteamMatchmakingPlayersResponse", "\t\ttypedef struct _ISteamMatchmakingPlayersResponse {\n\t\t\tvoid* vtbl;\n\t\t\tstruct {\n\t\t\t\tvoid(__thiscall* AddPlayerToList)(void*, const char *, int, float);\n\t\t\t\tvoid(__thiscall* PlayersFailedToRespond)(void*);\n\t\t\t\tvoid(__thiscall* PlayersRefreshComplete)(void*);\n\t\t\t} vtbl_storage[1];\n\t\t} ISteamMatchmakingPlayersResponse;\n\t")

local var_0_197 = var_0_4("struct _ISteamMatchmakingPlayersResponse[1]")
local var_0_198 = var_0_4("struct _ISteamMatchmakingPlayersResponse*")
local var_0_199
local var_0_200
local var_0_201 = {}

function var_0_196.new(arg_239_0)
	if var_0_27(arg_239_0) ~= "table" then
		return var_0_26("Invalid user_callbacks, expected table", 2)
	end

	if var_0_200 == nil then
		var_0_199 = {
			AddPlayerToList = {},
			PlayersFailedToRespond = {},
			PlayersRefreshComplete = {}
		}
		var_0_200 = {
			AddPlayerToList = var_0_2(var_0_4("void(__thiscall*)(void*, const char *, int, float)"), var_0_157(var_0_199.AddPlayerToList)),
			PlayersFailedToRespond = var_0_2(var_0_4("void(__thiscall*)(void*)"), var_0_157(var_0_199.PlayersFailedToRespond)),
			PlayersRefreshComplete = var_0_2(var_0_4("void(__thiscall*)(void*)"), var_0_157(var_0_199.PlayersRefreshComplete))
		}
	end

	for iter_239_0, iter_239_1 in var_0_22(arg_239_0) do
		if var_0_200[iter_239_0] == nil then
			return var_0_26("Unknown callback: " .. var_0_19(iter_239_0), 2)
		elseif var_0_27(iter_239_1) ~= "function" then
			return var_0_26(var_0_16("Invalid callback type for %s: %s", var_0_19(iter_239_0), var_0_27(iter_239_1)), 2)
		end
	end

	local var_239_0 = var_0_197()
	local var_239_1 = var_0_2(var_0_198, var_239_0)
	local var_239_2 = var_0_54(var_239_1)

	for iter_239_2, iter_239_3 in var_0_22(var_0_200) do
		if arg_239_0[iter_239_2] ~= nil then
			var_0_199[iter_239_2][var_239_2] = arg_239_0[iter_239_2]
		end
	end

	for iter_239_4, iter_239_5 in var_0_22(var_0_200) do
		var_239_1.vtbl_storage[0][iter_239_4] = iter_239_5
	end

	var_239_1.vtbl = var_239_1.vtbl_storage
	var_0_201[var_239_2] = var_239_0

	return var_239_1
end

local var_0_202 = {}

var_0_61.ISteamMatchmakingRulesResponse = var_0_202

var_0_56("ISteamMatchmakingRulesResponse", "\t\ttypedef struct _ISteamMatchmakingRulesResponse {\n\t\t\tvoid* vtbl;\n\t\t\tstruct {\n\t\t\t\tvoid(__thiscall* RulesResponded)(void*, const char *, const char *);\n\t\t\t\tvoid(__thiscall* RulesFailedToRespond)(void*);\n\t\t\t\tvoid(__thiscall* RulesRefreshComplete)(void*);\n\t\t\t} vtbl_storage[1];\n\t\t} ISteamMatchmakingRulesResponse;\n\t")

local var_0_203 = var_0_4("struct _ISteamMatchmakingRulesResponse[1]")
local var_0_204 = var_0_4("struct _ISteamMatchmakingRulesResponse*")
local var_0_205
local var_0_206
local var_0_207 = {}

function var_0_202.new(arg_240_0)
	if var_0_27(arg_240_0) ~= "table" then
		return var_0_26("Invalid user_callbacks, expected table", 2)
	end

	if var_0_206 == nil then
		var_0_205 = {
			RulesResponded = {},
			RulesFailedToRespond = {},
			RulesRefreshComplete = {}
		}
		var_0_206 = {
			RulesResponded = var_0_2(var_0_4("void(__thiscall*)(void*, const char *, const char *)"), var_0_157(var_0_205.RulesResponded)),
			RulesFailedToRespond = var_0_2(var_0_4("void(__thiscall*)(void*)"), var_0_157(var_0_205.RulesFailedToRespond)),
			RulesRefreshComplete = var_0_2(var_0_4("void(__thiscall*)(void*)"), var_0_157(var_0_205.RulesRefreshComplete))
		}
	end

	for iter_240_0, iter_240_1 in var_0_22(arg_240_0) do
		if var_0_206[iter_240_0] == nil then
			return var_0_26("Unknown callback: " .. var_0_19(iter_240_0), 2)
		elseif var_0_27(iter_240_1) ~= "function" then
			return var_0_26(var_0_16("Invalid callback type for %s: %s", var_0_19(iter_240_0), var_0_27(iter_240_1)), 2)
		end
	end

	local var_240_0 = var_0_203()
	local var_240_1 = var_0_2(var_0_204, var_240_0)
	local var_240_2 = var_0_54(var_240_1)

	for iter_240_2, iter_240_3 in var_0_22(var_0_206) do
		if arg_240_0[iter_240_2] ~= nil then
			var_0_205[iter_240_2][var_240_2] = arg_240_0[iter_240_2]
		end
	end

	for iter_240_4, iter_240_5 in var_0_22(var_0_206) do
		var_240_1.vtbl_storage[0][iter_240_4] = iter_240_5
	end

	var_240_1.vtbl = var_240_1.vtbl_storage
	var_0_207[var_240_2] = var_240_0

	return var_240_1
end

local var_0_208 = {
	version = "SteamMatchMakingServers002",
	version_number = 2
}

function var_0_62.ISteamMatchmakingServers()
	local var_241_0 = vtable_bind("steamclient.dll", "SteamClient020", 11, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "SteamMatchMakingServers002")

	var_0_208.thisptr = var_241_0

	local var_241_1 = var_0_53(var_241_0, 0, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function var_0_208.RequestInternetServerList(arg_242_0, arg_242_1, arg_242_2, arg_242_3)
		return var_241_1(var_241_0, arg_242_0, arg_242_1, arg_242_2, arg_242_3)
	end

	var_0_208.request_internet_server_list = var_0_208.RequestInternetServerList

	local var_241_2 = var_0_53(var_241_0, 1, "void *(__thiscall*)(void*, unsigned int, ISteamMatchmakingServerListResponse *)")

	function var_0_208.RequestLANServerList(arg_243_0, arg_243_1)
		return var_241_2(var_241_0, arg_243_0, arg_243_1)
	end

	var_0_208.request_lan_server_list = var_0_208.RequestLANServerList

	local var_241_3 = var_0_53(var_241_0, 2, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function var_0_208.RequestFriendsServerList(arg_244_0, arg_244_1, arg_244_2, arg_244_3)
		return var_241_3(var_241_0, arg_244_0, arg_244_1, arg_244_2, arg_244_3)
	end

	var_0_208.request_friends_server_list = var_0_208.RequestFriendsServerList

	local var_241_4 = var_0_53(var_241_0, 3, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function var_0_208.RequestFavoritesServerList(arg_245_0, arg_245_1, arg_245_2, arg_245_3)
		return var_241_4(var_241_0, arg_245_0, arg_245_1, arg_245_2, arg_245_3)
	end

	var_0_208.request_favorites_server_list = var_0_208.RequestFavoritesServerList

	local var_241_5 = var_0_53(var_241_0, 4, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function var_0_208.RequestHistoryServerList(arg_246_0, arg_246_1, arg_246_2, arg_246_3)
		return var_241_5(var_241_0, arg_246_0, arg_246_1, arg_246_2, arg_246_3)
	end

	var_0_208.request_history_server_list = var_0_208.RequestHistoryServerList

	local var_241_6 = var_0_53(var_241_0, 5, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function var_0_208.RequestSpectatorServerList(arg_247_0, arg_247_1, arg_247_2, arg_247_3)
		return var_241_6(var_241_0, arg_247_0, arg_247_1, arg_247_2, arg_247_3)
	end

	var_0_208.request_spectator_server_list = var_0_208.RequestSpectatorServerList

	local var_241_7 = var_0_53(var_241_0, 6, "void(__thiscall*)(void*, void *)")

	function var_0_208.ReleaseRequest(arg_248_0)
		return var_241_7(var_241_0, arg_248_0)
	end

	var_0_208.release_request = var_0_208.ReleaseRequest

	local var_241_8 = var_0_53(var_241_0, 7, "gameserveritem_t *(__thiscall*)(void*, void *, int)")

	function var_0_208.GetServerDetails(arg_249_0, arg_249_1)
		return var_241_8(var_241_0, arg_249_0, arg_249_1)
	end

	var_0_208.get_server_details = var_0_208.GetServerDetails

	local var_241_9 = var_0_53(var_241_0, 8, "void(__thiscall*)(void*, void *)")

	function var_0_208.CancelQuery(arg_250_0)
		return var_241_9(var_241_0, arg_250_0)
	end

	var_0_208.cancel_query = var_0_208.CancelQuery

	local var_241_10 = var_0_53(var_241_0, 9, "void(__thiscall*)(void*, void *)")

	function var_0_208.RefreshQuery(arg_251_0)
		return var_241_10(var_241_0, arg_251_0)
	end

	var_0_208.refresh_query = var_0_208.RefreshQuery

	local var_241_11 = var_0_53(var_241_0, 10, "bool(__thiscall*)(void*, void *)")

	function var_0_208.IsRefreshing(arg_252_0)
		return var_241_11(var_241_0, arg_252_0)
	end

	var_0_208.is_refreshing = var_0_208.IsRefreshing

	local var_241_12 = var_0_53(var_241_0, 11, "int(__thiscall*)(void*, void *)")

	function var_0_208.GetServerCount(arg_253_0)
		return var_241_12(var_241_0, arg_253_0)
	end

	var_0_208.get_server_count = var_0_208.GetServerCount

	local var_241_13 = var_0_53(var_241_0, 12, "void(__thiscall*)(void*, void *, int)")

	function var_0_208.RefreshServer(arg_254_0, arg_254_1)
		return var_241_13(var_241_0, arg_254_0, arg_254_1)
	end

	var_0_208.refresh_server = var_0_208.RefreshServer

	local var_241_14 = var_0_53(var_241_0, 13, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingPingResponse *)")

	function var_0_208.PingServer(arg_255_0, arg_255_1, arg_255_2)
		arg_255_0 = var_0_163(arg_255_0, "ip is required")

		return var_241_14(var_241_0, arg_255_0, arg_255_1, arg_255_2)
	end

	var_0_208.ping_server = var_0_208.PingServer

	local var_241_15 = var_0_53(var_241_0, 14, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingPlayersResponse *)")

	function var_0_208.PlayerDetails(arg_256_0, arg_256_1, arg_256_2)
		arg_256_0 = var_0_163(arg_256_0, "ip is required")

		return var_241_15(var_241_0, arg_256_0, arg_256_1, arg_256_2)
	end

	var_0_208.player_details = var_0_208.PlayerDetails

	local var_241_16 = var_0_53(var_241_0, 15, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingRulesResponse *)")

	function var_0_208.ServerRules(arg_257_0, arg_257_1, arg_257_2)
		arg_257_0 = var_0_163(arg_257_0, "ip is required")

		return var_241_16(var_241_0, arg_257_0, arg_257_1, arg_257_2)
	end

	var_0_208.server_rules = var_0_208.ServerRules

	local var_241_17 = var_0_53(var_241_0, 16, "void(__thiscall*)(void*, int)")

	function var_0_208.CancelServerQuery(arg_258_0)
		return var_241_17(var_241_0, arg_258_0)
	end

	var_0_208.cancel_server_query = var_0_208.CancelServerQuery

	return var_0_208
end

local var_0_209 = {
	version = "STEAMUSERSTATS_INTERFACE_VERSION012",
	version_number = 12
}

function var_0_62.ISteamUserStats()
	local var_259_0 = vtable_bind("steamclient.dll", "SteamClient020", 13, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMUSERSTATS_INTERFACE_VERSION012")

	var_0_209.thisptr = var_259_0

	local var_259_1 = var_0_53(var_259_0, 0, "bool(__thiscall*)(void*)")

	function var_0_209.RequestCurrentStats()
		return var_259_1(var_259_0)
	end

	var_0_209.request_current_stats = var_0_209.RequestCurrentStats

	local var_259_2 = var_0_53(var_259_0, 1, "bool(__thiscall*)(void*, const char *, int32_t *)")

	function var_0_209.GetStatInt32(arg_261_0)
		local var_261_0 = var_0_169()

		return var_259_2(var_259_0, arg_261_0, var_261_0), var_0_60(var_261_0)
	end

	var_0_209.get_stat_int32 = var_0_209.GetStatInt32

	local var_259_3 = var_0_53(var_259_0, 2, "bool(__thiscall*)(void*, const char *, float *)")

	function var_0_209.GetStatFloat(arg_262_0)
		local var_262_0 = var_0_168()

		return var_259_3(var_259_0, arg_262_0, var_262_0), var_0_60(var_262_0)
	end

	var_0_209.get_stat_float = var_0_209.GetStatFloat

	local var_259_4 = var_0_53(var_259_0, 3, "bool(__thiscall*)(void*, const char *, int32_t)")

	function var_0_209.SetStatInt32(arg_263_0, arg_263_1)
		return var_259_4(var_259_0, arg_263_0, arg_263_1)
	end

	var_0_209.set_stat_int32 = var_0_209.SetStatInt32

	local var_259_5 = var_0_53(var_259_0, 4, "bool(__thiscall*)(void*, const char *, float)")

	function var_0_209.SetStatFloat(arg_264_0, arg_264_1)
		return var_259_5(var_259_0, arg_264_0, arg_264_1)
	end

	var_0_209.set_stat_float = var_0_209.SetStatFloat

	local var_259_6 = var_0_53(var_259_0, 5, "bool(__thiscall*)(void*, const char *, float, double)")

	function var_0_209.UpdateAvgRateStat(arg_265_0, arg_265_1, arg_265_2)
		return var_259_6(var_259_0, arg_265_0, arg_265_1, arg_265_2)
	end

	var_0_209.update_avg_rate_stat = var_0_209.UpdateAvgRateStat

	local var_259_7 = var_0_53(var_259_0, 6, "bool(__thiscall*)(void*, const char *, bool *)")

	function var_0_209.GetAchievement(arg_266_0)
		local var_266_0 = var_0_166()

		return var_259_7(var_259_0, arg_266_0, var_266_0), var_0_60(var_266_0)
	end

	var_0_209.get_achievement = var_0_209.GetAchievement

	local var_259_8 = var_0_53(var_259_0, 7, "bool(__thiscall*)(void*, const char *)")

	function var_0_209.SetAchievement(arg_267_0)
		return var_259_8(var_259_0, arg_267_0)
	end

	var_0_209.set_achievement = var_0_209.SetAchievement

	local var_259_9 = var_0_53(var_259_0, 8, "bool(__thiscall*)(void*, const char *)")

	function var_0_209.ClearAchievement(arg_268_0)
		return var_259_9(var_259_0, arg_268_0)
	end

	var_0_209.clear_achievement = var_0_209.ClearAchievement

	local var_259_10 = var_0_53(var_259_0, 9, "bool(__thiscall*)(void*, const char *, bool *, uint32_t *)")

	function var_0_209.GetAchievementAndUnlockTime(arg_269_0)
		local var_269_0 = var_0_166()
		local var_269_1 = var_0_173()

		return var_259_10(var_259_0, arg_269_0, var_269_0, var_269_1), var_0_60(var_269_0), var_0_60(var_269_1)
	end

	var_0_209.get_achievement_and_unlock_time = var_0_209.GetAchievementAndUnlockTime

	local var_259_11 = var_0_53(var_259_0, 10, "bool(__thiscall*)(void*)")

	function var_0_209.StoreStats()
		return var_259_11(var_259_0)
	end

	var_0_209.store_stats = var_0_209.StoreStats

	local var_259_12 = var_0_53(var_259_0, 11, "int(__thiscall*)(void*, const char *)")

	function var_0_209.GetAchievementIcon(arg_271_0)
		return var_259_12(var_259_0, arg_271_0)
	end

	var_0_209.get_achievement_icon = var_0_209.GetAchievementIcon

	local var_259_13 = var_0_53(var_259_0, 12, "const char *(__thiscall*)(void*, const char *, const char *)")

	function var_0_209.GetAchievementDisplayAttribute(arg_272_0, arg_272_1)
		local var_272_0 = var_259_13(var_259_0, arg_272_0, arg_272_1)

		return var_272_0 ~= nil and var_0_7(var_272_0) or nil
	end

	var_0_209.get_achievement_display_attribute = var_0_209.GetAchievementDisplayAttribute

	local var_259_14 = var_0_53(var_259_0, 13, "bool(__thiscall*)(void*, const char *, uint32_t, uint32_t)")

	function var_0_209.IndicateAchievementProgress(arg_273_0, arg_273_1, arg_273_2)
		return var_259_14(var_259_0, arg_273_0, arg_273_1, arg_273_2)
	end

	var_0_209.indicate_achievement_progress = var_0_209.IndicateAchievementProgress

	local var_259_15 = var_0_53(var_259_0, 14, "uint32_t(__thiscall*)(void*)")

	function var_0_209.GetNumAchievements()
		return var_259_15(var_259_0)
	end

	var_0_209.get_num_achievements = var_0_209.GetNumAchievements

	local var_259_16 = var_0_53(var_259_0, 15, "const char *(__thiscall*)(void*, uint32_t)")

	function var_0_209.GetAchievementName(arg_275_0)
		local var_275_0 = var_259_16(var_259_0, arg_275_0)

		return var_275_0 ~= nil and var_0_7(var_275_0) or nil
	end

	var_0_209.get_achievement_name = var_0_209.GetAchievementName

	local var_259_17 = var_0_53(var_259_0, 16, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_259_18 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_nGameID;\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_steamIDUser;\n\t\t\t} *\n\t\t"),
		keys = {
			m_steamIDUser = "steamid_user",
			m_eResult = "result",
			m_nGameID = "game_id"
		}
	}

	function var_0_209.RequestUserStats(arg_276_0, arg_276_1)
		arg_276_0 = var_0_158(arg_276_0, "steamid_user is required")

		if arg_276_1 ~= nil and not var_0_117(arg_276_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_276_0 = var_259_17(var_259_0, arg_276_0)

		if arg_276_1 ~= nil then
			var_276_0 = var_0_152(var_276_0, arg_276_1, 1101, var_259_18)
		end

		return var_276_0
	end

	var_0_209.request_user_stats = var_0_209.RequestUserStats

	local var_259_19 = var_0_53(var_259_0, 17, "bool(__thiscall*)(void*, SteamID, const char *, int32_t *)")

	function var_0_209.GetUserStatInt32(arg_277_0, arg_277_1)
		arg_277_0 = var_0_158(arg_277_0, "steamid_user is required")

		local var_277_0 = var_0_169()

		return var_259_19(var_259_0, arg_277_0, arg_277_1, var_277_0), var_0_60(var_277_0)
	end

	var_0_209.get_user_stat_int32 = var_0_209.GetUserStatInt32

	local var_259_20 = var_0_53(var_259_0, 18, "bool(__thiscall*)(void*, SteamID, const char *, float *)")

	function var_0_209.GetUserStatFloat(arg_278_0, arg_278_1)
		arg_278_0 = var_0_158(arg_278_0, "steamid_user is required")

		local var_278_0 = var_0_168()

		return var_259_20(var_259_0, arg_278_0, arg_278_1, var_278_0), var_0_60(var_278_0)
	end

	var_0_209.get_user_stat_float = var_0_209.GetUserStatFloat

	local var_259_21 = var_0_53(var_259_0, 19, "bool(__thiscall*)(void*, SteamID, const char *, bool *)")

	function var_0_209.GetUserAchievement(arg_279_0, arg_279_1)
		arg_279_0 = var_0_158(arg_279_0, "steamid_user is required")

		local var_279_0 = var_0_166()

		return var_259_21(var_259_0, arg_279_0, arg_279_1, var_279_0), var_0_60(var_279_0)
	end

	var_0_209.get_user_achievement = var_0_209.GetUserAchievement

	local var_259_22 = var_0_53(var_259_0, 20, "bool(__thiscall*)(void*, SteamID, const char *, bool *, uint32_t *)")

	function var_0_209.GetUserAchievementAndUnlockTime(arg_280_0, arg_280_1)
		arg_280_0 = var_0_158(arg_280_0, "steamid_user is required")

		local var_280_0 = var_0_166()
		local var_280_1 = var_0_173()

		return var_259_22(var_259_0, arg_280_0, arg_280_1, var_280_0, var_280_1), var_0_60(var_280_0), var_0_60(var_280_1)
	end

	var_0_209.get_user_achievement_and_unlock_time = var_0_209.GetUserAchievementAndUnlockTime

	local var_259_23 = var_0_53(var_259_0, 21, "bool(__thiscall*)(void*, bool)")

	function var_0_209.ResetAllStats(arg_281_0)
		return var_259_23(var_259_0, arg_281_0)
	end

	var_0_209.reset_all_stats = var_0_209.ResetAllStats

	local var_259_24 = var_0_53(var_259_0, 22, "uint64_t(__thiscall*)(void*, const char *, int, int)")
	local var_259_25 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_hSteamLeaderboard;\n\t\t\t\tbool m_bLeaderboardFound;\n\t\t\t} *\n\t\t"),
		keys = {
			m_hSteamLeaderboard = "steam_leaderboard",
			m_bLeaderboardFound = "leaderboard_found"
		}
	}

	function var_0_209.FindOrCreateLeaderboard(arg_282_0, arg_282_1, arg_282_2, arg_282_3)
		arg_282_1 = var_0_160(arg_282_1, var_0_64.ELeaderboardSortMethod, "leaderboard_sort_method is required")
		arg_282_2 = var_0_160(arg_282_2, var_0_64.ELeaderboardDisplayType, "leaderboard_display_type is required")

		if arg_282_3 ~= nil and not var_0_117(arg_282_3) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_282_0 = var_259_24(var_259_0, arg_282_0, arg_282_1, arg_282_2)

		if arg_282_3 ~= nil then
			var_282_0 = var_0_152(var_282_0, arg_282_3, 1104, var_259_25)
		end

		return var_282_0
	end

	var_0_209.find_or_create_leaderboard = var_0_209.FindOrCreateLeaderboard

	local var_259_26 = var_0_53(var_259_0, 23, "uint64_t(__thiscall*)(void*, const char *)")
	local var_259_27 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_hSteamLeaderboard;\n\t\t\t\tbool m_bLeaderboardFound;\n\t\t\t} *\n\t\t"),
		keys = {
			m_hSteamLeaderboard = "steam_leaderboard",
			m_bLeaderboardFound = "leaderboard_found"
		}
	}

	function var_0_209.FindLeaderboard(arg_283_0, arg_283_1)
		if arg_283_1 ~= nil and not var_0_117(arg_283_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_283_0 = var_259_26(var_259_0, arg_283_0)

		if arg_283_1 ~= nil then
			var_283_0 = var_0_152(var_283_0, arg_283_1, 1104, var_259_27)
		end

		return var_283_0
	end

	var_0_209.find_leaderboard = var_0_209.FindLeaderboard

	local var_259_28 = var_0_53(var_259_0, 24, "const char *(__thiscall*)(void*, uint64_t)")

	function var_0_209.GetLeaderboardName(arg_284_0)
		local var_284_0 = var_259_28(var_259_0, arg_284_0)

		return var_284_0 ~= nil and var_0_7(var_284_0) or nil
	end

	var_0_209.get_leaderboard_name = var_0_209.GetLeaderboardName

	local var_259_29 = var_0_53(var_259_0, 25, "int(__thiscall*)(void*, uint64_t)")

	function var_0_209.GetLeaderboardEntryCount(arg_285_0)
		return var_259_29(var_259_0, arg_285_0)
	end

	var_0_209.get_leaderboard_entry_count = var_0_209.GetLeaderboardEntryCount

	local var_259_30 = var_0_53(var_259_0, 26, "int(__thiscall*)(void*, uint64_t)")

	function var_0_209.GetLeaderboardSortMethod(arg_286_0)
		return var_259_30(var_259_0, arg_286_0)
	end

	var_0_209.get_leaderboard_sort_method = var_0_209.GetLeaderboardSortMethod

	local var_259_31 = var_0_53(var_259_0, 27, "int(__thiscall*)(void*, uint64_t)")

	function var_0_209.GetLeaderboardDisplayType(arg_287_0)
		return var_259_31(var_259_0, arg_287_0)
	end

	var_0_209.get_leaderboard_display_type = var_0_209.GetLeaderboardDisplayType

	local var_259_32 = var_0_53(var_259_0, 28, "uint64_t(__thiscall*)(void*, uint64_t, int, int, int)")
	local var_259_33 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_hSteamLeaderboard;\n\t\t\t\tuint64_t m_hSteamLeaderboardEntries;\n\t\t\t\tint m_cEntryCount;\n\t\t\t} *\n\t\t"),
		keys = {
			m_hSteamLeaderboard = "steam_leaderboard",
			m_cEntryCount = "entry_count",
			m_hSteamLeaderboardEntries = "steam_leaderboard_entries"
		}
	}

	function var_0_209.DownloadLeaderboardEntries(arg_288_0, arg_288_1, arg_288_2, arg_288_3, arg_288_4)
		arg_288_1 = var_0_160(arg_288_1, var_0_64.ELeaderboardDataRequest, "leaderboard_data_request is required")

		if arg_288_4 ~= nil and not var_0_117(arg_288_4) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_288_0 = var_259_32(var_259_0, arg_288_0, arg_288_1, arg_288_2, arg_288_3)

		if arg_288_4 ~= nil then
			var_288_0 = var_0_152(var_288_0, arg_288_4, 1105, var_259_33)
		end

		return var_288_0
	end

	var_0_209.download_leaderboard_entries = var_0_209.DownloadLeaderboardEntries

	local var_259_34 = var_0_53(var_259_0, 29, "uint64_t(__thiscall*)(void*, uint64_t, SteamID *, int)")
	local var_259_35 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_hSteamLeaderboard;\n\t\t\t\tuint64_t m_hSteamLeaderboardEntries;\n\t\t\t\tint m_cEntryCount;\n\t\t\t} *\n\t\t"),
		keys = {
			m_hSteamLeaderboard = "steam_leaderboard",
			m_cEntryCount = "entry_count",
			m_hSteamLeaderboardEntries = "steam_leaderboard_entries"
		}
	}

	function var_0_209.DownloadLeaderboardEntriesForUsers(arg_289_0, arg_289_1, arg_289_2, arg_289_3)
		if arg_289_3 ~= nil and not var_0_117(arg_289_3) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_289_0 = var_259_34(var_259_0, arg_289_0, arg_289_1, arg_289_2)

		if arg_289_3 ~= nil then
			var_289_0 = var_0_152(var_289_0, arg_289_3, 1105, var_259_35)
		end

		return var_289_0
	end

	var_0_209.download_leaderboard_entries_for_users = var_0_209.DownloadLeaderboardEntriesForUsers

	local var_259_36 = var_0_53(var_259_0, 30, "bool(__thiscall*)(void*, uint64_t, int, LeaderboardEntry_t *, int32_t *, int)")

	function var_0_209.GetDownloadedLeaderboardEntry(arg_290_0, arg_290_1, arg_290_2, arg_290_3)
		local var_290_0 = var_0_103.LeaderboardEntry_t_arr(1)

		return var_259_36(var_259_0, arg_290_0, arg_290_1, var_290_0, arg_290_2, arg_290_3), var_0_60(var_290_0)
	end

	var_0_209.get_downloaded_leaderboard_entry = var_0_209.GetDownloadedLeaderboardEntry

	local var_259_37 = var_0_53(var_259_0, 31, "uint64_t(__thiscall*)(void*, uint64_t, int, int32_t, const int32_t *, int)")
	local var_259_38 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tbool m_bSuccess;\n\t\t\t\tuint64_t m_hSteamLeaderboard;\n\t\t\t\tint32_t m_nScore;\n\t\t\t\tbool m_bScoreChanged;\n\t\t\t\tint m_nGlobalRankNew;\n\t\t\t\tint m_nGlobalRankPrevious;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nGlobalRankNew = "global_rank_new",
			m_bSuccess = "success",
			m_bScoreChanged = "score_changed",
			m_hSteamLeaderboard = "steam_leaderboard",
			m_nScore = "score",
			m_nGlobalRankPrevious = "global_rank_previous"
		}
	}

	function var_0_209.UploadLeaderboardScore(arg_291_0, arg_291_1, arg_291_2, arg_291_3, arg_291_4, arg_291_5)
		arg_291_1 = var_0_160(arg_291_1, var_0_64.ELeaderboardUploadScoreMethod, "leaderboard_upload_score_method is required")

		if arg_291_5 ~= nil and not var_0_117(arg_291_5) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_291_0 = var_259_37(var_259_0, arg_291_0, arg_291_1, arg_291_2, arg_291_3, arg_291_4)

		if arg_291_5 ~= nil then
			var_291_0 = var_0_152(var_291_0, arg_291_5, 1106, var_259_38)
		end

		return var_291_0
	end

	var_0_209.upload_leaderboard_score = var_0_209.UploadLeaderboardScore

	local var_259_39 = var_0_53(var_259_0, 32, "uint64_t(__thiscall*)(void*, uint64_t, uint64_t)")
	local var_259_40 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_hSteamLeaderboard;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_hSteamLeaderboard = "steam_leaderboard"
		}
	}

	function var_0_209.AttachLeaderboardUGC(arg_292_0, arg_292_1, arg_292_2)
		if arg_292_2 ~= nil and not var_0_117(arg_292_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_292_0 = var_259_39(var_259_0, arg_292_0, arg_292_1)

		if arg_292_2 ~= nil then
			var_292_0 = var_0_152(var_292_0, arg_292_2, 1111, var_259_40)
		end

		return var_292_0
	end

	var_0_209.attach_leaderboard_ugc = var_0_209.AttachLeaderboardUGC

	local var_259_41 = var_0_53(var_259_0, 33, "uint64_t(__thiscall*)(void*)")
	local var_259_42 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tbool m_bSuccess;\n\t\t\t\tint32_t m_cPlayers;\n\t\t\t} *\n\t\t"),
		keys = {
			m_cPlayers = "players",
			m_bSuccess = "success"
		}
	}

	function var_0_209.GetNumberOfCurrentPlayers(arg_293_0)
		if arg_293_0 ~= nil and not var_0_117(arg_293_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_293_0 = var_259_41(var_259_0)

		if arg_293_0 ~= nil then
			var_293_0 = var_0_152(var_293_0, arg_293_0, 1107, var_259_42)
		end

		return var_293_0
	end

	var_0_209.get_number_of_current_players = var_0_209.GetNumberOfCurrentPlayers

	local var_259_43 = var_0_53(var_259_0, 34, "uint64_t(__thiscall*)(void*)")
	local var_259_44 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_nGameID;\n\t\t\t\tint m_eResult;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_nGameID = "game_id"
		}
	}

	function var_0_209.RequestGlobalAchievementPercentages(arg_294_0)
		if arg_294_0 ~= nil and not var_0_117(arg_294_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_294_0 = var_259_43(var_259_0)

		if arg_294_0 ~= nil then
			var_294_0 = var_0_152(var_294_0, arg_294_0, 1110, var_259_44)
		end

		return var_294_0
	end

	var_0_209.request_global_achievement_percentages = var_0_209.RequestGlobalAchievementPercentages

	local var_259_45 = var_0_53(var_259_0, 35, "int(__thiscall*)(void*, char *, uint32_t, float *, bool *)")

	function var_0_209.GetMostAchievedAchievementInfo(arg_295_0, arg_295_1)
		local var_295_0 = var_0_168()
		local var_295_1 = var_0_166()

		return var_259_45(var_259_0, arg_295_0, arg_295_1, var_295_0, var_295_1), var_0_60(var_295_0), var_0_60(var_295_1)
	end

	var_0_209.get_most_achieved_achievement_info = var_0_209.GetMostAchievedAchievementInfo

	local var_259_46 = var_0_53(var_259_0, 36, "int(__thiscall*)(void*, int, char *, uint32_t, float *, bool *)")

	function var_0_209.GetNextMostAchievedAchievementInfo(arg_296_0, arg_296_1, arg_296_2)
		local var_296_0 = var_0_168()
		local var_296_1 = var_0_166()

		return var_259_46(var_259_0, arg_296_0, arg_296_1, arg_296_2, var_296_0, var_296_1), var_0_60(var_296_0), var_0_60(var_296_1)
	end

	var_0_209.get_next_most_achieved_achievement_info = var_0_209.GetNextMostAchievedAchievementInfo

	local var_259_47 = var_0_53(var_259_0, 37, "bool(__thiscall*)(void*, const char *, float *)")

	function var_0_209.GetAchievementAchievedPercent(arg_297_0)
		local var_297_0 = var_0_168()

		return var_259_47(var_259_0, arg_297_0, var_297_0), var_0_60(var_297_0)
	end

	var_0_209.get_achievement_achieved_percent = var_0_209.GetAchievementAchievedPercent

	local var_259_48 = var_0_53(var_259_0, 38, "uint64_t(__thiscall*)(void*, int)")
	local var_259_49 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_nGameID;\n\t\t\t\tint m_eResult;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_nGameID = "game_id"
		}
	}

	function var_0_209.RequestGlobalStats(arg_298_0, arg_298_1)
		if arg_298_1 ~= nil and not var_0_117(arg_298_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_298_0 = var_259_48(var_259_0, arg_298_0)

		if arg_298_1 ~= nil then
			var_298_0 = var_0_152(var_298_0, arg_298_1, 1112, var_259_49)
		end

		return var_298_0
	end

	var_0_209.request_global_stats = var_0_209.RequestGlobalStats

	local var_259_50 = var_0_53(var_259_0, 39, "bool(__thiscall*)(void*, const char *, int64_t *)")

	function var_0_209.GetGlobalStatInt64(arg_299_0)
		local var_299_0 = var_0_170()

		return var_259_50(var_259_0, arg_299_0, var_299_0), var_0_60(var_299_0)
	end

	var_0_209.get_global_stat_int64 = var_0_209.GetGlobalStatInt64

	local var_259_51 = var_0_53(var_259_0, 40, "bool(__thiscall*)(void*, const char *, double *)")

	function var_0_209.GetGlobalStatDouble(arg_300_0)
		local var_300_0 = var_0_167()

		return var_259_51(var_259_0, arg_300_0, var_300_0), var_0_60(var_300_0)
	end

	var_0_209.get_global_stat_double = var_0_209.GetGlobalStatDouble

	local var_259_52 = var_0_53(var_259_0, 41, "int32_t(__thiscall*)(void*, const char *, int64_t *, uint32_t)")

	function var_0_209.GetGlobalStatHistoryInt64(arg_301_0, arg_301_1, arg_301_2)
		return var_259_52(var_259_0, arg_301_0, arg_301_1, arg_301_2)
	end

	var_0_209.get_global_stat_history_int64 = var_0_209.GetGlobalStatHistoryInt64

	local var_259_53 = var_0_53(var_259_0, 42, "int32_t(__thiscall*)(void*, const char *, double *, uint32_t)")

	function var_0_209.GetGlobalStatHistoryDouble(arg_302_0, arg_302_1, arg_302_2)
		return var_259_53(var_259_0, arg_302_0, arg_302_1, arg_302_2)
	end

	var_0_209.get_global_stat_history_double = var_0_209.GetGlobalStatHistoryDouble

	local var_259_54 = var_0_53(var_259_0, 43, "bool(__thiscall*)(void*, const char *, int32_t *, int32_t *)")

	function var_0_209.GetAchievementProgressLimitsInt32(arg_303_0)
		local var_303_0 = var_0_169()
		local var_303_1 = var_0_169()

		return var_259_54(var_259_0, arg_303_0, var_303_0, var_303_1), var_0_60(var_303_0), var_0_60(var_303_1)
	end

	var_0_209.get_achievement_progress_limits_int32 = var_0_209.GetAchievementProgressLimitsInt32

	local var_259_55 = var_0_53(var_259_0, 44, "bool(__thiscall*)(void*, const char *, float *, float *)")

	function var_0_209.GetAchievementProgressLimitsFloat(arg_304_0)
		local var_304_0 = var_0_168()
		local var_304_1 = var_0_168()

		return var_259_55(var_259_0, arg_304_0, var_304_0, var_304_1), var_0_60(var_304_0), var_0_60(var_304_1)
	end

	var_0_209.get_achievement_progress_limits_float = var_0_209.GetAchievementProgressLimitsFloat

	return var_0_209
end

local var_0_210 = {
	version = "STEAMAPPS_INTERFACE_VERSION008",
	version_number = 8
}

function var_0_62.ISteamApps()
	local var_305_0 = vtable_bind("steamclient.dll", "SteamClient020", 15, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMAPPS_INTERFACE_VERSION008")

	var_0_210.thisptr = var_305_0

	local var_305_1 = var_0_53(var_305_0, 0, "bool(__thiscall*)(void*)")

	function var_0_210.BIsSubscribed()
		return var_305_1(var_305_0)
	end

	var_0_210.is_subscribed = var_0_210.BIsSubscribed

	local var_305_2 = var_0_53(var_305_0, 1, "bool(__thiscall*)(void*)")

	function var_0_210.BIsLowViolence()
		return var_305_2(var_305_0)
	end

	var_0_210.is_low_violence = var_0_210.BIsLowViolence

	local var_305_3 = var_0_53(var_305_0, 2, "bool(__thiscall*)(void*)")

	function var_0_210.BIsCybercafe()
		return var_305_3(var_305_0)
	end

	var_0_210.is_cybercafe = var_0_210.BIsCybercafe

	local var_305_4 = var_0_53(var_305_0, 3, "bool(__thiscall*)(void*)")

	function var_0_210.BIsVACBanned()
		return var_305_4(var_305_0)
	end

	var_0_210.is_vac_banned = var_0_210.BIsVACBanned

	local var_305_5 = var_0_53(var_305_0, 4, "const char *(__thiscall*)(void*)")

	function var_0_210.GetCurrentGameLanguage()
		local var_310_0 = var_305_5(var_305_0)

		return var_310_0 ~= nil and var_0_7(var_310_0) or nil
	end

	var_0_210.get_current_game_language = var_0_210.GetCurrentGameLanguage

	local var_305_6 = var_0_53(var_305_0, 5, "const char *(__thiscall*)(void*)")

	function var_0_210.GetAvailableGameLanguages()
		local var_311_0 = var_305_6(var_305_0)

		return var_311_0 ~= nil and var_0_7(var_311_0) or nil
	end

	var_0_210.get_available_game_languages = var_0_210.GetAvailableGameLanguages

	local var_305_7 = var_0_53(var_305_0, 6, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_210.BIsSubscribedApp(arg_312_0)
		return var_305_7(var_305_0, arg_312_0)
	end

	var_0_210.is_subscribed_app = var_0_210.BIsSubscribedApp

	local var_305_8 = var_0_53(var_305_0, 7, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_210.BIsDlcInstalled(arg_313_0)
		return var_305_8(var_305_0, arg_313_0)
	end

	var_0_210.is_dlc_installed = var_0_210.BIsDlcInstalled

	local var_305_9 = var_0_53(var_305_0, 8, "uint32_t(__thiscall*)(void*, unsigned int)")

	function var_0_210.GetEarliestPurchaseUnixTime(arg_314_0)
		return var_305_9(var_305_0, arg_314_0)
	end

	var_0_210.get_earliest_purchase_unix_time = var_0_210.GetEarliestPurchaseUnixTime

	local var_305_10 = var_0_53(var_305_0, 9, "bool(__thiscall*)(void*)")

	function var_0_210.BIsSubscribedFromFreeWeekend()
		return var_305_10(var_305_0)
	end

	var_0_210.is_subscribed_from_free_weekend = var_0_210.BIsSubscribedFromFreeWeekend

	local var_305_11 = var_0_53(var_305_0, 10, "int(__thiscall*)(void*)")

	function var_0_210.GetDLCCount()
		return var_305_11(var_305_0)
	end

	var_0_210.get_dlc_count = var_0_210.GetDLCCount

	local var_305_12 = var_0_53(var_305_0, 11, "bool(__thiscall*)(void*, int, unsigned int *, bool *, char *, int)")

	function var_0_210.BGetDLCDataByIndex(arg_317_0, arg_317_1, arg_317_2)
		local var_317_0 = var_0_175()
		local var_317_1 = var_0_166()

		return var_305_12(var_305_0, arg_317_0, var_317_0, var_317_1, arg_317_1, arg_317_2), var_0_60(var_317_0), var_0_60(var_317_1)
	end

	var_0_210.get_dlc_data_by_index = var_0_210.BGetDLCDataByIndex

	local var_305_13 = var_0_53(var_305_0, 12, "void(__thiscall*)(void*, unsigned int)")

	function var_0_210.InstallDLC(arg_318_0)
		return var_305_13(var_305_0, arg_318_0)
	end

	var_0_210.install_dlc = var_0_210.InstallDLC

	local var_305_14 = var_0_53(var_305_0, 13, "void(__thiscall*)(void*, unsigned int)")

	function var_0_210.UninstallDLC(arg_319_0)
		return var_305_14(var_305_0, arg_319_0)
	end

	var_0_210.uninstall_dlc = var_0_210.UninstallDLC

	local var_305_15 = var_0_53(var_305_0, 14, "void(__thiscall*)(void*, unsigned int)")

	function var_0_210.RequestAppProofOfPurchaseKey(arg_320_0)
		return var_305_15(var_305_0, arg_320_0)
	end

	var_0_210.request_app_proof_of_purchase_key = var_0_210.RequestAppProofOfPurchaseKey

	local var_305_16 = var_0_53(var_305_0, 15, "bool(__thiscall*)(void*, char *, int)")

	function var_0_210.GetCurrentBetaName(arg_321_0, arg_321_1)
		return var_305_16(var_305_0, arg_321_0, arg_321_1)
	end

	var_0_210.get_current_beta_name = var_0_210.GetCurrentBetaName

	local var_305_17 = var_0_53(var_305_0, 16, "bool(__thiscall*)(void*, bool)")

	function var_0_210.MarkContentCorrupt(arg_322_0)
		return var_305_17(var_305_0, arg_322_0)
	end

	var_0_210.mark_content_corrupt = var_0_210.MarkContentCorrupt

	local var_305_18 = var_0_53(var_305_0, 17, "uint32_t(__thiscall*)(void*, unsigned int, unsigned int *, uint32_t)")

	function var_0_210.GetInstalledDepots(arg_323_0, arg_323_1, arg_323_2)
		return var_305_18(var_305_0, arg_323_0, arg_323_1, arg_323_2)
	end

	var_0_210.get_installed_depots = var_0_210.GetInstalledDepots

	local var_305_19 = var_0_53(var_305_0, 18, "uint32_t(__thiscall*)(void*, unsigned int, char *, uint32_t)")

	function var_0_210.GetAppInstallDir(arg_324_0, arg_324_1, arg_324_2)
		return var_305_19(var_305_0, arg_324_0, arg_324_1, arg_324_2)
	end

	var_0_210.get_app_install_dir = var_0_210.GetAppInstallDir

	local var_305_20 = var_0_53(var_305_0, 19, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_210.BIsAppInstalled(arg_325_0)
		return var_305_20(var_305_0, arg_325_0)
	end

	var_0_210.is_app_installed = var_0_210.BIsAppInstalled

	local var_305_21 = var_0_53(var_305_0, 20, "void(__thiscall*)(void*, SteamID *)")

	function var_0_210.GetAppOwner()
		local var_326_0 = var_0_165()

		var_305_21(var_305_0, var_326_0)

		return var_0_60(var_326_0)
	end

	var_0_210.get_app_owner = var_0_210.GetAppOwner

	local var_305_22 = var_0_53(var_305_0, 21, "const char *(__thiscall*)(void*, const char *)")

	function var_0_210.GetLaunchQueryParam(arg_327_0)
		local var_327_0 = var_305_22(var_305_0, arg_327_0)

		return var_327_0 ~= nil and var_0_7(var_327_0) or nil
	end

	var_0_210.get_launch_query_param = var_0_210.GetLaunchQueryParam

	local var_305_23 = var_0_53(var_305_0, 22, "bool(__thiscall*)(void*, unsigned int, uint64_t *, uint64_t *)")

	function var_0_210.GetDlcDownloadProgress(arg_328_0)
		local var_328_0 = var_0_174()
		local var_328_1 = var_0_174()

		return var_305_23(var_305_0, arg_328_0, var_328_0, var_328_1), var_0_60(var_328_0), var_0_60(var_328_1)
	end

	var_0_210.get_dlc_download_progress = var_0_210.GetDlcDownloadProgress

	local var_305_24 = var_0_53(var_305_0, 23, "int(__thiscall*)(void*)")

	function var_0_210.GetAppBuildId()
		return var_305_24(var_305_0)
	end

	var_0_210.get_app_build_id = var_0_210.GetAppBuildId

	local var_305_25 = var_0_53(var_305_0, 24, "void(__thiscall*)(void*)")

	function var_0_210.RequestAllProofOfPurchaseKeys()
		return var_305_25(var_305_0)
	end

	var_0_210.request_all_proof_of_purchase_keys = var_0_210.RequestAllProofOfPurchaseKeys

	local var_305_26 = var_0_53(var_305_0, 25, "uint64_t(__thiscall*)(void*, const char *)")
	local var_305_27 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_ulFileSize;\n\t\t\t\tuint8_t m_FileSHA[20];\n\t\t\t\tuint32_t m_unFlags;\n\t\t\t} *\n\t\t"),
		keys = {
			m_ulFileSize = "file_size",
			m_FileSHA = "file_sha",
			m_eResult = "result",
			m_unFlags = "flags"
		}
	}

	function var_0_210.GetFileDetails(arg_331_0, arg_331_1)
		if arg_331_1 ~= nil and not var_0_117(arg_331_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_331_0 = var_305_26(var_305_0, arg_331_0)

		if arg_331_1 ~= nil then
			var_331_0 = var_0_152(var_331_0, arg_331_1, 1023, var_305_27)
		end

		return var_331_0
	end

	var_0_210.get_file_details = var_0_210.GetFileDetails

	local var_305_28 = var_0_53(var_305_0, 26, "int(__thiscall*)(void*, char *, int)")

	function var_0_210.GetLaunchCommandLine(arg_332_0, arg_332_1)
		return var_305_28(var_305_0, arg_332_0, arg_332_1)
	end

	var_0_210.get_launch_command_line = var_0_210.GetLaunchCommandLine

	local var_305_29 = var_0_53(var_305_0, 27, "bool(__thiscall*)(void*)")

	function var_0_210.BIsSubscribedFromFamilySharing()
		return var_305_29(var_305_0)
	end

	var_0_210.is_subscribed_from_family_sharing = var_0_210.BIsSubscribedFromFamilySharing

	local var_305_30 = var_0_53(var_305_0, 28, "bool(__thiscall*)(void*, uint32_t *, uint32_t *)")

	function var_0_210.BIsTimedTrial()
		local var_334_0 = var_0_173()
		local var_334_1 = var_0_173()

		return var_305_30(var_305_0, var_334_0, var_334_1), var_0_60(var_334_0), var_0_60(var_334_1)
	end

	var_0_210.is_timed_trial = var_0_210.BIsTimedTrial

	local var_305_31 = var_0_53(var_305_0, 29, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_210.SetDlcContext(arg_335_0)
		return var_305_31(var_305_0, arg_335_0)
	end

	var_0_210.set_dlc_context = var_0_210.SetDlcContext

	return var_0_210
end

local var_0_211 = {
	version = "SteamNetworking006",
	version_number = 6
}

function var_0_62.ISteamNetworking()
	local var_336_0 = vtable_bind("steamclient.dll", "SteamClient020", 16, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "SteamNetworking006")

	var_0_211.thisptr = var_336_0

	local var_336_1 = var_0_53(var_336_0, 0, "bool(__thiscall*)(void*, SteamID, const void *, uint32_t, int, int)")

	function var_0_211.SendP2PPacket(arg_337_0, arg_337_1, arg_337_2, arg_337_3, arg_337_4)
		arg_337_0 = var_0_158(arg_337_0, "steamid_remote is required")
		arg_337_3 = var_0_160(arg_337_3, var_0_64.EP2PSend, "p2p_send_type is required")

		return var_336_1(var_336_0, arg_337_0, arg_337_1, arg_337_2, arg_337_3, arg_337_4)
	end

	var_0_211.send_p2p_packet = var_0_211.SendP2PPacket

	local var_336_2 = var_0_53(var_336_0, 1, "bool(__thiscall*)(void*, uint32_t *, int)")

	function var_0_211.IsP2PPacketAvailable(arg_338_0)
		local var_338_0 = var_0_173()

		return var_336_2(var_336_0, var_338_0, arg_338_0), var_0_60(var_338_0)
	end

	var_0_211.is_p2p_packet_available = var_0_211.IsP2PPacketAvailable

	local var_336_3 = var_0_53(var_336_0, 2, "bool(__thiscall*)(void*, void *, uint32_t, uint32_t *, SteamID *, int)")

	function var_0_211.ReadP2PPacket(arg_339_0, arg_339_1, arg_339_2, arg_339_3)
		local var_339_0 = var_0_173()

		return var_336_3(var_336_0, arg_339_0, arg_339_1, var_339_0, arg_339_2, arg_339_3), var_0_60(var_339_0)
	end

	var_0_211.read_p2p_packet = var_0_211.ReadP2PPacket

	local var_336_4 = var_0_53(var_336_0, 3, "bool(__thiscall*)(void*, SteamID)")

	function var_0_211.AcceptP2PSessionWithUser(arg_340_0)
		arg_340_0 = var_0_158(arg_340_0, "steamid_remote is required")

		return var_336_4(var_336_0, arg_340_0)
	end

	var_0_211.accept_p2p_session_with_user = var_0_211.AcceptP2PSessionWithUser

	local var_336_5 = var_0_53(var_336_0, 4, "bool(__thiscall*)(void*, SteamID)")

	function var_0_211.CloseP2PSessionWithUser(arg_341_0)
		arg_341_0 = var_0_158(arg_341_0, "steamid_remote is required")

		return var_336_5(var_336_0, arg_341_0)
	end

	var_0_211.close_p2p_session_with_user = var_0_211.CloseP2PSessionWithUser

	local var_336_6 = var_0_53(var_336_0, 5, "bool(__thiscall*)(void*, SteamID, int)")

	function var_0_211.CloseP2PChannelWithUser(arg_342_0, arg_342_1)
		arg_342_0 = var_0_158(arg_342_0, "steamid_remote is required")

		return var_336_6(var_336_0, arg_342_0, arg_342_1)
	end

	var_0_211.close_p2p_channel_with_user = var_0_211.CloseP2PChannelWithUser

	local var_336_7 = var_0_53(var_336_0, 6, "bool(__thiscall*)(void*, SteamID, P2PSessionState_t *)")

	function var_0_211.GetP2PSessionState(arg_343_0)
		arg_343_0 = var_0_158(arg_343_0, "steamid_remote is required")

		local var_343_0 = var_0_103.P2PSessionState_t_arr(1)

		return var_336_7(var_336_0, arg_343_0, var_343_0), var_0_60(var_343_0)
	end

	var_0_211.get_p2p_session_state = var_0_211.GetP2PSessionState

	local var_336_8 = var_0_53(var_336_0, 7, "bool(__thiscall*)(void*, bool)")

	function var_0_211.AllowP2PPacketRelay(arg_344_0)
		return var_336_8(var_336_0, arg_344_0)
	end

	var_0_211.allow_p2p_packet_relay = var_0_211.AllowP2PPacketRelay

	local var_336_9 = var_0_53(var_336_0, 8, "unsigned int(__thiscall*)(void*, int, SteamIPAddress_t, uint16_t, bool)")

	function var_0_211.CreateListenSocket(arg_345_0, arg_345_1, arg_345_2, arg_345_3)
		return var_336_9(var_336_0, arg_345_0, arg_345_1, arg_345_2, arg_345_3)
	end

	var_0_211.create_listen_socket = var_0_211.CreateListenSocket

	local var_336_10 = var_0_53(var_336_0, 9, "unsigned int(__thiscall*)(void*, SteamID, int, int, bool)")

	function var_0_211.CreateP2PConnectionSocket(arg_346_0, arg_346_1, arg_346_2, arg_346_3)
		arg_346_0 = var_0_158(arg_346_0, "steamid_target is required")

		return var_336_10(var_336_0, arg_346_0, arg_346_1, arg_346_2, arg_346_3)
	end

	var_0_211.create_p2p_connection_socket = var_0_211.CreateP2PConnectionSocket

	local var_336_11 = var_0_53(var_336_0, 10, "unsigned int(__thiscall*)(void*, SteamIPAddress_t, uint16_t, int)")

	function var_0_211.CreateConnectionSocket(arg_347_0, arg_347_1, arg_347_2)
		return var_336_11(var_336_0, arg_347_0, arg_347_1, arg_347_2)
	end

	var_0_211.create_connection_socket = var_0_211.CreateConnectionSocket

	local var_336_12 = var_0_53(var_336_0, 11, "bool(__thiscall*)(void*, unsigned int, bool)")

	function var_0_211.DestroySocket(arg_348_0, arg_348_1)
		return var_336_12(var_336_0, arg_348_0, arg_348_1)
	end

	var_0_211.destroy_socket = var_0_211.DestroySocket

	local var_336_13 = var_0_53(var_336_0, 12, "bool(__thiscall*)(void*, unsigned int, bool)")

	function var_0_211.DestroyListenSocket(arg_349_0, arg_349_1)
		return var_336_13(var_336_0, arg_349_0, arg_349_1)
	end

	var_0_211.destroy_listen_socket = var_0_211.DestroyListenSocket

	local var_336_14 = var_0_53(var_336_0, 13, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, bool)")

	function var_0_211.SendDataOnSocket(arg_350_0, arg_350_1, arg_350_2, arg_350_3)
		return var_336_14(var_336_0, arg_350_0, arg_350_1, arg_350_2, arg_350_3)
	end

	var_0_211.send_data_on_socket = var_0_211.SendDataOnSocket

	local var_336_15 = var_0_53(var_336_0, 14, "bool(__thiscall*)(void*, unsigned int, uint32_t *)")

	function var_0_211.IsDataAvailableOnSocket(arg_351_0)
		local var_351_0 = var_0_173()

		return var_336_15(var_336_0, arg_351_0, var_351_0), var_0_60(var_351_0)
	end

	var_0_211.is_data_available_on_socket = var_0_211.IsDataAvailableOnSocket

	local var_336_16 = var_0_53(var_336_0, 15, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, uint32_t *)")

	function var_0_211.RetrieveDataFromSocket(arg_352_0, arg_352_1, arg_352_2)
		local var_352_0 = var_0_173()

		return var_336_16(var_336_0, arg_352_0, arg_352_1, arg_352_2, var_352_0), var_0_60(var_352_0)
	end

	var_0_211.retrieve_data_from_socket = var_0_211.RetrieveDataFromSocket

	local var_336_17 = var_0_53(var_336_0, 16, "bool(__thiscall*)(void*, unsigned int, uint32_t *, unsigned int *)")

	function var_0_211.IsDataAvailable(arg_353_0)
		local var_353_0 = var_0_173()
		local var_353_1 = var_0_175()

		return var_336_17(var_336_0, arg_353_0, var_353_0, var_353_1), var_0_60(var_353_0), var_0_60(var_353_1)
	end

	var_0_211.is_data_available = var_0_211.IsDataAvailable

	local var_336_18 = var_0_53(var_336_0, 17, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, uint32_t *, unsigned int *)")

	function var_0_211.RetrieveData(arg_354_0, arg_354_1, arg_354_2)
		local var_354_0 = var_0_173()
		local var_354_1 = var_0_175()

		return var_336_18(var_336_0, arg_354_0, arg_354_1, arg_354_2, var_354_0, var_354_1), var_0_60(var_354_0), var_0_60(var_354_1)
	end

	var_0_211.retrieve_data = var_0_211.RetrieveData

	local var_336_19 = var_0_53(var_336_0, 18, "bool(__thiscall*)(void*, unsigned int, SteamID *, int *, SteamIPAddress_t *, uint16_t *)")

	function var_0_211.GetSocketInfo(arg_355_0, arg_355_1)
		local var_355_0 = var_0_171()
		local var_355_1 = var_0_103.SteamIPAddress_t_arr(1)
		local var_355_2 = var_0_172()

		return var_336_19(var_336_0, arg_355_0, arg_355_1, var_355_0, var_355_1, var_355_2), var_0_60(var_355_0), var_0_60(var_355_1), var_0_60(var_355_2)
	end

	var_0_211.get_socket_info = var_0_211.GetSocketInfo

	local var_336_20 = var_0_53(var_336_0, 19, "bool(__thiscall*)(void*, unsigned int, SteamIPAddress_t *, uint16_t *)")

	function var_0_211.GetListenSocketInfo(arg_356_0)
		local var_356_0 = var_0_103.SteamIPAddress_t_arr(1)
		local var_356_1 = var_0_172()

		return var_336_20(var_336_0, arg_356_0, var_356_0, var_356_1), var_0_60(var_356_0), var_0_60(var_356_1)
	end

	var_0_211.get_listen_socket_info = var_0_211.GetListenSocketInfo

	local var_336_21 = var_0_53(var_336_0, 20, "int(__thiscall*)(void*, unsigned int)")

	function var_0_211.GetSocketConnectionType(arg_357_0)
		return var_336_21(var_336_0, arg_357_0)
	end

	var_0_211.get_socket_connection_type = var_0_211.GetSocketConnectionType

	local var_336_22 = var_0_53(var_336_0, 21, "int(__thiscall*)(void*, unsigned int)")

	function var_0_211.GetMaxPacketSize(arg_358_0)
		return var_336_22(var_336_0, arg_358_0)
	end

	var_0_211.get_max_packet_size = var_0_211.GetMaxPacketSize

	return var_0_211
end

local var_0_212 = {
	version = "STEAMSCREENSHOTS_INTERFACE_VERSION003",
	version_number = 3
}

function var_0_62.ISteamScreenshots()
	local var_359_0 = vtable_bind("steamclient.dll", "SteamClient020", 18, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMSCREENSHOTS_INTERFACE_VERSION003")

	var_0_212.thisptr = var_359_0

	local var_359_1 = var_0_53(var_359_0, 0, "unsigned int(__thiscall*)(void*, void *, uint32_t, int, int)")

	function var_0_212.WriteScreenshot(arg_360_0, arg_360_1, arg_360_2, arg_360_3)
		return var_359_1(var_359_0, arg_360_0, arg_360_1, arg_360_2, arg_360_3)
	end

	var_0_212.write_screenshot = var_0_212.WriteScreenshot

	local var_359_2 = var_0_53(var_359_0, 1, "unsigned int(__thiscall*)(void*, const char *, const char *, int, int)")

	function var_0_212.AddScreenshotToLibrary(arg_361_0, arg_361_1, arg_361_2, arg_361_3)
		return var_359_2(var_359_0, arg_361_0, arg_361_1, arg_361_2, arg_361_3)
	end

	var_0_212.add_screenshot_to_library = var_0_212.AddScreenshotToLibrary

	local var_359_3 = var_0_53(var_359_0, 2, "void(__thiscall*)(void*)")

	function var_0_212.TriggerScreenshot()
		return var_359_3(var_359_0)
	end

	var_0_212.trigger_screenshot = var_0_212.TriggerScreenshot

	local var_359_4 = var_0_53(var_359_0, 3, "void(__thiscall*)(void*, bool)")

	function var_0_212.HookScreenshots(arg_363_0)
		return var_359_4(var_359_0, arg_363_0)
	end

	var_0_212.hook_screenshots = var_0_212.HookScreenshots

	local var_359_5 = var_0_53(var_359_0, 4, "bool(__thiscall*)(void*, unsigned int, const char *)")

	function var_0_212.SetLocation(arg_364_0, arg_364_1)
		return var_359_5(var_359_0, arg_364_0, arg_364_1)
	end

	var_0_212.set_location = var_0_212.SetLocation

	local var_359_6 = var_0_53(var_359_0, 5, "bool(__thiscall*)(void*, unsigned int, SteamID)")

	function var_0_212.TagUser(arg_365_0, arg_365_1)
		arg_365_1 = var_0_158(arg_365_1, "steamid is required")

		return var_359_6(var_359_0, arg_365_0, arg_365_1)
	end

	var_0_212.tag_user = var_0_212.TagUser

	local var_359_7 = var_0_53(var_359_0, 6, "bool(__thiscall*)(void*, unsigned int, uint64_t)")

	function var_0_212.TagPublishedFile(arg_366_0, arg_366_1)
		return var_359_7(var_359_0, arg_366_0, arg_366_1)
	end

	var_0_212.tag_published_file = var_0_212.TagPublishedFile

	local var_359_8 = var_0_53(var_359_0, 7, "bool(__thiscall*)(void*)")

	function var_0_212.IsScreenshotsHooked()
		return var_359_8(var_359_0)
	end

	var_0_212.is_screenshots_hooked = var_0_212.IsScreenshotsHooked

	local var_359_9 = var_0_53(var_359_0, 8, "unsigned int(__thiscall*)(void*, int, const char *, const char *)")

	function var_0_212.AddVRScreenshotToLibrary(arg_368_0, arg_368_1, arg_368_2)
		arg_368_0 = var_0_160(arg_368_0, var_0_64.EVRScreenshotType, "type is required")

		return var_359_9(var_359_0, arg_368_0, arg_368_1, arg_368_2)
	end

	var_0_212.add_vr_screenshot_to_library = var_0_212.AddVRScreenshotToLibrary

	return var_0_212
end

local var_0_213 = {
	version = "STEAMMUSIC_INTERFACE_VERSION001",
	version_number = 1
}

function var_0_62.ISteamMusic()
	local var_369_0 = vtable_bind("steamclient.dll", "SteamClient020", 29, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMMUSIC_INTERFACE_VERSION001")

	var_0_213.thisptr = var_369_0

	local var_369_1 = var_0_53(var_369_0, 0, "bool(__thiscall*)(void*)")

	function var_0_213.BIsEnabled()
		return var_369_1(var_369_0)
	end

	var_0_213.is_enabled = var_0_213.BIsEnabled

	local var_369_2 = var_0_53(var_369_0, 1, "bool(__thiscall*)(void*)")

	function var_0_213.BIsPlaying()
		return var_369_2(var_369_0)
	end

	var_0_213.is_playing = var_0_213.BIsPlaying

	local var_369_3 = var_0_53(var_369_0, 2, "int(__thiscall*)(void*)")

	function var_0_213.GetPlaybackStatus()
		return var_369_3(var_369_0)
	end

	var_0_213.get_playback_status = var_0_213.GetPlaybackStatus

	local var_369_4 = var_0_53(var_369_0, 3, "void(__thiscall*)(void*)")

	function var_0_213.Play()
		return var_369_4(var_369_0)
	end

	var_0_213.play = var_0_213.Play

	local var_369_5 = var_0_53(var_369_0, 4, "void(__thiscall*)(void*)")

	function var_0_213.Pause()
		return var_369_5(var_369_0)
	end

	var_0_213.pause = var_0_213.Pause

	local var_369_6 = var_0_53(var_369_0, 5, "void(__thiscall*)(void*)")

	function var_0_213.PlayPrevious()
		return var_369_6(var_369_0)
	end

	var_0_213.play_previous = var_0_213.PlayPrevious

	local var_369_7 = var_0_53(var_369_0, 6, "void(__thiscall*)(void*)")

	function var_0_213.PlayNext()
		return var_369_7(var_369_0)
	end

	var_0_213.play_next = var_0_213.PlayNext

	local var_369_8 = var_0_53(var_369_0, 7, "void(__thiscall*)(void*, float)")

	function var_0_213.SetVolume(arg_377_0)
		return var_369_8(var_369_0, arg_377_0)
	end

	var_0_213.set_volume = var_0_213.SetVolume

	local var_369_9 = var_0_53(var_369_0, 8, "float(__thiscall*)(void*)")

	function var_0_213.GetVolume()
		return var_369_9(var_369_0)
	end

	var_0_213.get_volume = var_0_213.GetVolume

	return var_0_213
end

local var_0_214 = {
	version = "STEAMMUSICREMOTE_INTERFACE_VERSION001",
	version_number = 1
}

function var_0_62.ISteamMusicRemote()
	local var_379_0 = vtable_bind("steamclient.dll", "SteamClient020", 30, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMMUSICREMOTE_INTERFACE_VERSION001")

	var_0_214.thisptr = var_379_0

	local var_379_1 = var_0_53(var_379_0, 0, "bool(__thiscall*)(void*, const char *)")

	function var_0_214.RegisterSteamMusicRemote(arg_380_0)
		return var_379_1(var_379_0, arg_380_0)
	end

	var_0_214.register_steam_music_remote = var_0_214.RegisterSteamMusicRemote

	local var_379_2 = var_0_53(var_379_0, 1, "bool(__thiscall*)(void*)")

	function var_0_214.DeregisterSteamMusicRemote()
		return var_379_2(var_379_0)
	end

	var_0_214.deregister_steam_music_remote = var_0_214.DeregisterSteamMusicRemote

	local var_379_3 = var_0_53(var_379_0, 2, "bool(__thiscall*)(void*)")

	function var_0_214.BIsCurrentMusicRemote()
		return var_379_3(var_379_0)
	end

	var_0_214.is_current_music_remote = var_0_214.BIsCurrentMusicRemote

	local var_379_4 = var_0_53(var_379_0, 3, "bool(__thiscall*)(void*, bool)")

	function var_0_214.BActivationSuccess(arg_383_0)
		return var_379_4(var_379_0, arg_383_0)
	end

	var_0_214.activation_success = var_0_214.BActivationSuccess

	local var_379_5 = var_0_53(var_379_0, 4, "bool(__thiscall*)(void*, const char *)")

	function var_0_214.SetDisplayName(arg_384_0)
		return var_379_5(var_379_0, arg_384_0)
	end

	var_0_214.set_display_name = var_0_214.SetDisplayName

	local var_379_6 = var_0_53(var_379_0, 5, "bool(__thiscall*)(void*, void *, uint32_t)")

	function var_0_214.SetPNGIcon_64x64(arg_385_0, arg_385_1)
		return var_379_6(var_379_0, arg_385_0, arg_385_1)
	end

	var_0_214.set_png_icon_64x64 = var_0_214.SetPNGIcon_64x64

	local var_379_7 = var_0_53(var_379_0, 6, "bool(__thiscall*)(void*, bool)")

	function var_0_214.EnablePlayPrevious(arg_386_0)
		return var_379_7(var_379_0, arg_386_0)
	end

	var_0_214.enable_play_previous = var_0_214.EnablePlayPrevious

	local var_379_8 = var_0_53(var_379_0, 7, "bool(__thiscall*)(void*, bool)")

	function var_0_214.EnablePlayNext(arg_387_0)
		return var_379_8(var_379_0, arg_387_0)
	end

	var_0_214.enable_play_next = var_0_214.EnablePlayNext

	local var_379_9 = var_0_53(var_379_0, 8, "bool(__thiscall*)(void*, bool)")

	function var_0_214.EnableShuffled(arg_388_0)
		return var_379_9(var_379_0, arg_388_0)
	end

	var_0_214.enable_shuffled = var_0_214.EnableShuffled

	local var_379_10 = var_0_53(var_379_0, 9, "bool(__thiscall*)(void*, bool)")

	function var_0_214.EnableLooped(arg_389_0)
		return var_379_10(var_379_0, arg_389_0)
	end

	var_0_214.enable_looped = var_0_214.EnableLooped

	local var_379_11 = var_0_53(var_379_0, 10, "bool(__thiscall*)(void*, bool)")

	function var_0_214.EnableQueue(arg_390_0)
		return var_379_11(var_379_0, arg_390_0)
	end

	var_0_214.enable_queue = var_0_214.EnableQueue

	local var_379_12 = var_0_53(var_379_0, 11, "bool(__thiscall*)(void*, bool)")

	function var_0_214.EnablePlaylists(arg_391_0)
		return var_379_12(var_379_0, arg_391_0)
	end

	var_0_214.enable_playlists = var_0_214.EnablePlaylists

	local var_379_13 = var_0_53(var_379_0, 12, "bool(__thiscall*)(void*, int)")

	function var_0_214.UpdatePlaybackStatus(arg_392_0)
		arg_392_0 = var_0_160(arg_392_0, var_0_64.AudioPlayback_Status, "status is required")

		return var_379_13(var_379_0, arg_392_0)
	end

	var_0_214.update_playback_status = var_0_214.UpdatePlaybackStatus

	local var_379_14 = var_0_53(var_379_0, 13, "bool(__thiscall*)(void*, bool)")

	function var_0_214.UpdateShuffled(arg_393_0)
		return var_379_14(var_379_0, arg_393_0)
	end

	var_0_214.update_shuffled = var_0_214.UpdateShuffled

	local var_379_15 = var_0_53(var_379_0, 14, "bool(__thiscall*)(void*, bool)")

	function var_0_214.UpdateLooped(arg_394_0)
		return var_379_15(var_379_0, arg_394_0)
	end

	var_0_214.update_looped = var_0_214.UpdateLooped

	local var_379_16 = var_0_53(var_379_0, 15, "bool(__thiscall*)(void*, float)")

	function var_0_214.UpdateVolume(arg_395_0)
		return var_379_16(var_379_0, arg_395_0)
	end

	var_0_214.update_volume = var_0_214.UpdateVolume

	local var_379_17 = var_0_53(var_379_0, 16, "bool(__thiscall*)(void*)")

	function var_0_214.CurrentEntryWillChange()
		return var_379_17(var_379_0)
	end

	var_0_214.current_entry_will_change = var_0_214.CurrentEntryWillChange

	local var_379_18 = var_0_53(var_379_0, 17, "bool(__thiscall*)(void*, bool)")

	function var_0_214.CurrentEntryIsAvailable(arg_397_0)
		return var_379_18(var_379_0, arg_397_0)
	end

	var_0_214.current_entry_is_available = var_0_214.CurrentEntryIsAvailable

	local var_379_19 = var_0_53(var_379_0, 18, "bool(__thiscall*)(void*, const char *)")

	function var_0_214.UpdateCurrentEntryText(arg_398_0)
		return var_379_19(var_379_0, arg_398_0)
	end

	var_0_214.update_current_entry_text = var_0_214.UpdateCurrentEntryText

	local var_379_20 = var_0_53(var_379_0, 19, "bool(__thiscall*)(void*, int)")

	function var_0_214.UpdateCurrentEntryElapsedSeconds(arg_399_0)
		return var_379_20(var_379_0, arg_399_0)
	end

	var_0_214.update_current_entry_elapsed_seconds = var_0_214.UpdateCurrentEntryElapsedSeconds

	local var_379_21 = var_0_53(var_379_0, 20, "bool(__thiscall*)(void*, void *, uint32_t)")

	function var_0_214.UpdateCurrentEntryCoverArt(arg_400_0, arg_400_1)
		return var_379_21(var_379_0, arg_400_0, arg_400_1)
	end

	var_0_214.update_current_entry_cover_art = var_0_214.UpdateCurrentEntryCoverArt

	local var_379_22 = var_0_53(var_379_0, 21, "bool(__thiscall*)(void*)")

	function var_0_214.CurrentEntryDidChange()
		return var_379_22(var_379_0)
	end

	var_0_214.current_entry_did_change = var_0_214.CurrentEntryDidChange

	local var_379_23 = var_0_53(var_379_0, 22, "bool(__thiscall*)(void*)")

	function var_0_214.QueueWillChange()
		return var_379_23(var_379_0)
	end

	var_0_214.queue_will_change = var_0_214.QueueWillChange

	local var_379_24 = var_0_53(var_379_0, 23, "bool(__thiscall*)(void*)")

	function var_0_214.ResetQueueEntries()
		return var_379_24(var_379_0)
	end

	var_0_214.reset_queue_entries = var_0_214.ResetQueueEntries

	local var_379_25 = var_0_53(var_379_0, 24, "bool(__thiscall*)(void*, int, int, const char *)")

	function var_0_214.SetQueueEntry(arg_404_0, arg_404_1, arg_404_2)
		return var_379_25(var_379_0, arg_404_0, arg_404_1, arg_404_2)
	end

	var_0_214.set_queue_entry = var_0_214.SetQueueEntry

	local var_379_26 = var_0_53(var_379_0, 25, "bool(__thiscall*)(void*, int)")

	function var_0_214.SetCurrentQueueEntry(arg_405_0)
		return var_379_26(var_379_0, arg_405_0)
	end

	var_0_214.set_current_queue_entry = var_0_214.SetCurrentQueueEntry

	local var_379_27 = var_0_53(var_379_0, 26, "bool(__thiscall*)(void*)")

	function var_0_214.QueueDidChange()
		return var_379_27(var_379_0)
	end

	var_0_214.queue_did_change = var_0_214.QueueDidChange

	local var_379_28 = var_0_53(var_379_0, 27, "bool(__thiscall*)(void*)")

	function var_0_214.PlaylistWillChange()
		return var_379_28(var_379_0)
	end

	var_0_214.playlist_will_change = var_0_214.PlaylistWillChange

	local var_379_29 = var_0_53(var_379_0, 28, "bool(__thiscall*)(void*)")

	function var_0_214.ResetPlaylistEntries()
		return var_379_29(var_379_0)
	end

	var_0_214.reset_playlist_entries = var_0_214.ResetPlaylistEntries

	local var_379_30 = var_0_53(var_379_0, 29, "bool(__thiscall*)(void*, int, int, const char *)")

	function var_0_214.SetPlaylistEntry(arg_409_0, arg_409_1, arg_409_2)
		return var_379_30(var_379_0, arg_409_0, arg_409_1, arg_409_2)
	end

	var_0_214.set_playlist_entry = var_0_214.SetPlaylistEntry

	local var_379_31 = var_0_53(var_379_0, 30, "bool(__thiscall*)(void*, int)")

	function var_0_214.SetCurrentPlaylistEntry(arg_410_0)
		return var_379_31(var_379_0, arg_410_0)
	end

	var_0_214.set_current_playlist_entry = var_0_214.SetCurrentPlaylistEntry

	local var_379_32 = var_0_53(var_379_0, 31, "bool(__thiscall*)(void*)")

	function var_0_214.PlaylistDidChange()
		return var_379_32(var_379_0)
	end

	var_0_214.playlist_did_change = var_0_214.PlaylistDidChange

	return var_0_214
end

local var_0_215 = {
	version = "STEAMHTTP_INTERFACE_VERSION003",
	version_number = 3
}

function var_0_62.ISteamHTTP()
	local var_412_0 = vtable_bind("steamclient.dll", "SteamClient020", 24, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMHTTP_INTERFACE_VERSION003")

	var_0_215.thisptr = var_412_0

	local var_412_1 = var_0_53(var_412_0, 0, "unsigned int(__thiscall*)(void*, int, const char *)")

	function var_0_215.CreateHTTPRequest(arg_413_0, arg_413_1)
		arg_413_0 = var_0_160(arg_413_0, var_0_64.EHTTPMethod, "http_request_method is required")

		return var_412_1(var_412_0, arg_413_0, arg_413_1)
	end

	var_0_215.create_http_request = var_0_215.CreateHTTPRequest

	local var_412_2 = var_0_53(var_412_0, 1, "bool(__thiscall*)(void*, unsigned int, uint64_t)")

	function var_0_215.SetHTTPRequestContextValue(arg_414_0, arg_414_1)
		return var_412_2(var_412_0, arg_414_0, arg_414_1)
	end

	var_0_215.set_http_request_context_value = var_0_215.SetHTTPRequestContextValue

	local var_412_3 = var_0_53(var_412_0, 2, "bool(__thiscall*)(void*, unsigned int, uint32_t)")

	function var_0_215.SetHTTPRequestNetworkActivityTimeout(arg_415_0, arg_415_1)
		return var_412_3(var_412_0, arg_415_0, arg_415_1)
	end

	var_0_215.set_http_request_network_activity_timeout = var_0_215.SetHTTPRequestNetworkActivityTimeout

	local var_412_4 = var_0_53(var_412_0, 3, "bool(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function var_0_215.SetHTTPRequestHeaderValue(arg_416_0, arg_416_1, arg_416_2)
		return var_412_4(var_412_0, arg_416_0, arg_416_1, arg_416_2)
	end

	var_0_215.set_http_request_header_value = var_0_215.SetHTTPRequestHeaderValue

	local var_412_5 = var_0_53(var_412_0, 4, "bool(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function var_0_215.SetHTTPRequestGetOrPostParameter(arg_417_0, arg_417_1, arg_417_2)
		return var_412_5(var_412_0, arg_417_0, arg_417_1, arg_417_2)
	end

	var_0_215.set_http_request_get_or_post_parameter = var_0_215.SetHTTPRequestGetOrPostParameter

	local var_412_6 = var_0_53(var_412_0, 5, "bool(__thiscall*)(void*, unsigned int, uint64_t *)")
	local var_412_7 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tunsigned int m_hRequest;\n\t\t\t\tuint64_t m_ulContextValue;\n\t\t\t\tbool m_bRequestSuccessful;\n\t\t\t\tint m_eStatusCode;\n\t\t\t\tuint32_t m_unBodySize;\n\t\t\t} *\n\t\t"),
		keys = {
			m_ulContextValue = "context_value",
			m_hRequest = "request",
			m_unBodySize = "body_size",
			m_eStatusCode = "status_code",
			m_bRequestSuccessful = "request_successful"
		}
	}

	function var_0_215.SendHTTPRequest(arg_418_0, arg_418_1)
		if arg_418_1 ~= nil and not var_0_117(arg_418_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_418_0 = var_0_174()
		local var_418_1 = var_412_6(var_412_0, arg_418_0, var_418_0)

		if arg_418_1 ~= nil then
			var_418_0 = var_0_152(var_418_0, arg_418_1, 2101, var_412_7)
		end

		return var_418_1, var_0_60(var_418_0)
	end

	var_0_215.send_http_request = var_0_215.SendHTTPRequest

	local var_412_8 = var_0_53(var_412_0, 6, "bool(__thiscall*)(void*, unsigned int, uint64_t *)")
	local var_412_9 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tunsigned int m_hRequest;\n\t\t\t\tuint64_t m_ulContextValue;\n\t\t\t\tbool m_bRequestSuccessful;\n\t\t\t\tint m_eStatusCode;\n\t\t\t\tuint32_t m_unBodySize;\n\t\t\t} *\n\t\t"),
		keys = {
			m_ulContextValue = "context_value",
			m_hRequest = "request",
			m_unBodySize = "body_size",
			m_eStatusCode = "status_code",
			m_bRequestSuccessful = "request_successful"
		}
	}

	function var_0_215.SendHTTPRequestAndStreamResponse(arg_419_0, arg_419_1)
		if arg_419_1 ~= nil and not var_0_117(arg_419_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_419_0 = var_0_174()
		local var_419_1 = var_412_8(var_412_0, arg_419_0, var_419_0)

		if arg_419_1 ~= nil then
			var_419_0 = var_0_152(var_419_0, arg_419_1, 2101, var_412_9)
		end

		return var_419_1, var_0_60(var_419_0)
	end

	var_0_215.send_http_request_and_stream_response = var_0_215.SendHTTPRequestAndStreamResponse

	local var_412_10 = var_0_53(var_412_0, 7, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_215.DeferHTTPRequest(arg_420_0)
		return var_412_10(var_412_0, arg_420_0)
	end

	var_0_215.defer_http_request = var_0_215.DeferHTTPRequest

	local var_412_11 = var_0_53(var_412_0, 8, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_215.PrioritizeHTTPRequest(arg_421_0)
		return var_412_11(var_412_0, arg_421_0)
	end

	var_0_215.prioritize_http_request = var_0_215.PrioritizeHTTPRequest

	local var_412_12 = var_0_53(var_412_0, 9, "bool(__thiscall*)(void*, unsigned int, const char *, uint32_t *)")

	function var_0_215.GetHTTPResponseHeaderSize(arg_422_0, arg_422_1)
		local var_422_0 = var_0_173()

		return var_412_12(var_412_0, arg_422_0, arg_422_1, var_422_0), var_0_60(var_422_0)
	end

	var_0_215.get_http_response_header_size = var_0_215.GetHTTPResponseHeaderSize

	local var_412_13 = var_0_53(var_412_0, 10, "bool(__thiscall*)(void*, unsigned int, const char *, uint8_t *, uint32_t)")

	function var_0_215.GetHTTPResponseHeaderValue(arg_423_0, arg_423_1, arg_423_2, arg_423_3)
		return var_412_13(var_412_0, arg_423_0, arg_423_1, arg_423_2, arg_423_3)
	end

	var_0_215.get_http_response_header_value = var_0_215.GetHTTPResponseHeaderValue

	local var_412_14 = var_0_53(var_412_0, 11, "bool(__thiscall*)(void*, unsigned int, uint32_t *)")

	function var_0_215.GetHTTPResponseBodySize(arg_424_0)
		local var_424_0 = var_0_173()

		return var_412_14(var_412_0, arg_424_0, var_424_0), var_0_60(var_424_0)
	end

	var_0_215.get_http_response_body_size = var_0_215.GetHTTPResponseBodySize

	local var_412_15 = var_0_53(var_412_0, 12, "bool(__thiscall*)(void*, unsigned int, uint8_t *, uint32_t)")

	function var_0_215.GetHTTPResponseBodyData(arg_425_0, arg_425_1, arg_425_2)
		return var_412_15(var_412_0, arg_425_0, arg_425_1, arg_425_2)
	end

	var_0_215.get_http_response_body_data = var_0_215.GetHTTPResponseBodyData

	local var_412_16 = var_0_53(var_412_0, 13, "bool(__thiscall*)(void*, unsigned int, uint32_t, uint8_t *, uint32_t)")

	function var_0_215.GetHTTPStreamingResponseBodyData(arg_426_0, arg_426_1, arg_426_2, arg_426_3)
		return var_412_16(var_412_0, arg_426_0, arg_426_1, arg_426_2, arg_426_3)
	end

	var_0_215.get_http_streaming_response_body_data = var_0_215.GetHTTPStreamingResponseBodyData

	local var_412_17 = var_0_53(var_412_0, 14, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_215.ReleaseHTTPRequest(arg_427_0)
		return var_412_17(var_412_0, arg_427_0)
	end

	var_0_215.release_http_request = var_0_215.ReleaseHTTPRequest

	local var_412_18 = var_0_53(var_412_0, 15, "bool(__thiscall*)(void*, unsigned int, float *)")

	function var_0_215.GetHTTPDownloadProgressPct(arg_428_0)
		local var_428_0 = var_0_168()

		return var_412_18(var_412_0, arg_428_0, var_428_0), var_0_60(var_428_0)
	end

	var_0_215.get_http_download_progress_pct = var_0_215.GetHTTPDownloadProgressPct

	local var_412_19 = var_0_53(var_412_0, 16, "bool(__thiscall*)(void*, unsigned int, const char *, uint8_t *, uint32_t)")

	function var_0_215.SetHTTPRequestRawPostBody(arg_429_0, arg_429_1, arg_429_2, arg_429_3)
		return var_412_19(var_412_0, arg_429_0, arg_429_1, arg_429_2, arg_429_3)
	end

	var_0_215.set_http_request_raw_post_body = var_0_215.SetHTTPRequestRawPostBody

	local var_412_20 = var_0_53(var_412_0, 17, "unsigned int(__thiscall*)(void*, bool)")

	function var_0_215.CreateCookieContainer(arg_430_0)
		return var_412_20(var_412_0, arg_430_0)
	end

	var_0_215.create_cookie_container = var_0_215.CreateCookieContainer

	local var_412_21 = var_0_53(var_412_0, 18, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_215.ReleaseCookieContainer(arg_431_0)
		return var_412_21(var_412_0, arg_431_0)
	end

	var_0_215.release_cookie_container = var_0_215.ReleaseCookieContainer

	local var_412_22 = var_0_53(var_412_0, 19, "bool(__thiscall*)(void*, unsigned int, const char *, const char *, const char *)")

	function var_0_215.SetCookie(arg_432_0, arg_432_1, arg_432_2, arg_432_3)
		return var_412_22(var_412_0, arg_432_0, arg_432_1, arg_432_2, arg_432_3)
	end

	var_0_215.set_cookie = var_0_215.SetCookie

	local var_412_23 = var_0_53(var_412_0, 20, "bool(__thiscall*)(void*, unsigned int, unsigned int)")

	function var_0_215.SetHTTPRequestCookieContainer(arg_433_0, arg_433_1)
		return var_412_23(var_412_0, arg_433_0, arg_433_1)
	end

	var_0_215.set_http_request_cookie_container = var_0_215.SetHTTPRequestCookieContainer

	local var_412_24 = var_0_53(var_412_0, 21, "bool(__thiscall*)(void*, unsigned int, const char *)")

	function var_0_215.SetHTTPRequestUserAgentInfo(arg_434_0, arg_434_1)
		return var_412_24(var_412_0, arg_434_0, arg_434_1)
	end

	var_0_215.set_http_request_user_agent_info = var_0_215.SetHTTPRequestUserAgentInfo

	local var_412_25 = var_0_53(var_412_0, 22, "bool(__thiscall*)(void*, unsigned int, bool)")

	function var_0_215.SetHTTPRequestRequiresVerifiedCertificate(arg_435_0, arg_435_1)
		return var_412_25(var_412_0, arg_435_0, arg_435_1)
	end

	var_0_215.set_http_request_requires_verified_certificate = var_0_215.SetHTTPRequestRequiresVerifiedCertificate

	local var_412_26 = var_0_53(var_412_0, 23, "bool(__thiscall*)(void*, unsigned int, uint32_t)")

	function var_0_215.SetHTTPRequestAbsoluteTimeoutMS(arg_436_0, arg_436_1)
		return var_412_26(var_412_0, arg_436_0, arg_436_1)
	end

	var_0_215.set_http_request_absolute_timeout_ms = var_0_215.SetHTTPRequestAbsoluteTimeoutMS

	local var_412_27 = var_0_53(var_412_0, 24, "bool(__thiscall*)(void*, unsigned int, bool *)")

	function var_0_215.GetHTTPRequestWasTimedOut(arg_437_0)
		local var_437_0 = var_0_166()

		return var_412_27(var_412_0, arg_437_0, var_437_0), var_0_60(var_437_0)
	end

	var_0_215.get_http_request_was_timed_out = var_0_215.GetHTTPRequestWasTimedOut

	return var_0_215
end

local var_0_216 = {
	version = "STEAMUGC_INTERFACE_VERSION016",
	version_number = 16
}

function var_0_62.ISteamUGC()
	local var_438_0 = vtable_bind("steamclient.dll", "SteamClient020", 27, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMUGC_INTERFACE_VERSION016")

	var_0_216.thisptr = var_438_0

	local var_438_1 = var_0_53(var_438_0, 0, "void(__thiscall*)(void*, uint64_t *, unsigned int, int, int, int, unsigned int, unsigned int, uint32_t)")

	function var_0_216.CreateQueryUserUGCRequest(arg_439_0, arg_439_1, arg_439_2, arg_439_3, arg_439_4, arg_439_5, arg_439_6)
		arg_439_1 = var_0_160(arg_439_1, var_0_64.EUserUGCList, "list_type is required")
		arg_439_2 = var_0_160(arg_439_2, var_0_64.EUGCMatchingUGCType, "matching_ugc_type is required")
		arg_439_3 = var_0_160(arg_439_3, var_0_64.EUserUGCListSortOrder, "sort_order is required")

		local var_439_0 = var_0_174()

		var_438_1(var_438_0, var_439_0, arg_439_0, arg_439_1, arg_439_2, arg_439_3, arg_439_4, arg_439_5, arg_439_6)

		return var_0_60(var_439_0)
	end

	var_0_216.create_query_user_ugc_request = var_0_216.CreateQueryUserUGCRequest

	local var_438_2 = var_0_53(var_438_0, 1, "void(__thiscall*)(void*, uint64_t *, int, int, unsigned int, unsigned int, uint32_t)")

	function var_0_216.CreateQueryAllUGCRequestPage(arg_440_0, arg_440_1, arg_440_2, arg_440_3, arg_440_4)
		arg_440_0 = var_0_160(arg_440_0, var_0_64.EUGCQuery, "query_type is required")
		arg_440_1 = var_0_160(arg_440_1, var_0_64.EUGCMatchingUGCType, "matchinge_matching_ugc_type_file_type is required")

		local var_440_0 = var_0_174()

		var_438_2(var_438_0, var_440_0, arg_440_0, arg_440_1, arg_440_2, arg_440_3, arg_440_4)

		return var_0_60(var_440_0)
	end

	var_0_216.create_query_all_ugc_request_page = var_0_216.CreateQueryAllUGCRequestPage

	local var_438_3 = var_0_53(var_438_0, 2, "void(__thiscall*)(void*, uint64_t *, int, int, unsigned int, unsigned int, const char *)")

	function var_0_216.CreateQueryAllUGCRequestCursor(arg_441_0, arg_441_1, arg_441_2, arg_441_3, arg_441_4)
		arg_441_0 = var_0_160(arg_441_0, var_0_64.EUGCQuery, "query_type is required")
		arg_441_1 = var_0_160(arg_441_1, var_0_64.EUGCMatchingUGCType, "matchinge_matching_ugc_type_file_type is required")

		local var_441_0 = var_0_174()

		var_438_3(var_438_0, var_441_0, arg_441_0, arg_441_1, arg_441_2, arg_441_3, arg_441_4)

		return var_0_60(var_441_0)
	end

	var_0_216.create_query_all_ugc_request_cursor = var_0_216.CreateQueryAllUGCRequestCursor

	local var_438_4 = var_0_53(var_438_0, 3, "void(__thiscall*)(void*, uint64_t *, uint64_t *, uint32_t)")

	function var_0_216.CreateQueryUGCDetailsRequest(arg_442_0, arg_442_1)
		local var_442_0 = var_0_174()

		var_438_4(var_438_0, var_442_0, arg_442_0, arg_442_1)

		return var_0_60(var_442_0)
	end

	var_0_216.create_query_ugc_details_request = var_0_216.CreateQueryUGCDetailsRequest

	local var_438_5 = var_0_53(var_438_0, 4, "uint64_t(__thiscall*)(void*, uint64_t)")
	local var_438_6 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_handle;\n\t\t\t\tint m_eResult;\n\t\t\t\tuint32_t m_unNumResultsReturned;\n\t\t\t\tuint32_t m_unTotalMatchingResults;\n\t\t\t\tbool m_bCachedData;\n\t\t\t\tchar m_rgchNextCursor[256];\n\t\t\t} *\n\t\t"),
		keys = {
			m_rgchNextCursor = "next_cursor",
			m_eResult = "result",
			m_bCachedData = "cached_data",
			m_unTotalMatchingResults = "total_matching_results",
			m_handle = "handle",
			m_unNumResultsReturned = "num_results_returned"
		}
	}

	function var_0_216.SendQueryUGCRequest(arg_443_0, arg_443_1)
		if arg_443_1 ~= nil and not var_0_117(arg_443_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_443_0 = var_438_5(var_438_0, arg_443_0)

		if arg_443_1 ~= nil then
			var_443_0 = var_0_152(var_443_0, arg_443_1, 3401, var_438_6)
		end

		return var_443_0
	end

	var_0_216.send_query_ugc_request = var_0_216.SendQueryUGCRequest

	local var_438_7 = var_0_53(var_438_0, 5, "bool(__thiscall*)(void*, uint64_t, uint32_t, SteamUGCDetails_t *)")

	function var_0_216.GetQueryUGCResult(arg_444_0, arg_444_1)
		local var_444_0 = var_0_103.SteamUGCDetails_t_arr(1)

		return var_438_7(var_438_0, arg_444_0, arg_444_1, var_444_0), var_0_60(var_444_0)
	end

	var_0_216.get_query_ugc_result = var_0_216.GetQueryUGCResult

	local var_438_8 = var_0_53(var_438_0, 6, "uint32_t(__thiscall*)(void*, uint64_t, uint32_t)")

	function var_0_216.GetQueryUGCNumTags(arg_445_0, arg_445_1)
		return var_438_8(var_438_0, arg_445_0, arg_445_1)
	end

	var_0_216.get_query_ugc_num_tags = var_0_216.GetQueryUGCNumTags

	local var_438_9 = var_0_53(var_438_0, 7, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t)")

	function var_0_216.GetQueryUGCTag(arg_446_0, arg_446_1, arg_446_2, arg_446_3, arg_446_4)
		return var_438_9(var_438_0, arg_446_0, arg_446_1, arg_446_2, arg_446_3, arg_446_4)
	end

	var_0_216.get_query_ugc_tag = var_0_216.GetQueryUGCTag

	local var_438_10 = var_0_53(var_438_0, 8, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t)")

	function var_0_216.GetQueryUGCTagDisplayName(arg_447_0, arg_447_1, arg_447_2, arg_447_3, arg_447_4)
		return var_438_10(var_438_0, arg_447_0, arg_447_1, arg_447_2, arg_447_3, arg_447_4)
	end

	var_0_216.get_query_ugc_tag_display_name = var_0_216.GetQueryUGCTagDisplayName

	local var_438_11 = var_0_53(var_438_0, 9, "bool(__thiscall*)(void*, uint64_t, uint32_t, char *, uint32_t)")

	function var_0_216.GetQueryUGCPreviewURL(arg_448_0, arg_448_1, arg_448_2, arg_448_3)
		return var_438_11(var_438_0, arg_448_0, arg_448_1, arg_448_2, arg_448_3)
	end

	var_0_216.get_query_ugc_preview_url = var_0_216.GetQueryUGCPreviewURL

	local var_438_12 = var_0_53(var_438_0, 10, "bool(__thiscall*)(void*, uint64_t, uint32_t, char *, uint32_t)")

	function var_0_216.GetQueryUGCMetadata(arg_449_0, arg_449_1, arg_449_2, arg_449_3)
		return var_438_12(var_438_0, arg_449_0, arg_449_1, arg_449_2, arg_449_3)
	end

	var_0_216.get_query_ugc_metadata = var_0_216.GetQueryUGCMetadata

	local var_438_13 = var_0_53(var_438_0, 11, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint64_t *, uint32_t)")

	function var_0_216.GetQueryUGCChildren(arg_450_0, arg_450_1, arg_450_2, arg_450_3)
		return var_438_13(var_438_0, arg_450_0, arg_450_1, arg_450_2, arg_450_3)
	end

	var_0_216.get_query_ugc_children = var_0_216.GetQueryUGCChildren

	local var_438_14 = var_0_53(var_438_0, 12, "bool(__thiscall*)(void*, uint64_t, uint32_t, int, uint64_t *)")

	function var_0_216.GetQueryUGCStatistic(arg_451_0, arg_451_1, arg_451_2)
		arg_451_2 = var_0_160(arg_451_2, var_0_64.EItemStatistic, "stat_type is required")

		local var_451_0 = var_0_174()

		return var_438_14(var_438_0, arg_451_0, arg_451_1, arg_451_2, var_451_0), var_0_60(var_451_0)
	end

	var_0_216.get_query_ugc_statistic = var_0_216.GetQueryUGCStatistic

	local var_438_15 = var_0_53(var_438_0, 13, "uint32_t(__thiscall*)(void*, uint64_t, uint32_t)")

	function var_0_216.GetQueryUGCNumAdditionalPreviews(arg_452_0, arg_452_1)
		return var_438_15(var_438_0, arg_452_0, arg_452_1)
	end

	var_0_216.get_query_ugc_num_additional_previews = var_0_216.GetQueryUGCNumAdditionalPreviews

	local var_438_16 = var_0_53(var_438_0, 14, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t, char *, uint32_t, int *)")

	function var_0_216.GetQueryUGCAdditionalPreview(arg_453_0, arg_453_1, arg_453_2, arg_453_3, arg_453_4, arg_453_5, arg_453_6)
		local var_453_0 = var_0_171()

		return var_438_16(var_438_0, arg_453_0, arg_453_1, arg_453_2, arg_453_3, arg_453_4, arg_453_5, arg_453_6, var_453_0), var_0_60(var_453_0)
	end

	var_0_216.get_query_ugc_additional_preview = var_0_216.GetQueryUGCAdditionalPreview

	local var_438_17 = var_0_53(var_438_0, 15, "uint32_t(__thiscall*)(void*, uint64_t, uint32_t)")

	function var_0_216.GetQueryUGCNumKeyValueTags(arg_454_0, arg_454_1)
		return var_438_17(var_438_0, arg_454_0, arg_454_1)
	end

	var_0_216.get_query_ugc_num_key_value_tags = var_0_216.GetQueryUGCNumKeyValueTags

	local var_438_18 = var_0_53(var_438_0, 16, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t, char *, uint32_t)")

	function var_0_216.GetQueryUGCKeyValueTag(arg_455_0, arg_455_1, arg_455_2, arg_455_3, arg_455_4, arg_455_5, arg_455_6)
		return var_438_18(var_438_0, arg_455_0, arg_455_1, arg_455_2, arg_455_3, arg_455_4, arg_455_5, arg_455_6)
	end

	var_0_216.get_query_ugc_key_value_tag = var_0_216.GetQueryUGCKeyValueTag

	local var_438_19 = var_0_53(var_438_0, 17, "bool(__thiscall*)(void*, uint64_t, uint32_t, const char *, char *, uint32_t)")

	function var_0_216.GetQueryFirstUGCKeyValueTag(arg_456_0, arg_456_1, arg_456_2, arg_456_3, arg_456_4)
		return var_438_19(var_438_0, arg_456_0, arg_456_1, arg_456_2, arg_456_3, arg_456_4)
	end

	var_0_216.get_query_first_ugc_key_value_tag = var_0_216.GetQueryFirstUGCKeyValueTag

	local var_438_20 = var_0_53(var_438_0, 18, "bool(__thiscall*)(void*, uint64_t)")

	function var_0_216.ReleaseQueryUGCRequest(arg_457_0)
		return var_438_20(var_438_0, arg_457_0)
	end

	var_0_216.release_query_ugc_request = var_0_216.ReleaseQueryUGCRequest

	local var_438_21 = var_0_53(var_438_0, 19, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.AddRequiredTag(arg_458_0, arg_458_1)
		return var_438_21(var_438_0, arg_458_0, arg_458_1)
	end

	var_0_216.add_required_tag = var_0_216.AddRequiredTag

	local var_438_22 = var_0_53(var_438_0, 20, "bool(__thiscall*)(void*, uint64_t, const SteamParamStringArray_t *)")

	function var_0_216.AddRequiredTagGroup(arg_459_0, arg_459_1)
		return var_438_22(var_438_0, arg_459_0, arg_459_1)
	end

	var_0_216.add_required_tag_group = var_0_216.AddRequiredTagGroup

	local var_438_23 = var_0_53(var_438_0, 21, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.AddExcludedTag(arg_460_0, arg_460_1)
		return var_438_23(var_438_0, arg_460_0, arg_460_1)
	end

	var_0_216.add_excluded_tag = var_0_216.AddExcludedTag

	local var_438_24 = var_0_53(var_438_0, 22, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetReturnOnlyIDs(arg_461_0, arg_461_1)
		return var_438_24(var_438_0, arg_461_0, arg_461_1)
	end

	var_0_216.set_return_only_ids = var_0_216.SetReturnOnlyIDs

	local var_438_25 = var_0_53(var_438_0, 23, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetReturnKeyValueTags(arg_462_0, arg_462_1)
		return var_438_25(var_438_0, arg_462_0, arg_462_1)
	end

	var_0_216.set_return_key_value_tags = var_0_216.SetReturnKeyValueTags

	local var_438_26 = var_0_53(var_438_0, 24, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetReturnLongDescription(arg_463_0, arg_463_1)
		return var_438_26(var_438_0, arg_463_0, arg_463_1)
	end

	var_0_216.set_return_long_description = var_0_216.SetReturnLongDescription

	local var_438_27 = var_0_53(var_438_0, 25, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetReturnMetadata(arg_464_0, arg_464_1)
		return var_438_27(var_438_0, arg_464_0, arg_464_1)
	end

	var_0_216.set_return_metadata = var_0_216.SetReturnMetadata

	local var_438_28 = var_0_53(var_438_0, 26, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetReturnChildren(arg_465_0, arg_465_1)
		return var_438_28(var_438_0, arg_465_0, arg_465_1)
	end

	var_0_216.set_return_children = var_0_216.SetReturnChildren

	local var_438_29 = var_0_53(var_438_0, 27, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetReturnAdditionalPreviews(arg_466_0, arg_466_1)
		return var_438_29(var_438_0, arg_466_0, arg_466_1)
	end

	var_0_216.set_return_additional_previews = var_0_216.SetReturnAdditionalPreviews

	local var_438_30 = var_0_53(var_438_0, 28, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetReturnTotalOnly(arg_467_0, arg_467_1)
		return var_438_30(var_438_0, arg_467_0, arg_467_1)
	end

	var_0_216.set_return_total_only = var_0_216.SetReturnTotalOnly

	local var_438_31 = var_0_53(var_438_0, 29, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function var_0_216.SetReturnPlaytimeStats(arg_468_0, arg_468_1)
		return var_438_31(var_438_0, arg_468_0, arg_468_1)
	end

	var_0_216.set_return_playtime_stats = var_0_216.SetReturnPlaytimeStats

	local var_438_32 = var_0_53(var_438_0, 30, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetLanguage(arg_469_0, arg_469_1)
		return var_438_32(var_438_0, arg_469_0, arg_469_1)
	end

	var_0_216.set_language = var_0_216.SetLanguage

	local var_438_33 = var_0_53(var_438_0, 31, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function var_0_216.SetAllowCachedResponse(arg_470_0, arg_470_1)
		return var_438_33(var_438_0, arg_470_0, arg_470_1)
	end

	var_0_216.set_allow_cached_response = var_0_216.SetAllowCachedResponse

	local var_438_34 = var_0_53(var_438_0, 32, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetCloudFileNameFilter(arg_471_0, arg_471_1)
		return var_438_34(var_438_0, arg_471_0, arg_471_1)
	end

	var_0_216.set_cloud_file_name_filter = var_0_216.SetCloudFileNameFilter

	local var_438_35 = var_0_53(var_438_0, 33, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetMatchAnyTag(arg_472_0, arg_472_1)
		return var_438_35(var_438_0, arg_472_0, arg_472_1)
	end

	var_0_216.set_match_any_tag = var_0_216.SetMatchAnyTag

	local var_438_36 = var_0_53(var_438_0, 34, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetSearchText(arg_473_0, arg_473_1)
		return var_438_36(var_438_0, arg_473_0, arg_473_1)
	end

	var_0_216.set_search_text = var_0_216.SetSearchText

	local var_438_37 = var_0_53(var_438_0, 35, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function var_0_216.SetRankedByTrendDays(arg_474_0, arg_474_1)
		return var_438_37(var_438_0, arg_474_0, arg_474_1)
	end

	var_0_216.set_ranked_by_trend_days = var_0_216.SetRankedByTrendDays

	local var_438_38 = var_0_53(var_438_0, 36, "bool(__thiscall*)(void*, uint64_t, unsigned int, unsigned int)")

	function var_0_216.SetTimeCreatedDateRange(arg_475_0, arg_475_1, arg_475_2)
		return var_438_38(var_438_0, arg_475_0, arg_475_1, arg_475_2)
	end

	var_0_216.set_time_created_date_range = var_0_216.SetTimeCreatedDateRange

	local var_438_39 = var_0_53(var_438_0, 37, "bool(__thiscall*)(void*, uint64_t, unsigned int, unsigned int)")

	function var_0_216.SetTimeUpdatedDateRange(arg_476_0, arg_476_1, arg_476_2)
		return var_438_39(var_438_0, arg_476_0, arg_476_1, arg_476_2)
	end

	var_0_216.set_time_updated_date_range = var_0_216.SetTimeUpdatedDateRange

	local var_438_40 = var_0_53(var_438_0, 38, "bool(__thiscall*)(void*, uint64_t, const char *, const char *)")

	function var_0_216.AddRequiredKeyValueTag(arg_477_0, arg_477_1, arg_477_2)
		return var_438_40(var_438_0, arg_477_0, arg_477_1, arg_477_2)
	end

	var_0_216.add_required_key_value_tag = var_0_216.AddRequiredKeyValueTag

	local var_438_41 = var_0_53(var_438_0, 39, "uint64_t(__thiscall*)(void*, uint64_t, uint32_t)")
	local var_438_42 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tSteamUGCDetails_t m_details;\n\t\t\t\tbool m_bCachedData;\n\t\t\t} *\n\t\t"),
		keys = {
			m_details = "details",
			m_bCachedData = "cached_data"
		}
	}

	function var_0_216.RequestUGCDetails(arg_478_0, arg_478_1, arg_478_2)
		if arg_478_2 ~= nil and not var_0_117(arg_478_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_478_0 = var_438_41(var_438_0, arg_478_0, arg_478_1)

		if arg_478_2 ~= nil then
			var_478_0 = var_0_152(var_478_0, arg_478_2, 3402, var_438_42)
		end

		return var_478_0
	end

	var_0_216.request_ugc_details = var_0_216.RequestUGCDetails

	local var_438_43 = var_0_53(var_438_0, 40, "uint64_t(__thiscall*)(void*, unsigned int, int)")
	local var_438_44 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tbool m_bUserNeedsToAcceptWorkshopLegalAgreement;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bUserNeedsToAcceptWorkshopLegalAgreement = "user_needs_to_accept_workshop_legal_agreement",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.CreateItem(arg_479_0, arg_479_1, arg_479_2)
		arg_479_1 = var_0_160(arg_479_1, var_0_64.EWorkshopFileType, "file_type is required")

		if arg_479_2 ~= nil and not var_0_117(arg_479_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_479_0 = var_438_43(var_438_0, arg_479_0, arg_479_1)

		if arg_479_2 ~= nil then
			var_479_0 = var_0_152(var_479_0, arg_479_2, 3403, var_438_44)
		end

		return var_479_0
	end

	var_0_216.create_item = var_0_216.CreateItem

	local var_438_45 = var_0_53(var_438_0, 41, "void(__thiscall*)(void*, uint64_t *, unsigned int, uint64_t)")

	function var_0_216.StartItemUpdate(arg_480_0, arg_480_1)
		local var_480_0 = var_0_174()

		var_438_45(var_438_0, var_480_0, arg_480_0, arg_480_1)

		return var_0_60(var_480_0)
	end

	var_0_216.start_item_update = var_0_216.StartItemUpdate

	local var_438_46 = var_0_53(var_438_0, 42, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetItemTitle(arg_481_0, arg_481_1)
		return var_438_46(var_438_0, arg_481_0, arg_481_1)
	end

	var_0_216.set_item_title = var_0_216.SetItemTitle

	local var_438_47 = var_0_53(var_438_0, 43, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetItemDescription(arg_482_0, arg_482_1)
		return var_438_47(var_438_0, arg_482_0, arg_482_1)
	end

	var_0_216.set_item_description = var_0_216.SetItemDescription

	local var_438_48 = var_0_53(var_438_0, 44, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetItemUpdateLanguage(arg_483_0, arg_483_1)
		return var_438_48(var_438_0, arg_483_0, arg_483_1)
	end

	var_0_216.set_item_update_language = var_0_216.SetItemUpdateLanguage

	local var_438_49 = var_0_53(var_438_0, 45, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetItemMetadata(arg_484_0, arg_484_1)
		return var_438_49(var_438_0, arg_484_0, arg_484_1)
	end

	var_0_216.set_item_metadata = var_0_216.SetItemMetadata

	local var_438_50 = var_0_53(var_438_0, 46, "bool(__thiscall*)(void*, uint64_t, int)")

	function var_0_216.SetItemVisibility(arg_485_0, arg_485_1)
		arg_485_1 = var_0_160(arg_485_1, var_0_64.ERemoteStoragePublishedFileVisibility, "visibility is required")

		return var_438_50(var_438_0, arg_485_0, arg_485_1)
	end

	var_0_216.set_item_visibility = var_0_216.SetItemVisibility

	local var_438_51 = var_0_53(var_438_0, 47, "bool(__thiscall*)(void*, uint64_t, const SteamParamStringArray_t *)")

	function var_0_216.SetItemTags(arg_486_0, arg_486_1)
		return var_438_51(var_438_0, arg_486_0, arg_486_1)
	end

	var_0_216.set_item_tags = var_0_216.SetItemTags

	local var_438_52 = var_0_53(var_438_0, 48, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetItemContent(arg_487_0, arg_487_1)
		return var_438_52(var_438_0, arg_487_0, arg_487_1)
	end

	var_0_216.set_item_content = var_0_216.SetItemContent

	local var_438_53 = var_0_53(var_438_0, 49, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.SetItemPreview(arg_488_0, arg_488_1)
		return var_438_53(var_438_0, arg_488_0, arg_488_1)
	end

	var_0_216.set_item_preview = var_0_216.SetItemPreview

	local var_438_54 = var_0_53(var_438_0, 50, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.SetAllowLegacyUpload(arg_489_0, arg_489_1)
		return var_438_54(var_438_0, arg_489_0, arg_489_1)
	end

	var_0_216.set_allow_legacy_upload = var_0_216.SetAllowLegacyUpload

	local var_438_55 = var_0_53(var_438_0, 51, "bool(__thiscall*)(void*, uint64_t)")

	function var_0_216.RemoveAllItemKeyValueTags(arg_490_0)
		return var_438_55(var_438_0, arg_490_0)
	end

	var_0_216.remove_all_item_key_value_tags = var_0_216.RemoveAllItemKeyValueTags

	local var_438_56 = var_0_53(var_438_0, 52, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.RemoveItemKeyValueTags(arg_491_0, arg_491_1)
		return var_438_56(var_438_0, arg_491_0, arg_491_1)
	end

	var_0_216.remove_item_key_value_tags = var_0_216.RemoveItemKeyValueTags

	local var_438_57 = var_0_53(var_438_0, 53, "bool(__thiscall*)(void*, uint64_t, const char *, const char *)")

	function var_0_216.AddItemKeyValueTag(arg_492_0, arg_492_1, arg_492_2)
		return var_438_57(var_438_0, arg_492_0, arg_492_1, arg_492_2)
	end

	var_0_216.add_item_key_value_tag = var_0_216.AddItemKeyValueTag

	local var_438_58 = var_0_53(var_438_0, 54, "bool(__thiscall*)(void*, uint64_t, const char *, int)")

	function var_0_216.AddItemPreviewFile(arg_493_0, arg_493_1, arg_493_2)
		arg_493_2 = var_0_160(arg_493_2, var_0_64.EItemPreviewType, "type is required")

		return var_438_58(var_438_0, arg_493_0, arg_493_1, arg_493_2)
	end

	var_0_216.add_item_preview_file = var_0_216.AddItemPreviewFile

	local var_438_59 = var_0_53(var_438_0, 55, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function var_0_216.AddItemPreviewVideo(arg_494_0, arg_494_1)
		return var_438_59(var_438_0, arg_494_0, arg_494_1)
	end

	var_0_216.add_item_preview_video = var_0_216.AddItemPreviewVideo

	local var_438_60 = var_0_53(var_438_0, 56, "bool(__thiscall*)(void*, uint64_t, uint32_t, const char *)")

	function var_0_216.UpdateItemPreviewFile(arg_495_0, arg_495_1, arg_495_2)
		return var_438_60(var_438_0, arg_495_0, arg_495_1, arg_495_2)
	end

	var_0_216.update_item_preview_file = var_0_216.UpdateItemPreviewFile

	local var_438_61 = var_0_53(var_438_0, 57, "bool(__thiscall*)(void*, uint64_t, uint32_t, const char *)")

	function var_0_216.UpdateItemPreviewVideo(arg_496_0, arg_496_1, arg_496_2)
		return var_438_61(var_438_0, arg_496_0, arg_496_1, arg_496_2)
	end

	var_0_216.update_item_preview_video = var_0_216.UpdateItemPreviewVideo

	local var_438_62 = var_0_53(var_438_0, 58, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function var_0_216.RemoveItemPreview(arg_497_0, arg_497_1)
		return var_438_62(var_438_0, arg_497_0, arg_497_1)
	end

	var_0_216.remove_item_preview = var_0_216.RemoveItemPreview

	local var_438_63 = var_0_53(var_438_0, 59, "uint64_t(__thiscall*)(void*, uint64_t, const char *)")
	local var_438_64 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tbool m_bUserNeedsToAcceptWorkshopLegalAgreement;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_bUserNeedsToAcceptWorkshopLegalAgreement = "user_needs_to_accept_workshop_legal_agreement",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.SubmitItemUpdate(arg_498_0, arg_498_1, arg_498_2)
		if arg_498_2 ~= nil and not var_0_117(arg_498_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_498_0 = var_438_63(var_438_0, arg_498_0, arg_498_1)

		if arg_498_2 ~= nil then
			var_498_0 = var_0_152(var_498_0, arg_498_2, 3404, var_438_64)
		end

		return var_498_0
	end

	var_0_216.submit_item_update = var_0_216.SubmitItemUpdate

	local var_438_65 = var_0_53(var_438_0, 60, "int(__thiscall*)(void*, uint64_t, uint64_t *, uint64_t *)")

	function var_0_216.GetItemUpdateProgress(arg_499_0)
		local var_499_0 = var_0_174()
		local var_499_1 = var_0_174()

		return var_438_65(var_438_0, arg_499_0, var_499_0, var_499_1), var_0_60(var_499_0), var_0_60(var_499_1)
	end

	var_0_216.get_item_update_progress = var_0_216.GetItemUpdateProgress

	local var_438_66 = var_0_53(var_438_0, 61, "uint64_t(__thiscall*)(void*, uint64_t, bool)")
	local var_438_67 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tint m_eResult;\n\t\t\t\tbool m_bVoteUp;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bVoteUp = "vote_up",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.SetUserItemVote(arg_500_0, arg_500_1, arg_500_2)
		if arg_500_2 ~= nil and not var_0_117(arg_500_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_500_0 = var_438_66(var_438_0, arg_500_0, arg_500_1)

		if arg_500_2 ~= nil then
			var_500_0 = var_0_152(var_500_0, arg_500_2, 3408, var_438_67)
		end

		return var_500_0
	end

	var_0_216.set_user_item_vote = var_0_216.SetUserItemVote

	local var_438_68 = var_0_53(var_438_0, 62, "uint64_t(__thiscall*)(void*, uint64_t)")
	local var_438_69 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tint m_eResult;\n\t\t\t\tbool m_bVotedUp;\n\t\t\t\tbool m_bVotedDown;\n\t\t\t\tbool m_bVoteSkipped;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bVoteSkipped = "vote_skipped",
			m_bVotedDown = "voted_down",
			m_bVotedUp = "voted_up",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.GetUserItemVote(arg_501_0, arg_501_1)
		if arg_501_1 ~= nil and not var_0_117(arg_501_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_501_0 = var_438_68(var_438_0, arg_501_0)

		if arg_501_1 ~= nil then
			var_501_0 = var_0_152(var_501_0, arg_501_1, 3409, var_438_69)
		end

		return var_501_0
	end

	var_0_216.get_user_item_vote = var_0_216.GetUserItemVote

	local var_438_70 = var_0_53(var_438_0, 63, "uint64_t(__thiscall*)(void*, unsigned int, uint64_t)")
	local var_438_71 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tint m_eResult;\n\t\t\t\tbool m_bWasAddRequest;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bWasAddRequest = "was_add_request",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.AddItemToFavorites(arg_502_0, arg_502_1, arg_502_2)
		if arg_502_2 ~= nil and not var_0_117(arg_502_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_502_0 = var_438_70(var_438_0, arg_502_0, arg_502_1)

		if arg_502_2 ~= nil then
			var_502_0 = var_0_152(var_502_0, arg_502_2, 3407, var_438_71)
		end

		return var_502_0
	end

	var_0_216.add_item_to_favorites = var_0_216.AddItemToFavorites

	local var_438_72 = var_0_53(var_438_0, 64, "uint64_t(__thiscall*)(void*, unsigned int, uint64_t)")
	local var_438_73 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tint m_eResult;\n\t\t\t\tbool m_bWasAddRequest;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bWasAddRequest = "was_add_request",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.RemoveItemFromFavorites(arg_503_0, arg_503_1, arg_503_2)
		if arg_503_2 ~= nil and not var_0_117(arg_503_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_503_0 = var_438_72(var_438_0, arg_503_0, arg_503_1)

		if arg_503_2 ~= nil then
			var_503_0 = var_0_152(var_503_0, arg_503_2, 3407, var_438_73)
		end

		return var_503_0
	end

	var_0_216.remove_item_from_favorites = var_0_216.RemoveItemFromFavorites

	local var_438_74 = var_0_53(var_438_0, 65, "uint64_t(__thiscall*)(void*, uint64_t)")
	local var_438_75 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.SubscribeItem(arg_504_0, arg_504_1)
		if arg_504_1 ~= nil and not var_0_117(arg_504_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_504_0 = var_438_74(var_438_0, arg_504_0)

		if arg_504_1 ~= nil then
			var_504_0 = var_0_152(var_504_0, arg_504_1, 1313, var_438_75)
		end

		return var_504_0
	end

	var_0_216.subscribe_item = var_0_216.SubscribeItem

	local var_438_76 = var_0_53(var_438_0, 66, "uint64_t(__thiscall*)(void*, uint64_t)")
	local var_438_77 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.UnsubscribeItem(arg_505_0, arg_505_1)
		if arg_505_1 ~= nil and not var_0_117(arg_505_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_505_0 = var_438_76(var_438_0, arg_505_0)

		if arg_505_1 ~= nil then
			var_505_0 = var_0_152(var_505_0, arg_505_1, 1315, var_438_77)
		end

		return var_505_0
	end

	var_0_216.unsubscribe_item = var_0_216.UnsubscribeItem

	local var_438_78 = var_0_53(var_438_0, 67, "uint32_t(__thiscall*)(void*)")

	function var_0_216.GetNumSubscribedItems()
		return var_438_78(var_438_0)
	end

	var_0_216.get_num_subscribed_items = var_0_216.GetNumSubscribedItems

	local var_438_79 = var_0_53(var_438_0, 68, "uint32_t(__thiscall*)(void*, uint64_t *, uint32_t)")

	function var_0_216.GetSubscribedItems(arg_507_0, arg_507_1)
		return var_438_79(var_438_0, arg_507_0, arg_507_1)
	end

	var_0_216.get_subscribed_items = var_0_216.GetSubscribedItems

	local var_438_80 = var_0_53(var_438_0, 69, "uint32_t(__thiscall*)(void*, uint64_t)")

	function var_0_216.GetItemState(arg_508_0)
		return var_438_80(var_438_0, arg_508_0)
	end

	var_0_216.get_item_state = var_0_216.GetItemState

	local var_438_81 = var_0_53(var_438_0, 70, "bool(__thiscall*)(void*, uint64_t, uint64_t *, char *, uint32_t, uint32_t *)")

	function var_0_216.GetItemInstallInfo(arg_509_0, arg_509_1, arg_509_2)
		local var_509_0 = var_0_174()
		local var_509_1 = var_0_173()

		return var_438_81(var_438_0, arg_509_0, var_509_0, arg_509_1, arg_509_2, var_509_1), var_0_60(var_509_0), var_0_60(var_509_1)
	end

	var_0_216.get_item_install_info = var_0_216.GetItemInstallInfo

	local var_438_82 = var_0_53(var_438_0, 71, "bool(__thiscall*)(void*, uint64_t, uint64_t *, uint64_t *)")

	function var_0_216.GetItemDownloadInfo(arg_510_0)
		local var_510_0 = var_0_174()
		local var_510_1 = var_0_174()

		return var_438_82(var_438_0, arg_510_0, var_510_0, var_510_1), var_0_60(var_510_0), var_0_60(var_510_1)
	end

	var_0_216.get_item_download_info = var_0_216.GetItemDownloadInfo

	local var_438_83 = var_0_53(var_438_0, 72, "bool(__thiscall*)(void*, uint64_t, bool)")

	function var_0_216.DownloadItem(arg_511_0, arg_511_1)
		return var_438_83(var_438_0, arg_511_0, arg_511_1)
	end

	var_0_216.download_item = var_0_216.DownloadItem

	local var_438_84 = var_0_53(var_438_0, 73, "bool(__thiscall*)(void*, unsigned int, const char *)")

	function var_0_216.BInitWorkshopForGameServer(arg_512_0, arg_512_1)
		return var_438_84(var_438_0, arg_512_0, arg_512_1)
	end

	var_0_216.init_workshop_for_game_server = var_0_216.BInitWorkshopForGameServer

	local var_438_85 = var_0_53(var_438_0, 74, "void(__thiscall*)(void*, bool)")

	function var_0_216.SuspendDownloads(arg_513_0)
		return var_438_85(var_438_0, arg_513_0)
	end

	var_0_216.suspend_downloads = var_0_216.SuspendDownloads

	local var_438_86 = var_0_53(var_438_0, 75, "uint64_t(__thiscall*)(void*, uint64_t *, uint32_t)")
	local var_438_87 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result"
		}
	}

	function var_0_216.StartPlaytimeTracking(arg_514_0, arg_514_1, arg_514_2)
		if arg_514_2 ~= nil and not var_0_117(arg_514_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_514_0 = var_438_86(var_438_0, arg_514_0, arg_514_1)

		if arg_514_2 ~= nil then
			var_514_0 = var_0_152(var_514_0, arg_514_2, 3410, var_438_87)
		end

		return var_514_0
	end

	var_0_216.start_playtime_tracking = var_0_216.StartPlaytimeTracking

	local var_438_88 = var_0_53(var_438_0, 76, "uint64_t(__thiscall*)(void*, uint64_t *, uint32_t)")
	local var_438_89 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result"
		}
	}

	function var_0_216.StopPlaytimeTracking(arg_515_0, arg_515_1, arg_515_2)
		if arg_515_2 ~= nil and not var_0_117(arg_515_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_515_0 = var_438_88(var_438_0, arg_515_0, arg_515_1)

		if arg_515_2 ~= nil then
			var_515_0 = var_0_152(var_515_0, arg_515_2, 3411, var_438_89)
		end

		return var_515_0
	end

	var_0_216.stop_playtime_tracking = var_0_216.StopPlaytimeTracking

	local var_438_90 = var_0_53(var_438_0, 77, "uint64_t(__thiscall*)(void*)")
	local var_438_91 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result"
		}
	}

	function var_0_216.StopPlaytimeTrackingForAllItems(arg_516_0)
		if arg_516_0 ~= nil and not var_0_117(arg_516_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_516_0 = var_438_90(var_438_0)

		if arg_516_0 ~= nil then
			var_516_0 = var_0_152(var_516_0, arg_516_0, 3411, var_438_91)
		end

		return var_516_0
	end

	var_0_216.stop_playtime_tracking_for_all_items = var_0_216.StopPlaytimeTrackingForAllItems

	local var_438_92 = var_0_53(var_438_0, 78, "uint64_t(__thiscall*)(void*, uint64_t, uint64_t)")
	local var_438_93 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tuint64_t m_nChildPublishedFileId;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nChildPublishedFileId = "child_published_file_id",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.AddDependency(arg_517_0, arg_517_1, arg_517_2)
		if arg_517_2 ~= nil and not var_0_117(arg_517_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_517_0 = var_438_92(var_438_0, arg_517_0, arg_517_1)

		if arg_517_2 ~= nil then
			var_517_0 = var_0_152(var_517_0, arg_517_2, 3412, var_438_93)
		end

		return var_517_0
	end

	var_0_216.add_dependency = var_0_216.AddDependency

	local var_438_94 = var_0_53(var_438_0, 79, "uint64_t(__thiscall*)(void*, uint64_t, uint64_t)")
	local var_438_95 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tuint64_t m_nChildPublishedFileId;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nChildPublishedFileId = "child_published_file_id",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.RemoveDependency(arg_518_0, arg_518_1, arg_518_2)
		if arg_518_2 ~= nil and not var_0_117(arg_518_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_518_0 = var_438_94(var_438_0, arg_518_0, arg_518_1)

		if arg_518_2 ~= nil then
			var_518_0 = var_0_152(var_518_0, arg_518_2, 3413, var_438_95)
		end

		return var_518_0
	end

	var_0_216.remove_dependency = var_0_216.RemoveDependency

	local var_438_96 = var_0_53(var_438_0, 80, "uint64_t(__thiscall*)(void*, uint64_t, unsigned int)")
	local var_438_97 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tunsigned int m_nAppID;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nAppID = "appid",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.AddAppDependency(arg_519_0, arg_519_1, arg_519_2)
		if arg_519_2 ~= nil and not var_0_117(arg_519_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_519_0 = var_438_96(var_438_0, arg_519_0, arg_519_1)

		if arg_519_2 ~= nil then
			var_519_0 = var_0_152(var_519_0, arg_519_2, 3414, var_438_97)
		end

		return var_519_0
	end

	var_0_216.add_app_dependency = var_0_216.AddAppDependency

	local var_438_98 = var_0_53(var_438_0, 81, "uint64_t(__thiscall*)(void*, uint64_t, unsigned int)")
	local var_438_99 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tunsigned int m_nAppID;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nAppID = "appid",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.RemoveAppDependency(arg_520_0, arg_520_1, arg_520_2)
		if arg_520_2 ~= nil and not var_0_117(arg_520_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_520_0 = var_438_98(var_438_0, arg_520_0, arg_520_1)

		if arg_520_2 ~= nil then
			var_520_0 = var_0_152(var_520_0, arg_520_2, 3415, var_438_99)
		end

		return var_520_0
	end

	var_0_216.remove_app_dependency = var_0_216.RemoveAppDependency

	local var_438_100 = var_0_53(var_438_0, 82, "uint64_t(__thiscall*)(void*, uint64_t)")
	local var_438_101 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t\tunsigned int m_rgAppIDs[32];\n\t\t\t\tuint32_t m_nNumAppDependencies;\n\t\t\t\tuint32_t m_nTotalNumAppDependencies;\n\t\t\t} *\n\t\t"),
		keys = {
			m_nTotalNumAppDependencies = "total_num_app_dependencies",
			m_nNumAppDependencies = "num_app_dependencies",
			m_rgAppIDs = "appids",
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.GetAppDependencies(arg_521_0, arg_521_1)
		if arg_521_1 ~= nil and not var_0_117(arg_521_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_521_0 = var_438_100(var_438_0, arg_521_0)

		if arg_521_1 ~= nil then
			var_521_0 = var_0_152(var_521_0, arg_521_1, 3416, var_438_101)
		end

		return var_521_0
	end

	var_0_216.get_app_dependencies = var_0_216.GetAppDependencies

	local var_438_102 = var_0_53(var_438_0, 83, "uint64_t(__thiscall*)(void*, uint64_t)")
	local var_438_103 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tuint64_t m_nPublishedFileId;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function var_0_216.DeleteItem(arg_522_0, arg_522_1)
		if arg_522_1 ~= nil and not var_0_117(arg_522_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_522_0 = var_438_102(var_438_0, arg_522_0)

		if arg_522_1 ~= nil then
			var_522_0 = var_0_152(var_522_0, arg_522_1, 3417, var_438_103)
		end

		return var_522_0
	end

	var_0_216.delete_item = var_0_216.DeleteItem

	local var_438_104 = var_0_53(var_438_0, 84, "bool(__thiscall*)(void*)")

	function var_0_216.ShowWorkshopEULA()
		return var_438_104(var_438_0)
	end

	var_0_216.show_workshop_eula = var_0_216.ShowWorkshopEULA

	local var_438_105 = var_0_53(var_438_0, 85, "uint64_t(__thiscall*)(void*)")
	local var_438_106 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tunsigned int m_nAppID;\n\t\t\t\tuint32_t m_unVersion;\n\t\t\t\tunsigned int m_rtAction;\n\t\t\t\tbool m_bAccepted;\n\t\t\t\tbool m_bNeedsAction;\n\t\t\t} *\n\t\t"),
		keys = {
			m_bAccepted = "accepted",
			m_nAppID = "appid",
			m_rtAction = "action",
			m_unVersion = "version",
			m_bNeedsAction = "needs_action",
			m_eResult = "result"
		}
	}

	function var_0_216.GetWorkshopEULAStatus(arg_524_0)
		if arg_524_0 ~= nil and not var_0_117(arg_524_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_524_0 = var_438_105(var_438_0)

		if arg_524_0 ~= nil then
			var_524_0 = var_0_152(var_524_0, arg_524_0, 3420, var_438_106)
		end

		return var_524_0
	end

	var_0_216.get_workshop_eula_status = var_0_216.GetWorkshopEULAStatus

	return var_0_216
end

local var_0_217 = {
	version = "STEAMHTMLSURFACE_INTERFACE_VERSION_005",
	version_number = 5
}

function var_0_62.ISteamHTMLSurface()
	local var_525_0 = vtable_bind("steamclient.dll", "SteamClient020", 31, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMHTMLSURFACE_INTERFACE_VERSION_005")

	var_0_217.thisptr = var_525_0

	local var_525_1 = var_0_53(var_525_0, 1, "bool(__thiscall*)(void*)")

	function var_0_217.Init()
		return var_525_1(var_525_0)
	end

	var_0_217.init = var_0_217.Init

	local var_525_2 = var_0_53(var_525_0, 2, "bool(__thiscall*)(void*)")

	function var_0_217.Shutdown()
		return var_525_2(var_525_0)
	end

	var_0_217.shutdown = var_0_217.Shutdown

	local var_525_3 = var_0_53(var_525_0, 3, "uint64_t(__thiscall*)(void*, const char *, const char *)")
	local var_525_4 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tunsigned int unBrowserHandle;\n\t\t\t} *\n\t\t"),
		keys = {
			unBrowserHandle = "browser_handle"
		}
	}

	function var_0_217.CreateBrowser(arg_528_0, arg_528_1, arg_528_2)
		if arg_528_2 ~= nil and not var_0_117(arg_528_2) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_528_0 = var_525_3(var_525_0, arg_528_0, arg_528_1)

		if arg_528_2 ~= nil then
			var_528_0 = var_0_152(var_528_0, arg_528_2, 4501, var_525_4)
		end

		return var_528_0
	end

	var_0_217.create_browser = var_0_217.CreateBrowser

	local var_525_5 = var_0_53(var_525_0, 4, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.RemoveBrowser(arg_529_0)
		return var_525_5(var_525_0, arg_529_0)
	end

	var_0_217.remove_browser = var_0_217.RemoveBrowser

	local var_525_6 = var_0_53(var_525_0, 5, "void(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function var_0_217.LoadURL(arg_530_0, arg_530_1, arg_530_2)
		return var_525_6(var_525_0, arg_530_0, arg_530_1, arg_530_2)
	end

	var_0_217.load_url = var_0_217.LoadURL

	local var_525_7 = var_0_53(var_525_0, 6, "void(__thiscall*)(void*, unsigned int, uint32_t, uint32_t)")

	function var_0_217.SetSize(arg_531_0, arg_531_1, arg_531_2)
		return var_525_7(var_525_0, arg_531_0, arg_531_1, arg_531_2)
	end

	var_0_217.set_size = var_0_217.SetSize

	local var_525_8 = var_0_53(var_525_0, 7, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.StopLoad(arg_532_0)
		return var_525_8(var_525_0, arg_532_0)
	end

	var_0_217.stop_load = var_0_217.StopLoad

	local var_525_9 = var_0_53(var_525_0, 8, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.Reload(arg_533_0)
		return var_525_9(var_525_0, arg_533_0)
	end

	var_0_217.reload = var_0_217.Reload

	local var_525_10 = var_0_53(var_525_0, 9, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.GoBack(arg_534_0)
		return var_525_10(var_525_0, arg_534_0)
	end

	var_0_217.go_back = var_0_217.GoBack

	local var_525_11 = var_0_53(var_525_0, 10, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.GoForward(arg_535_0)
		return var_525_11(var_525_0, arg_535_0)
	end

	var_0_217.go_forward = var_0_217.GoForward

	local var_525_12 = var_0_53(var_525_0, 11, "void(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function var_0_217.AddHeader(arg_536_0, arg_536_1, arg_536_2)
		return var_525_12(var_525_0, arg_536_0, arg_536_1, arg_536_2)
	end

	var_0_217.add_header = var_0_217.AddHeader

	local var_525_13 = var_0_53(var_525_0, 12, "void(__thiscall*)(void*, unsigned int, const char *)")

	function var_0_217.ExecuteJavascript(arg_537_0, arg_537_1)
		return var_525_13(var_525_0, arg_537_0, arg_537_1)
	end

	var_0_217.execute_javascript = var_0_217.ExecuteJavascript

	local var_525_14 = var_0_53(var_525_0, 13, "void(__thiscall*)(void*, unsigned int, int)")

	function var_0_217.MouseUp(arg_538_0, arg_538_1)
		arg_538_1 = var_0_160(arg_538_1, var_0_64.EHTMLMouseButton, "mouse_button is required")

		return var_525_14(var_525_0, arg_538_0, arg_538_1)
	end

	var_0_217.mouse_up = var_0_217.MouseUp

	local var_525_15 = var_0_53(var_525_0, 14, "void(__thiscall*)(void*, unsigned int, int)")

	function var_0_217.MouseDown(arg_539_0, arg_539_1)
		arg_539_1 = var_0_160(arg_539_1, var_0_64.EHTMLMouseButton, "mouse_button is required")

		return var_525_15(var_525_0, arg_539_0, arg_539_1)
	end

	var_0_217.mouse_down = var_0_217.MouseDown

	local var_525_16 = var_0_53(var_525_0, 15, "void(__thiscall*)(void*, unsigned int, int)")

	function var_0_217.MouseDoubleClick(arg_540_0, arg_540_1)
		arg_540_1 = var_0_160(arg_540_1, var_0_64.EHTMLMouseButton, "mouse_button is required")

		return var_525_16(var_525_0, arg_540_0, arg_540_1)
	end

	var_0_217.mouse_double_click = var_0_217.MouseDoubleClick

	local var_525_17 = var_0_53(var_525_0, 16, "void(__thiscall*)(void*, unsigned int, int, int)")

	function var_0_217.MouseMove(arg_541_0, arg_541_1, arg_541_2)
		return var_525_17(var_525_0, arg_541_0, arg_541_1, arg_541_2)
	end

	var_0_217.mouse_move = var_0_217.MouseMove

	local var_525_18 = var_0_53(var_525_0, 17, "void(__thiscall*)(void*, unsigned int, int32_t)")

	function var_0_217.MouseWheel(arg_542_0, arg_542_1)
		return var_525_18(var_525_0, arg_542_0, arg_542_1)
	end

	var_0_217.mouse_wheel = var_0_217.MouseWheel

	local var_525_19 = var_0_53(var_525_0, 18, "void(__thiscall*)(void*, unsigned int, uint32_t, int, bool)")

	function var_0_217.KeyDown(arg_543_0, arg_543_1, arg_543_2, arg_543_3)
		arg_543_2 = var_0_160(arg_543_2, var_0_64.EHTMLKeyModifiers, "html_key_modifiers is required")

		return var_525_19(var_525_0, arg_543_0, arg_543_1, arg_543_2, arg_543_3)
	end

	var_0_217.key_down = var_0_217.KeyDown

	local var_525_20 = var_0_53(var_525_0, 19, "void(__thiscall*)(void*, unsigned int, uint32_t, int)")

	function var_0_217.KeyUp(arg_544_0, arg_544_1, arg_544_2)
		arg_544_2 = var_0_160(arg_544_2, var_0_64.EHTMLKeyModifiers, "html_key_modifiers is required")

		return var_525_20(var_525_0, arg_544_0, arg_544_1, arg_544_2)
	end

	var_0_217.key_up = var_0_217.KeyUp

	local var_525_21 = var_0_53(var_525_0, 20, "void(__thiscall*)(void*, unsigned int, uint32_t, int)")

	function var_0_217.KeyChar(arg_545_0, arg_545_1, arg_545_2)
		arg_545_2 = var_0_160(arg_545_2, var_0_64.EHTMLKeyModifiers, "html_key_modifiers is required")

		return var_525_21(var_525_0, arg_545_0, arg_545_1, arg_545_2)
	end

	var_0_217.key_char = var_0_217.KeyChar

	local var_525_22 = var_0_53(var_525_0, 21, "void(__thiscall*)(void*, unsigned int, uint32_t)")

	function var_0_217.SetHorizontalScroll(arg_546_0, arg_546_1)
		return var_525_22(var_525_0, arg_546_0, arg_546_1)
	end

	var_0_217.set_horizontal_scroll = var_0_217.SetHorizontalScroll

	local var_525_23 = var_0_53(var_525_0, 22, "void(__thiscall*)(void*, unsigned int, uint32_t)")

	function var_0_217.SetVerticalScroll(arg_547_0, arg_547_1)
		return var_525_23(var_525_0, arg_547_0, arg_547_1)
	end

	var_0_217.set_vertical_scroll = var_0_217.SetVerticalScroll

	local var_525_24 = var_0_53(var_525_0, 23, "void(__thiscall*)(void*, unsigned int, bool)")

	function var_0_217.SetKeyFocus(arg_548_0, arg_548_1)
		return var_525_24(var_525_0, arg_548_0, arg_548_1)
	end

	var_0_217.set_key_focus = var_0_217.SetKeyFocus

	local var_525_25 = var_0_53(var_525_0, 24, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.ViewSource(arg_549_0)
		return var_525_25(var_525_0, arg_549_0)
	end

	var_0_217.view_source = var_0_217.ViewSource

	local var_525_26 = var_0_53(var_525_0, 25, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.CopyToClipboard(arg_550_0)
		return var_525_26(var_525_0, arg_550_0)
	end

	var_0_217.copy_to_clipboard = var_0_217.CopyToClipboard

	local var_525_27 = var_0_53(var_525_0, 26, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.PasteFromClipboard(arg_551_0)
		return var_525_27(var_525_0, arg_551_0)
	end

	var_0_217.paste_from_clipboard = var_0_217.PasteFromClipboard

	local var_525_28 = var_0_53(var_525_0, 27, "void(__thiscall*)(void*, unsigned int, const char *, bool, bool)")

	function var_0_217.Find(arg_552_0, arg_552_1, arg_552_2, arg_552_3)
		return var_525_28(var_525_0, arg_552_0, arg_552_1, arg_552_2, arg_552_3)
	end

	var_0_217.find = var_0_217.Find

	local var_525_29 = var_0_53(var_525_0, 28, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.StopFind(arg_553_0)
		return var_525_29(var_525_0, arg_553_0)
	end

	var_0_217.stop_find = var_0_217.StopFind

	local var_525_30 = var_0_53(var_525_0, 29, "void(__thiscall*)(void*, unsigned int, int, int)")

	function var_0_217.GetLinkAtPosition(arg_554_0, arg_554_1, arg_554_2)
		return var_525_30(var_525_0, arg_554_0, arg_554_1, arg_554_2)
	end

	var_0_217.get_link_at_position = var_0_217.GetLinkAtPosition

	local var_525_31 = var_0_53(var_525_0, 30, "void(__thiscall*)(void*, const char *, const char *, const char *, const char *, unsigned int, bool, bool)")

	function var_0_217.SetCookie(arg_555_0, arg_555_1, arg_555_2, arg_555_3, arg_555_4, arg_555_5, arg_555_6)
		return var_525_31(var_525_0, arg_555_0, arg_555_1, arg_555_2, arg_555_3, arg_555_4, arg_555_5, arg_555_6)
	end

	var_0_217.set_cookie = var_0_217.SetCookie

	local var_525_32 = var_0_53(var_525_0, 31, "void(__thiscall*)(void*, unsigned int, float, int, int)")

	function var_0_217.SetPageScaleFactor(arg_556_0, arg_556_1, arg_556_2, arg_556_3)
		return var_525_32(var_525_0, arg_556_0, arg_556_1, arg_556_2, arg_556_3)
	end

	var_0_217.set_page_scale_factor = var_0_217.SetPageScaleFactor

	local var_525_33 = var_0_53(var_525_0, 32, "void(__thiscall*)(void*, unsigned int, bool)")

	function var_0_217.SetBackgroundMode(arg_557_0, arg_557_1)
		return var_525_33(var_525_0, arg_557_0, arg_557_1)
	end

	var_0_217.set_background_mode = var_0_217.SetBackgroundMode

	local var_525_34 = var_0_53(var_525_0, 33, "void(__thiscall*)(void*, unsigned int, float)")

	function var_0_217.SetDPIScalingFactor(arg_558_0, arg_558_1)
		return var_525_34(var_525_0, arg_558_0, arg_558_1)
	end

	var_0_217.set_dpi_scaling_factor = var_0_217.SetDPIScalingFactor

	local var_525_35 = var_0_53(var_525_0, 34, "void(__thiscall*)(void*, unsigned int)")

	function var_0_217.OpenDeveloperTools(arg_559_0)
		return var_525_35(var_525_0, arg_559_0)
	end

	var_0_217.open_developer_tools = var_0_217.OpenDeveloperTools

	local var_525_36 = var_0_53(var_525_0, 35, "void(__thiscall*)(void*, unsigned int, bool)")

	function var_0_217.AllowStartRequest(arg_560_0, arg_560_1)
		return var_525_36(var_525_0, arg_560_0, arg_560_1)
	end

	var_0_217.allow_start_request = var_0_217.AllowStartRequest

	local var_525_37 = var_0_53(var_525_0, 36, "void(__thiscall*)(void*, unsigned int, bool)")

	function var_0_217.JSDialogResponse(arg_561_0, arg_561_1)
		return var_525_37(var_525_0, arg_561_0, arg_561_1)
	end

	var_0_217.js_dialog_response = var_0_217.JSDialogResponse

	local var_525_38 = var_0_53(var_525_0, 37, "void(__thiscall*)(void*, unsigned int, const char **)")

	function var_0_217.FileLoadDialogResponse(arg_562_0, arg_562_1)
		return var_525_38(var_525_0, arg_562_0, arg_562_1)
	end

	var_0_217.file_load_dialog_response = var_0_217.FileLoadDialogResponse

	return var_0_217
end

local var_0_218 = {
	version = "STEAMINVENTORY_INTERFACE_V003",
	version_number = 3
}

function var_0_62.ISteamInventory()
	local var_563_0 = vtable_bind("steamclient.dll", "SteamClient020", 35, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMINVENTORY_INTERFACE_V003")

	var_0_218.thisptr = var_563_0

	local var_563_1 = var_0_53(var_563_0, 0, "int(__thiscall*)(void*, int)")

	function var_0_218.GetResultStatus(arg_564_0)
		return var_563_1(var_563_0, arg_564_0)
	end

	var_0_218.get_result_status = var_0_218.GetResultStatus

	local var_563_2 = var_0_53(var_563_0, 1, "bool(__thiscall*)(void*, int, SteamItemDetails_t *, uint32_t *)")

	function var_0_218.GetResultItems(arg_565_0, arg_565_1, arg_565_2)
		return var_563_2(var_563_0, arg_565_0, arg_565_1, arg_565_2)
	end

	var_0_218.get_result_items = var_0_218.GetResultItems

	local var_563_3 = var_0_53(var_563_0, 2, "bool(__thiscall*)(void*, int, uint32_t, const char *, char *, uint32_t *)")

	function var_0_218.GetResultItemProperty(arg_566_0, arg_566_1, arg_566_2, arg_566_3, arg_566_4)
		return var_563_3(var_563_0, arg_566_0, arg_566_1, arg_566_2, arg_566_3, arg_566_4)
	end

	var_0_218.get_result_item_property = var_0_218.GetResultItemProperty

	local var_563_4 = var_0_53(var_563_0, 3, "uint32_t(__thiscall*)(void*, int)")

	function var_0_218.GetResultTimestamp(arg_567_0)
		return var_563_4(var_563_0, arg_567_0)
	end

	var_0_218.get_result_timestamp = var_0_218.GetResultTimestamp

	local var_563_5 = var_0_53(var_563_0, 4, "bool(__thiscall*)(void*, int, SteamID)")

	function var_0_218.CheckResultSteamID(arg_568_0, arg_568_1)
		arg_568_1 = var_0_158(arg_568_1, "steamid_expected is required")

		return var_563_5(var_563_0, arg_568_0, arg_568_1)
	end

	var_0_218.check_result_steamid = var_0_218.CheckResultSteamID

	local var_563_6 = var_0_53(var_563_0, 5, "void(__thiscall*)(void*, int)")

	function var_0_218.DestroyResult(arg_569_0)
		return var_563_6(var_563_0, arg_569_0)
	end

	var_0_218.destroy_result = var_0_218.DestroyResult

	local var_563_7 = var_0_53(var_563_0, 6, "bool(__thiscall*)(void*, int *)")

	function var_0_218.GetAllItems()
		local var_570_0 = var_0_171()

		return var_563_7(var_563_0, var_570_0), var_0_60(var_570_0)
	end

	var_0_218.get_all_items = var_0_218.GetAllItems

	local var_563_8 = var_0_53(var_563_0, 7, "bool(__thiscall*)(void*, int *, const uint64_t *, uint32_t)")

	function var_0_218.GetItemsByID(arg_571_0, arg_571_1)
		local var_571_0 = var_0_171()

		return var_563_8(var_563_0, var_571_0, arg_571_0, arg_571_1), var_0_60(var_571_0)
	end

	var_0_218.get_items_by_id = var_0_218.GetItemsByID

	local var_563_9 = var_0_53(var_563_0, 8, "bool(__thiscall*)(void*, int, void *, uint32_t *)")

	function var_0_218.SerializeResult(arg_572_0, arg_572_1, arg_572_2)
		return var_563_9(var_563_0, arg_572_0, arg_572_1, arg_572_2)
	end

	var_0_218.serialize_result = var_0_218.SerializeResult

	local var_563_10 = var_0_53(var_563_0, 9, "bool(__thiscall*)(void*, int *, const void *, uint32_t, bool)")

	function var_0_218.DeserializeResult(arg_573_0, arg_573_1, arg_573_2)
		local var_573_0 = var_0_171()

		return var_563_10(var_563_0, var_573_0, arg_573_0, arg_573_1, arg_573_2), var_0_60(var_573_0)
	end

	var_0_218.deserialize_result = var_0_218.DeserializeResult

	local var_563_11 = var_0_53(var_563_0, 10, "bool(__thiscall*)(void*, int *, const int *, const uint32_t *, uint32_t)")

	function var_0_218.GenerateItems(arg_574_0, arg_574_1, arg_574_2)
		local var_574_0 = var_0_171()

		return var_563_11(var_563_0, var_574_0, arg_574_0, arg_574_1, arg_574_2), var_0_60(var_574_0)
	end

	var_0_218.generate_items = var_0_218.GenerateItems

	local var_563_12 = var_0_53(var_563_0, 11, "bool(__thiscall*)(void*, int *)")

	function var_0_218.GrantPromoItems()
		local var_575_0 = var_0_171()

		return var_563_12(var_563_0, var_575_0), var_0_60(var_575_0)
	end

	var_0_218.grant_promo_items = var_0_218.GrantPromoItems

	local var_563_13 = var_0_53(var_563_0, 12, "bool(__thiscall*)(void*, int *, int)")

	function var_0_218.AddPromoItem(arg_576_0)
		local var_576_0 = var_0_171()

		return var_563_13(var_563_0, var_576_0, arg_576_0), var_0_60(var_576_0)
	end

	var_0_218.add_promo_item = var_0_218.AddPromoItem

	local var_563_14 = var_0_53(var_563_0, 13, "bool(__thiscall*)(void*, int *, const int *, uint32_t)")

	function var_0_218.AddPromoItems(arg_577_0, arg_577_1)
		local var_577_0 = var_0_171()

		return var_563_14(var_563_0, var_577_0, arg_577_0, arg_577_1), var_0_60(var_577_0)
	end

	var_0_218.add_promo_items = var_0_218.AddPromoItems

	local var_563_15 = var_0_53(var_563_0, 14, "bool(__thiscall*)(void*, int *, uint64_t, uint32_t)")

	function var_0_218.ConsumeItem(arg_578_0, arg_578_1)
		local var_578_0 = var_0_171()

		return var_563_15(var_563_0, var_578_0, arg_578_0, arg_578_1), var_0_60(var_578_0)
	end

	var_0_218.consume_item = var_0_218.ConsumeItem

	local var_563_16 = var_0_53(var_563_0, 15, "bool(__thiscall*)(void*, int *, const int *, const uint32_t *, uint32_t, const uint64_t *, const uint32_t *, uint32_t)")

	function var_0_218.ExchangeItems(arg_579_0, arg_579_1, arg_579_2, arg_579_3, arg_579_4, arg_579_5)
		local var_579_0 = var_0_171()

		return var_563_16(var_563_0, var_579_0, arg_579_0, arg_579_1, arg_579_2, arg_579_3, arg_579_4, arg_579_5), var_0_60(var_579_0)
	end

	var_0_218.exchange_items = var_0_218.ExchangeItems

	local var_563_17 = var_0_53(var_563_0, 16, "bool(__thiscall*)(void*, int *, uint64_t, uint32_t, uint64_t)")

	function var_0_218.TransferItemQuantity(arg_580_0, arg_580_1, arg_580_2)
		local var_580_0 = var_0_171()

		return var_563_17(var_563_0, var_580_0, arg_580_0, arg_580_1, arg_580_2), var_0_60(var_580_0)
	end

	var_0_218.transfer_item_quantity = var_0_218.TransferItemQuantity

	local var_563_18 = var_0_53(var_563_0, 17, "void(__thiscall*)(void*)")

	function var_0_218.SendItemDropHeartbeat()
		return var_563_18(var_563_0)
	end

	var_0_218.send_item_drop_heartbeat = var_0_218.SendItemDropHeartbeat

	local var_563_19 = var_0_53(var_563_0, 18, "bool(__thiscall*)(void*, int *, int)")

	function var_0_218.TriggerItemDrop(arg_582_0)
		local var_582_0 = var_0_171()

		return var_563_19(var_563_0, var_582_0, arg_582_0), var_0_60(var_582_0)
	end

	var_0_218.trigger_item_drop = var_0_218.TriggerItemDrop

	local var_563_20 = var_0_53(var_563_0, 19, "bool(__thiscall*)(void*, int *, SteamID, const uint64_t *, const uint32_t *, uint32_t, const uint64_t *, const uint32_t *, uint32_t)")

	function var_0_218.TradeItems(arg_583_0, arg_583_1, arg_583_2, arg_583_3, arg_583_4, arg_583_5, arg_583_6)
		arg_583_0 = var_0_158(arg_583_0, "steamid_trade_partner is required")

		local var_583_0 = var_0_171()

		return var_563_20(var_563_0, var_583_0, arg_583_0, arg_583_1, arg_583_2, arg_583_3, arg_583_4, arg_583_5, arg_583_6), var_0_60(var_583_0)
	end

	var_0_218.trade_items = var_0_218.TradeItems

	local var_563_21 = var_0_53(var_563_0, 20, "bool(__thiscall*)(void*)")

	function var_0_218.LoadItemDefinitions()
		return var_563_21(var_563_0)
	end

	var_0_218.load_item_definitions = var_0_218.LoadItemDefinitions

	local var_563_22 = var_0_53(var_563_0, 21, "bool(__thiscall*)(void*, int *, uint32_t *)")

	function var_0_218.GetItemDefinitionIDs(arg_585_0, arg_585_1)
		return var_563_22(var_563_0, arg_585_0, arg_585_1)
	end

	var_0_218.get_item_definition_ids = var_0_218.GetItemDefinitionIDs

	local var_563_23 = var_0_53(var_563_0, 22, "bool(__thiscall*)(void*, int, const char *, char *, uint32_t *)")

	function var_0_218.GetItemDefinitionProperty(arg_586_0, arg_586_1, arg_586_2, arg_586_3)
		return var_563_23(var_563_0, arg_586_0, arg_586_1, arg_586_2, arg_586_3)
	end

	var_0_218.get_item_definition_property = var_0_218.GetItemDefinitionProperty

	local var_563_24 = var_0_53(var_563_0, 23, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_563_25 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_result;\n\t\t\t\tSteamID m_steamID;\n\t\t\t\tint m_numEligiblePromoItemDefs;\n\t\t\t\tbool m_bCachedData;\n\t\t\t} *\n\t\t"),
		keys = {
			m_steamID = "steamid",
			m_numEligiblePromoItemDefs = "num_eligible_promo_item_defs",
			m_bCachedData = "cached_data",
			m_result = "result"
		}
	}

	function var_0_218.RequestEligiblePromoItemDefinitionsIDs(arg_587_0, arg_587_1)
		arg_587_0 = var_0_158(arg_587_0, "steamid is required")

		if arg_587_1 ~= nil and not var_0_117(arg_587_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_587_0 = var_563_24(var_563_0, arg_587_0)

		if arg_587_1 ~= nil then
			var_587_0 = var_0_152(var_587_0, arg_587_1, 4703, var_563_25)
		end

		return var_587_0
	end

	var_0_218.request_eligible_promo_item_definitions_ids = var_0_218.RequestEligiblePromoItemDefinitionsIDs

	local var_563_26 = var_0_53(var_563_0, 24, "bool(__thiscall*)(void*, SteamID, int *, uint32_t *)")

	function var_0_218.GetEligiblePromoItemDefinitionIDs(arg_588_0, arg_588_1, arg_588_2)
		arg_588_0 = var_0_158(arg_588_0, "steamid is required")

		return var_563_26(var_563_0, arg_588_0, arg_588_1, arg_588_2)
	end

	var_0_218.get_eligible_promo_item_definition_ids = var_0_218.GetEligiblePromoItemDefinitionIDs

	local var_563_27 = var_0_53(var_563_0, 25, "uint64_t(__thiscall*)(void*, const int *, const uint32_t *, uint32_t)")
	local var_563_28 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_result;\n\t\t\t\tuint64_t m_ulOrderID;\n\t\t\t\tuint64_t m_ulTransID;\n\t\t\t} *\n\t\t"),
		keys = {
			m_result = "result",
			m_ulTransID = "trans_id",
			m_ulOrderID = "order_id"
		}
	}

	function var_0_218.StartPurchase(arg_589_0, arg_589_1, arg_589_2, arg_589_3)
		if arg_589_3 ~= nil and not var_0_117(arg_589_3) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_589_0 = var_563_27(var_563_0, arg_589_0, arg_589_1, arg_589_2)

		if arg_589_3 ~= nil then
			var_589_0 = var_0_152(var_589_0, arg_589_3, 4704, var_563_28)
		end

		return var_589_0
	end

	var_0_218.start_purchase = var_0_218.StartPurchase

	local var_563_29 = var_0_53(var_563_0, 26, "uint64_t(__thiscall*)(void*)")
	local var_563_30 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_result;\n\t\t\t\tchar m_rgchCurrency[4];\n\t\t\t} *\n\t\t"),
		keys = {
			m_result = "result",
			m_rgchCurrency = "currency"
		}
	}

	function var_0_218.RequestPrices(arg_590_0)
		if arg_590_0 ~= nil and not var_0_117(arg_590_0) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_590_0 = var_563_29(var_563_0)

		if arg_590_0 ~= nil then
			var_590_0 = var_0_152(var_590_0, arg_590_0, 4705, var_563_30)
		end

		return var_590_0
	end

	var_0_218.request_prices = var_0_218.RequestPrices

	local var_563_31 = var_0_53(var_563_0, 27, "uint32_t(__thiscall*)(void*)")

	function var_0_218.GetNumItemsWithPrices()
		return var_563_31(var_563_0)
	end

	var_0_218.get_num_items_with_prices = var_0_218.GetNumItemsWithPrices

	local var_563_32 = var_0_53(var_563_0, 28, "bool(__thiscall*)(void*, int *, uint64_t *, uint64_t *, uint32_t)")

	function var_0_218.GetItemsWithPrices(arg_592_0, arg_592_1, arg_592_2, arg_592_3)
		return var_563_32(var_563_0, arg_592_0, arg_592_1, arg_592_2, arg_592_3)
	end

	var_0_218.get_items_with_prices = var_0_218.GetItemsWithPrices

	local var_563_33 = var_0_53(var_563_0, 29, "bool(__thiscall*)(void*, int, uint64_t *, uint64_t *)")

	function var_0_218.GetItemPrice(arg_593_0)
		local var_593_0 = var_0_174()
		local var_593_1 = var_0_174()

		return var_563_33(var_563_0, arg_593_0, var_593_0, var_593_1), var_0_60(var_593_0), var_0_60(var_593_1)
	end

	var_0_218.get_item_price = var_0_218.GetItemPrice

	local var_563_34 = var_0_53(var_563_0, 30, "void(__thiscall*)(void*, uint64_t *)")

	function var_0_218.StartUpdateProperties()
		local var_594_0 = var_0_174()

		var_563_34(var_563_0, var_594_0)

		return var_0_60(var_594_0)
	end

	var_0_218.start_update_properties = var_0_218.StartUpdateProperties

	local var_563_35 = var_0_53(var_563_0, 31, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *)")

	function var_0_218.RemoveProperty(arg_595_0, arg_595_1, arg_595_2)
		return var_563_35(var_563_0, arg_595_0, arg_595_1, arg_595_2)
	end

	var_0_218.remove_property = var_0_218.RemoveProperty

	local var_563_36 = var_0_53(var_563_0, 32, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, const char *)")

	function var_0_218.SetPropertyString(arg_596_0, arg_596_1, arg_596_2, arg_596_3)
		return var_563_36(var_563_0, arg_596_0, arg_596_1, arg_596_2, arg_596_3)
	end

	var_0_218.set_property_string = var_0_218.SetPropertyString

	local var_563_37 = var_0_53(var_563_0, 33, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, bool)")

	function var_0_218.SetPropertyBool(arg_597_0, arg_597_1, arg_597_2, arg_597_3)
		return var_563_37(var_563_0, arg_597_0, arg_597_1, arg_597_2, arg_597_3)
	end

	var_0_218.set_property_bool = var_0_218.SetPropertyBool

	local var_563_38 = var_0_53(var_563_0, 34, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, int64_t)")

	function var_0_218.SetPropertyInt64(arg_598_0, arg_598_1, arg_598_2, arg_598_3)
		return var_563_38(var_563_0, arg_598_0, arg_598_1, arg_598_2, arg_598_3)
	end

	var_0_218.set_property_int64 = var_0_218.SetPropertyInt64

	local var_563_39 = var_0_53(var_563_0, 35, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, float)")

	function var_0_218.SetPropertyFloat(arg_599_0, arg_599_1, arg_599_2, arg_599_3)
		return var_563_39(var_563_0, arg_599_0, arg_599_1, arg_599_2, arg_599_3)
	end

	var_0_218.set_property_float = var_0_218.SetPropertyFloat

	local var_563_40 = var_0_53(var_563_0, 36, "bool(__thiscall*)(void*, uint64_t, int *)")

	function var_0_218.SubmitUpdateProperties(arg_600_0)
		local var_600_0 = var_0_171()

		return var_563_40(var_563_0, arg_600_0, var_600_0), var_0_60(var_600_0)
	end

	var_0_218.submit_update_properties = var_0_218.SubmitUpdateProperties

	local var_563_41 = var_0_53(var_563_0, 37, "bool(__thiscall*)(void*, int *, const char *)")

	function var_0_218.InspectItem(arg_601_0)
		local var_601_0 = var_0_171()

		return var_563_41(var_563_0, var_601_0, arg_601_0), var_0_60(var_601_0)
	end

	var_0_218.inspect_item = var_0_218.InspectItem

	return var_0_218
end

local var_0_219 = {
	version = "STEAMVIDEO_INTERFACE_V002",
	version_number = 2
}

function var_0_62.ISteamVideo()
	local var_602_0 = vtable_bind("steamclient.dll", "SteamClient020", 36, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMVIDEO_INTERFACE_V002")

	var_0_219.thisptr = var_602_0

	local var_602_1 = var_0_53(var_602_0, 0, "void(__thiscall*)(void*, unsigned int)")

	function var_0_219.GetVideoURL(arg_603_0)
		return var_602_1(var_602_0, arg_603_0)
	end

	var_0_219.get_video_url = var_0_219.GetVideoURL

	local var_602_2 = var_0_53(var_602_0, 1, "bool(__thiscall*)(void*, int *)")

	function var_0_219.IsBroadcasting()
		local var_604_0 = var_0_171()

		return var_602_2(var_602_0, var_604_0), var_0_60(var_604_0)
	end

	var_0_219.is_broadcasting = var_0_219.IsBroadcasting

	local var_602_3 = var_0_53(var_602_0, 2, "void(__thiscall*)(void*, unsigned int)")

	function var_0_219.GetOPFSettings(arg_605_0)
		return var_602_3(var_602_0, arg_605_0)
	end

	var_0_219.get_opf_settings = var_0_219.GetOPFSettings

	local var_602_4 = var_0_53(var_602_0, 3, "bool(__thiscall*)(void*, unsigned int, char *, int32_t *)")

	function var_0_219.GetOPFStringForApp(arg_606_0, arg_606_1, arg_606_2)
		return var_602_4(var_602_0, arg_606_0, arg_606_1, arg_606_2)
	end

	var_0_219.get_opf_string_for_app = var_0_219.GetOPFStringForApp

	return var_0_219
end

local var_0_220 = {
	version = "STEAMPARENTALSETTINGS_INTERFACE_VERSION001",
	version_number = 1
}

function var_0_62.ISteamParentalSettings()
	local var_607_0 = vtable_bind("steamclient.dll", "SteamClient020", 37, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMPARENTALSETTINGS_INTERFACE_VERSION001")

	var_0_220.thisptr = var_607_0

	local var_607_1 = var_0_53(var_607_0, 0, "bool(__thiscall*)(void*)")

	function var_0_220.BIsParentalLockEnabled()
		return var_607_1(var_607_0)
	end

	var_0_220.is_parental_lock_enabled = var_0_220.BIsParentalLockEnabled

	local var_607_2 = var_0_53(var_607_0, 1, "bool(__thiscall*)(void*)")

	function var_0_220.BIsParentalLockLocked()
		return var_607_2(var_607_0)
	end

	var_0_220.is_parental_lock_locked = var_0_220.BIsParentalLockLocked

	local var_607_3 = var_0_53(var_607_0, 2, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_220.BIsAppBlocked(arg_610_0)
		return var_607_3(var_607_0, arg_610_0)
	end

	var_0_220.is_app_blocked = var_0_220.BIsAppBlocked

	local var_607_4 = var_0_53(var_607_0, 3, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_220.BIsAppInBlockList(arg_611_0)
		return var_607_4(var_607_0, arg_611_0)
	end

	var_0_220.is_app_in_block_list = var_0_220.BIsAppInBlockList

	local var_607_5 = var_0_53(var_607_0, 4, "bool(__thiscall*)(void*, int)")

	function var_0_220.BIsFeatureBlocked(arg_612_0)
		arg_612_0 = var_0_160(arg_612_0, var_0_64.EParentalFeature, "feature is required")

		return var_607_5(var_607_0, arg_612_0)
	end

	var_0_220.is_feature_blocked = var_0_220.BIsFeatureBlocked

	local var_607_6 = var_0_53(var_607_0, 5, "bool(__thiscall*)(void*, int)")

	function var_0_220.BIsFeatureInBlockList(arg_613_0)
		arg_613_0 = var_0_160(arg_613_0, var_0_64.EParentalFeature, "feature is required")

		return var_607_6(var_607_0, arg_613_0)
	end

	var_0_220.is_feature_in_block_list = var_0_220.BIsFeatureInBlockList

	return var_0_220
end

local var_0_221 = {
	version = "STEAMREMOTEPLAY_INTERFACE_VERSION001",
	version_number = 1
}

function var_0_62.ISteamRemotePlay()
	local var_614_0 = vtable_bind("steamclient.dll", "SteamClient020", 40, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "STEAMREMOTEPLAY_INTERFACE_VERSION001")

	var_0_221.thisptr = var_614_0

	local var_614_1 = var_0_53(var_614_0, 0, "uint32_t(__thiscall*)(void*)")

	function var_0_221.GetSessionCount()
		return var_614_1(var_614_0)
	end

	var_0_221.get_session_count = var_0_221.GetSessionCount

	local var_614_2 = var_0_53(var_614_0, 1, "unsigned int(__thiscall*)(void*, int)")

	function var_0_221.GetSessionID(arg_616_0)
		return var_614_2(var_614_0, arg_616_0)
	end

	var_0_221.get_session_id = var_0_221.GetSessionID

	local var_614_3 = var_0_53(var_614_0, 2, "void(__thiscall*)(void*, SteamID *, unsigned int)")

	function var_0_221.GetSessionSteamID(arg_617_0)
		local var_617_0 = var_0_165()

		var_614_3(var_614_0, var_617_0, arg_617_0)

		return var_0_60(var_617_0)
	end

	var_0_221.get_session_steamid = var_0_221.GetSessionSteamID

	local var_614_4 = var_0_53(var_614_0, 3, "const char *(__thiscall*)(void*, unsigned int)")

	function var_0_221.GetSessionClientName(arg_618_0)
		local var_618_0 = var_614_4(var_614_0, arg_618_0)

		return var_618_0 ~= nil and var_0_7(var_618_0) or nil
	end

	var_0_221.get_session_client_name = var_0_221.GetSessionClientName

	local var_614_5 = var_0_53(var_614_0, 4, "int(__thiscall*)(void*, unsigned int)")

	function var_0_221.GetSessionClientFormFactor(arg_619_0)
		return var_614_5(var_614_0, arg_619_0)
	end

	var_0_221.get_session_client_form_factor = var_0_221.GetSessionClientFormFactor

	local var_614_6 = var_0_53(var_614_0, 5, "bool(__thiscall*)(void*, unsigned int, int *, int *)")

	function var_0_221.BGetSessionClientResolution(arg_620_0)
		local var_620_0 = var_0_171()
		local var_620_1 = var_0_171()

		return var_614_6(var_614_0, arg_620_0, var_620_0, var_620_1), var_0_60(var_620_0), var_0_60(var_620_1)
	end

	var_0_221.get_session_client_resolution = var_0_221.BGetSessionClientResolution

	local var_614_7 = var_0_53(var_614_0, 6, "bool(__thiscall*)(void*, SteamID)")

	function var_0_221.BSendRemotePlayTogetherInvite(arg_621_0)
		arg_621_0 = var_0_158(arg_621_0, "steamid_friend is required")

		return var_614_7(var_614_0, arg_621_0)
	end

	var_0_221.send_remote_play_together_invite = var_0_221.BSendRemotePlayTogetherInvite

	return var_0_221
end

local var_0_222 = {
	version = "SteamNetworkingMessages002",
	version_number = 2
}

function var_0_62.ISteamNetworkingMessages()
	local var_622_0 = var_0_114("steamnetworkingsockets.dll", "SteamNetworkingMessages_LibV2", "void*(__thiscall*)(unsigned int, unsigned int)")()

	var_0_222.thisptr = var_622_0

	local var_622_1 = var_0_53(var_622_0, 0, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, const void *, uint32_t, int, int)")

	function var_0_222.SendMessageToUser(arg_623_0, arg_623_1, arg_623_2, arg_623_3, arg_623_4)
		return var_622_1(var_622_0, arg_623_0, arg_623_1, arg_623_2, arg_623_3, arg_623_4)
	end

	var_0_222.send_message_to_user = var_0_222.SendMessageToUser

	local var_622_2 = var_0_53(var_622_0, 1, "int(__thiscall*)(void*, int, SteamNetworkingMessage_t **, int)")

	function var_0_222.ReceiveMessagesOnChannel(arg_624_0, arg_624_1, arg_624_2)
		return var_622_2(var_622_0, arg_624_0, arg_624_1, arg_624_2)
	end

	var_0_222.receive_messages_on_channel = var_0_222.ReceiveMessagesOnChannel

	local var_622_3 = var_0_53(var_622_0, 2, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &)")

	function var_0_222.AcceptSessionWithUser(arg_625_0)
		return var_622_3(var_622_0, arg_625_0)
	end

	var_0_222.accept_session_with_user = var_0_222.AcceptSessionWithUser

	local var_622_4 = var_0_53(var_622_0, 3, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &)")

	function var_0_222.CloseSessionWithUser(arg_626_0)
		return var_622_4(var_622_0, arg_626_0)
	end

	var_0_222.close_session_with_user = var_0_222.CloseSessionWithUser

	local var_622_5 = var_0_53(var_622_0, 4, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &, int)")

	function var_0_222.CloseChannelWithUser(arg_627_0, arg_627_1)
		return var_622_5(var_622_0, arg_627_0, arg_627_1)
	end

	var_0_222.close_channel_with_user = var_0_222.CloseChannelWithUser

	local var_622_6 = var_0_53(var_622_0, 5, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, SteamNetConnectionInfo_t *, SteamNetConnectionRealTimeStatus_t *)")

	function var_0_222.GetSessionConnectionInfo(arg_628_0)
		local var_628_0 = var_0_103.SteamNetConnectionInfo_t_arr(1)
		local var_628_1 = var_0_103.SteamNetConnectionRealTimeStatus_t_arr(1)

		return var_622_6(var_622_0, arg_628_0, var_628_0, var_628_1), var_0_60(var_628_0), var_0_60(var_628_1)
	end

	var_0_222.get_session_connection_info = var_0_222.GetSessionConnectionInfo

	return var_0_222
end

local var_0_223 = {
	version = "SteamNetworkingSockets012",
	version_number = 12
}

function var_0_62.ISteamNetworkingSockets()
	local var_629_0 = var_0_114("steamnetworkingsockets.dll", "SteamNetworkingSockets_LibV12", "void*(__thiscall*)(unsigned int, unsigned int)")()

	var_0_223.thisptr = var_629_0

	local var_629_1 = var_0_53(var_629_0, 0, "unsigned int(__thiscall*)(void*, const SteamNetworkingIPAddr &, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.CreateListenSocketIP(arg_630_0, arg_630_1, arg_630_2)
		return var_629_1(var_629_0, arg_630_0, arg_630_1, arg_630_2)
	end

	var_0_223.create_listen_socket_ip = var_0_223.CreateListenSocketIP

	local var_629_2 = var_0_53(var_629_0, 1, "unsigned int(__thiscall*)(void*, const SteamNetworkingIPAddr &, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.ConnectByIPAddress(arg_631_0, arg_631_1, arg_631_2)
		return var_629_2(var_629_0, arg_631_0, arg_631_1, arg_631_2)
	end

	var_0_223.connect_by_ip_address = var_0_223.ConnectByIPAddress

	local var_629_3 = var_0_53(var_629_0, 2, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.CreateListenSocketP2P(arg_632_0, arg_632_1, arg_632_2)
		return var_629_3(var_629_0, arg_632_0, arg_632_1, arg_632_2)
	end

	var_0_223.create_listen_socket_p2p = var_0_223.CreateListenSocketP2P

	local var_629_4 = var_0_53(var_629_0, 3, "unsigned int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.ConnectP2P(arg_633_0, arg_633_1, arg_633_2, arg_633_3)
		return var_629_4(var_629_0, arg_633_0, arg_633_1, arg_633_2, arg_633_3)
	end

	var_0_223.connect_p2p = var_0_223.ConnectP2P

	local var_629_5 = var_0_53(var_629_0, 4, "int(__thiscall*)(void*, unsigned int)")

	function var_0_223.AcceptConnection(arg_634_0)
		return var_629_5(var_629_0, arg_634_0)
	end

	var_0_223.accept_connection = var_0_223.AcceptConnection

	local var_629_6 = var_0_53(var_629_0, 5, "bool(__thiscall*)(void*, unsigned int, int, const char *, bool)")

	function var_0_223.CloseConnection(arg_635_0, arg_635_1, arg_635_2, arg_635_3)
		return var_629_6(var_629_0, arg_635_0, arg_635_1, arg_635_2, arg_635_3)
	end

	var_0_223.close_connection = var_0_223.CloseConnection

	local var_629_7 = var_0_53(var_629_0, 6, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_223.CloseListenSocket(arg_636_0)
		return var_629_7(var_629_0, arg_636_0)
	end

	var_0_223.close_listen_socket = var_0_223.CloseListenSocket

	local var_629_8 = var_0_53(var_629_0, 7, "bool(__thiscall*)(void*, unsigned int, int64_t)")

	function var_0_223.SetConnectionUserData(arg_637_0, arg_637_1)
		return var_629_8(var_629_0, arg_637_0, arg_637_1)
	end

	var_0_223.set_connection_user_data = var_0_223.SetConnectionUserData

	local var_629_9 = var_0_53(var_629_0, 8, "int64_t(__thiscall*)(void*, unsigned int)")

	function var_0_223.GetConnectionUserData(arg_638_0)
		return var_629_9(var_629_0, arg_638_0)
	end

	var_0_223.get_connection_user_data = var_0_223.GetConnectionUserData

	local var_629_10 = var_0_53(var_629_0, 9, "void(__thiscall*)(void*, unsigned int, const char *)")

	function var_0_223.SetConnectionName(arg_639_0, arg_639_1)
		return var_629_10(var_629_0, arg_639_0, arg_639_1)
	end

	var_0_223.set_connection_name = var_0_223.SetConnectionName

	local var_629_11 = var_0_53(var_629_0, 10, "bool(__thiscall*)(void*, unsigned int, char *, int)")

	function var_0_223.GetConnectionName(arg_640_0, arg_640_1, arg_640_2)
		return var_629_11(var_629_0, arg_640_0, arg_640_1, arg_640_2)
	end

	var_0_223.get_connection_name = var_0_223.GetConnectionName

	local var_629_12 = var_0_53(var_629_0, 11, "int(__thiscall*)(void*, unsigned int, const void *, uint32_t, int, int64_t *)")

	function var_0_223.SendMessageToConnection(arg_641_0, arg_641_1, arg_641_2, arg_641_3)
		local var_641_0 = var_0_170()

		return var_629_12(var_629_0, arg_641_0, arg_641_1, arg_641_2, arg_641_3, var_641_0), var_0_60(var_641_0)
	end

	var_0_223.send_message_to_connection = var_0_223.SendMessageToConnection

	local var_629_13 = var_0_53(var_629_0, 12, "void(__thiscall*)(void*, int, SteamNetworkingMessage_t *const *, int64_t *)")

	function var_0_223.SendMessages(arg_642_0, arg_642_1)
		local var_642_0 = var_0_170()

		var_629_13(var_629_0, arg_642_0, arg_642_1, var_642_0)

		return var_0_60(var_642_0)
	end

	var_0_223.send_messages = var_0_223.SendMessages

	local var_629_14 = var_0_53(var_629_0, 13, "int(__thiscall*)(void*, unsigned int)")

	function var_0_223.FlushMessagesOnConnection(arg_643_0)
		return var_629_14(var_629_0, arg_643_0)
	end

	var_0_223.flush_messages_on_connection = var_0_223.FlushMessagesOnConnection

	local var_629_15 = var_0_53(var_629_0, 14, "int(__thiscall*)(void*, unsigned int, SteamNetworkingMessage_t **, int)")

	function var_0_223.ReceiveMessagesOnConnection(arg_644_0, arg_644_1, arg_644_2)
		return var_629_15(var_629_0, arg_644_0, arg_644_1, arg_644_2)
	end

	var_0_223.receive_messages_on_connection = var_0_223.ReceiveMessagesOnConnection

	local var_629_16 = var_0_53(var_629_0, 15, "bool(__thiscall*)(void*, unsigned int, SteamNetConnectionInfo_t *)")

	function var_0_223.GetConnectionInfo(arg_645_0)
		local var_645_0 = var_0_103.SteamNetConnectionInfo_t_arr(1)

		return var_629_16(var_629_0, arg_645_0, var_645_0), var_0_60(var_645_0)
	end

	var_0_223.get_connection_info = var_0_223.GetConnectionInfo

	local var_629_17 = var_0_53(var_629_0, 16, "int(__thiscall*)(void*, unsigned int, SteamNetConnectionRealTimeStatus_t *, int, SteamNetConnectionRealTimeLaneStatus_t *)")

	function var_0_223.GetConnectionRealTimeStatus(arg_646_0, arg_646_1, arg_646_2, arg_646_3)
		return var_629_17(var_629_0, arg_646_0, arg_646_1, arg_646_2, arg_646_3)
	end

	var_0_223.get_connection_real_time_status = var_0_223.GetConnectionRealTimeStatus

	local var_629_18 = var_0_53(var_629_0, 17, "int(__thiscall*)(void*, unsigned int, char *, int)")

	function var_0_223.GetDetailedConnectionStatus(arg_647_0, arg_647_1, arg_647_2)
		return var_629_18(var_629_0, arg_647_0, arg_647_1, arg_647_2)
	end

	var_0_223.get_detailed_connection_status = var_0_223.GetDetailedConnectionStatus

	local var_629_19 = var_0_53(var_629_0, 18, "bool(__thiscall*)(void*, unsigned int, SteamNetworkingIPAddr *)")

	function var_0_223.GetListenSocketAddress(arg_648_0)
		local var_648_0 = var_0_103.SteamNetworkingIPAddr_arr(1)

		return var_629_19(var_629_0, arg_648_0, var_648_0), var_0_60(var_648_0)
	end

	var_0_223.get_listen_socket_address = var_0_223.GetListenSocketAddress

	local var_629_20 = var_0_53(var_629_0, 19, "bool(__thiscall*)(void*, unsigned int *, unsigned int *, bool, const SteamNetworkingIdentity *, const SteamNetworkingIdentity *)")

	function var_0_223.CreateSocketPair(arg_649_0, arg_649_1, arg_649_2)
		local var_649_0 = var_0_175()
		local var_649_1 = var_0_175()

		return var_629_20(var_629_0, var_649_0, var_649_1, arg_649_0, arg_649_1, arg_649_2), var_0_60(var_649_0), var_0_60(var_649_1)
	end

	var_0_223.create_socket_pair = var_0_223.CreateSocketPair

	local var_629_21 = var_0_53(var_629_0, 20, "int(__thiscall*)(void*, unsigned int, int, const int *, const uint16_t *)")

	function var_0_223.ConfigureConnectionLanes(arg_650_0, arg_650_1, arg_650_2, arg_650_3)
		return var_629_21(var_629_0, arg_650_0, arg_650_1, arg_650_2, arg_650_3)
	end

	var_0_223.configure_connection_lanes = var_0_223.ConfigureConnectionLanes

	local var_629_22 = var_0_53(var_629_0, 21, "bool(__thiscall*)(void*, SteamNetworkingIdentity *)")

	function var_0_223.GetIdentity()
		local var_651_0 = var_0_103.SteamNetworkingIdentity_arr(1)

		return var_629_22(var_629_0, var_651_0), var_0_60(var_651_0)
	end

	var_0_223.get_identity = var_0_223.GetIdentity

	local var_629_23 = var_0_53(var_629_0, 22, "int(__thiscall*)(void*)")

	function var_0_223.InitAuthentication()
		return var_629_23(var_629_0)
	end

	var_0_223.init_authentication = var_0_223.InitAuthentication

	local var_629_24 = var_0_53(var_629_0, 23, "int(__thiscall*)(void*, SteamNetAuthenticationStatus_t *)")

	function var_0_223.GetAuthenticationStatus()
		local var_653_0 = var_0_103.SteamNetAuthenticationStatus_t_arr(1)

		return var_629_24(var_629_0, var_653_0), var_0_60(var_653_0)
	end

	var_0_223.get_authentication_status = var_0_223.GetAuthenticationStatus

	local var_629_25 = var_0_53(var_629_0, 24, "unsigned int(__thiscall*)(void*)")

	function var_0_223.CreatePollGroup()
		return var_629_25(var_629_0)
	end

	var_0_223.create_poll_group = var_0_223.CreatePollGroup

	local var_629_26 = var_0_53(var_629_0, 25, "bool(__thiscall*)(void*, unsigned int)")

	function var_0_223.DestroyPollGroup(arg_655_0)
		return var_629_26(var_629_0, arg_655_0)
	end

	var_0_223.destroy_poll_group = var_0_223.DestroyPollGroup

	local var_629_27 = var_0_53(var_629_0, 26, "bool(__thiscall*)(void*, unsigned int, unsigned int)")

	function var_0_223.SetConnectionPollGroup(arg_656_0, arg_656_1)
		return var_629_27(var_629_0, arg_656_0, arg_656_1)
	end

	var_0_223.set_connection_poll_group = var_0_223.SetConnectionPollGroup

	local var_629_28 = var_0_53(var_629_0, 27, "int(__thiscall*)(void*, unsigned int, SteamNetworkingMessage_t **, int)")

	function var_0_223.ReceiveMessagesOnPollGroup(arg_657_0, arg_657_1, arg_657_2)
		return var_629_28(var_629_0, arg_657_0, arg_657_1, arg_657_2)
	end

	var_0_223.receive_messages_on_poll_group = var_0_223.ReceiveMessagesOnPollGroup

	local var_629_29 = var_0_53(var_629_0, 28, "bool(__thiscall*)(void*, const void *, int, SteamDatagramRelayAuthTicket *)")

	function var_0_223.ReceivedRelayAuthTicket(arg_658_0, arg_658_1, arg_658_2)
		return var_629_29(var_629_0, arg_658_0, arg_658_1, arg_658_2)
	end

	var_0_223.received_relay_auth_ticket = var_0_223.ReceivedRelayAuthTicket

	local var_629_30 = var_0_53(var_629_0, 29, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, SteamDatagramRelayAuthTicket *)")

	function var_0_223.FindRelayAuthTicketForServer(arg_659_0, arg_659_1, arg_659_2)
		return var_629_30(var_629_0, arg_659_0, arg_659_1, arg_659_2)
	end

	var_0_223.find_relay_auth_ticket_for_server = var_0_223.FindRelayAuthTicketForServer

	local var_629_31 = var_0_53(var_629_0, 30, "unsigned int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.ConnectToHostedDedicatedServer(arg_660_0, arg_660_1, arg_660_2, arg_660_3)
		return var_629_31(var_629_0, arg_660_0, arg_660_1, arg_660_2, arg_660_3)
	end

	var_0_223.connect_to_hosted_dedicated_server = var_0_223.ConnectToHostedDedicatedServer

	local var_629_32 = var_0_53(var_629_0, 31, "uint16_t(__thiscall*)(void*)")

	function var_0_223.GetHostedDedicatedServerPort()
		return var_629_32(var_629_0)
	end

	var_0_223.get_hosted_dedicated_server_port = var_0_223.GetHostedDedicatedServerPort

	local var_629_33 = var_0_53(var_629_0, 32, "unsigned int(__thiscall*)(void*)")

	function var_0_223.GetHostedDedicatedServerPOPID()
		return var_629_33(var_629_0)
	end

	var_0_223.get_hosted_dedicated_server_pop_id = var_0_223.GetHostedDedicatedServerPOPID

	local var_629_34 = var_0_53(var_629_0, 33, "int(__thiscall*)(void*, SteamDatagramHostedAddress *)")

	function var_0_223.GetHostedDedicatedServerAddress()
		local var_663_0 = var_0_103.SteamDatagramHostedAddress_arr(1)

		return var_629_34(var_629_0, var_663_0), var_0_60(var_663_0)
	end

	var_0_223.get_hosted_dedicated_server_address = var_0_223.GetHostedDedicatedServerAddress

	local var_629_35 = var_0_53(var_629_0, 34, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.CreateHostedDedicatedServerListenSocket(arg_664_0, arg_664_1, arg_664_2)
		return var_629_35(var_629_0, arg_664_0, arg_664_1, arg_664_2)
	end

	var_0_223.create_hosted_dedicated_server_listen_socket = var_0_223.CreateHostedDedicatedServerListenSocket

	local var_629_36 = var_0_53(var_629_0, 35, "int(__thiscall*)(void*, SteamDatagramGameCoordinatorServerLogin *, int *, void *)")

	function var_0_223.GetGameCoordinatorServerLogin(arg_665_0, arg_665_1, arg_665_2)
		return var_629_36(var_629_0, arg_665_0, arg_665_1, arg_665_2)
	end

	var_0_223.get_game_coordinator_server_login = var_0_223.GetGameCoordinatorServerLogin

	local var_629_37 = var_0_53(var_629_0, 36, "unsigned int(__thiscall*)(void*, void* *, const SteamNetworkingIdentity *, int, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.ConnectP2PCustomSignaling(arg_666_0, arg_666_1, arg_666_2, arg_666_3, arg_666_4)
		return var_629_37(var_629_0, arg_666_0, arg_666_1, arg_666_2, arg_666_3, arg_666_4)
	end

	var_0_223.connect_p2p_custom_signaling = var_0_223.ConnectP2PCustomSignaling

	local var_629_38 = var_0_53(var_629_0, 37, "bool(__thiscall*)(void*, const void *, int, void* *)")

	function var_0_223.ReceivedP2PCustomSignal(arg_667_0, arg_667_1, arg_667_2)
		return var_629_38(var_629_0, arg_667_0, arg_667_1, arg_667_2)
	end

	var_0_223.received_p2p_custom_signal = var_0_223.ReceivedP2PCustomSignal

	local var_629_39 = var_0_53(var_629_0, 38, "bool(__thiscall*)(void*, int *, void *, char * &)")

	function var_0_223.GetCertificateRequest(arg_668_0, arg_668_1, arg_668_2)
		return var_629_39(var_629_0, arg_668_0, arg_668_1, arg_668_2)
	end

	var_0_223.get_certificate_request = var_0_223.GetCertificateRequest

	local var_629_40 = var_0_53(var_629_0, 39, "bool(__thiscall*)(void*, const void *, int, char * &)")

	function var_0_223.SetCertificate(arg_669_0, arg_669_1, arg_669_2)
		return var_629_40(var_629_0, arg_669_0, arg_669_1, arg_669_2)
	end

	var_0_223.set_certificate = var_0_223.SetCertificate

	local var_629_41 = var_0_53(var_629_0, 40, "void(__thiscall*)(void*, const SteamNetworkingIdentity *)")

	function var_0_223.ResetIdentity(arg_670_0)
		return var_629_41(var_629_0, arg_670_0)
	end

	var_0_223.reset_identity = var_0_223.ResetIdentity

	local var_629_42 = var_0_53(var_629_0, 41, "void(__thiscall*)(void*)")

	function var_0_223.RunCallbacks()
		return var_629_42(var_629_0)
	end

	var_0_223.run_callbacks = var_0_223.RunCallbacks

	local var_629_43 = var_0_53(var_629_0, 42, "bool(__thiscall*)(void*, int)")

	function var_0_223.BeginAsyncRequestFakeIP(arg_672_0)
		return var_629_43(var_629_0, arg_672_0)
	end

	var_0_223.begin_async_request_fake_ip = var_0_223.BeginAsyncRequestFakeIP

	local var_629_44 = var_0_53(var_629_0, 43, "void(__thiscall*)(void*, int, SteamNetworkingFakeIPResult_t *)")

	function var_0_223.GetFakeIP(arg_673_0, arg_673_1)
		return var_629_44(var_629_0, arg_673_0, arg_673_1)
	end

	var_0_223.get_fake_ip = var_0_223.GetFakeIP

	local var_629_45 = var_0_53(var_629_0, 44, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")

	function var_0_223.CreateListenSocketP2PFakeIP(arg_674_0, arg_674_1, arg_674_2)
		return var_629_45(var_629_0, arg_674_0, arg_674_1, arg_674_2)
	end

	var_0_223.create_listen_socket_p2p_fake_ip = var_0_223.CreateListenSocketP2PFakeIP

	local var_629_46 = var_0_53(var_629_0, 45, "int(__thiscall*)(void*, unsigned int, SteamNetworkingIPAddr *)")

	function var_0_223.GetRemoteFakeIPForConnection(arg_675_0, arg_675_1)
		return var_629_46(var_629_0, arg_675_0, arg_675_1)
	end

	var_0_223.get_remote_fake_ip_for_connection = var_0_223.GetRemoteFakeIPForConnection

	local var_629_47 = var_0_53(var_629_0, 46, "ISteamNetworkingFakeUDPPort *(__thiscall*)(void*, int)")

	function var_0_223.CreateFakeUDPPort(arg_676_0)
		return var_629_47(var_629_0, arg_676_0)
	end

	var_0_223.create_fake_udp_port = var_0_223.CreateFakeUDPPort

	return var_0_223
end

local var_0_224 = {
	version = "SteamNetworkingUtils004",
	version_number = 4
}

function var_0_62.ISteamNetworkingUtils()
	local var_677_0 = var_0_114("steamnetworkingsockets.dll", "SteamNetworkingUtils_LibV4", "void*(__thiscall*)(unsigned int, unsigned int)")()

	var_0_224.thisptr = var_677_0

	local var_677_1 = var_0_53(var_677_0, 0, "SteamNetworkingMessage_t *(__thiscall*)(void*, int)")

	function var_0_224.AllocateMessage(arg_678_0)
		return var_677_1(var_677_0, arg_678_0)
	end

	var_0_224.allocate_message = var_0_224.AllocateMessage

	local var_677_2 = var_0_53(var_677_0, 1, "int(__thiscall*)(void*, SteamRelayNetworkStatus_t *)")

	function var_0_224.GetRelayNetworkStatus()
		local var_679_0 = var_0_103.SteamRelayNetworkStatus_t_arr(1)

		return var_677_2(var_677_0, var_679_0), var_0_60(var_679_0)
	end

	var_0_224.get_relay_network_status = var_0_224.GetRelayNetworkStatus

	local var_677_3 = var_0_53(var_677_0, 2, "float(__thiscall*)(void*, SteamNetworkPingLocation_t &)")

	function var_0_224.GetLocalPingLocation(arg_680_0)
		return var_677_3(var_677_0, arg_680_0)
	end

	var_0_224.get_local_ping_location = var_0_224.GetLocalPingLocation

	local var_677_4 = var_0_53(var_677_0, 3, "int(__thiscall*)(void*, const SteamNetworkPingLocation_t &, const SteamNetworkPingLocation_t &)")

	function var_0_224.EstimatePingTimeBetweenTwoLocations(arg_681_0, arg_681_1)
		return var_677_4(var_677_0, arg_681_0, arg_681_1)
	end

	var_0_224.estimate_ping_time_between_two_locations = var_0_224.EstimatePingTimeBetweenTwoLocations

	local var_677_5 = var_0_53(var_677_0, 4, "int(__thiscall*)(void*, const SteamNetworkPingLocation_t &)")

	function var_0_224.EstimatePingTimeFromLocalHost(arg_682_0)
		return var_677_5(var_677_0, arg_682_0)
	end

	var_0_224.estimate_ping_time_from_local_host = var_0_224.EstimatePingTimeFromLocalHost

	local var_677_6 = var_0_53(var_677_0, 5, "void(__thiscall*)(void*, const SteamNetworkPingLocation_t &, char *, int)")

	function var_0_224.ConvertPingLocationToString(arg_683_0, arg_683_1, arg_683_2)
		return var_677_6(var_677_0, arg_683_0, arg_683_1, arg_683_2)
	end

	var_0_224.convert_ping_location_to_string = var_0_224.ConvertPingLocationToString

	local var_677_7 = var_0_53(var_677_0, 6, "bool(__thiscall*)(void*, const char *, SteamNetworkPingLocation_t &)")

	function var_0_224.ParsePingLocationString(arg_684_0, arg_684_1)
		return var_677_7(var_677_0, arg_684_0, arg_684_1)
	end

	var_0_224.parse_ping_location_string = var_0_224.ParsePingLocationString

	local var_677_8 = var_0_53(var_677_0, 7, "bool(__thiscall*)(void*, float)")

	function var_0_224.CheckPingDataUpToDate(arg_685_0)
		return var_677_8(var_677_0, arg_685_0)
	end

	var_0_224.check_ping_data_up_to_date = var_0_224.CheckPingDataUpToDate

	local var_677_9 = var_0_53(var_677_0, 8, "int(__thiscall*)(void*, unsigned int, unsigned int *)")

	function var_0_224.GetPingToDataCenter(arg_686_0)
		local var_686_0 = var_0_175()

		return var_677_9(var_677_0, arg_686_0, var_686_0), var_0_60(var_686_0)
	end

	var_0_224.get_ping_to_data_center = var_0_224.GetPingToDataCenter

	local var_677_10 = var_0_53(var_677_0, 9, "int(__thiscall*)(void*, unsigned int)")

	function var_0_224.GetDirectPingToPOP(arg_687_0)
		return var_677_10(var_677_0, arg_687_0)
	end

	var_0_224.get_direct_ping_to_pop = var_0_224.GetDirectPingToPOP

	local var_677_11 = var_0_53(var_677_0, 10, "int(__thiscall*)(void*)")

	function var_0_224.GetPOPCount()
		return var_677_11(var_677_0)
	end

	var_0_224.get_pop_count = var_0_224.GetPOPCount

	local var_677_12 = var_0_53(var_677_0, 11, "int(__thiscall*)(void*, unsigned int *, int)")

	function var_0_224.GetPOPList(arg_689_0, arg_689_1)
		return var_677_12(var_677_0, arg_689_0, arg_689_1)
	end

	var_0_224.get_pop_list = var_0_224.GetPOPList

	local var_677_13 = var_0_53(var_677_0, 12, "long long(__thiscall*)(void*)")

	function var_0_224.GetLocalTimestamp()
		return var_677_13(var_677_0)
	end

	var_0_224.get_local_timestamp = var_0_224.GetLocalTimestamp

	local var_677_14 = var_0_53(var_677_0, 13, "void(__thiscall*)(void*, int, void (__thiscall*)(int, const char *))")

	function var_0_224.SetDebugOutputFunction(arg_691_0, arg_691_1)
		arg_691_0 = var_0_160(arg_691_0, var_0_64.ESteamNetworkingSocketsDebugOutputType, "detail_level is required")

		return var_677_14(var_677_0, arg_691_0, arg_691_1)
	end

	var_0_224.set_debug_output_function = var_0_224.SetDebugOutputFunction

	local var_677_15 = var_0_53(var_677_0, 14, "int(__thiscall*)(void*, uint32_t)")

	function var_0_224.GetIPv4FakeIPType(arg_692_0)
		return var_677_15(var_677_0, arg_692_0)
	end

	var_0_224.get_i_pv4_fake_ip_type = var_0_224.GetIPv4FakeIPType

	local var_677_16 = var_0_53(var_677_0, 15, "int(__thiscall*)(void*, const SteamNetworkingIPAddr &, SteamNetworkingIdentity *)")

	function var_0_224.GetRealIdentityForFakeIP(arg_693_0, arg_693_1)
		return var_677_16(var_677_0, arg_693_0, arg_693_1)
	end

	var_0_224.get_real_identity_for_fake_ip = var_0_224.GetRealIdentityForFakeIP

	local var_677_17 = var_0_53(var_677_0, 16, "bool(__thiscall*)(void*, int, int, intptr_t, int, const void *)")

	function var_0_224.SetConfigValue(arg_694_0, arg_694_1, arg_694_2, arg_694_3, arg_694_4)
		arg_694_0 = var_0_160(arg_694_0, var_0_64.ESteamNetworkingConfigValue, "value is required")
		arg_694_1 = var_0_160(arg_694_1, var_0_64.ESteamNetworkingConfigScope, "scope_type is required")
		arg_694_3 = var_0_160(arg_694_3, var_0_64.ESteamNetworkingConfigDataType, "data_type is required")

		return var_677_17(var_677_0, arg_694_0, arg_694_1, arg_694_2, arg_694_3, arg_694_4)
	end

	var_0_224.set_config_value = var_0_224.SetConfigValue

	local var_677_18 = var_0_53(var_677_0, 17, "int(__thiscall*)(void*, int, int, intptr_t, int *, void *, size_t *)")

	function var_0_224.GetConfigValue(arg_695_0, arg_695_1, arg_695_2, arg_695_3, arg_695_4)
		arg_695_0 = var_0_160(arg_695_0, var_0_64.ESteamNetworkingConfigValue, "value is required")
		arg_695_1 = var_0_160(arg_695_1, var_0_64.ESteamNetworkingConfigScope, "scope_type is required")

		local var_695_0 = var_0_171()

		return var_677_18(var_677_0, arg_695_0, arg_695_1, arg_695_2, var_695_0, arg_695_3, arg_695_4), var_0_60(var_695_0)
	end

	var_0_224.get_config_value = var_0_224.GetConfigValue

	local var_677_19 = var_0_53(var_677_0, 18, "const char *(__thiscall*)(void*, int, int *, int *)")

	function var_0_224.GetConfigValueInfo(arg_696_0)
		arg_696_0 = var_0_160(arg_696_0, var_0_64.ESteamNetworkingConfigValue, "value is required")

		local var_696_0 = var_0_171()
		local var_696_1 = var_0_171()
		local var_696_2 = var_677_19(var_677_0, arg_696_0, var_696_0, var_696_1)

		return var_696_2 ~= nil and var_0_7(var_696_2) or nil, var_0_60(var_696_0), var_0_60(var_696_1)
	end

	var_0_224.get_config_value_info = var_0_224.GetConfigValueInfo

	local var_677_20 = var_0_53(var_677_0, 19, "int(__thiscall*)(void*, int, bool)")

	function var_0_224.IterateGenericEditableConfigValues(arg_697_0, arg_697_1)
		arg_697_0 = var_0_160(arg_697_0, var_0_64.ESteamNetworkingConfigValue, "current is required")

		return var_677_20(var_677_0, arg_697_0, arg_697_1)
	end

	var_0_224.iterate_generic_editable_config_values = var_0_224.IterateGenericEditableConfigValues

	local var_677_21 = var_0_53(var_677_0, 20, "void(__thiscall*)(void*, const SteamNetworkingIPAddr &, char *, uint32_t, bool)")

	function var_0_224.SteamNetworkingIPAddr_ToString(arg_698_0, arg_698_1, arg_698_2, arg_698_3)
		return var_677_21(var_677_0, arg_698_0, arg_698_1, arg_698_2, arg_698_3)
	end

	var_0_224.steam_networking_ip_addr_to_string = var_0_224.SteamNetworkingIPAddr_ToString

	local var_677_22 = var_0_53(var_677_0, 21, "bool(__thiscall*)(void*, SteamNetworkingIPAddr *, const char *)")

	function var_0_224.SteamNetworkingIPAddr_ParseString(arg_699_0, arg_699_1)
		return var_677_22(var_677_0, arg_699_0, arg_699_1)
	end

	var_0_224.steam_networking_ip_addr_parse_string = var_0_224.SteamNetworkingIPAddr_ParseString

	local var_677_23 = var_0_53(var_677_0, 22, "int(__thiscall*)(void*, const SteamNetworkingIPAddr &)")

	function var_0_224.SteamNetworkingIPAddr_GetFakeIPType(arg_700_0)
		return var_677_23(var_677_0, arg_700_0)
	end

	var_0_224.steam_networking_ip_addr_get_fake_ip_type = var_0_224.SteamNetworkingIPAddr_GetFakeIPType

	local var_677_24 = var_0_53(var_677_0, 23, "void(__thiscall*)(void*, const SteamNetworkingIdentity &, char *, uint32_t)")

	function var_0_224.SteamNetworkingIdentity_ToString(arg_701_0, arg_701_1, arg_701_2)
		return var_677_24(var_677_0, arg_701_0, arg_701_1, arg_701_2)
	end

	var_0_224.steam_networking_identity_to_string = var_0_224.SteamNetworkingIdentity_ToString

	local var_677_25 = var_0_53(var_677_0, 24, "bool(__thiscall*)(void*, SteamNetworkingIdentity *, const char *)")

	function var_0_224.SteamNetworkingIdentity_ParseString(arg_702_0, arg_702_1)
		return var_677_25(var_677_0, arg_702_0, arg_702_1)
	end

	var_0_224.steam_networking_identity_parse_string = var_0_224.SteamNetworkingIdentity_ParseString

	return var_0_224
end

local var_0_225 = {
	version = "SteamGameServerStats001",
	version_number = 1
}

function var_0_62.ISteamGameServerStats()
	local var_703_0 = vtable_bind("steamclient.dll", "SteamClient020", 14, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "SteamGameServerStats001")

	var_0_225.thisptr = var_703_0

	local var_703_1 = var_0_53(var_703_0, 0, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_703_2 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_steamIDUser;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_steamIDUser = "steamid_user"
		}
	}

	function var_0_225.RequestUserStats(arg_704_0, arg_704_1)
		arg_704_0 = var_0_158(arg_704_0, "steamid_user is required")

		if arg_704_1 ~= nil and not var_0_117(arg_704_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_704_0 = var_703_1(var_703_0, arg_704_0)

		if arg_704_1 ~= nil then
			var_704_0 = var_0_152(var_704_0, arg_704_1, 1800, var_703_2)
		end

		return var_704_0
	end

	var_0_225.request_user_stats = var_0_225.RequestUserStats

	local var_703_3 = var_0_53(var_703_0, 1, "bool(__thiscall*)(void*, SteamID, const char *, int32_t *)")

	function var_0_225.GetUserStatInt32(arg_705_0, arg_705_1)
		arg_705_0 = var_0_158(arg_705_0, "steamid_user is required")

		local var_705_0 = var_0_169()

		return var_703_3(var_703_0, arg_705_0, arg_705_1, var_705_0), var_0_60(var_705_0)
	end

	var_0_225.get_user_stat_int32 = var_0_225.GetUserStatInt32

	local var_703_4 = var_0_53(var_703_0, 2, "bool(__thiscall*)(void*, SteamID, const char *, float *)")

	function var_0_225.GetUserStatFloat(arg_706_0, arg_706_1)
		arg_706_0 = var_0_158(arg_706_0, "steamid_user is required")

		local var_706_0 = var_0_168()

		return var_703_4(var_703_0, arg_706_0, arg_706_1, var_706_0), var_0_60(var_706_0)
	end

	var_0_225.get_user_stat_float = var_0_225.GetUserStatFloat

	local var_703_5 = var_0_53(var_703_0, 3, "bool(__thiscall*)(void*, SteamID, const char *, bool *)")

	function var_0_225.GetUserAchievement(arg_707_0, arg_707_1)
		arg_707_0 = var_0_158(arg_707_0, "steamid_user is required")

		local var_707_0 = var_0_166()

		return var_703_5(var_703_0, arg_707_0, arg_707_1, var_707_0), var_0_60(var_707_0)
	end

	var_0_225.get_user_achievement = var_0_225.GetUserAchievement

	local var_703_6 = var_0_53(var_703_0, 4, "bool(__thiscall*)(void*, SteamID, const char *, int32_t)")

	function var_0_225.SetUserStatInt32(arg_708_0, arg_708_1, arg_708_2)
		arg_708_0 = var_0_158(arg_708_0, "steamid_user is required")

		return var_703_6(var_703_0, arg_708_0, arg_708_1, arg_708_2)
	end

	var_0_225.set_user_stat_int32 = var_0_225.SetUserStatInt32

	local var_703_7 = var_0_53(var_703_0, 5, "bool(__thiscall*)(void*, SteamID, const char *, float)")

	function var_0_225.SetUserStatFloat(arg_709_0, arg_709_1, arg_709_2)
		arg_709_0 = var_0_158(arg_709_0, "steamid_user is required")

		return var_703_7(var_703_0, arg_709_0, arg_709_1, arg_709_2)
	end

	var_0_225.set_user_stat_float = var_0_225.SetUserStatFloat

	local var_703_8 = var_0_53(var_703_0, 6, "bool(__thiscall*)(void*, SteamID, const char *, float, double)")

	function var_0_225.UpdateUserAvgRateStat(arg_710_0, arg_710_1, arg_710_2, arg_710_3)
		arg_710_0 = var_0_158(arg_710_0, "steamid_user is required")

		return var_703_8(var_703_0, arg_710_0, arg_710_1, arg_710_2, arg_710_3)
	end

	var_0_225.update_user_avg_rate_stat = var_0_225.UpdateUserAvgRateStat

	local var_703_9 = var_0_53(var_703_0, 7, "bool(__thiscall*)(void*, SteamID, const char *)")

	function var_0_225.SetUserAchievement(arg_711_0, arg_711_1)
		arg_711_0 = var_0_158(arg_711_0, "steamid_user is required")

		return var_703_9(var_703_0, arg_711_0, arg_711_1)
	end

	var_0_225.set_user_achievement = var_0_225.SetUserAchievement

	local var_703_10 = var_0_53(var_703_0, 8, "bool(__thiscall*)(void*, SteamID, const char *)")

	function var_0_225.ClearUserAchievement(arg_712_0, arg_712_1)
		arg_712_0 = var_0_158(arg_712_0, "steamid_user is required")

		return var_703_10(var_703_0, arg_712_0, arg_712_1)
	end

	var_0_225.clear_user_achievement = var_0_225.ClearUserAchievement

	local var_703_11 = var_0_53(var_703_0, 9, "uint64_t(__thiscall*)(void*, SteamID)")
	local var_703_12 = {
		struct = var_0_4("\t\t\tstruct {\n\t\t\t\tint m_eResult;\n\t\t\t\tSteamID m_steamIDUser;\n\t\t\t} *\n\t\t"),
		keys = {
			m_eResult = "result",
			m_steamIDUser = "steamid_user"
		}
	}

	function var_0_225.StoreUserStats(arg_713_0, arg_713_1)
		arg_713_0 = var_0_158(arg_713_0, "steamid_user is required")

		if arg_713_1 ~= nil and not var_0_117(arg_713_1) then
			return var_0_26("Invalid callback, expected function or await")
		end

		local var_713_0 = var_703_11(var_703_0, arg_713_0)

		if arg_713_1 ~= nil then
			var_713_0 = var_0_152(var_713_0, arg_713_1, 1801, var_703_12)
		end

		return var_713_0
	end

	var_0_225.store_user_stats = var_0_225.StoreUserStats

	return var_0_225
end

local var_0_226 = {}

var_0_61.ISteamNetworkingFakeUDPPort = var_0_226

var_0_56("ISteamNetworkingFakeUDPPort", "\t\ttypedef struct _ISteamNetworkingFakeUDPPort {\n\t\t\tvoid* vtbl;\n\t\t\tstruct {\n\t\t\t} vtbl_storage[1];\n\t\t} ISteamNetworkingFakeUDPPort;\n\t")

local var_0_227 = var_0_4("struct _ISteamNetworkingFakeUDPPort[1]")
local var_0_228 = var_0_4("struct _ISteamNetworkingFakeUDPPort*")
local var_0_229
local var_0_230
local var_0_231 = {}

function var_0_226.new(arg_714_0)
	if var_0_27(arg_714_0) ~= "table" then
		return var_0_26("Invalid user_callbacks, expected table", 2)
	end

	if var_0_230 == nil then
		var_0_229 = {}
		var_0_230 = {}
	end

	for iter_714_0, iter_714_1 in var_0_22(arg_714_0) do
		if var_0_230[iter_714_0] == nil then
			return var_0_26("Unknown callback: " .. var_0_19(iter_714_0), 2)
		elseif var_0_27(iter_714_1) ~= "function" then
			return var_0_26(var_0_16("Invalid callback type for %s: %s", var_0_19(iter_714_0), var_0_27(iter_714_1)), 2)
		end
	end

	local var_714_0 = var_0_227()
	local var_714_1 = var_0_2(var_0_228, var_714_0)
	local var_714_2 = var_0_54(var_714_1)

	for iter_714_2, iter_714_3 in var_0_22(var_0_230) do
		if arg_714_0[iter_714_2] ~= nil then
			var_0_229[iter_714_2][var_714_2] = arg_714_0[iter_714_2]
		end
	end

	for iter_714_4, iter_714_5 in var_0_22(var_0_230) do
		var_714_1.vtbl_storage[0][iter_714_4] = iter_714_5
	end

	var_714_1.vtbl = var_714_1.vtbl_storage
	var_0_231[var_714_2] = var_714_0

	return var_714_1
end

function var_0_63.ISteamFriends()
	local var_715_0 = vtable_bind("steamclient.dll", "SteamClient020", 8, "void*(__thiscall*)(void*, int, int, const char *)")(var_0_179, var_0_178, "SteamFriends002")
	local var_715_1 = var_0_53(var_715_0, 3, "void(__thiscall*)(void*, int)")

	function var_0_61.ISteamFriends.SetPersonaState(arg_716_0)
		arg_716_0 = var_0_160(arg_716_0, var_0_64.EPersonaState, "ePersonaState is required")

		return var_715_1(var_715_0, arg_716_0)
	end

	var_0_61.ISteamFriends.set_persona_state = var_0_61.ISteamFriends.SetPersonaState

	local var_715_2 = var_0_53(var_715_0, 13, "bool(__thiscall*)(void*, SteamID)")

	function var_0_61.ISteamFriends.AddFriend(arg_717_0)
		arg_717_0 = var_0_158(arg_717_0, "steamIDFriend is required")

		return var_715_2(var_715_0, arg_717_0)
	end

	var_0_61.ISteamFriends.add_friend = var_0_61.ISteamFriends.AddFriend

	local var_715_3 = var_0_53(var_715_0, 14, "bool(__thiscall*)(void*, SteamID)")

	function var_0_61.ISteamFriends.RemoveFriend(arg_718_0)
		arg_718_0 = var_0_158(arg_718_0, "steamIDFriend is required")

		return var_715_3(var_715_0, arg_718_0)
	end

	var_0_61.ISteamFriends.remove_friend = var_0_61.ISteamFriends.RemoveFriend

	local var_715_4 = var_0_53(var_715_0, 19, "bool(__thiscall*)(void*, SteamID, int, const char*, int)")

	function var_0_61.ISteamFriends.SendMsgToFriend(arg_719_0, arg_719_1, arg_719_2)
		arg_719_0 = var_0_158(arg_719_0, "steamIDFriend is required")
		arg_719_1 = var_0_160(arg_719_1, var_0_64.EChatEntryType, "eFriendMsgType is required")

		local var_719_0 = var_0_9(arg_719_2)

		return var_715_4(var_715_0, arg_719_0, arg_719_1, arg_719_2, var_719_0)
	end

	var_0_61.ISteamFriends.send_msg_to_friend = var_0_61.ISteamFriends.SendMsgToFriend

	local var_715_5 = var_0_61.ISteamFriends.GetFriendPersonaState
	local var_715_6 = var_0_61.ISteamUser.GetSteamID()

	function var_0_61.ISteamFriends.GetPersonaState()
		return var_715_5(var_715_6)
	end

	var_0_61.ISteamFriends.get_persona_state = var_0_61.ISteamFriends.GetPersonaState
end

function var_0_63.ISteamMatchmaking()
	local var_721_0 = vtable_bind("matchmaking.dll", "MATCHFRAMEWORK_001", 13, "void*(__thiscall*)(void*)")
	local var_721_1 = vtable_thunk(4, "SteamID(__thiscall*)(void*)")

	function var_0_61.ISteamMatchmaking.GetLobbyID()
		local var_722_0 = var_721_0()

		if var_722_0 ~= nil then
			local var_722_1 = var_721_1(var_722_0)

			if var_722_1 ~= nil and var_722_1.accountid > 0 then
				return var_722_1
			end
		end
	end
end

function var_0_63.ISteamNetworkingUtils()
	local var_723_0 = var_0_114("steamnetworkingsockets.dll", "SteamDatagram_GetNetworkConfigURL", "char *(__thiscall*)(unsigned int, unsigned int)")

	function var_0_61.ISteamNetworkingUtils.SteamDatagram_GetNetworkConfigURL()
		local var_724_0 = var_723_0()

		if var_724_0 ~= nil then
			return var_0_0.string(var_724_0)
		end
	end
end

client.set_event_callback("shutdown", function()
	for iter_725_0, iter_725_1 in var_0_22(var_0_137) do
		local var_725_0 = var_0_2(var_0_134, iter_725_1)

		var_0_144(var_725_0)
	end

	for iter_725_2, iter_725_3 in var_0_22(var_0_138) do
		local var_725_1 = var_0_2(var_0_134, iter_725_3)

		var_0_150(var_725_1)
	end
end)

return var_0_61
