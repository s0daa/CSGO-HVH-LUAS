slot0 = require("ffi")
slot2 = slot0.cast
slot3 = slot0.cdef
slot4 = slot0.typeof
slot5 = slot0.sizeof
slot6 = slot0.istype
slot7 = slot0.string
slot8 = slot0.copy
slot9 = string.len
slot10 = string.sub
slot11 = string.gsub
slot12 = string.match
slot13 = string.gmatch
slot14 = string.lower
slot15 = string.upper
slot16 = string.format
slot17 = string.reverse
slot18 = assert
slot19 = tostring
slot20 = tonumber
slot21 = setmetatable
slot23 = ipairs
slot24 = pcall
slot25 = xpcall
slot26 = error
slot27 = type
slot28 = client.error_log
slot29 = client.find_signature
slot30 = client.timestamp
slot31 = table.insert
slot32 = table.remove
slot33 = math.floor
slot34 = math.min
slot35 = math.max
slot36 = bit.band
slot37 = bit.bor
slot38 = bit.rshift
slot39 = bit.lshift
slot40 = bit.bswap
slot41 = require("gamesense/md5").sum
slot42 = slot4("uintptr_t")
slot43 = slot4("uint64_t")
slot44 = 1.458225794582441e-303
slot45 = slot4("uint64_t[?]")
slot46 = slot4("uint32_t[?]")
slot47 = slot4("uint32_t*")
slot48 = slot4("uint8_t[?]")
slot49 = slot4("uint8_t*")
slot50 = slot4("bool[?]")
slot51 = slot4("bool*")

function slot52(slot0, slot1, slot2, slot3, slot4)
	if slot3 ~= nil and slot3 ~= 0 then
		slot6 = uv2("uintptr_t", uv0(slot0, slot1) or uv1("signature not found", 2)) + slot3
	end

	if slot4 ~= nil then
		for slot10 = 1, slot4 do
			if uv2("uintptr_t*", slot6)[0] == nil then
				return uv1("signature not found")
			end
		end
	end

	return uv2(slot2, slot6)
end

function slot53(slot0, slot1, slot2)
	uv0(slot0 ~= nil)
	uv0(uv1("void***", slot0)[0] ~= nil)

	return uv1(slot2, uv1("void***", slot0)[0][slot1])
end

function slot54(slot0)
	return uv0(uv1(uv2, slot0))
end

function slot55(slot0)
	return uv0(uv1, slot0)
end

function slot56(slot0, slot1)
	if not uv0(slot0) then
		uv1(slot1)
	end
end

function slot57(slot0, slot1, slot2)
	slot4 = uv0({}, {
		__index = {}
	})

	if slot0 ~= nil then
		for slot8, slot9 in uv1(slot1) do
			if slot2 ~= nil and slot2[slot8] and slot0[slot8] ~= nil then
				slot10 = uv2(slot0[slot8])
			end

			slot4[slot8] = slot10
			slot3[slot9] = slot10
		end
	end

	return slot4
end

function slot58(slot0)
	return function (slot0)
		return uv0(uv1 .. uv2(slot0))
	end
end

slot59 = slot21({}, {
	__mode = "k"
})

function slot60(slot0)
	slot1 = slot0[0]
	uv0[slot1] = slot0

	return slot1
end

slot62 = {}
slot63 = {}

slot21({}, {
	__index = function (slot0, slot1)
		if slot0 == uv0 and uv1[slot1] ~= nil then
			uv0[slot1] = uv1[slot1]()
			uv1[slot1] = nil

			if uv2[slot1] ~= nil then
				uv2[slot1]()
			end

			return uv0[slot1]
		end
	end
})

for slot68, slot69 in pairs({
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
		InvalidParam = 8,
		InvalidProtocolVer = 7,
		LoggedInElsewhere = 6,
		InvalidPassword = 5,
		NoConnection = 3,
		Fail = 2,
		OK = 1,
		None = 0,
		PhoneNumberIsVOIP = 127,
		CachedCredentialInvalid = 126,
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
		PersistFailed = 32
	},
	EVoiceResult = {
		NotRecording = 2,
		ReceiverDidNotAnswer = 9,
		ReceiverOutOfDate = 8,
		UnsupportedCodec = 7,
		Restricted = 6,
		DataCorrupted = 5,
		BufferTooSmall = 4,
		NoData = 3,
		OK = 0,
		NotInitialized = 1
	},
	EDenyReason = {
		LoggedInElseWhere = 6,
		Cheater = 5,
		NoLicense = 4,
		Generic = 2,
		InvalidVersion = 1,
		Invalid = 0,
		SteamConnectionError = 12,
		SteamOwnerLeftGuestUser = 15,
		SteamValidationStalled = 14,
		SteamResponseTimedOut = 13,
		NotLoggedOn = 3,
		SteamConnectionLost = 11,
		IncompatibleSoftware = 10,
		MemoryCorruption = 9,
		IncompatibleAnticheat = 8,
		UnknownText = 7
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
		LoggedInElseWhere = 4,
		UserNotConnectedToSteam = 1,
		AuthTicketCanceled = 6,
		NoLicenseOrExpired = 2,
		PublisherIssuedBan = 9,
		AuthTicketInvalid = 8,
		AuthTicketInvalidAlreadyUsed = 7,
		OK = 0,
		VACCheckTimedOut = 5,
		VACBanned = 3
	},
	EUserHasLicenseForAppResult = {
		HasLicense = 0,
		NoAuth = 2,
		DoesNotHaveLicense = 1
	},
	EAccountType = {
		ContentServer = 6,
		AnonGameServer = 4,
		GameServer = 3,
		Multiseat = 2,
		Individual = 1,
		Invalid = 0,
		Max = 11,
		Pending = 5,
		AnonUser = 10,
		ConsoleUser = 9,
		Chat = 8,
		Clan = 7
	},
	EChatEntryType = {
		LinkBlocked = 14,
		HistoricalChat = 11,
		Disconnected = 10,
		WasBanned = 9,
		WasKicked = 8,
		Invalid = 0,
		LeftConversation = 6,
		Emote = 4,
		InviteGame = 3,
		Typing = 2,
		ChatMsg = 1,
		Entered = 7
	},
	EChatRoomEnterResponse = {
		Success = 1,
		RatelimitExceeded = 15,
		YouBlockedMember = 11,
		MemberBlockedYou = 10,
		CommunityBan = 9,
		ClanDisabled = 8,
		Limited = 7,
		Error = 5,
		Full = 4,
		NotAllowed = 3,
		DoesntExist = 2,
		Banned = 6
	},
	EChatSteamIDInstanceFlags = {
		FlagLobby = 262144,
		FlagClan = 524288,
		InstanceMask = 4095,
		FlagMMSLobby = 131072
	},
	ENotificationPosition = {
		TopRight = 1,
		TopLeft = 0,
		BottomRight = 3,
		BottomLeft = 2
	},
	EMarketNotAllowedReasonFlags = {
		InvalidCookie = 1024,
		NewPaymentMethod = 512,
		RecentPasswordReset = 256,
		SteamGuardOnlyRecentlyEnabled = 128,
		SteamGuardNotEnabled = 64,
		AccountNotTrusted = 32,
		TradeBanned = 16,
		AccountLimited = 8,
		TemporaryFailure = 1,
		RecentSelfRefund = 4096,
		AccountDisabled = 2,
		AccountLockedDown = 4,
		AcceptedWalletGift = 32768,
		NoRecentPurchases = 16384,
		NewPaymentMethodCannotBeVerified = 8192,
		None = 0,
		UsingNewDevice = 2048
	},
	EDurationControlProgress = {
		ExitSoon_3h = 3,
		Half = 1,
		ExitSoon_Night = 5,
		Full = 0,
		None = 2,
		ExitSoon_5h = 4
	},
	EDurationControlNotification = {
		ExitSoon_3h = 5,
		NoProgress = 4,
		HalfProgress = 3,
		["3Hours"] = 2,
		["1Hour"] = 1,
		ExitSoon_Night = 7,
		None = 0,
		ExitSoon_5h = 6
	},
	EDurationControlOnlineState = {
		OnlineHighPri = 3,
		Invalid = 0,
		Online = 2,
		Offline = 1
	},
	ESteamIPv6ConnectivityProtocol = {
		Invalid = 0,
		UDP = 2,
		HTTP = 1
	},
	ESteamIPv6ConnectivityState = {
		Unknown = 0,
		Bad = 2,
		Good = 1
	},
	EFriendRelationship = {
		Suggested_DEPRECATED = 7,
		IgnoredFriend = 6,
		RequestInitiator = 4,
		Friend = 3,
		RequestRecipient = 2,
		Max = 8,
		Ignored = 5,
		Blocked = 1,
		None = 0
	},
	EPersonaState = {
		Max = 8,
		Away = 3,
		Busy = 2,
		Invisible = 7,
		LookingToPlay = 6,
		LookingToTrade = 5,
		Snooze = 4,
		Online = 1,
		Offline = 0
	},
	EFriendFlags = {
		Immediate = 4,
		IgnoredFriend = 1024,
		ChatMember = 4096,
		RequestingInfo = 256,
		RequestingFriendship = 128,
		OnGameServer = 16,
		ClanMember = 8,
		Blocked = 1,
		FriendshipRequested = 2,
		Ignored = 512,
		All = 65535,
		None = 0
	},
	EOverlayToStoreFlag = {
		AddToCartAndShow = 2,
		None = 0,
		AddToCart = 1
	},
	EActivateGameOverlayToWebPageMode = {
		Modal = 1,
		Default = 0
	},
	ECommunityProfileItemType = {
		AnimatedAvatar = 0,
		MiniProfileBackground = 4,
		ProfileBackground = 3,
		ProfileModifier = 2,
		AvatarFrame = 1
	},
	ECommunityProfileItemProperty = {
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
		ImageSmall = 0,
		MovieMP4Small = 11
	},
	EPersonaChange = {
		RichPresence = 16384,
		SteamLevel = 8192,
		GameServer = 32,
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
		Name = 1,
		Nickname = 4096
	},
	ESteamAPICallFailure = {
		SteamGone = 0,
		MismatchedCallback = 3,
		InvalidHandle = 2,
		NetworkFailure = 1,
		None = -1
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
		ModeNumeric = 3,
		ModeEmail = 2,
		ModeMultipleLines = 1,
		ModeSingleLine = 0
	},
	ETextFilteringContext = {
		Unknown = 0,
		Name = 3,
		GameContent = 1,
		Chat = 2
	},
	ECheckFileSignature = {
		FileNotFound = 2,
		NoSignaturesFoundForThisFile = 4,
		NoSignaturesFoundForThisApp = 3,
		ValidSignature = 1,
		InvalidSignature = 0
	},
	EMatchMakingServerResponse = {
		eServerResponded = 0,
		eNoServersListedOnMasterServer = 2,
		eServerFailedToRespond = 1
	},
	ELobbyType = {
		Private = 0,
		PrivateUnique = 4,
		Invisible = 3,
		FriendsOnly = 1,
		Public = 2
	},
	ELobbyComparison = {
		EqualToOrLessThan = -2,
		NotEqual = 3,
		EqualToOrGreaterThan = 2,
		GreaterThan = 1,
		Equal = 0,
		LessThan = -1
	},
	ELobbyDistanceFilter = {
		Far = 2,
		Close = 0,
		Worldwide = 3,
		Default = 1
	},
	ESteamPartyBeaconLocationType = {
		Max = 2,
		Invalid = 0,
		ChatGroup = 1
	},
	ERemoteStoragePublishedFileVisibility = {
		Public = 0,
		Private = 2,
		Unlisted = 3,
		FriendsOnly = 1
	},
	EWorkshopFileType = {
		Max = 16,
		SteamworksAccessInvite = 13,
		Community = 0,
		GameManagedItem = 15,
		SteamVideo = 14,
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
		ControllerBinding = 12,
		First = 0
	},
	EWorkshopVote = {
		Later = 3,
		Against = 2,
		For = 1,
		Unvoted = 0
	},
	EWorkshopFileAction = {
		Played = 0,
		Completed = 1
	},
	ELeaderboardDataRequest = {
		Users = 3,
		Friends = 2,
		GlobalAroundUser = 1,
		Global = 0
	},
	ELeaderboardSortMethod = {
		None = 0,
		Descending = 2,
		Ascending = 1
	},
	ELeaderboardDisplayType = {
		TimeSeconds = 2,
		TimeMilliSeconds = 3,
		None = 0,
		Numeric = 1
	},
	ELeaderboardUploadScoreMethod = {
		ForceUpdate = 2,
		None = 0,
		KeepBest = 1
	},
	ERegisterActivationCodeResult = {
		Fail = 1,
		AlreadyOwned = 4,
		AlreadyRegistered = 2,
		OK = 0,
		Timeout = 3
	},
	EP2PSessionError = {
		DestinationNotLoggedIn_DELETED = 3,
		NotRunningApp_DELETED = 1,
		NoRightsToApp = 2,
		Max = 5,
		None = 0,
		Timeout = 4
	},
	EP2PSend = {
		Reliable = 2,
		UnreliableNoDelay = 1,
		Unreliable = 0,
		ReliableWithBuffering = 3
	},
	ESNetSocketState = {
		ConnectionBroken = 25,
		RemoteEndDisconnected = 24,
		TimeoutDuringConnect = 23,
		LocalDisconnect = 22,
		Disconnecting = 21,
		Invalid = 0,
		ReceivedRemoteCandidates = 12,
		LocalCandidatesFound = 11,
		Initiated = 10,
		Connected = 1,
		ChallengeHandshake = 15
	},
	ESNetSocketConnectionType = {
		NotConnected = 0,
		UDPRelay = 2,
		UDP = 1
	},
	EVRScreenshotType = {
		MonoPanorama = 4,
		MonoCubemap = 3,
		Stereo = 2,
		Mono = 1,
		None = 0,
		StereoPanorama = 5
	},
	AudioPlayback_Status = {
		Playing = 1,
		Undefined = 0,
		Idle = 3,
		Paused = 2
	},
	EHTTPMethod = {
		GET = 1,
		PUT = 4,
		PATCH = 7,
		OPTIONS = 6,
		DELETE = 5,
		Invalid = 0,
		POST = 3,
		HEAD = 2
	},
	EHTTPStatusCode = {
		["400BadRequest"] = 400,
		["307TemporaryRedirect"] = 307,
		["204NoContent"] = 204,
		["203NonAuthoritative"] = 203,
		["202Accepted"] = 202,
		["201Created"] = 201,
		["200OK"] = 200,
		["101SwitchingProtocols"] = 101,
		["100Continue"] = 100,
		["302Found"] = 302,
		["429TooManyRequests"] = 429,
		["4xxUnknown"] = 418,
		["417ExpectationFailed"] = 417,
		["416RequestedRangeNotSatisfiable"] = 416,
		["415UnsupportedMediaType"] = 415,
		["414RequestURITooLong"] = 414,
		["413RequestEntityTooLarge"] = 413,
		["206PartialContent"] = 206,
		["205ResetContent"] = 205,
		["305UseProxy"] = 305,
		["304NotModified"] = 304,
		["303SeeOther"] = 303,
		["5xxUnknown"] = 599,
		["301MovedPermanently"] = 301,
		["300MultipleChoices"] = 300,
		Invalid = 0,
		["505HTTPVersionNotSupported"] = 505,
		["504GatewayTimeout"] = 504,
		["503ServiceUnavailable"] = 503,
		["502BadGateway"] = 502,
		["501NotImplemented"] = 501,
		["500InternalServerError"] = 500,
		["444ConnectionClosed"] = 444,
		["412PreconditionFailed"] = 412,
		["411LengthRequired"] = 411,
		["410Gone"] = 410,
		["409Conflict"] = 409,
		["408RequestTimeout"] = 408,
		["407ProxyAuthRequired"] = 407,
		["406NotAcceptable"] = 406,
		["405MethodNotAllowed"] = 405,
		["404NotFound"] = 404,
		["403Forbidden"] = 403,
		["402PaymentRequired"] = 402,
		["401Unauthorized"] = 401
	},
	EInputSourceMode = {
		AbsoluteMouse = 4,
		FourButtons = 3,
		Buttons = 2,
		Dpad = 1,
		JoystickMove = 6,
		Switches = 16,
		SingleButton = 15,
		RadialMenu = 14,
		MouseRegion = 13,
		MouseJoystick = 12,
		ouchMenu = 11,
		rigger = 10,
		ScrollWheel = 9,
		JoystickCamera = 8,
		JoystickMouse = 7,
		None = 0,
		RelativeMouse = 5
	},
	EUGCMatchingUGCType = {
		Items_ReadyToUse = 2,
		Items_Mtx = 1,
		Items = 0,
		All = -1,
		GameManagedItems = 12,
		ControllerBindings = 11,
		UsableInGame = 10,
		IntegratedGuides = 9,
		WebGuides = 8,
		AllGuides = 7,
		Screenshots = 6,
		Videos = 5,
		Artwork = 4,
		Collections = 3
	},
	EUserUGCList = {
		WillVoteLater = 4,
		VotedDown = 3,
		VotedUp = 2,
		VotedOn = 1,
		Published = 0,
		Followed = 8,
		UsedOrPlayed = 7,
		Subscribed = 6,
		Favorited = 5
	},
	EUserUGCListSortOrder = {
		itleAsc = 2,
		CreationOrderAsc = 1,
		CreationOrderDesc = 0,
		ForModeration = 6,
		VoteScoreDesc = 5,
		SubscriptionDateDesc = 4,
		LastUpdatedDesc = 3
	},
	EUGCQuery = {
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
		RankedByVote = 0,
		RankedByLastUpdatedDate = 19
	},
	EItemUpdateStatus = {
		Invalid = 0,
		CommittingChanges = 5,
		UploadingPreviewFile = 4,
		UploadingContent = 3,
		PreparingContent = 2,
		PreparingConfig = 1
	},
	EItemStatistic = {
		ReportScore = 7,
		NumUniqueWebsiteViews = 6,
		NumUniqueFollowers = 5,
		NumUniqueFavorites = 4,
		NumUniqueSubscriptions = 3,
		NumFollowers = 2,
		NumFavorites = 1,
		NumSubscriptions = 0,
		NumPlaytimeSessionsDuringTimePeriod = 12,
		NumSecondsPlayedDuringTimePeriod = 11,
		NumComments = 10,
		NumPlaytimeSessions = 9,
		NumSecondsPlayed = 8
	},
	EItemPreviewType = {
		YouTubeVideo = 1,
		Image = 0,
		ReservedMax = 255,
		EnvironmentMap_LatLong = 4,
		EnvironmentMap_HorizontalCross = 3,
		Sketchfab = 2
	},
	EParentalFeature = {
		News = 5,
		Friends = 4,
		Store = 1,
		Profile = 3,
		Community = 2,
		Invalid = 0,
		Max = 14,
		SiteLicense = 13,
		Test = 12,
		Library = 11,
		ParentalSetup = 10,
		Browser = 9,
		Console = 8,
		Settings = 7,
		Trading = 6
	},
	ESteamDeviceFormFactor = {
		Unknown = 0,
		TV = 4,
		Computer = 3,
		Tablet = 2,
		Phone = 1
	},
	ESteamNetworkingAvailability = {
		Failed = -101,
		CannotTry = -102,
		Unknown = 0,
		Current = 100,
		Attempting = 3,
		Waiting = 2,
		NeverTried = 1,
		Retrying = -10,
		Previously = -100
	},
	ESteamNetworkingIdentityType = {
		GoogleStadia = 19,
		UnknownType = 4,
		GenericBytes = 3,
		GenericString = 2,
		IPAddress = 1,
		Invalid = 0,
		SonyPSN = 18,
		XboxPairwiseID = 17,
		SteamID = 16
	},
	ESteamNetworkingFakeIPType = {
		LocalIPv4 = 3,
		Invalid = 0,
		GlobalIPv4 = 2,
		NotFake = 1
	},
	ESteamNetworkingConnectionState = {
		Connected = 3,
		Dead = -3,
		Linger = -2,
		FinWait = -1,
		ProblemDetectedLocally = 5,
		ClosedByPeer = 4,
		FindingRoute = 2,
		Connecting = 1,
		None = 0
	},
	ESteamNetworkingConfigScope = {
		SocketsInterface = 2,
		Connection = 4,
		ListenSocket = 3,
		Global = 1
	},
	ESteamNetworkingConfigDataType = {
		Ptr = 5,
		String = 4,
		Float = 3,
		Int64 = 2,
		Int32 = 1
	},
	ESteamNetworkingConfigValue = {
		MTU_DataSize = 33,
		MTU_PacketSize = 32,
		IP_AllowWithoutAuth = 23,
		NagleTime = 12,
		SendRateMax = 11,
		SendRateMin = 10,
		ConnectionUserData = 40,
		SendBufferSize = 9,
		TimeoutConnected = 25,
		TimeoutInitial = 24,
		Callback_FakeIPResult = 207,
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
		P2P_Transport_SDR_Penalty = 106,
		P2P_Transport_ICE_Penalty = 105,
		P2P_Transport_ICE_Enable = 104,
		P2P_STUN_ServerList = 103,
		Invalid = 0,
		Callback_CreateConnectionSignaling = 206,
		Callback_MessagesSessionFailed = 205,
		Callback_MessagesSessionRequest = 204,
		Callback_RelayNetworkStatusChanged = 203,
		Callback_AuthStatusChanged = 202,
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
		FakePacketLoss_Send = 2,
		EnableDiagnosticsUI = 46,
		DualWifi_Enable = 39,
		LocalVirtualPort = 38,
		SymmetricConnect = 37,
		Unencrypted = 34
	},
	ESteamNetworkingGetConfigValueResult = {
		BufferTooSmall = -3,
		OKInherited = 2,
		BadScopeObj = -2,
		BadValue = -1,
		OK = 1
	},
	ESteamNetworkingSocketsDebugOutputType = {
		Everything = 8,
		Debug = 7,
		Verbose = 6,
		Msg = 5,
		Warning = 4,
		Important = 3,
		Bug = 1,
		Error = 2,
		None = 0
	},
	EHTMLMouseButton = {
		Middle = 2,
		Right = 1,
		Left = 0
	},
	EHTMLKeyModifiers = {
		CtrlDown = 2,
		ShiftDown = 4,
		None = 0,
		AltDown = 1
	},
	PlayerAcceptState_t = {
		Unknown = 0,
		PlayerDeclined = 2,
		PlayerAccepted = 1
	}
}) do
	slot70 = {
		__index = {}
	}

	for slot74, slot75 in slot22(slot69) do
		slot70.__index[slot14(slot74)] = slot75
		slot70.__index[slot15(slot74)] = slot75
		slot70.__index[slot75] = slot74
	end

	slot21(slot69, slot70)

	slot61[slot68] = slot69
end

for slot69, slot70 in slot22({}) do
	slot61[slot69] = slot70
end

if not slot55("SteamID") then
	slot3([[
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

slot18(slot5("SteamID") == 8)

slot66 = nil
slot67 = slot4("SteamID")
slot68 = slot64.EAccountType
slot69 = slot64.EChatSteamIDInstanceFlags
slot70 = {
	[slot68.INVALID] = "I",
	[slot68.INDIVIDUAL] = "U",
	[slot68.MULTISEAT] = "M",
	[slot68.GAMESERVER] = "G",
	[slot68.ANONGAMESERVER] = "A",
	[slot68.PENDING] = "P",
	[slot68.CONTENTSERVER] = "C",
	[slot68.CLAN] = "g",
	[slot68.CHAT] = "T",
	[slot68.ANONUSER] = "a"
}
slot71 = {
	b = "q",
	["0"] = "b",
	a = "p",
	["8"] = "m",
	["7"] = "k",
	["9"] = "n",
	["6"] = "j",
	e = "v",
	["5"] = "h",
	["4"] = "g",
	f = "w",
	["3"] = "f",
	d = "t",
	["2"] = "d",
	c = "r",
	["1"] = "c"
}
slot72 = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
slot73 = {
	[slot78 - 1] = slot79
}
slot74 = {
	[slot79] = slot78 - 1
}

for slot78 = 1, 32 do
	slot79 = slot72:sub(slot78, slot78)
end

slot75 = "[" .. slot72 .. "]"
slot76 = {
	[slot81] = slot80
}

for slot80, slot81 in slot22(slot70) do
	-- Nothing
end

slot77 = 1
slot78 = slot69.FlagClan
slot79 = slot69.FlagLobby
slot80 = slot68.INVALID
slot81 = slot68.INDIVIDUAL
slot82 = slot68.GAMESERVER
slot83 = slot68.ANONGAMESERVER
slot84 = slot68.MULTISEAT
slot85 = slot68.CLAN
slot86 = slot68.CHAT
slot87 = slot68.MAX
slot88 = "^765(" .. string.rep("%d", 14) .. ")$"
slot89 = "^STEAM_([012345]):([01]):(%d+)$"
slot90 = "^%[(%a):([012345]):(%d+)%]$"
slot91 = "^%[(%a):([012345]):(%d+):(%d+)%]$"
slot92 = "^(" .. string.rep(slot75, 5) .. ")%-(" .. string.rep(slot75, 4) .. ")$"

function slot93(slot0)
	return uv0(uv1(slot0.steamid64), 1, -4)
end

slot24(slot0.metatype, slot67, {
	__index = {
		is_valid = function (slot0)
			if slot0.type <= uv0 or uv1 <= slot0.type then
				return false
			end

			if slot0.universe <= 0 or slot0.universe > 4 then
				return false
			end

			if slot0.type == uv2 and (slot0.accountid == 0 or slot0.instance > 4) then
				return false
			end

			if slot0.type == uv3 and (slot0.accountid == 0 or slot0.instance ~= 0) then
				return false
			end

			if slot0.type == uv4 and slot0.accountid == 0 then
				return false
			end

			return true
		end,
		render_steam2 = function (slot0, slot1)
			if slot0.type ~= uv0 then
				return uv1("Cannot render non-individual ID as Steam2")
			end

			if (slot1 or slot1 == nil) and slot0.universe == 1 then
				slot2 = 0
			end

			return uv2("STEAM_%d:%d:%d", slot2, uv3(slot0.accountid, 1), uv4(slot0.accountid / 2))
		end,
		render_steam3 = function (slot0)
			slot1 = nil

			return uv8("[%s:%d:%d%s]", uv0(slot0.instance, uv1) == uv1 and "c" or uv0(slot0.instance, uv2) == uv2 and "L" or uv3[slot0.type] or "i", slot0.universe, slot0.accountid, (slot0.type == uv4 or slot0.type == uv5 or slot0.type == uv6 and slot0.instance ~= uv7) and ":" .. slot0.instance or "")
		end,
		render_steam64 = slot93,
		render_steam_invite = function (slot0)
			if slot0.type ~= uv0 and slot0.type ~= uv1 then
				return uv2("Cannot only render individual / invalid ID as Steam Invite")
			end

			if uv6(uv3(uv4("%x", slot0.accountid), ".", function (slot0)
				return uv0[slot0] or slot0
			end)) > 3 then
				slot3 = uv7(slot2 / 2)

				return uv4("%s-%s", uv8(slot1, 1, slot3), uv8(slot1, slot3 + 1, -1))
			end

			return slot1
		end,
		render_friend_code = function (slot0)
			if slot0.type ~= uv0 and slot0.type ~= uv1 then
				return uv2("Cannot only render individual / invalid ID as Friend Code")
			end

			slot1 = uv3(1, uv4(slot0.accountid, 2.1705716741963776e+16))

			uv8(uv6("void*", slot1), uv7(uv5(uv6("const char*", slot1), 8)), 4)

			slot4 = 0.0

			for slot8 = 0, 7 do
				slot11 = uv4(uv12(slot4, 4), uv9(uv10(uv11(slot0.steamid64, slot8 * 4), 15)))
				slot4 = uv4(uv12(uv11(uv4(uv12(uv11(slot4, 28), 32), slot11), 31), 32), uv4(uv12(slot11, 1), uv9(uv10(uv11(slot1[0], slot8), 1))))
			end

			slot4 = uv13(slot4)

			for slot9 = 0, 8 do
				if slot9 == 5 then
					slot5 = "" .. "-"
				end

				slot5 = slot5 .. uv14[uv9(uv10(uv11(slot4, 20 + slot9 * 5), 31))]
			end

			return slot5
		end,
		pack = function (slot0, slot1)
			if slot1 then
				slot2 = uv3(uv0(uv1("const char*", uv2(1, slot0.steamid64)), 8))
			end

			return slot2
		end
	},
	__tostring = slot93,
	__eq = function (slot0, slot1)
		if not uv0(uv1, slot0) then
			slot0 = slot0
		end

		slot2 = uv2(slot1)

		if not uv0(uv1, slot0) then
			return uv2(slot0) == "nil" and slot2 == "nil"
		end

		if slot2 == "nil" then
			return false
		elseif slot2 == "cdata" and uv0(uv1, slot1) then
			return slot0.steamid64 == slot1.steamid64
		elseif (slot2 == "number" or slot2 == "cdata") and (slot0.accountid == slot1 or slot0.steamid64 == slot1) then
			return true
		end

		return slot0.steamid64 == uv3(slot1).steamid64
	end
})

function slot66(slot0)
	if uv0(uv1, slot0) then
		return slot0
	elseif uv0(uv2, slot0) and uv3 < slot0 then
		return uv1(slot0)
	end

	if uv4(slot0) == "string" then
		if uv5(slot0, uv6) ~= nil then
			return uv1(1.4483174291037683e-303 + uv7(slot2))
		end

		slot3, slot4, slot5 = uv5(slot0, uv8)

		if slot3 ~= nil then
			slot6 = uv1()
			slot6.universe = slot3 == "0" and 1 or uv7(slot3)
			slot6.type = uv9
			slot6.instance = uv10
			slot6.accountid = uv7(slot5) * 2 + slot4

			return slot6
		end

		slot6, slot7, slot8, slot9 = uv5(slot0, uv11)

		if slot6 ~= nil then
			if slot6 == "U" then
				slot9 = uv10
			else
				slot9 = 0
			end
		else
			slot6, slot7, slot8, slot9 = uv5(slot0, uv12)
		end

		if slot6 ~= nil then
			slot10 = uv1()
			slot10.universe = uv7(slot7)
			slot10.instance = uv7(slot9)
			slot10.accountid = uv7(slot8)

			if slot6 == "c" then
				slot10.instance = uv13(slot10.instance, uv14)
				slot10.type = uv15
			elseif slot6 == "L" then
				slot10.instance = uv13(slot10.instance, uv16)
				slot10.type = uv15
			else
				slot10.type = uv17[slot6] or 0
			end

			return slot10
		end

		slot10, slot11 = uv5(slot0, uv18)

		if slot10 ~= nil then
			slot14 = 0

			for slot18 in uv19("AAAA" .. slot10 .. slot11, ".") do
				slot13 = uv13(0.0, uv22(uv20(uv2, uv21[slot18]), slot14 * 5))
				slot14 = slot14 + 1
			end

			slot15 = uv1()

			for slot19 = 0, 7 do
				slot13 = uv24(uv23(slot13), 1)
				slot13 = uv24(slot13, 4)
				slot15.accountid = uv13(uv22(slot15.accountid, 4), uv25(slot13, 15))
			end

			slot15.type = uv9
			slot15.universe = 1
			slot15.instance = 1

			return slot15
		end
	elseif slot1 == "number" and slot0 > 0 then
		return uv1(uv3 + slot0)
	end

	return nil
end

slot56("SteamIPAddress_t", [[
	typedef struct {
		uint8_t m_rgubIPv6[16];
		int m_eType;
	} SteamIPAddress_t;
]])
slot56("FriendGameInfo_t", [[
	typedef struct {
		uint64_t m_gameID;
		uint32_t m_unGameIP;
		uint16_t m_usGamePort;
		uint16_t m_usQueryPort;
		SteamID m_steamIDLobby;
	} FriendGameInfo_t;
]])
slot56("MatchMakingKeyValuePair_t", [[
	typedef struct {
		char m_szKey[256];
		char m_szValue[256];
	} MatchMakingKeyValuePair_t;
]])
slot56("servernetadr_t", [[
	typedef struct {
		uint16_t m_usConnectionPort;
		uint16_t m_usQueryPort;
		uint32_t m_unIP;
	} servernetadr_t;
]])
slot56("gameserveritem_t", [[
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
slot56("SteamPartyBeaconLocation_t", [[
	typedef struct {
		int m_eType;
		uint64_t m_ulLocationID;
	} SteamPartyBeaconLocation_t;
]])
slot56("SteamParamStringArray_t", [[
	typedef struct {
		const char ** m_ppStrings;
		int32_t m_nNumStrings;
	} SteamParamStringArray_t;
]])
slot56("LeaderboardEntry_t", [[
	typedef struct {
		SteamID m_steamIDUser;
		int32_t m_nGlobalRank;
		int32_t m_nScore;
		int32_t m_cDetails;
		uint64_t m_hUGC;
	} LeaderboardEntry_t;
]])
slot56("P2PSessionState_t", [[
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
slot56("InputAnalogActionData_t", [[
	typedef struct {
		int eMode;
		float x;
		float y;
		bool bActive;
	} InputAnalogActionData_t;
]])
slot56("InputDigitalActionData_t", [[
	typedef struct {
		bool bState;
		bool bActive;
	} InputDigitalActionData_t;
]])
slot56("InputMotionData_t", [[
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
slot56("SteamUGCDetails_t", [[
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
slot56("SteamItemDetails_t", [[
	typedef struct {
		uint64_t m_itemId;
		int m_iDefinition;
		uint16_t m_unQuantity;
		uint16_t m_unFlags;
	} SteamItemDetails_t;
]])
slot56("SteamNetworkingIPAddr", [[
	typedef struct {
		uint8_t m_ipv6[16];
		uint16_t m_port;
	} SteamNetworkingIPAddr;
]])
slot56("SteamNetworkingIdentity", [[
	typedef struct {
		int m_eType;
		int m_cbSize;
		char m_szUnknownRawString[128];
	} SteamNetworkingIdentity;
]])
slot56("SteamNetConnectionInfo_t", [[
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
		int m_nFlags;
		uint32_t reserved[63];
	} SteamNetConnectionInfo_t;
]])
slot56("SteamNetConnectionRealTimeStatus_t", [[
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
	} SteamNetConnectionRealTimeStatus_t;
]])
slot56("SteamNetConnectionRealTimeLaneStatus_t", [[
	typedef struct {
		int m_cbPendingUnreliable;
		int m_cbPendingReliable;
		int m_cbSentUnackedReliable;
		int _reservePad1;
		long long m_usecQueueTime;
		uint32_t reserved[10];
	} SteamNetConnectionRealTimeLaneStatus_t;
]])
slot56("SteamNetworkingMessage_t", [[
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
		uint16_t m_idxLane;
		uint16_t _pad1__;
	} SteamNetworkingMessage_t;
]])
slot56("SteamNetworkPingLocation_t", [[
	typedef struct {
		uint8_t m_data[512];
	} SteamNetworkPingLocation_t;
]])
slot56("SteamNetworkingConfigValue_t", [[
	typedef struct {
		int m_eValue;
		int m_eDataType;
		int64_t m_int64;
	} SteamNetworkingConfigValue_t;
]])
slot56("SteamDatagramHostedAddress", [[
	typedef struct {
		int m_cbSize;
		char m_data[128];
	} SteamDatagramHostedAddress;
]])
slot56("SteamDatagramGameCoordinatorServerLogin", [[
	typedef struct {
		SteamNetworkingIdentity m_identity;
		SteamDatagramHostedAddress m_routing;
		unsigned int m_nAppID;
		unsigned int m_rtime;
		int m_cbAppData;
		char m_appData[2048];
	} SteamDatagramGameCoordinatorServerLogin;
]])
slot56("SteamNetAuthenticationStatus_t", [[
	typedef struct {
		int m_eAvail;
		char m_debugMsg[256];
	} SteamNetAuthenticationStatus_t;
]])
slot56("SteamNetworkingFakeIPResult_t", [[
	typedef struct {
		int m_eResult;
		SteamNetworkingIdentity m_identity;
		uint32_t m_unIP;
		uint16_t m_unPorts[8];
	} SteamNetworkingFakeIPResult_t;
]])
slot56("SteamRelayNetworkStatus_t", [[
	typedef struct {
		int m_eAvail;
		int m_bPingMeasurementInProgress;
		int m_eAvailNetworkConfig;
		int m_eAvailAnyRelay;
		char m_debugMsg[256];
	} SteamRelayNetworkStatus_t;
]])
slot56("SteamNetConnectionStatusChangedCallback_t", [[
	typedef struct {
		unsigned int m_hConn;
		SteamNetConnectionInfo_t m_info;
		int m_eOldState;
	} SteamNetConnectionStatusChangedCallback_t;
]])
slot56("SteamNetworkingMessagesSessionRequest_t", [[
	typedef struct {
		SteamNetworkingIdentity m_identityRemote;
	} SteamNetworkingMessagesSessionRequest_t;
]])
slot56("SteamNetworkingMessagesSessionFailed_t", [[
	typedef struct {
		SteamNetConnectionInfo_t m_info;
	} SteamNetworkingMessagesSessionFailed_t;
]])
slot56("SteamDatagramRelayAuthTicket", [[
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

for slot72, slot73 in slot22({
	SteamIPAddress_t = slot4("SteamIPAddress_t"),
	SteamIPAddress_t_arr = slot4("SteamIPAddress_t [?]"),
	FriendGameInfo_t = slot4("FriendGameInfo_t"),
	FriendGameInfo_t_arr = slot4("FriendGameInfo_t [?]"),
	MatchMakingKeyValuePair_t = slot4("MatchMakingKeyValuePair_t"),
	MatchMakingKeyValuePair_t_arr = slot4("MatchMakingKeyValuePair_t [?]"),
	servernetadr_t = slot4("servernetadr_t"),
	servernetadr_t_arr = slot4("servernetadr_t [?]"),
	gameserveritem_t = slot4("gameserveritem_t"),
	gameserveritem_t_arr = slot4("gameserveritem_t [?]"),
	SteamPartyBeaconLocation_t = slot4("SteamPartyBeaconLocation_t"),
	SteamPartyBeaconLocation_t_arr = slot4("SteamPartyBeaconLocation_t [?]"),
	SteamParamStringArray_t = slot4("SteamParamStringArray_t"),
	SteamParamStringArray_t_arr = slot4("SteamParamStringArray_t [?]"),
	LeaderboardEntry_t = slot4("LeaderboardEntry_t"),
	LeaderboardEntry_t_arr = slot4("LeaderboardEntry_t [?]"),
	P2PSessionState_t = slot4("P2PSessionState_t"),
	P2PSessionState_t_arr = slot4("P2PSessionState_t [?]"),
	InputAnalogActionData_t = slot4("InputAnalogActionData_t"),
	InputAnalogActionData_t_arr = slot4("InputAnalogActionData_t [?]"),
	InputDigitalActionData_t = slot4("InputDigitalActionData_t"),
	InputDigitalActionData_t_arr = slot4("InputDigitalActionData_t [?]"),
	InputMotionData_t = slot4("InputMotionData_t"),
	InputMotionData_t_arr = slot4("InputMotionData_t [?]"),
	SteamUGCDetails_t = slot4("SteamUGCDetails_t"),
	SteamUGCDetails_t_arr = slot4("SteamUGCDetails_t [?]"),
	SteamItemDetails_t = slot4("SteamItemDetails_t"),
	SteamItemDetails_t_arr = slot4("SteamItemDetails_t [?]"),
	SteamNetworkingIPAddr = slot4("SteamNetworkingIPAddr"),
	SteamNetworkingIPAddr_arr = slot4("SteamNetworkingIPAddr [?]"),
	SteamNetworkingIdentity = slot4("SteamNetworkingIdentity"),
	SteamNetworkingIdentity_arr = slot4("SteamNetworkingIdentity [?]"),
	SteamNetConnectionInfo_t = slot4("SteamNetConnectionInfo_t"),
	SteamNetConnectionInfo_t_arr = slot4("SteamNetConnectionInfo_t [?]"),
	SteamNetConnectionRealTimeStatus_t = slot4("SteamNetConnectionRealTimeStatus_t"),
	SteamNetConnectionRealTimeStatus_t_arr = slot4("SteamNetConnectionRealTimeStatus_t [?]"),
	SteamNetConnectionRealTimeLaneStatus_t = slot4("SteamNetConnectionRealTimeLaneStatus_t"),
	SteamNetConnectionRealTimeLaneStatus_t_arr = slot4("SteamNetConnectionRealTimeLaneStatus_t [?]"),
	SteamNetworkingMessage_t = slot4("SteamNetworkingMessage_t"),
	SteamNetworkingMessage_t_arr = slot4("SteamNetworkingMessage_t [?]"),
	SteamNetworkPingLocation_t = slot4("SteamNetworkPingLocation_t"),
	SteamNetworkPingLocation_t_arr = slot4("SteamNetworkPingLocation_t [?]"),
	SteamNetworkingConfigValue_t = slot4("SteamNetworkingConfigValue_t"),
	SteamNetworkingConfigValue_t_arr = slot4("SteamNetworkingConfigValue_t [?]"),
	SteamDatagramHostedAddress = slot4("SteamDatagramHostedAddress"),
	SteamDatagramHostedAddress_arr = slot4("SteamDatagramHostedAddress [?]"),
	SteamDatagramGameCoordinatorServerLogin = slot4("SteamDatagramGameCoordinatorServerLogin"),
	SteamDatagramGameCoordinatorServerLogin_arr = slot4("SteamDatagramGameCoordinatorServerLogin [?]"),
	SteamNetAuthenticationStatus_t = slot4("SteamNetAuthenticationStatus_t"),
	SteamNetAuthenticationStatus_t_arr = slot4("SteamNetAuthenticationStatus_t [?]"),
	SteamNetworkingFakeIPResult_t = slot4("SteamNetworkingFakeIPResult_t"),
	SteamNetworkingFakeIPResult_t_arr = slot4("SteamNetworkingFakeIPResult_t [?]"),
	SteamRelayNetworkStatus_t = slot4("SteamRelayNetworkStatus_t"),
	SteamRelayNetworkStatus_t_arr = slot4("SteamRelayNetworkStatus_t [?]"),
	SteamNetConnectionStatusChangedCallback_t = slot4("SteamNetConnectionStatusChangedCallback_t"),
	SteamNetConnectionStatusChangedCallback_t_arr = slot4("SteamNetConnectionStatusChangedCallback_t [?]"),
	SteamNetworkingMessagesSessionRequest_t = slot4("SteamNetworkingMessagesSessionRequest_t"),
	SteamNetworkingMessagesSessionRequest_t_arr = slot4("SteamNetworkingMessagesSessionRequest_t [?]"),
	SteamNetworkingMessagesSessionFailed_t = slot4("SteamNetworkingMessagesSessionFailed_t"),
	SteamNetworkingMessagesSessionFailed_t_arr = slot4("SteamNetworkingMessagesSessionFailed_t [?]")
}) do
	slot61[slot72] = slot73
end

slot75 = "uintptr_t"
slot76 = 1
slot70 = slot2("uintptr_t**", slot52("client_panorama.dll", "\\xb9\\xcc\\xcc\\xcc\\xcc\\xe8\\xcc\\xcc\\xcc̃=\\xcc\\xcc\\xcc\\xcc\\xcc\\x84", slot75, slot76, 1))
slot71 = {
	[slot76] = slot70[slot75 - 1][0],
	[slot76:gsub("%d+$", "")] = slot70[slot75 - 1][0]
}

for slot75, slot76 in slot23({
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
}) do
	-- Nothing
end

slot74 = client.find_signature("engine.dll", "\\xff\\xe1")
slot75 = slot2("uint32_t**", slot2("uint32_t", client.find_signature("engine.dll", "\\xff\\xcc\\xcc\\xcc̣\\xcc\\xcc\\xcc\\xcc\\xeb") or slot26("Couldn't find signature #2")) + 2)[0][0]
slot76 = slot2("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", slot74)
slot77 = slot2("uint32_t**", slot2("uint32_t", client.find_signature("engine.dll", "\\xff\\xcc\\xcc\\xcc̅\\xc0t") or slot26("Couldn't find signature #1")) + 2)[0][0]
slot78 = slot2("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", slot74)

function slot79(slot0, slot1, slot2)
	if uv0(uv1, 0, slot0) == 0 then
		return
	end

	if uv2(uv3, 0, slot3, slot1) == 0 then
		return
	end

	slot5 = uv4(uv5(slot2), uv6)

	return function (...)
		return uv0(uv1, 0, ...)
	end
end

slot80 = 10
slot61.await = ({
	__call = function (slot0, slot1, slot2)
		if uv0(slot1) == "function" then
			slot1 = slot1
		end

		return uv1({
			uv2(slot1) or uv3,
			slot2
		}, uv4)
	end
}).__call()

function slot82(slot0)
	return uv0(slot0) == "function" or slot1 == "table" and getmetatable(slot0) == uv1
end

slot83 = {
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
slot84 = {
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

if not slot24(slot5, "SteamAPICall_t") then
	slot3([[
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

slot85 = slot64.ESteamAPICallFailure
slot86, slot87, slot88, slot89 = nil
slot90 = slot71.ISteamUtils
slot91 = slot53(slot90, 12, "int(__thiscall*)(void*, SteamAPICall_t)")
slot92 = slot53(slot90, 11, "bool(__thiscall*)(void*, SteamAPICall_t, bool*)")

function slot93(slot0)
	return uv0(uv1, slot0)
end

slot94 = slot50(1)

function slot95(slot0)
	return uv0(uv1, slot0, uv2), uv2[0]
end

slot96 = slot4("struct SteamAPI_callback_base")
slot97 = slot5(slot96)
slot98 = slot4("struct SteamAPI_callback_base[1]")
slot99 = slot4("struct SteamAPI_callback_base*")
slot100 = {}
slot101 = {}
slot102 = {}
slot103 = {}
slot104 = slot58("[steamworks] callback failed: ")

function slot105(slot0, slot1, slot2)
	slot2 = slot2 and (uv0[uv1(slot0.api_call_handle)] or true)
	slot0.api_call_handle = 0

	if uv3[uv2(slot0)] ~= nil then
		if uv4[slot3] ~= nil then
			if slot1 ~= nil then
				slot1 = uv5(slot5.struct, slot1)
			end

			slot6 = uv6(slot1, slot5.keys, slot5.string_keys_lookup)

			if slot2 ~= false then
				slot6.io_failure = slot2
			end

			uv7(slot4, uv8, slot6)
		else
			uv7(slot4, uv8, slot1, slot2)
		end
	end

	if uv9[slot3] ~= nil then
		uv3[slot3] = nil
		uv4[slot3] = nil
		uv9[slot3] = nil
	end
end

function slot109(slot0)
	if slot0.api_call_handle ~= 0 then
		uv0(slot0, slot0.api_call_handle)

		slot0.api_call_handle = 0
		slot1 = uv1(slot0)
		uv2[slot1] = nil
		uv3[slot1] = nil
		uv4[slot1] = nil
	end
end

slot24(slot0.metatype, slot96, {
	__gc = slot109,
	__index = {
		cancel = slot109
	}
})

slot110 = slot2("void(__thiscall *)(struct SteamAPI_callback_base *, void *, bool, uint64_t)", function (slot0, slot1, slot2, slot3)
	if slot3 == slot0.api_call_handle then
		uv0(uv1, uv2, slot0, slot1, slot2)
	end
end)
slot111 = slot2("void(__thiscall *)(struct SteamAPI_callback_base *, void *)", function (slot0, slot1)
	uv0(uv1, uv2, slot0, slot1, false)
end)
slot112 = slot2("int(__thiscall *)(struct SteamAPI_callback_base *)", function ()
	return uv0
end)
slot86 = slot52("steam_api.dll", "U\\x8b\\xec\\x83=\\xcc\\xcc\\xcc\\xcc\\xcc~\rh\\xcc\\xcc\\xcc\\xcc\\xff\\xcc\\xcc\\xcc\\xcc]\\xc3\\xffu", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
slot87 = slot52("steam_api.dll", "U\\x8b\\xec\\xffu\\xffu", "void(__cdecl*)(struct SteamAPI_callback_base *, uint64_t)")
slot88 = slot52("steam_api.dll", "U\\x8b\\xec\\x83=\\xcc\\xcc\\xcc\\xcc\\xcc~\rh\\xcc\\xcc\\xcc\\xcc\\xff\\xcc\\xcc\\xcc\\xcc]\\xc3\\xc7", "void(__cdecl*)(struct SteamAPI_callback_base *, int)")
slot89 = slot52("steam_api.dll", "U\\x8b\\xec\\x83\\xec\\x80=\\xcc\\xcc\\xcc\\xcc\\xcc\\x84", "void(__cdecl*)(struct SteamAPI_callback_base *)")
slot113 = slot52("steam_api.dll", "2Ƀ=\\xcc\\xcc\\xcc\\xcc\\xcc", "void(__cdecl*)(void)")

function slot114(slot0, slot1, slot2, slot3)
	uv0(slot0 ~= 0)

	slot5 = uv2(uv3, uv1())
	slot5.vtbl_storage[0].run1 = uv4
	slot5.vtbl_storage[0].run2 = uv5
	slot5.vtbl_storage[0].get_size = uv6
	slot5.vtbl = slot5.vtbl_storage
	slot5.api_call_handle = slot0
	slot5.id = slot2
	slot6 = slot0
	slot7 = false

	if uv7(slot1) == "table" and getmetatable(slot1) == uv8 and slot1 or nil then
		jit.off(true, true)

		slot6 = nil
		slot9 = uv7(slot8[2]) == "function" and slot8[2] or nil

		function slot1(slot0)
			if uv0 and uv1 ~= nil then
				uv2(uv1, uv3, slot0)
			end

			uv4 = slot0
		end
	end

	slot9 = uv11(slot5)
	uv12[slot9] = slot1
	uv13[slot9] = slot3
	uv14[slot9] = slot4

	uv15(slot5, slot0)

	if slot8 then
		while true do
			if slot6 ~= nil or uv16() + uv17(999, uv18(0, uv19(slot8[1]) or uv20)) < uv16() then
				break
			end

			uv21()
		end

		slot7 = true
	end

	return slot6
end

slot115 = {}

function slot116(slot0, slot1)
	slot3 = {
		[slot11] = true
	}
	slot4 = uv0[slot0].fields or {}
	slot5 = slot2.fields_alt or {}
	slot6 = {}

	for slot10, slot11 in uv1(slot2.string_fields or {}) do
		-- Nothing
	end

	slot7 = "struct {"

	for slot11, slot12 in uv1(slot4) do
		slot13, slot14 = uv2(slot2.types[slot11], "^(.*)(%[.*%])$")
		slot7 = slot13 ~= nil and slot7 .. slot13 .. " " .. slot12 .. slot14 .. "; " or slot7 .. slot13 .. " " .. slot12 .. slot14 .. "; " .. slot2.types[slot11] .. " " .. slot12 .. "; "
		slot6[slot12] = slot5[slot11] or true
	end

	slot8 = uv3(slot7 .. "} *")

	return function (slot0, slot1)
		if slot0 ~= nil then
			slot0 = uv0(uv1, slot0)
		end

		if slot1 ~= false then
			uv2(slot0, uv3, uv4).io_failure = slot1
		end

		for slot6, slot7 in uv5(uv6) do
			uv7(slot7, uv8, slot2)
		end
	end
end

function slot61.set_callback(slot0, slot1)
	if uv0(slot0) == "string" and uv1[uv2(uv3(slot0, "_t$", ""))] ~= nil then
		slot0 = uv1[uv2(uv3(slot0, "_t$", ""))]
	end

	if uv4[slot0] == nil then
		return uv5("Invalid Steam callback")
	end

	if uv6[slot0] == nil then
		uv7(uv8[slot0] == nil)

		uv6[slot0] = {}
		slot2 = uv9()
		slot3 = uv10(uv11, slot2)
		slot3.vtbl_storage[0].run1 = uv12
		slot3.vtbl_storage[0].run2 = uv13
		slot3.vtbl_storage[0].get_size = uv14
		slot3.vtbl = slot3.vtbl_storage
		slot3.api_call_handle = 0
		slot3.id = slot0
		uv16[uv15(slot3)] = uv17(slot0, uv6[slot0])
		uv8[slot0] = slot2

		uv18(slot3, slot0)
	else
		for slot5, slot6 in uv19(uv6[slot0]) do
			if slot6 == slot1 then
				return false
			end
		end
	end

	uv20(uv6[slot0], slot1)

	return true
end

function slot61.unset_callback(slot0, slot1)
	if uv0(slot0) == "string" and uv1[uv2(uv3(slot0, "_t$", ""))] ~= nil then
		slot0 = uv1[uv2(uv3(slot0, "_t$", ""))]
	end

	if uv4[slot0] == nil then
		return uv5("Invalid Steam callback")
	end

	if uv6[slot0] == nil then
		return false
	end

	for slot5, slot6 in uv7(uv6[slot0]) do
		if slot6 == slot1 then
			uv8(uv6[slot0], slot5)

			break
		end
	end

	if #uv6[slot0] == 0 then
		slot3 = uv10(uv11, uv9[slot0])

		uv12(slot3)

		uv6[slot0] = nil
		uv9[slot0] = nil
		uv14[uv13(slot3)] = nil
	end

	return true
end

function slot61.await_callback(slot0, slot1, slot2)
	if uv0(slot0) == "string" and uv1[uv2(uv3(slot0, "_t$", ""))] ~= nil then
		slot0 = uv1[uv2(uv3(slot0, "_t$", ""))]
	end

	if uv4[slot0] == nil then
		return uv5("Invalid Steam callback")
	end

	slot3 = false

	if slot2 ~= nil then
		slot3 = uv6(slot0, slot2)
	end

	if slot3 then
		uv7(slot0, slot2)
	end
end

function slot119(slot0)
	return function (slot0, ...)
		if uv0[uv1(slot0)] ~= nil then
			uv2(slot1, uv3, slot0, ...)
		end
	end
end

function slot120(slot0, slot1)
	return uv0(slot0) or uv1(slot1, 3)
end

function slot121(slot0, slot1)
	if (uv0(slot0) == "number" or slot2 == "string") and slot1[slot0] ~= nil then
		return slot2 == "string" and slot3 or slot0
	end
end

function slot122(slot0, slot1, slot2)
	return uv0(slot0, slot1) or uv1(slot2, 3)
end

function slot125(slot0, slot1)
	if uv0(slot0) == "number" then
		return slot0
	elseif slot2 == "string" then
		return uv1(slot0) or uv2(slot1, 3)
	end

	uv2(slot1, 3)
end

slot61.SteamID = slot66
slot61.CSteamID = slot66

function slot61.ipv4_parse(slot0)
	slot1, slot2, slot3, slot4 = uv0(slot0, "^(%d+)%.(%d+)%.(%d+)%.(%d+)$")

	if slot1 ~= nil then
		return uv3(uv4, uv1(4, uv2(slot4), uv2(slot3), uv2(slot2), uv2(slot1)))[0]
	end
end

function slot61.ipv4_tostring(slot0)
	slot2 = uv1(uv2, uv0(1, slot0))

	return uv3("%d.%d.%d.%d", slot2[3], slot2[2], slot2[1], slot2[0])
end

slot126 = slot4("FriendGameInfo_t [1]")
slot127 = slot4("SteamID [1]")
slot128 = slot4("bool [1]")
slot129 = slot4("double [1]")
slot130 = slot4("float [1]")
slot131 = slot4("int32_t [1]")
slot132 = slot4("int64_t [1]")
slot133 = slot4("int [1]")
slot134 = slot4("uint16_t [1]")
slot135 = slot4("uint32_t [1]")
slot136 = slot4("uint64_t [1]")
slot137 = slot4("unsigned int [1]")
slot138 = slot2("char*", slot29("client.dll", "\\xff\\xcc\\xcc\\xcc̋\\xd8\\xff") or slot26("Invalid SteamAPI_GetHSteamUser signature"))
slot141 = slot2("int(__cdecl***)()", slot138 + 10)[0][0]()
slot142 = slot2("int(__cdecl***)()", slot138 + 2)[0][0]()
slot143 = {
	version_number = 21,
	version = "SteamUser021"
}

function slot62.ISteamUser()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 5, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "SteamUser021")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "int(__thiscall*)(void*)")

	function uv2.GetHSteamUser()
		return uv0(uv1)
	end

	uv2.get_hsteamuser = uv2.GetHSteamUser
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*)")

	function uv2.BLoggedOn()
		return uv0(uv1)
	end

	uv2.logged_on = uv2.BLoggedOn
	slot3 = uv3(slot0, 2, "void(__thiscall*)(void*, SteamID *)")

	function uv2.GetSteamID()
		slot0 = uv0()

		uv1(uv2, slot0)

		return uv3(slot0)
	end

	uv2.get_steamid = uv2.GetSteamID
	slot4 = uv3(slot0, 3, "int(__thiscall*)(void*, void *, int, SteamID, uint32_t, uint16_t, bool)")

	function uv2.InitiateGameConnection_DEPRECATED(slot0, slot1, slot2, slot3, slot4, slot5)
		return uv2(uv3, slot0, slot1, uv0(slot2, "steamid_game_server is required"), uv1(slot3, "ip_server is required"), slot4, slot5)
	end

	uv2.initiate_game_connection_deprecated = uv2.InitiateGameConnection_DEPRECATED
	slot5 = uv3(slot0, 4, "void(__thiscall*)(void*, uint32_t, uint16_t)")

	function uv2.TerminateGameConnection_DEPRECATED(slot0, slot1)
		return uv1(uv2, uv0(slot0, "ip_server is required"), slot1)
	end

	uv2.terminate_game_connection_deprecated = uv2.TerminateGameConnection_DEPRECATED
	slot6 = uv3(slot0, 5, "void(__thiscall*)(void*, uint64_t, int, const char *)")

	function uv2.TrackAppUsageEvent(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.track_app_usage_event = uv2.TrackAppUsageEvent
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, char *, int)")

	function uv2.GetUserDataFolder(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_user_data_folder = uv2.GetUserDataFolder
	slot8 = uv3(slot0, 7, "void(__thiscall*)(void*)")

	function uv2.StartVoiceRecording()
		return uv0(uv1)
	end

	uv2.start_voice_recording = uv2.StartVoiceRecording
	slot9 = uv3(slot0, 8, "void(__thiscall*)(void*)")

	function uv2.StopVoiceRecording()
		return uv0(uv1)
	end

	uv2.stop_voice_recording = uv2.StopVoiceRecording
	slot10 = uv3(slot0, 9, "int(__thiscall*)(void*, uint32_t *, uint32_t *, uint32_t)")

	function uv2.GetAvailableVoice(slot0, slot1)
		slot2 = uv0()

		return uv1(uv2, slot2, slot0, slot1), uv3(slot2)
	end

	uv2.get_available_voice = uv2.GetAvailableVoice
	slot11 = uv3(slot0, 10, "int(__thiscall*)(void*, bool, void *, uint32_t, uint32_t *, bool, void *, uint32_t, uint32_t *, uint32_t)")

	function uv2.GetVoice(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		slot8 = uv0()

		return uv1(uv2, slot0, slot1, slot2, slot8, slot3, slot4, slot5, slot6, slot7), uv3(slot8)
	end

	uv2.get_voice = uv2.GetVoice
	slot12 = uv3(slot0, 11, "int(__thiscall*)(void*, const void *, uint32_t, void *, uint32_t, uint32_t *, uint32_t)")

	function uv2.DecompressVoice(slot0, slot1, slot2, slot3, slot4)
		slot5 = uv0()

		return uv1(uv2, slot0, slot1, slot2, slot3, slot5, slot4), uv3(slot5)
	end

	uv2.decompress_voice = uv2.DecompressVoice
	slot13 = uv3(slot0, 12, "uint32_t(__thiscall*)(void*)")

	function uv2.GetVoiceOptimalSampleRate()
		return uv0(uv1)
	end

	uv2.get_voice_optimal_sample_rate = uv2.GetVoiceOptimalSampleRate
	slot14 = uv3(slot0, 13, "unsigned int(__thiscall*)(void*, void *, int, uint32_t *)")

	function uv2.GetAuthSessionTicket(slot0, slot1)
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot2)
	end

	uv2.get_auth_session_ticket = uv2.GetAuthSessionTicket
	slot15 = uv3(slot0, 14, "int(__thiscall*)(void*, const void *, int, SteamID)")

	function uv2.BeginAuthSession(slot0, slot1, slot2)
		return uv1(uv2, slot0, slot1, uv0(slot2, "steamid is required"))
	end

	uv2.begin_auth_session = uv2.BeginAuthSession
	slot16 = uv3(slot0, 15, "void(__thiscall*)(void*, SteamID)")

	function uv2.EndAuthSession(slot0)
		return uv1(uv2, uv0(slot0, "steamid is required"))
	end

	uv2.end_auth_session = uv2.EndAuthSession
	slot17 = uv3(slot0, 16, "void(__thiscall*)(void*, unsigned int)")

	function uv2.CancelAuthTicket(slot0)
		return uv0(uv1, slot0)
	end

	uv2.cancel_auth_ticket = uv2.CancelAuthTicket
	slot18 = uv3(slot0, 17, "int(__thiscall*)(void*, SteamID, unsigned int)")

	function uv2.UserHasLicenseForApp(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid is required"), slot1)
	end

	uv2.user_has_license_for_app = uv2.UserHasLicenseForApp
	slot19 = uv3(slot0, 18, "bool(__thiscall*)(void*)")

	function uv2.BIsBehindNAT()
		return uv0(uv1)
	end

	uv2.is_behind_nat = uv2.BIsBehindNAT
	slot20 = uv3(slot0, 19, "void(__thiscall*)(void*, SteamID, uint32_t, uint16_t)")

	function uv2.AdvertiseGame(slot0, slot1, slot2)
		return uv2(uv3, uv0(slot0, "steamid_game_server is required"), uv1(slot1, "ip_server is required"), slot2)
	end

	uv2.advertise_game = uv2.AdvertiseGame
	slot21 = uv3(slot0, 20, "uint64_t(__thiscall*)(void*, void *, int)")
	slot22 = {
		struct = uv9([[
			struct {
				int m_eResult;
			} *
		]]),
		keys = {
			m_eResult = "result"
		}
	}

	function uv2.RequestEncryptedAppTicket(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 154, uv5)
		end

		return slot3
	end

	uv2.request_encrypted_app_ticket = uv2.RequestEncryptedAppTicket
	slot23 = uv3(slot0, 21, "bool(__thiscall*)(void*, void *, int, uint32_t *)")

	function uv2.GetEncryptedAppTicket(slot0, slot1)
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot2)
	end

	uv2.get_encrypted_app_ticket = uv2.GetEncryptedAppTicket
	slot24 = uv3(slot0, 22, "int(__thiscall*)(void*, int, bool)")

	function uv2.GetGameBadgeLevel(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_game_badge_level = uv2.GetGameBadgeLevel
	slot25 = uv3(slot0, 23, "int(__thiscall*)(void*)")

	function uv2.GetPlayerSteamLevel()
		return uv0(uv1)
	end

	uv2.get_player_steam_level = uv2.GetPlayerSteamLevel
	slot26 = uv3(slot0, 24, "uint64_t(__thiscall*)(void*, const char *)")
	slot27 = {
		struct = uv9([[
			struct {
				char m_szURL[512];
			} *
		]]),
		keys = {
			m_szURL = "url"
		}
	}

	function uv2.RequestStoreAuthURL(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 165, uv5)
		end

		return slot2
	end

	uv2.request_store_auth_url = uv2.RequestStoreAuthURL
	slot28 = uv3(slot0, 25, "bool(__thiscall*)(void*)")

	function uv2.BIsPhoneVerified()
		return uv0(uv1)
	end

	uv2.is_phone_verified = uv2.BIsPhoneVerified
	slot29 = uv3(slot0, 26, "bool(__thiscall*)(void*)")

	function uv2.BIsTwoFactorEnabled()
		return uv0(uv1)
	end

	uv2.is_two_factor_enabled = uv2.BIsTwoFactorEnabled
	slot30 = uv3(slot0, 27, "bool(__thiscall*)(void*)")

	function uv2.BIsPhoneIdentifying()
		return uv0(uv1)
	end

	uv2.is_phone_identifying = uv2.BIsPhoneIdentifying
	slot31 = uv3(slot0, 28, "bool(__thiscall*)(void*)")

	function uv2.BIsPhoneRequiringVerification()
		return uv0(uv1)
	end

	uv2.is_phone_requiring_verification = uv2.BIsPhoneRequiringVerification
	slot32 = uv3(slot0, 29, "uint64_t(__thiscall*)(void*)")
	slot33 = {
		struct = uv9([[
			struct {
				bool m_bAllowed;
				int m_eNotAllowedReason;
				unsigned int m_rtAllowedAtTime;
				int m_cdaySteamGuardRequiredDays;
				int m_cdayNewDeviceCooldown;
			} *
		]]),
		keys = {
			m_cdayNewDeviceCooldown = "new_device_cooldown",
			m_cdaySteamGuardRequiredDays = "steam_guard_required_days",
			m_rtAllowedAtTime = "allowed_at_time",
			m_eNotAllowedReason = "not_allowed_reason",
			m_bAllowed = "allowed"
		}
	}

	function uv2.GetMarketEligibility(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 166, uv5)
		end

		return slot1
	end

	uv2.get_market_eligibility = uv2.GetMarketEligibility
	slot34 = uv3(slot0, 30, "uint64_t(__thiscall*)(void*)")
	slot35 = {
		struct = uv9([[
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
		keys = {
			m_appid = "appid",
			m_notification = "notification",
			m_eResult = "result",
			m_progress = "progress",
			m_csecsToday = "today",
			m_csecsLast5h = "last5h",
			m_csecsRemaining = "remaining",
			m_bApplicable = "applicable"
		}
	}

	function uv2.GetDurationControl(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 167, uv5)
		end

		return slot1
	end

	uv2.get_duration_control = uv2.GetDurationControl
	slot36 = uv3(slot0, 31, "bool(__thiscall*)(void*, int)")

	function uv2.BSetDurationControlOnlineState(slot0)
		return uv2(uv3, uv0(slot0, uv1.EDurationControlOnlineState, "new_state is required"))
	end

	uv2.set_duration_control_online_state = uv2.BSetDurationControlOnlineState

	return uv2
end

slot144 = {
	version_number = 17,
	version = "SteamFriends017"
}

function slot62.ISteamFriends()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 8, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "SteamFriends017")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "const char *(__thiscall*)(void*)")

	function uv2.GetPersonaName()
		return uv0(uv1) ~= nil and uv2(slot0) or nil
	end

	uv2.get_persona_name = uv2.GetPersonaName
	slot2 = uv3(slot0, 1, "uint64_t(__thiscall*)(void*, const char *)")
	slot3 = {
		struct = uv5([[
			struct {
				bool m_bSuccess;
				bool m_bLocalSuccess;
				int m_result;
			} *
		]]),
		keys = {
			m_result = "result",
			m_bSuccess = "success",
			m_bLocalSuccess = "local_success"
		}
	}

	function uv2.SetPersonaName(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 347, uv5)
		end

		return slot2
	end

	uv2.set_persona_name = uv2.SetPersonaName
	slot4 = uv3(slot0, 2, "int(__thiscall*)(void*)")

	function uv2.GetPersonaState()
		return uv0(uv1)
	end

	uv2.get_persona_state = uv2.GetPersonaState
	slot5 = uv3(slot0, 3, "int(__thiscall*)(void*, int)")

	function uv2.GetFriendCount(slot0)
		return uv2(uv3, uv0(slot0, uv1.EFriendFlags, "friend_flags is required"))
	end

	uv2.get_friend_count = uv2.GetFriendCount
	slot6 = uv3(slot0, 4, "void(__thiscall*)(void*, SteamID *, int, int)")

	function uv2.GetFriendByIndex(slot0, slot1)
		slot2 = uv2()

		uv3(uv4, slot2, slot0, uv0(slot1, uv1.EFriendFlags, "friend_flags is required"))

		return uv5(slot2)
	end

	uv2.get_friend_by_index = uv2.GetFriendByIndex
	slot7 = uv3(slot0, 5, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendRelationship(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_friend_relationship = uv2.GetFriendRelationship
	slot8 = uv3(slot0, 6, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendPersonaState(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_friend_persona_state = uv2.GetFriendPersonaState
	slot9 = uv3(slot0, 7, "const char *(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendPersonaName(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required")) ~= nil and uv3(slot1) or nil
	end

	uv2.get_friend_persona_name = uv2.GetFriendPersonaName
	slot10 = uv3(slot0, 8, "bool(__thiscall*)(void*, SteamID, FriendGameInfo_t *)")

	function uv2.GetFriendGamePlayed(slot0)
		slot1 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_friend is required"), slot1), uv4(slot1)
	end

	uv2.get_friend_game_played = uv2.GetFriendGamePlayed
	slot11 = uv3(slot0, 9, "const char *(__thiscall*)(void*, SteamID, int)")

	function uv2.GetFriendPersonaNameHistory(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"), slot1) ~= nil and uv3(slot2) or nil
	end

	uv2.get_friend_persona_name_history = uv2.GetFriendPersonaNameHistory
	slot12 = uv3(slot0, 10, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendSteamLevel(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_friend_steam_level = uv2.GetFriendSteamLevel
	slot13 = uv3(slot0, 11, "const char *(__thiscall*)(void*, SteamID)")

	function uv2.GetPlayerNickname(slot0)
		return uv1(uv2, uv0(slot0, "steamid_player is required")) ~= nil and uv3(slot1) or nil
	end

	uv2.get_player_nickname = uv2.GetPlayerNickname
	slot14 = uv3(slot0, 12, "int(__thiscall*)(void*)")

	function uv2.GetFriendsGroupCount()
		return uv0(uv1)
	end

	uv2.get_friends_group_count = uv2.GetFriendsGroupCount
	slot15 = uv3(slot0, 13, "short(__thiscall*)(void*, int)")

	function uv2.GetFriendsGroupIDByIndex(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_friends_group_id_by_index = uv2.GetFriendsGroupIDByIndex
	slot16 = uv3(slot0, 14, "const char *(__thiscall*)(void*, short)")

	function uv2.GetFriendsGroupName(slot0)
		return uv0(uv1, slot0) ~= nil and uv2(slot1) or nil
	end

	uv2.get_friends_group_name = uv2.GetFriendsGroupName
	slot17 = uv3(slot0, 15, "int(__thiscall*)(void*, short)")

	function uv2.GetFriendsGroupMembersCount(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_friends_group_members_count = uv2.GetFriendsGroupMembersCount
	slot18 = uv3(slot0, 16, "void(__thiscall*)(void*, short, SteamID *, int)")

	function uv2.GetFriendsGroupMembersList(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_friends_group_members_list = uv2.GetFriendsGroupMembersList
	slot19 = uv3(slot0, 17, "bool(__thiscall*)(void*, SteamID, int)")

	function uv2.HasFriend(slot0, slot1)
		return uv3(uv4, uv0(slot0, "steamid_friend is required"), uv1(slot1, uv2.EFriendFlags, "friend_flags is required"))
	end

	uv2.has_friend = uv2.HasFriend
	slot20 = uv3(slot0, 18, "int(__thiscall*)(void*)")

	function uv2.GetClanCount()
		return uv0(uv1)
	end

	uv2.get_clan_count = uv2.GetClanCount
	slot21 = uv3(slot0, 19, "void(__thiscall*)(void*, SteamID *, int)")

	function uv2.GetClanByIndex(slot0)
		slot1 = uv0()

		uv1(uv2, slot1, slot0)

		return uv3(slot1)
	end

	uv2.get_clan_by_index = uv2.GetClanByIndex
	slot22 = uv3(slot0, 20, "const char *(__thiscall*)(void*, SteamID)")

	function uv2.GetClanName(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan is required")) ~= nil and uv3(slot1) or nil
	end

	uv2.get_clan_name = uv2.GetClanName
	slot23 = uv3(slot0, 21, "const char *(__thiscall*)(void*, SteamID)")

	function uv2.GetClanTag(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan is required")) ~= nil and uv3(slot1) or nil
	end

	uv2.get_clan_tag = uv2.GetClanTag
	slot24 = uv3(slot0, 22, "bool(__thiscall*)(void*, SteamID, int *, int *, int *)")

	function uv2.GetClanActivityCounts(slot0)
		slot1 = uv1()
		slot2 = uv1()
		slot3 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_clan is required"), slot1, slot2, slot3), uv4(slot1), uv4(slot2), uv4(slot3)
	end

	uv2.get_clan_activity_counts = uv2.GetClanActivityCounts
	slot25 = uv3(slot0, 23, "uint64_t(__thiscall*)(void*, SteamID *, int)")
	slot26 = {
		struct = uv5([[
			struct {
				bool m_bSuccess;
			} *
		]]),
		keys = {
			m_bSuccess = "success"
		}
	}

	function uv2.DownloadClanActivityCounts(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 341, uv5)
		end

		return slot3
	end

	uv2.download_clan_activity_counts = uv2.DownloadClanActivityCounts
	slot27 = uv3(slot0, 24, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendCountFromSource(slot0)
		return uv1(uv2, uv0(slot0, "steamid_source is required"))
	end

	uv2.get_friend_count_from_source = uv2.GetFriendCountFromSource
	slot28 = uv3(slot0, 25, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function uv2.GetFriendFromSourceByIndex(slot0, slot1)
		slot2 = uv1()

		uv2(uv3, slot2, uv0(slot0, "steamid_source is required"), slot1)

		return uv4(slot2)
	end

	uv2.get_friend_from_source_by_index = uv2.GetFriendFromSourceByIndex
	slot29 = uv3(slot0, 26, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function uv2.IsUserInSource(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), uv0(slot1, "steamid_source is required"))
	end

	uv2.is_user_in_source = uv2.IsUserInSource
	slot30 = uv3(slot0, 27, "void(__thiscall*)(void*, SteamID, bool)")

	function uv2.SetInGameVoiceSpeaking(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), slot1)
	end

	uv2.set_in_game_voice_speaking = uv2.SetInGameVoiceSpeaking
	slot31 = uv3(slot0, 28, "void(__thiscall*)(void*, const char *)")

	function uv2.ActivateGameOverlay(slot0)
		return uv0(uv1, slot0)
	end

	uv2.activate_game_overlay = uv2.ActivateGameOverlay
	slot32 = uv3(slot0, 29, "void(__thiscall*)(void*, const char *, SteamID)")

	function uv2.ActivateGameOverlayToUser(slot0, slot1)
		return uv1(uv2, slot0, uv0(slot1, "steamid is required"))
	end

	uv2.activate_game_overlay_to_user = uv2.ActivateGameOverlayToUser
	slot33 = uv3(slot0, 30, "void(__thiscall*)(void*, const char *, int)")

	function uv2.ActivateGameOverlayToWebPage(slot0, slot1)
		return uv2(uv3, slot0, uv0(slot1, uv1.EActivateGameOverlayToWebPageMode, "mode is required"))
	end

	uv2.activate_game_overlay_to_web_page = uv2.ActivateGameOverlayToWebPage
	slot34 = uv3(slot0, 31, "void(__thiscall*)(void*, unsigned int, int)")

	function uv2.ActivateGameOverlayToStore(slot0, slot1)
		return uv2(uv3, slot0, uv0(slot1, uv1.EOverlayToStoreFlag, "flag is required"))
	end

	uv2.activate_game_overlay_to_store = uv2.ActivateGameOverlayToStore
	slot35 = uv3(slot0, 32, "void(__thiscall*)(void*, SteamID)")

	function uv2.SetPlayedWith(slot0)
		return uv1(uv2, uv0(slot0, "steamid_user_played_with is required"))
	end

	uv2.set_played_with = uv2.SetPlayedWith
	slot36 = uv3(slot0, 33, "void(__thiscall*)(void*, SteamID)")

	function uv2.ActivateGameOverlayInviteDialog(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.activate_game_overlay_invite_dialog = uv2.ActivateGameOverlayInviteDialog
	slot37 = uv3(slot0, 34, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetSmallFriendAvatar(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_small_friend_avatar = uv2.GetSmallFriendAvatar
	slot38 = uv3(slot0, 35, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetMediumFriendAvatar(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_medium_friend_avatar = uv2.GetMediumFriendAvatar
	slot39 = uv3(slot0, 36, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetLargeFriendAvatar(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_large_friend_avatar = uv2.GetLargeFriendAvatar
	slot40 = uv3(slot0, 37, "bool(__thiscall*)(void*, SteamID, bool)")

	function uv2.RequestUserInformation(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), slot1)
	end

	uv2.request_user_information = uv2.RequestUserInformation
	slot41 = uv3(slot0, 38, "uint64_t(__thiscall*)(void*, SteamID)")
	slot42 = {
		struct = uv5([[
			struct {
				SteamID m_steamIDClan;
				int m_cOfficers;
				bool m_bSuccess;
			} *
		]]),
		keys = {
			m_bSuccess = "success",
			m_cOfficers = "officers",
			m_steamIDClan = "steamid_clan"
		}
	}

	function uv2.RequestClanOfficerList(slot0, slot1)
		slot0 = uv0(slot0, "steamid_clan is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 335, uv6)
		end

		return slot2
	end

	uv2.request_clan_officer_list = uv2.RequestClanOfficerList
	slot43 = uv3(slot0, 39, "void(__thiscall*)(void*, SteamID *, SteamID)")

	function uv2.GetClanOwner(slot0)
		slot1 = uv1()

		uv2(uv3, slot1, uv0(slot0, "steamid_clan is required"))

		return uv4(slot1)
	end

	uv2.get_clan_owner = uv2.GetClanOwner
	slot44 = uv3(slot0, 40, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetClanOfficerCount(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan is required"))
	end

	uv2.get_clan_officer_count = uv2.GetClanOfficerCount
	slot45 = uv3(slot0, 41, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function uv2.GetClanOfficerByIndex(slot0, slot1)
		slot2 = uv1()

		uv2(uv3, slot2, uv0(slot0, "steamid_clan is required"), slot1)

		return uv4(slot2)
	end

	uv2.get_clan_officer_by_index = uv2.GetClanOfficerByIndex
	slot46 = uv3(slot0, 42, "uint32_t(__thiscall*)(void*)")

	function uv2.GetUserRestrictions()
		return uv0(uv1)
	end

	uv2.get_user_restrictions = uv2.GetUserRestrictions
	slot47 = uv3(slot0, 43, "bool(__thiscall*)(void*, const char *, const char *)")

	function uv2.SetRichPresence(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_rich_presence = uv2.SetRichPresence
	slot48 = uv3(slot0, 44, "void(__thiscall*)(void*)")

	function uv2.ClearRichPresence()
		return uv0(uv1)
	end

	uv2.clear_rich_presence = uv2.ClearRichPresence
	slot49 = uv3(slot0, 45, "const char *(__thiscall*)(void*, SteamID, const char *)")

	function uv2.GetFriendRichPresence(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"), slot1) ~= nil and uv3(slot2) or nil
	end

	uv2.get_friend_rich_presence = uv2.GetFriendRichPresence
	slot50 = uv3(slot0, 46, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendRichPresenceKeyCount(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_friend_rich_presence_key_count = uv2.GetFriendRichPresenceKeyCount
	slot51 = uv3(slot0, 47, "const char *(__thiscall*)(void*, SteamID, int)")

	function uv2.GetFriendRichPresenceKeyByIndex(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"), slot1) ~= nil and uv3(slot2) or nil
	end

	uv2.get_friend_rich_presence_key_by_index = uv2.GetFriendRichPresenceKeyByIndex
	slot52 = uv3(slot0, 48, "void(__thiscall*)(void*, SteamID)")

	function uv2.RequestFriendRichPresence(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.request_friend_rich_presence = uv2.RequestFriendRichPresence
	slot53 = uv3(slot0, 49, "bool(__thiscall*)(void*, SteamID, const char *)")

	function uv2.InviteUserToGame(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"), slot1)
	end

	uv2.invite_user_to_game = uv2.InviteUserToGame
	slot54 = uv3(slot0, 50, "int(__thiscall*)(void*)")

	function uv2.GetCoplayFriendCount()
		return uv0(uv1)
	end

	uv2.get_coplay_friend_count = uv2.GetCoplayFriendCount
	slot55 = uv3(slot0, 51, "void(__thiscall*)(void*, SteamID *, int)")

	function uv2.GetCoplayFriend(slot0)
		slot1 = uv0()

		uv1(uv2, slot1, slot0)

		return uv3(slot1)
	end

	uv2.get_coplay_friend = uv2.GetCoplayFriend
	slot56 = uv3(slot0, 52, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendCoplayTime(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_friend_coplay_time = uv2.GetFriendCoplayTime
	slot57 = uv3(slot0, 53, "unsigned int(__thiscall*)(void*, SteamID)")

	function uv2.GetFriendCoplayGame(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.get_friend_coplay_game = uv2.GetFriendCoplayGame
	slot58 = uv3(slot0, 54, "uint64_t(__thiscall*)(void*, SteamID)")
	slot59 = {
		struct = uv5([[
			struct {
				SteamID m_steamIDClanChat;
				int m_eChatRoomEnterResponse;
			} *
		]]),
		keys = {
			m_steamIDClanChat = "steamid_clan_chat",
			m_eChatRoomEnterResponse = "chat_room_enter_response"
		}
	}

	function uv2.JoinClanChatRoom(slot0, slot1)
		slot0 = uv0(slot0, "steamid_clan is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 342, uv6)
		end

		return slot2
	end

	uv2.join_clan_chat_room = uv2.JoinClanChatRoom
	slot60 = uv3(slot0, 55, "bool(__thiscall*)(void*, SteamID)")

	function uv2.LeaveClanChatRoom(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan is required"))
	end

	uv2.leave_clan_chat_room = uv2.LeaveClanChatRoom
	slot61 = uv3(slot0, 56, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetClanChatMemberCount(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan is required"))
	end

	uv2.get_clan_chat_member_count = uv2.GetClanChatMemberCount
	slot62 = uv3(slot0, 57, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function uv2.GetChatMemberByIndex(slot0, slot1)
		slot2 = uv1()

		uv2(uv3, slot2, uv0(slot0, "steamid_clan is required"), slot1)

		return uv4(slot2)
	end

	uv2.get_chat_member_by_index = uv2.GetChatMemberByIndex
	slot63 = uv3(slot0, 58, "bool(__thiscall*)(void*, SteamID, const char *)")

	function uv2.SendClanChatMessage(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_clan_chat is required"), slot1)
	end

	uv2.send_clan_chat_message = uv2.SendClanChatMessage
	slot64 = uv3(slot0, 59, "int(__thiscall*)(void*, SteamID, int, void *, int, int *, SteamID *)")

	function uv2.GetClanChatMessage(slot0, slot1, slot2, slot3)
		slot4 = uv1()
		slot5 = uv2()

		return uv3(uv4, uv0(slot0, "steamid_clan_chat is required"), slot1, slot2, slot3, slot4, slot5), uv5(slot4), uv5(slot5)
	end

	uv2.get_clan_chat_message = uv2.GetClanChatMessage
	slot65 = uv3(slot0, 60, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function uv2.IsClanChatAdmin(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_clan_chat is required"), uv0(slot1, "steamid_user is required"))
	end

	uv2.is_clan_chat_admin = uv2.IsClanChatAdmin
	slot66 = uv3(slot0, 61, "bool(__thiscall*)(void*, SteamID)")

	function uv2.IsClanChatWindowOpenInSteam(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan_chat is required"))
	end

	uv2.is_clan_chat_window_open_in_steam = uv2.IsClanChatWindowOpenInSteam
	slot67 = uv3(slot0, 62, "bool(__thiscall*)(void*, SteamID)")

	function uv2.OpenClanChatWindowInSteam(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan_chat is required"))
	end

	uv2.open_clan_chat_window_in_steam = uv2.OpenClanChatWindowInSteam
	slot68 = uv3(slot0, 63, "bool(__thiscall*)(void*, SteamID)")

	function uv2.CloseClanChatWindowInSteam(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan_chat is required"))
	end

	uv2.close_clan_chat_window_in_steam = uv2.CloseClanChatWindowInSteam
	slot69 = uv3(slot0, 64, "bool(__thiscall*)(void*, bool)")

	function uv2.SetListenForFriendsMessages(slot0)
		return uv0(uv1, slot0)
	end

	uv2.set_listen_for_friends_messages = uv2.SetListenForFriendsMessages
	slot70 = uv3(slot0, 65, "bool(__thiscall*)(void*, SteamID, const char *)")

	function uv2.ReplyToFriendMessage(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"), slot1)
	end

	uv2.reply_to_friend_message = uv2.ReplyToFriendMessage
	slot71 = uv3(slot0, 66, "int(__thiscall*)(void*, SteamID, int, void *, int, int *)")

	function uv2.GetFriendMessage(slot0, slot1, slot2, slot3)
		slot4 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_friend is required"), slot1, slot2, slot3, slot4), uv4(slot4)
	end

	uv2.get_friend_message = uv2.GetFriendMessage
	slot72 = uv3(slot0, 67, "uint64_t(__thiscall*)(void*, SteamID)")
	slot73 = {
		struct = uv5([[
			struct {
				int m_eResult;
				SteamID m_steamID;
				int m_nCount;
			} *
		]]),
		keys = {
			m_steamID = "steamid",
			m_eResult = "result",
			m_nCount = "count"
		}
	}

	function uv2.GetFollowerCount(slot0, slot1)
		slot0 = uv0(slot0, "steamid is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 344, uv6)
		end

		return slot2
	end

	uv2.get_follower_count = uv2.GetFollowerCount
	slot74 = uv3(slot0, 68, "uint64_t(__thiscall*)(void*, SteamID)")
	slot75 = {
		struct = uv5([[
			struct {
				int m_eResult;
				SteamID m_steamID;
				bool m_bIsFollowing;
			} *
		]]),
		keys = {
			m_steamID = "steamid",
			m_eResult = "result",
			m_bIsFollowing = "is_following"
		}
	}

	function uv2.IsFollowing(slot0, slot1)
		slot0 = uv0(slot0, "steamid is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 345, uv6)
		end

		return slot2
	end

	uv2.is_following = uv2.IsFollowing
	slot76 = uv3(slot0, 69, "uint64_t(__thiscall*)(void*, uint32_t)")
	slot77 = {
		struct = uv5([[
			struct {
				int m_eResult;
				SteamID m_rgSteamID[50];
				int32_t m_nResultsReturned;
				int32_t m_nTotalResultCount;
			} *
		]]),
		keys = {
			m_rgSteamID = "steamid",
			m_nResultsReturned = "results_returned",
			m_eResult = "result",
			m_nTotalResultCount = "total_result_count"
		}
	}

	function uv2.EnumerateFollowingList(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 346, uv5)
		end

		return slot2
	end

	uv2.enumerate_following_list = uv2.EnumerateFollowingList
	slot78 = uv3(slot0, 70, "bool(__thiscall*)(void*, SteamID)")

	function uv2.IsClanPublic(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan is required"))
	end

	uv2.is_clan_public = uv2.IsClanPublic
	slot79 = uv3(slot0, 71, "bool(__thiscall*)(void*, SteamID)")

	function uv2.IsClanOfficialGameGroup(slot0)
		return uv1(uv2, uv0(slot0, "steamid_clan is required"))
	end

	uv2.is_clan_official_game_group = uv2.IsClanOfficialGameGroup
	slot80 = uv3(slot0, 72, "int(__thiscall*)(void*)")

	function uv2.GetNumChatsWithUnreadPriorityMessages()
		return uv0(uv1)
	end

	uv2.get_num_chats_with_unread_priority_messages = uv2.GetNumChatsWithUnreadPriorityMessages
	slot81 = uv3(slot0, 73, "void(__thiscall*)(void*, SteamID)")

	function uv2.ActivateGameOverlayRemotePlayTogetherInviteDialog(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.activate_game_overlay_remote_play_together_invite_dialog = uv2.ActivateGameOverlayRemotePlayTogetherInviteDialog
	slot82 = uv3(slot0, 74, "bool(__thiscall*)(void*, const char *)")

	function uv2.RegisterProtocolInOverlayBrowser(slot0)
		return uv0(uv1, slot0)
	end

	uv2.register_protocol_in_overlay_browser = uv2.RegisterProtocolInOverlayBrowser
	slot83 = uv3(slot0, 75, "void(__thiscall*)(void*, const char *)")

	function uv2.ActivateGameOverlayInviteDialogConnectString(slot0)
		return uv0(uv1, slot0)
	end

	uv2.activate_game_overlay_invite_dialog_connect_string = uv2.ActivateGameOverlayInviteDialogConnectString
	slot84 = uv3(slot0, 76, "uint64_t(__thiscall*)(void*, SteamID)")
	slot85 = {
		struct = uv5([[
			struct {
				int m_eResult;
				SteamID m_steamID;
				bool m_bHasAnimatedAvatar;
				bool m_bHasAvatarFrame;
				bool m_bHasProfileModifier;
				bool m_bHasProfileBackground;
				bool m_bHasMiniProfileBackground;
			} *
		]]),
		keys = {
			m_bHasAnimatedAvatar = "has_animated_avatar",
			m_bHasProfileModifier = "has_profile_modifier",
			m_eResult = "result",
			m_bHasProfileBackground = "has_profile_background",
			m_steamID = "steamid",
			m_bHasMiniProfileBackground = "has_mini_profile_background",
			m_bHasAvatarFrame = "has_avatar_frame"
		}
	}

	function uv2.RequestEquippedProfileItems(slot0, slot1)
		slot0 = uv0(slot0, "steamid is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 351, uv6)
		end

		return slot2
	end

	uv2.request_equipped_profile_items = uv2.RequestEquippedProfileItems
	slot86 = uv3(slot0, 77, "bool(__thiscall*)(void*, SteamID, int)")

	function uv2.BHasEquippedProfileItem(slot0, slot1)
		return uv3(uv4, uv0(slot0, "steamid is required"), uv1(slot1, uv2.ECommunityProfileItemType, "item_type is required"))
	end

	uv2.has_equipped_profile_item = uv2.BHasEquippedProfileItem
	slot87 = uv3(slot0, 78, "const char *(__thiscall*)(void*, SteamID, int, int)")

	function uv2.GetProfileItemPropertyString(slot0, slot1, slot2)
		return uv3(uv4, uv0(slot0, "steamid is required"), uv1(slot1, uv2.ECommunityProfileItemType, "item_type is required"), uv1(slot2, uv2.ECommunityProfileItemProperty, "prop is required")) ~= nil and uv5(slot3) or nil
	end

	uv2.get_profile_item_property_string = uv2.GetProfileItemPropertyString
	slot88 = uv3(slot0, 79, "uint32_t(__thiscall*)(void*, SteamID, int, int)")

	function uv2.GetProfileItemPropertyUint(slot0, slot1, slot2)
		return uv3(uv4, uv0(slot0, "steamid is required"), uv1(slot1, uv2.ECommunityProfileItemType, "item_type is required"), uv1(slot2, uv2.ECommunityProfileItemProperty, "prop is required"))
	end

	uv2.get_profile_item_property_uint = uv2.GetProfileItemPropertyUint

	return uv2
end

slot145 = {
	version_number = 10,
	version = "SteamUtils010"
}

function slot62.ISteamUtils()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 9, "void*(__thiscall*)(void*, int, const char *)")(uv0, "SteamUtils010")
	uv1.thisptr = slot0
	slot1 = uv2(slot0, 0, "uint32_t(__thiscall*)(void*)")

	function uv1.GetSecondsSinceAppActive()
		return uv0(uv1)
	end

	uv1.get_seconds_since_app_active = uv1.GetSecondsSinceAppActive
	slot2 = uv2(slot0, 1, "uint32_t(__thiscall*)(void*)")

	function uv1.GetSecondsSinceComputerActive()
		return uv0(uv1)
	end

	uv1.get_seconds_since_computer_active = uv1.GetSecondsSinceComputerActive
	slot3 = uv2(slot0, 2, "int(__thiscall*)(void*)")

	function uv1.GetConnectedUniverse()
		return uv0(uv1)
	end

	uv1.get_connected_universe = uv1.GetConnectedUniverse
	slot4 = uv2(slot0, 3, "uint32_t(__thiscall*)(void*)")

	function uv1.GetServerRealTime()
		return uv0(uv1)
	end

	uv1.get_server_real_time = uv1.GetServerRealTime
	slot5 = uv2(slot0, 4, "const char *(__thiscall*)(void*)")

	function uv1.GetIPCountry()
		return uv0(uv1) ~= nil and uv2(slot0) or nil
	end

	uv1.get_ip_country = uv1.GetIPCountry
	slot6 = uv2(slot0, 5, "bool(__thiscall*)(void*, int, uint32_t *, uint32_t *)")

	function uv1.GetImageSize(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv1.get_image_size = uv1.GetImageSize
	slot7 = uv2(slot0, 6, "bool(__thiscall*)(void*, int, uint8_t *, int)")

	function uv1.GetImageRGBA(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.get_image_rgba = uv1.GetImageRGBA
	slot8 = uv2(slot0, 8, "uint8_t(__thiscall*)(void*)")

	function uv1.GetCurrentBatteryPower()
		return uv0(uv1)
	end

	uv1.get_current_battery_power = uv1.GetCurrentBatteryPower
	slot9 = uv2(slot0, 9, "uint32_t(__thiscall*)(void*)")

	function uv1.GetAppID()
		return uv0(uv1)
	end

	uv1.get_appid = uv1.GetAppID
	slot10 = uv2(slot0, 10, "void(__thiscall*)(void*, int)")

	function uv1.SetOverlayNotificationPosition(slot0)
		return uv2(uv3, uv0(slot0, uv1.ENotificationPosition, "notification_position is required"))
	end

	uv1.set_overlay_notification_position = uv1.SetOverlayNotificationPosition
	slot11 = uv2(slot0, 11, "bool(__thiscall*)(void*, uint64_t, bool *)")

	function uv1.IsAPICallCompleted(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv1.is_api_call_completed = uv1.IsAPICallCompleted
	slot12 = uv2(slot0, 12, "int(__thiscall*)(void*, uint64_t)")

	function uv1.GetAPICallFailureReason(slot0)
		return uv0(uv1, slot0)
	end

	uv1.get_api_call_failure_reason = uv1.GetAPICallFailureReason
	slot13 = uv2(slot0, 13, "bool(__thiscall*)(void*, uint64_t, void *, int, int, bool *)")

	function uv1.GetAPICallResult(slot0, slot1, slot2, slot3)
		slot4 = uv0()

		return uv1(uv2, slot0, slot1, slot2, slot3, slot4), uv3(slot4)
	end

	uv1.get_api_call_result = uv1.GetAPICallResult
	slot14 = uv2(slot0, 15, "uint32_t(__thiscall*)(void*)")

	function uv1.GetIPCCallCount()
		return uv0(uv1)
	end

	uv1.get_ipc_call_count = uv1.GetIPCCallCount
	slot15 = uv2(slot0, 16, "void(__thiscall*)(void*, void*(__cdecl*)(int, const char*))")

	function uv1.SetWarningMessageHook(slot0)
		return uv0(uv1, slot0)
	end

	uv1.set_warning_message_hook = uv1.SetWarningMessageHook
	slot16 = uv2(slot0, 17, "bool(__thiscall*)(void*)")

	function uv1.IsOverlayEnabled()
		return uv0(uv1)
	end

	uv1.is_overlay_enabled = uv1.IsOverlayEnabled
	slot17 = uv2(slot0, 18, "bool(__thiscall*)(void*)")

	function uv1.BOverlayNeedsPresent()
		return uv0(uv1)
	end

	uv1.overlay_needs_present = uv1.BOverlayNeedsPresent
	slot18 = uv2(slot0, 19, "uint64_t(__thiscall*)(void*, const char *)")
	slot19 = {
		struct = uv9([[
			struct {
				int m_eCheckFileSignature;
			} *
		]]),
		keys = {
			m_eCheckFileSignature = "check_file_signature"
		}
	}

	function uv1.CheckFileSignature(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 705, uv5)
		end

		return slot2
	end

	uv1.check_file_signature = uv1.CheckFileSignature
	slot20 = uv2(slot0, 20, "bool(__thiscall*)(void*, int, int, const char *, uint32_t, const char *)")

	function uv1.ShowGamepadTextInput(slot0, slot1, slot2, slot3, slot4)
		return uv2(uv3, uv0(slot0, uv1.EGamepadTextInputMode, "input_mode is required"), uv0(slot1, uv1.EGamepadTextInputLineMode, "line_input_mode is required"), slot2, slot3, slot4)
	end

	uv1.show_gamepad_text_input = uv1.ShowGamepadTextInput
	slot21 = uv2(slot0, 21, "uint32_t(__thiscall*)(void*)")

	function uv1.GetEnteredGamepadTextLength()
		return uv0(uv1)
	end

	uv1.get_entered_gamepad_text_length = uv1.GetEnteredGamepadTextLength
	slot22 = uv2(slot0, 22, "bool(__thiscall*)(void*, char *, uint32_t)")

	function uv1.GetEnteredGamepadTextInput(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.get_entered_gamepad_text_input = uv1.GetEnteredGamepadTextInput
	slot23 = uv2(slot0, 23, "const char *(__thiscall*)(void*)")

	function uv1.GetSteamUILanguage()
		return uv0(uv1) ~= nil and uv2(slot0) or nil
	end

	uv1.get_steam_ui_language = uv1.GetSteamUILanguage
	slot24 = uv2(slot0, 24, "bool(__thiscall*)(void*)")

	function uv1.IsSteamRunningInVR()
		return uv0(uv1)
	end

	uv1.is_steam_running_in_vr = uv1.IsSteamRunningInVR
	slot25 = uv2(slot0, 25, "void(__thiscall*)(void*, int, int)")

	function uv1.SetOverlayNotificationInset(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.set_overlay_notification_inset = uv1.SetOverlayNotificationInset
	slot26 = uv2(slot0, 26, "bool(__thiscall*)(void*)")

	function uv1.IsSteamInBigPictureMode()
		return uv0(uv1)
	end

	uv1.is_steam_in_big_picture_mode = uv1.IsSteamInBigPictureMode
	slot27 = uv2(slot0, 27, "void(__thiscall*)(void*)")

	function uv1.StartVRDashboard()
		return uv0(uv1)
	end

	uv1.start_vr_dashboard = uv1.StartVRDashboard
	slot28 = uv2(slot0, 28, "bool(__thiscall*)(void*)")

	function uv1.IsVRHeadsetStreamingEnabled()
		return uv0(uv1)
	end

	uv1.is_vr_headset_streaming_enabled = uv1.IsVRHeadsetStreamingEnabled
	slot29 = uv2(slot0, 29, "void(__thiscall*)(void*, bool)")

	function uv1.SetVRHeadsetStreamingEnabled(slot0)
		return uv0(uv1, slot0)
	end

	uv1.set_vr_headset_streaming_enabled = uv1.SetVRHeadsetStreamingEnabled
	slot30 = uv2(slot0, 30, "bool(__thiscall*)(void*)")

	function uv1.IsSteamChinaLauncher()
		return uv0(uv1)
	end

	uv1.is_steam_china_launcher = uv1.IsSteamChinaLauncher
	slot31 = uv2(slot0, 31, "bool(__thiscall*)(void*, uint32_t)")

	function uv1.InitFilterText(slot0)
		return uv0(uv1, slot0)
	end

	uv1.init_filter_text = uv1.InitFilterText
	slot32 = uv2(slot0, 32, "int(__thiscall*)(void*, int, SteamID, const char *, char *, uint32_t)")

	function uv1.FilterText(slot0, slot1, slot2, slot3, slot4)
		return uv3(uv4, uv0(slot0, uv1.ETextFilteringContext, "context is required"), uv2(slot1, "source_steamid is required"), slot2, slot3, slot4)
	end

	uv1.filter_text = uv1.FilterText
	slot33 = uv2(slot0, 33, "int(__thiscall*)(void*, int)")

	function uv1.GetIPv6ConnectivityState(slot0)
		return uv2(uv3, uv0(slot0, uv1.ESteamIPv6ConnectivityProtocol, "protocol is required"))
	end

	uv1.get_ipv6_connectivity_state = uv1.GetIPv6ConnectivityState
	slot34 = uv2(slot0, 34, "bool(__thiscall*)(void*)")

	function uv1.IsSteamRunningOnSteamDeck()
		return uv0(uv1)
	end

	uv1.is_steam_running_on_steam_deck = uv1.IsSteamRunningOnSteamDeck
	slot35 = uv2(slot0, 35, "bool(__thiscall*)(void*, int, int, int, int, int)")

	function uv1.ShowFloatingGamepadTextInput(slot0, slot1, slot2, slot3, slot4)
		return uv2(uv3, uv0(slot0, uv1.EFloatingGamepadTextInputMode, "keyboard_mode is required"), slot1, slot2, slot3, slot4)
	end

	uv1.show_floating_gamepad_text_input = uv1.ShowFloatingGamepadTextInput
	slot36 = uv2(slot0, 36, "void(__thiscall*)(void*, bool)")

	function uv1.SetGameLauncherMode(slot0)
		return uv0(uv1, slot0)
	end

	uv1.set_game_launcher_mode = uv1.SetGameLauncherMode
	slot37 = uv2(slot0, 37, "bool(__thiscall*)(void*)")

	function uv1.DismissFloatingGamepadTextInput()
		return uv0(uv1)
	end

	uv1.dismiss_floating_gamepad_text_input = uv1.DismissFloatingGamepadTextInput

	return uv1
end

slot146 = {
	version_number = 9,
	version = "SteamMatchMaking009"
}

function slot62.ISteamMatchmaking()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 10, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "SteamMatchMaking009")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "int(__thiscall*)(void*)")

	function uv2.GetFavoriteGameCount()
		return uv0(uv1)
	end

	uv2.get_favorite_game_count = uv2.GetFavoriteGameCount
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*, int, unsigned int *, uint32_t *, uint16_t *, uint16_t *, uint32_t *, uint32_t *)")

	function uv2.GetFavoriteGame(slot0)
		slot1 = uv0()
		slot2 = uv1()
		slot3 = uv2()
		slot4 = uv2()
		slot5 = uv1()
		slot6 = uv1()

		return uv3(uv4, slot0, slot1, slot2, slot3, slot4, slot5, slot6), uv5(slot1), uv5(slot2), uv5(slot3), uv5(slot4), uv5(slot5), uv5(slot6)
	end

	uv2.get_favorite_game = uv2.GetFavoriteGame
	slot3 = uv3(slot0, 2, "int(__thiscall*)(void*, unsigned int, uint32_t, uint16_t, uint16_t, uint32_t, uint32_t)")

	function uv2.AddFavoriteGame(slot0, slot1, slot2, slot3, slot4, slot5)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4, slot5)
	end

	uv2.add_favorite_game = uv2.AddFavoriteGame
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*, unsigned int, uint32_t, uint16_t, uint16_t, uint32_t)")

	function uv2.RemoveFavoriteGame(slot0, slot1, slot2, slot3, slot4)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4)
	end

	uv2.remove_favorite_game = uv2.RemoveFavoriteGame
	slot5 = uv3(slot0, 4, "uint64_t(__thiscall*)(void*)")
	slot6 = {
		struct = uv8([[
			struct {
				uint32_t m_nLobbiesMatching;
			} *
		]]),
		keys = {
			m_nLobbiesMatching = "lobbies_matching"
		}
	}

	function uv2.RequestLobbyList(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 510, uv5)
		end

		return slot1
	end

	uv2.request_lobby_list = uv2.RequestLobbyList
	slot7 = uv3(slot0, 5, "void(__thiscall*)(void*, const char *, const char *, int)")

	function uv2.AddRequestLobbyListStringFilter(slot0, slot1, slot2)
		return uv2(uv3, slot0, slot1, uv0(slot2, uv1.ELobbyComparison, "comparison_type is required"))
	end

	uv2.add_request_lobby_list_string_filter = uv2.AddRequestLobbyListStringFilter
	slot8 = uv3(slot0, 6, "void(__thiscall*)(void*, const char *, int, int)")

	function uv2.AddRequestLobbyListNumericalFilter(slot0, slot1, slot2)
		return uv2(uv3, slot0, slot1, uv0(slot2, uv1.ELobbyComparison, "comparison_type is required"))
	end

	uv2.add_request_lobby_list_numerical_filter = uv2.AddRequestLobbyListNumericalFilter
	slot9 = uv3(slot0, 7, "void(__thiscall*)(void*, const char *, int)")

	function uv2.AddRequestLobbyListNearValueFilter(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.add_request_lobby_list_near_value_filter = uv2.AddRequestLobbyListNearValueFilter
	slot10 = uv3(slot0, 8, "void(__thiscall*)(void*, int)")

	function uv2.AddRequestLobbyListFilterSlotsAvailable(slot0)
		return uv0(uv1, slot0)
	end

	uv2.add_request_lobby_list_filter_slots_available = uv2.AddRequestLobbyListFilterSlotsAvailable
	slot11 = uv3(slot0, 9, "void(__thiscall*)(void*, int)")

	function uv2.AddRequestLobbyListDistanceFilter(slot0)
		return uv2(uv3, uv0(slot0, uv1.ELobbyDistanceFilter, "lobby_distance_filter is required"))
	end

	uv2.add_request_lobby_list_distance_filter = uv2.AddRequestLobbyListDistanceFilter
	slot12 = uv3(slot0, 10, "void(__thiscall*)(void*, int)")

	function uv2.AddRequestLobbyListResultCountFilter(slot0)
		return uv0(uv1, slot0)
	end

	uv2.add_request_lobby_list_result_count_filter = uv2.AddRequestLobbyListResultCountFilter
	slot13 = uv3(slot0, 11, "void(__thiscall*)(void*, SteamID)")

	function uv2.AddRequestLobbyListCompatibleMembersFilter(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.add_request_lobby_list_compatible_members_filter = uv2.AddRequestLobbyListCompatibleMembersFilter
	slot14 = uv3(slot0, 12, "void(__thiscall*)(void*, SteamID *, int)")

	function uv2.GetLobbyByIndex(slot0)
		slot1 = uv0()

		uv1(uv2, slot1, slot0)

		return uv3(slot1)
	end

	uv2.get_lobby_by_index = uv2.GetLobbyByIndex
	slot15 = uv3(slot0, 13, "uint64_t(__thiscall*)(void*, int, int)")
	slot16 = {
		struct = uv8([[
			struct {
				int m_eResult;
				SteamID m_ulSteamIDLobby;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_ulSteamIDLobby = "steamid_lobby"
		}
	}

	function uv2.CreateLobby(slot0, slot1, slot2)
		slot0 = uv0(slot0, uv1.ELobbyType, "lobby_type is required")

		if slot2 ~= nil and not uv2(slot2) then
			return uv3("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv6(uv4(uv5, slot0, slot1), slot2, 513, uv7)
		end

		return slot3
	end

	uv2.create_lobby = uv2.CreateLobby
	slot17 = uv3(slot0, 14, "uint64_t(__thiscall*)(void*, SteamID)")
	slot18 = {
		struct = uv8([[
			struct {
				SteamID m_ulSteamIDLobby;
				uint32_t m_rgfChatPermissions;
				bool m_bLocked;
				uint32_t m_EChatRoomEnterResponse;
			} *
		]]),
		keys = {
			m_bLocked = "locked",
			m_ulSteamIDLobby = "steamid_lobby",
			m_EChatRoomEnterResponse = "e_chat_room_enter_response",
			m_rgfChatPermissions = "chat_permissions"
		}
	}

	function uv2.JoinLobby(slot0, slot1)
		slot0 = uv0(slot0, "steamid_lobby is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 504, uv6)
		end

		return slot2
	end

	uv2.join_lobby = uv2.JoinLobby
	slot19 = uv3(slot0, 15, "void(__thiscall*)(void*, SteamID)")

	function uv2.LeaveLobby(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.leave_lobby = uv2.LeaveLobby
	slot20 = uv3(slot0, 16, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function uv2.InviteUserToLobby(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), uv0(slot1, "steamid_invitee is required"))
	end

	uv2.invite_user_to_lobby = uv2.InviteUserToLobby
	slot21 = uv3(slot0, 17, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetNumLobbyMembers(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.get_num_lobby_members = uv2.GetNumLobbyMembers
	slot22 = uv3(slot0, 18, "void(__thiscall*)(void*, SteamID *, SteamID, int)")

	function uv2.GetLobbyMemberByIndex(slot0, slot1)
		slot2 = uv1()

		uv2(uv3, slot2, uv0(slot0, "steamid_lobby is required"), slot1)

		return uv4(slot2)
	end

	uv2.get_lobby_member_by_index = uv2.GetLobbyMemberByIndex
	slot23 = uv3(slot0, 19, "const char *(__thiscall*)(void*, SteamID, const char *)")

	function uv2.GetLobbyData(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1) ~= nil and uv3(slot2) or nil
	end

	uv2.get_lobby_data = uv2.GetLobbyData
	slot24 = uv3(slot0, 20, "bool(__thiscall*)(void*, SteamID, const char *, const char *)")

	function uv2.SetLobbyData(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1, slot2)
	end

	uv2.set_lobby_data = uv2.SetLobbyData
	slot25 = uv3(slot0, 21, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetLobbyDataCount(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.get_lobby_data_count = uv2.GetLobbyDataCount
	slot26 = uv3(slot0, 22, "bool(__thiscall*)(void*, SteamID, int, char *, int, char *, int)")

	function uv2.GetLobbyDataByIndex(slot0, slot1, slot2, slot3, slot4, slot5)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1, slot2, slot3, slot4, slot5)
	end

	uv2.get_lobby_data_by_index = uv2.GetLobbyDataByIndex
	slot27 = uv3(slot0, 23, "bool(__thiscall*)(void*, SteamID, const char *)")

	function uv2.DeleteLobbyData(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1)
	end

	uv2.delete_lobby_data = uv2.DeleteLobbyData
	slot28 = uv3(slot0, 24, "const char *(__thiscall*)(void*, SteamID, SteamID, const char *)")

	function uv2.GetLobbyMemberData(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), uv0(slot1, "steamid_user is required"), slot2) ~= nil and uv3(slot3) or nil
	end

	uv2.get_lobby_member_data = uv2.GetLobbyMemberData
	slot29 = uv3(slot0, 25, "void(__thiscall*)(void*, SteamID, const char *, const char *)")

	function uv2.SetLobbyMemberData(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1, slot2)
	end

	uv2.set_lobby_member_data = uv2.SetLobbyMemberData
	slot30 = uv3(slot0, 26, "bool(__thiscall*)(void*, SteamID, const void *, int)")

	function uv2.SendLobbyChatMsg(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1, slot2)
	end

	uv2.send_lobby_chat_msg = uv2.SendLobbyChatMsg
	slot31 = uv3(slot0, 27, "int(__thiscall*)(void*, SteamID, int, SteamID *, void *, int, int *)")

	function uv2.GetLobbyChatEntry(slot0, slot1, slot2, slot3)
		slot4 = uv1()
		slot5 = uv2()

		return uv3(uv4, uv0(slot0, "steamid_lobby is required"), slot1, slot4, slot2, slot3, slot5), uv5(slot4), uv5(slot5)
	end

	uv2.get_lobby_chat_entry = uv2.GetLobbyChatEntry
	slot32 = uv3(slot0, 28, "bool(__thiscall*)(void*, SteamID)")

	function uv2.RequestLobbyData(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.request_lobby_data = uv2.RequestLobbyData
	slot33 = uv3(slot0, 29, "void(__thiscall*)(void*, SteamID, uint32_t, uint16_t, SteamID)")

	function uv2.SetLobbyGameServer(slot0, slot1, slot2, slot3)
		return uv2(uv3, uv0(slot0, "steamid_lobby is required"), uv1(slot1, "game_server_ip is required"), slot2, uv0(slot3, "steamid_game_server is required"))
	end

	uv2.set_lobby_game_server = uv2.SetLobbyGameServer
	slot34 = uv3(slot0, 30, "bool(__thiscall*)(void*, SteamID, uint32_t *, uint16_t *, SteamID *)")

	function uv2.GetLobbyGameServer(slot0)
		slot1 = uv1()
		slot2 = uv2()
		slot3 = uv3()

		return uv4(uv5, uv0(slot0, "steamid_lobby is required"), slot1, slot2, slot3), uv6(slot1), uv6(slot2), uv6(slot3)
	end

	uv2.get_lobby_game_server = uv2.GetLobbyGameServer
	slot35 = uv3(slot0, 31, "bool(__thiscall*)(void*, SteamID, int)")

	function uv2.SetLobbyMemberLimit(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1)
	end

	uv2.set_lobby_member_limit = uv2.SetLobbyMemberLimit
	slot36 = uv3(slot0, 32, "int(__thiscall*)(void*, SteamID)")

	function uv2.GetLobbyMemberLimit(slot0)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"))
	end

	uv2.get_lobby_member_limit = uv2.GetLobbyMemberLimit
	slot37 = uv3(slot0, 33, "bool(__thiscall*)(void*, SteamID, int)")

	function uv2.SetLobbyType(slot0, slot1)
		return uv3(uv4, uv0(slot0, "steamid_lobby is required"), uv1(slot1, uv2.ELobbyType, "lobby_type is required"))
	end

	uv2.set_lobby_type = uv2.SetLobbyType
	slot38 = uv3(slot0, 34, "bool(__thiscall*)(void*, SteamID, bool)")

	function uv2.SetLobbyJoinable(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), slot1)
	end

	uv2.set_lobby_joinable = uv2.SetLobbyJoinable
	slot39 = uv3(slot0, 35, "void(__thiscall*)(void*, SteamID *, SteamID)")

	function uv2.GetLobbyOwner(slot0)
		slot1 = uv1()

		uv2(uv3, slot1, uv0(slot0, "steamid_lobby is required"))

		return uv4(slot1)
	end

	uv2.get_lobby_owner = uv2.GetLobbyOwner
	slot40 = uv3(slot0, 36, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function uv2.SetLobbyOwner(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), uv0(slot1, "steamid_new_owner is required"))
	end

	uv2.set_lobby_owner = uv2.SetLobbyOwner
	slot41 = uv3(slot0, 37, "bool(__thiscall*)(void*, SteamID, SteamID)")

	function uv2.SetLinkedLobby(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_lobby is required"), uv0(slot1, "steamid_lobby_dependent is required"))
	end

	uv2.set_linked_lobby = uv2.SetLinkedLobby

	return uv2
end

slot147 = {}
slot61.ISteamMatchmakingServerListResponse = slot147

slot56("ISteamMatchmakingServerListResponse", [[
		typedef struct _ISteamMatchmakingServerListResponse {
			void* vtbl;
			struct {
				void(__thiscall* ServerResponded)(void*, void *, int);
				void(__thiscall* ServerFailedToRespond)(void*, void *, int);
				void(__thiscall* RefreshComplete)(void*, void *, int);
			} vtbl_storage[1];
		} ISteamMatchmakingServerListResponse;
	]])

slot148 = slot4("struct _ISteamMatchmakingServerListResponse[1]")
slot149 = slot4("struct _ISteamMatchmakingServerListResponse*")
slot150, slot151 = nil
slot152 = {}

function slot147.new(slot0)
	if uv0(slot0) ~= "table" then
		return uv1("Invalid user_callbacks, expected table", 2)
	end

	if uv2 == nil then
		uv3 = {
			ServerResponded = {},
			ServerFailedToRespond = {},
			RefreshComplete = {}
		}
		uv2 = {
			ServerResponded = uv4(uv5("void(__thiscall*)(void*, void *, int)"), uv6(uv3.ServerResponded)),
			ServerFailedToRespond = uv4(uv5("void(__thiscall*)(void*, void *, int)"), uv6(uv3.ServerFailedToRespond)),
			RefreshComplete = uv4(uv5("void(__thiscall*)(void*, void *, int)"), uv6(uv3.RefreshComplete))
		}
	end

	for slot4, slot5 in uv7(slot0) do
		if uv2[slot4] == nil then
			return uv1("Unknown callback: " .. uv8(slot4), 2)
		elseif uv0(slot5) ~= "function" then
			return uv1(uv9("Invalid callback type for %s: %s", uv8(slot4), uv0(slot5)), 2)
		end
	end

	for slot7, slot8 in uv7(uv2) do
		if slot0[slot7] ~= nil then
			uv3[slot7][uv12(uv4(uv11, uv10()))] = slot0[slot7]
		end
	end

	for slot7, slot8 in uv7(uv2) do
		slot2.vtbl_storage[0][slot7] = slot8
	end

	slot2.vtbl = slot2.vtbl_storage
	uv13[slot3] = slot1

	return slot2
end

slot148 = {}
slot61.ISteamMatchmakingPingResponse = slot148

slot56("ISteamMatchmakingPingResponse", [[
		typedef struct _ISteamMatchmakingPingResponse {
			void* vtbl;
			struct {
				void(__thiscall* ServerResponded)(void*, gameserveritem_t &);
				void(__thiscall* ServerFailedToRespond)(void*);
			} vtbl_storage[1];
		} ISteamMatchmakingPingResponse;
	]])

slot149 = slot4("struct _ISteamMatchmakingPingResponse[1]")
slot150 = slot4("struct _ISteamMatchmakingPingResponse*")
slot151, slot152 = nil
slot153 = {}

function slot148.new(slot0)
	if uv0(slot0) ~= "table" then
		return uv1("Invalid user_callbacks, expected table", 2)
	end

	if uv2 == nil then
		uv3 = {
			ServerResponded = {},
			ServerFailedToRespond = {}
		}
		uv2 = {
			ServerResponded = uv4(uv5("void(__thiscall*)(void*, gameserveritem_t &)"), uv6(uv3.ServerResponded)),
			ServerFailedToRespond = uv4(uv5("void(__thiscall*)(void*)"), uv6(uv3.ServerFailedToRespond))
		}
	end

	for slot4, slot5 in uv7(slot0) do
		if uv2[slot4] == nil then
			return uv1("Unknown callback: " .. uv8(slot4), 2)
		elseif uv0(slot5) ~= "function" then
			return uv1(uv9("Invalid callback type for %s: %s", uv8(slot4), uv0(slot5)), 2)
		end
	end

	for slot7, slot8 in uv7(uv2) do
		if slot0[slot7] ~= nil then
			uv3[slot7][uv12(uv4(uv11, uv10()))] = slot0[slot7]
		end
	end

	for slot7, slot8 in uv7(uv2) do
		slot2.vtbl_storage[0][slot7] = slot8
	end

	slot2.vtbl = slot2.vtbl_storage
	uv13[slot3] = slot1

	return slot2
end

slot149 = {}
slot61.ISteamMatchmakingPlayersResponse = slot149

slot56("ISteamMatchmakingPlayersResponse", [[
		typedef struct _ISteamMatchmakingPlayersResponse {
			void* vtbl;
			struct {
				void(__thiscall* AddPlayerToList)(void*, const char *, int, float);
				void(__thiscall* PlayersFailedToRespond)(void*);
				void(__thiscall* PlayersRefreshComplete)(void*);
			} vtbl_storage[1];
		} ISteamMatchmakingPlayersResponse;
	]])

slot150 = slot4("struct _ISteamMatchmakingPlayersResponse[1]")
slot151 = slot4("struct _ISteamMatchmakingPlayersResponse*")
slot152, slot153 = nil
slot154 = {}

function slot149.new(slot0)
	if uv0(slot0) ~= "table" then
		return uv1("Invalid user_callbacks, expected table", 2)
	end

	if uv2 == nil then
		uv3 = {
			AddPlayerToList = {},
			PlayersFailedToRespond = {},
			PlayersRefreshComplete = {}
		}
		uv2 = {
			AddPlayerToList = uv4(uv5("void(__thiscall*)(void*, const char *, int, float)"), uv6(uv3.AddPlayerToList)),
			PlayersFailedToRespond = uv4(uv5("void(__thiscall*)(void*)"), uv6(uv3.PlayersFailedToRespond)),
			PlayersRefreshComplete = uv4(uv5("void(__thiscall*)(void*)"), uv6(uv3.PlayersRefreshComplete))
		}
	end

	for slot4, slot5 in uv7(slot0) do
		if uv2[slot4] == nil then
			return uv1("Unknown callback: " .. uv8(slot4), 2)
		elseif uv0(slot5) ~= "function" then
			return uv1(uv9("Invalid callback type for %s: %s", uv8(slot4), uv0(slot5)), 2)
		end
	end

	for slot7, slot8 in uv7(uv2) do
		if slot0[slot7] ~= nil then
			uv3[slot7][uv12(uv4(uv11, uv10()))] = slot0[slot7]
		end
	end

	for slot7, slot8 in uv7(uv2) do
		slot2.vtbl_storage[0][slot7] = slot8
	end

	slot2.vtbl = slot2.vtbl_storage
	uv13[slot3] = slot1

	return slot2
end

slot150 = {}
slot61.ISteamMatchmakingRulesResponse = slot150

slot56("ISteamMatchmakingRulesResponse", [[
		typedef struct _ISteamMatchmakingRulesResponse {
			void* vtbl;
			struct {
				void(__thiscall* RulesResponded)(void*, const char *, const char *);
				void(__thiscall* RulesFailedToRespond)(void*);
				void(__thiscall* RulesRefreshComplete)(void*);
			} vtbl_storage[1];
		} ISteamMatchmakingRulesResponse;
	]])

slot151 = slot4("struct _ISteamMatchmakingRulesResponse[1]")
slot152 = slot4("struct _ISteamMatchmakingRulesResponse*")
slot153, slot154 = nil
slot155 = {}

function slot150.new(slot0)
	if uv0(slot0) ~= "table" then
		return uv1("Invalid user_callbacks, expected table", 2)
	end

	if uv2 == nil then
		uv3 = {
			RulesResponded = {},
			RulesFailedToRespond = {},
			RulesRefreshComplete = {}
		}
		uv2 = {
			RulesResponded = uv4(uv5("void(__thiscall*)(void*, const char *, const char *)"), uv6(uv3.RulesResponded)),
			RulesFailedToRespond = uv4(uv5("void(__thiscall*)(void*)"), uv6(uv3.RulesFailedToRespond)),
			RulesRefreshComplete = uv4(uv5("void(__thiscall*)(void*)"), uv6(uv3.RulesRefreshComplete))
		}
	end

	for slot4, slot5 in uv7(slot0) do
		if uv2[slot4] == nil then
			return uv1("Unknown callback: " .. uv8(slot4), 2)
		elseif uv0(slot5) ~= "function" then
			return uv1(uv9("Invalid callback type for %s: %s", uv8(slot4), uv0(slot5)), 2)
		end
	end

	for slot7, slot8 in uv7(uv2) do
		if slot0[slot7] ~= nil then
			uv3[slot7][uv12(uv4(uv11, uv10()))] = slot0[slot7]
		end
	end

	for slot7, slot8 in uv7(uv2) do
		slot2.vtbl_storage[0][slot7] = slot8
	end

	slot2.vtbl = slot2.vtbl_storage
	uv13[slot3] = slot1

	return slot2
end

slot151 = {
	version_number = 2,
	version = "SteamMatchMakingServers002"
}

function slot62.ISteamMatchmakingServers()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 11, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "SteamMatchMakingServers002")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function uv2.RequestInternetServerList(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.request_internet_server_list = uv2.RequestInternetServerList
	slot2 = uv3(slot0, 1, "void *(__thiscall*)(void*, unsigned int, ISteamMatchmakingServerListResponse *)")

	function uv2.RequestLANServerList(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.request_lan_server_list = uv2.RequestLANServerList
	slot3 = uv3(slot0, 2, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function uv2.RequestFriendsServerList(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.request_friends_server_list = uv2.RequestFriendsServerList
	slot4 = uv3(slot0, 3, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function uv2.RequestFavoritesServerList(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.request_favorites_server_list = uv2.RequestFavoritesServerList
	slot5 = uv3(slot0, 4, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function uv2.RequestHistoryServerList(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.request_history_server_list = uv2.RequestHistoryServerList
	slot6 = uv3(slot0, 5, "void *(__thiscall*)(void*, unsigned int, MatchMakingKeyValuePair_t **, uint32_t, ISteamMatchmakingServerListResponse *)")

	function uv2.RequestSpectatorServerList(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.request_spectator_server_list = uv2.RequestSpectatorServerList
	slot7 = uv3(slot0, 6, "void(__thiscall*)(void*, void *)")

	function uv2.ReleaseRequest(slot0)
		return uv0(uv1, slot0)
	end

	uv2.release_request = uv2.ReleaseRequest
	slot8 = uv3(slot0, 7, "gameserveritem_t *(__thiscall*)(void*, void *, int)")

	function uv2.GetServerDetails(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_server_details = uv2.GetServerDetails
	slot9 = uv3(slot0, 8, "void(__thiscall*)(void*, void *)")

	function uv2.CancelQuery(slot0)
		return uv0(uv1, slot0)
	end

	uv2.cancel_query = uv2.CancelQuery
	slot10 = uv3(slot0, 9, "void(__thiscall*)(void*, void *)")

	function uv2.RefreshQuery(slot0)
		return uv0(uv1, slot0)
	end

	uv2.refresh_query = uv2.RefreshQuery
	slot11 = uv3(slot0, 10, "bool(__thiscall*)(void*, void *)")

	function uv2.IsRefreshing(slot0)
		return uv0(uv1, slot0)
	end

	uv2.is_refreshing = uv2.IsRefreshing
	slot12 = uv3(slot0, 11, "int(__thiscall*)(void*, void *)")

	function uv2.GetServerCount(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_server_count = uv2.GetServerCount
	slot13 = uv3(slot0, 12, "void(__thiscall*)(void*, void *, int)")

	function uv2.RefreshServer(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.refresh_server = uv2.RefreshServer
	slot14 = uv3(slot0, 13, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingPingResponse *)")

	function uv2.PingServer(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "ip is required"), slot1, slot2)
	end

	uv2.ping_server = uv2.PingServer
	slot15 = uv3(slot0, 14, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingPlayersResponse *)")

	function uv2.PlayerDetails(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "ip is required"), slot1, slot2)
	end

	uv2.player_details = uv2.PlayerDetails
	slot16 = uv3(slot0, 15, "int(__thiscall*)(void*, uint32_t, uint16_t, ISteamMatchmakingRulesResponse *)")

	function uv2.ServerRules(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "ip is required"), slot1, slot2)
	end

	uv2.server_rules = uv2.ServerRules
	slot17 = uv3(slot0, 16, "void(__thiscall*)(void*, int)")

	function uv2.CancelServerQuery(slot0)
		return uv0(uv1, slot0)
	end

	uv2.cancel_server_query = uv2.CancelServerQuery

	return uv2
end

slot152 = {
	version_number = 12,
	version = "STEAMUSERSTATS_INTERFACE_VERSION012"
}

function slot62.ISteamUserStats()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 13, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMUSERSTATS_INTERFACE_VERSION012")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "bool(__thiscall*)(void*)")

	function uv2.RequestCurrentStats()
		return uv0(uv1)
	end

	uv2.request_current_stats = uv2.RequestCurrentStats
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*, const char *, int32_t *)")

	function uv2.GetStatInt32(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_stat_int32 = uv2.GetStatInt32
	slot3 = uv3(slot0, 2, "bool(__thiscall*)(void*, const char *, float *)")

	function uv2.GetStatFloat(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_stat_float = uv2.GetStatFloat
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*, const char *, int32_t)")

	function uv2.SetStatInt32(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_stat_int32 = uv2.SetStatInt32
	slot5 = uv3(slot0, 4, "bool(__thiscall*)(void*, const char *, float)")

	function uv2.SetStatFloat(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_stat_float = uv2.SetStatFloat
	slot6 = uv3(slot0, 5, "bool(__thiscall*)(void*, const char *, float, double)")

	function uv2.UpdateAvgRateStat(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.update_avg_rate_stat = uv2.UpdateAvgRateStat
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, const char *, bool *)")

	function uv2.GetAchievement(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_achievement = uv2.GetAchievement
	slot8 = uv3(slot0, 7, "bool(__thiscall*)(void*, const char *)")

	function uv2.SetAchievement(slot0)
		return uv0(uv1, slot0)
	end

	uv2.set_achievement = uv2.SetAchievement
	slot9 = uv3(slot0, 8, "bool(__thiscall*)(void*, const char *)")

	function uv2.ClearAchievement(slot0)
		return uv0(uv1, slot0)
	end

	uv2.clear_achievement = uv2.ClearAchievement
	slot10 = uv3(slot0, 9, "bool(__thiscall*)(void*, const char *, bool *, uint32_t *)")

	function uv2.GetAchievementAndUnlockTime(slot0)
		slot1 = uv0()
		slot2 = uv1()

		return uv2(uv3, slot0, slot1, slot2), uv4(slot1), uv4(slot2)
	end

	uv2.get_achievement_and_unlock_time = uv2.GetAchievementAndUnlockTime
	slot11 = uv3(slot0, 10, "bool(__thiscall*)(void*)")

	function uv2.StoreStats()
		return uv0(uv1)
	end

	uv2.store_stats = uv2.StoreStats
	slot12 = uv3(slot0, 11, "int(__thiscall*)(void*, const char *)")

	function uv2.GetAchievementIcon(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_achievement_icon = uv2.GetAchievementIcon
	slot13 = uv3(slot0, 12, "const char *(__thiscall*)(void*, const char *, const char *)")

	function uv2.GetAchievementDisplayAttribute(slot0, slot1)
		return uv0(uv1, slot0, slot1) ~= nil and uv2(slot2) or nil
	end

	uv2.get_achievement_display_attribute = uv2.GetAchievementDisplayAttribute
	slot14 = uv3(slot0, 13, "bool(__thiscall*)(void*, const char *, uint32_t, uint32_t)")

	function uv2.IndicateAchievementProgress(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.indicate_achievement_progress = uv2.IndicateAchievementProgress
	slot15 = uv3(slot0, 14, "uint32_t(__thiscall*)(void*)")

	function uv2.GetNumAchievements()
		return uv0(uv1)
	end

	uv2.get_num_achievements = uv2.GetNumAchievements
	slot16 = uv3(slot0, 15, "const char *(__thiscall*)(void*, uint32_t)")

	function uv2.GetAchievementName(slot0)
		return uv0(uv1, slot0) ~= nil and uv2(slot1) or nil
	end

	uv2.get_achievement_name = uv2.GetAchievementName
	slot17 = uv3(slot0, 16, "uint64_t(__thiscall*)(void*, SteamID)")
	slot18 = {
		struct = uv10([[
			struct {
				uint64_t m_nGameID;
				int m_eResult;
				SteamID m_steamIDUser;
			} *
		]]),
		keys = {
			m_nGameID = "game_id",
			m_steamIDUser = "steamid_user",
			m_eResult = "result"
		}
	}

	function uv2.RequestUserStats(slot0, slot1)
		slot0 = uv0(slot0, "steamid_user is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 1101, uv6)
		end

		return slot2
	end

	uv2.request_user_stats = uv2.RequestUserStats
	slot19 = uv3(slot0, 17, "bool(__thiscall*)(void*, SteamID, const char *, int32_t *)")

	function uv2.GetUserStatInt32(slot0, slot1)
		slot2 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_user is required"), slot1, slot2), uv4(slot2)
	end

	uv2.get_user_stat_int32 = uv2.GetUserStatInt32
	slot20 = uv3(slot0, 18, "bool(__thiscall*)(void*, SteamID, const char *, float *)")

	function uv2.GetUserStatFloat(slot0, slot1)
		slot2 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_user is required"), slot1, slot2), uv4(slot2)
	end

	uv2.get_user_stat_float = uv2.GetUserStatFloat
	slot21 = uv3(slot0, 19, "bool(__thiscall*)(void*, SteamID, const char *, bool *)")

	function uv2.GetUserAchievement(slot0, slot1)
		slot2 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_user is required"), slot1, slot2), uv4(slot2)
	end

	uv2.get_user_achievement = uv2.GetUserAchievement
	slot22 = uv3(slot0, 20, "bool(__thiscall*)(void*, SteamID, const char *, bool *, uint32_t *)")

	function uv2.GetUserAchievementAndUnlockTime(slot0, slot1)
		slot2 = uv1()
		slot3 = uv2()

		return uv3(uv4, uv0(slot0, "steamid_user is required"), slot1, slot2, slot3), uv5(slot2), uv5(slot3)
	end

	uv2.get_user_achievement_and_unlock_time = uv2.GetUserAchievementAndUnlockTime
	slot23 = uv3(slot0, 21, "bool(__thiscall*)(void*, bool)")

	function uv2.ResetAllStats(slot0)
		return uv0(uv1, slot0)
	end

	uv2.reset_all_stats = uv2.ResetAllStats
	slot24 = uv3(slot0, 22, "uint64_t(__thiscall*)(void*, const char *, int, int)")
	slot25 = {
		struct = uv10([[
			struct {
				uint64_t m_hSteamLeaderboard;
				bool m_bLeaderboardFound;
			} *
		]]),
		keys = {
			m_hSteamLeaderboard = "steam_leaderboard",
			m_bLeaderboardFound = "leaderboard_found"
		}
	}

	function uv2.FindOrCreateLeaderboard(slot0, slot1, slot2, slot3)
		slot1 = uv0(slot1, uv1.ELeaderboardSortMethod, "leaderboard_sort_method is required")
		slot2 = uv0(slot2, uv1.ELeaderboardDisplayType, "leaderboard_display_type is required")

		if slot3 ~= nil and not uv2(slot3) then
			return uv3("Invalid callback, expected function or await")
		end

		if slot3 ~= nil then
			slot4 = uv6(uv4(uv5, slot0, slot1, slot2), slot3, 1104, uv7)
		end

		return slot4
	end

	uv2.find_or_create_leaderboard = uv2.FindOrCreateLeaderboard
	slot26 = uv3(slot0, 23, "uint64_t(__thiscall*)(void*, const char *)")
	slot27 = {
		struct = uv10([[
			struct {
				uint64_t m_hSteamLeaderboard;
				bool m_bLeaderboardFound;
			} *
		]]),
		keys = {
			m_hSteamLeaderboard = "steam_leaderboard",
			m_bLeaderboardFound = "leaderboard_found"
		}
	}

	function uv2.FindLeaderboard(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 1104, uv5)
		end

		return slot2
	end

	uv2.find_leaderboard = uv2.FindLeaderboard
	slot28 = uv3(slot0, 24, "const char *(__thiscall*)(void*, uint64_t)")

	function uv2.GetLeaderboardName(slot0)
		return uv0(uv1, slot0) ~= nil and uv2(slot1) or nil
	end

	uv2.get_leaderboard_name = uv2.GetLeaderboardName
	slot29 = uv3(slot0, 25, "int(__thiscall*)(void*, uint64_t)")

	function uv2.GetLeaderboardEntryCount(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_leaderboard_entry_count = uv2.GetLeaderboardEntryCount
	slot30 = uv3(slot0, 26, "int(__thiscall*)(void*, uint64_t)")

	function uv2.GetLeaderboardSortMethod(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_leaderboard_sort_method = uv2.GetLeaderboardSortMethod
	slot31 = uv3(slot0, 27, "int(__thiscall*)(void*, uint64_t)")

	function uv2.GetLeaderboardDisplayType(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_leaderboard_display_type = uv2.GetLeaderboardDisplayType
	slot32 = uv3(slot0, 28, "uint64_t(__thiscall*)(void*, uint64_t, int, int, int)")
	slot33 = {
		struct = uv10([[
			struct {
				uint64_t m_hSteamLeaderboard;
				uint64_t m_hSteamLeaderboardEntries;
				int m_cEntryCount;
			} *
		]]),
		keys = {
			m_hSteamLeaderboardEntries = "steam_leaderboard_entries",
			m_hSteamLeaderboard = "steam_leaderboard",
			m_cEntryCount = "entry_count"
		}
	}

	function uv2.DownloadLeaderboardEntries(slot0, slot1, slot2, slot3, slot4)
		slot1 = uv0(slot1, uv1.ELeaderboardDataRequest, "leaderboard_data_request is required")

		if slot4 ~= nil and not uv2(slot4) then
			return uv3("Invalid callback, expected function or await")
		end

		if slot4 ~= nil then
			slot5 = uv6(uv4(uv5, slot0, slot1, slot2, slot3), slot4, 1105, uv7)
		end

		return slot5
	end

	uv2.download_leaderboard_entries = uv2.DownloadLeaderboardEntries
	slot34 = uv3(slot0, 29, "uint64_t(__thiscall*)(void*, uint64_t, SteamID *, int)")
	slot35 = {
		struct = uv10([[
			struct {
				uint64_t m_hSteamLeaderboard;
				uint64_t m_hSteamLeaderboardEntries;
				int m_cEntryCount;
			} *
		]]),
		keys = {
			m_hSteamLeaderboardEntries = "steam_leaderboard_entries",
			m_hSteamLeaderboard = "steam_leaderboard",
			m_cEntryCount = "entry_count"
		}
	}

	function uv2.DownloadLeaderboardEntriesForUsers(slot0, slot1, slot2, slot3)
		if slot3 ~= nil and not uv0(slot3) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot3 ~= nil then
			slot4 = uv4(uv2(uv3, slot0, slot1, slot2), slot3, 1105, uv5)
		end

		return slot4
	end

	uv2.download_leaderboard_entries_for_users = uv2.DownloadLeaderboardEntriesForUsers
	slot36 = uv3(slot0, 30, "bool(__thiscall*)(void*, uint64_t, int, LeaderboardEntry_t *, int32_t *, int)")

	function uv2.GetDownloadedLeaderboardEntry(slot0, slot1, slot2, slot3)
		slot4 = uv0.LeaderboardEntry_t_arr(1)

		return uv1(uv2, slot0, slot1, slot4, slot2, slot3), uv3(slot4)
	end

	uv2.get_downloaded_leaderboard_entry = uv2.GetDownloadedLeaderboardEntry
	slot37 = uv3(slot0, 31, "uint64_t(__thiscall*)(void*, uint64_t, int, int32_t, const int32_t *, int)")
	slot38 = {
		struct = uv10([[
			struct {
				bool m_bSuccess;
				uint64_t m_hSteamLeaderboard;
				int32_t m_nScore;
				bool m_bScoreChanged;
				int m_nGlobalRankNew;
				int m_nGlobalRankPrevious;
			} *
		]]),
		keys = {
			m_nGlobalRankNew = "global_rank_new",
			m_nGlobalRankPrevious = "global_rank_previous",
			m_bScoreChanged = "score_changed",
			m_nScore = "score",
			m_bSuccess = "success",
			m_hSteamLeaderboard = "steam_leaderboard"
		}
	}

	function uv2.UploadLeaderboardScore(slot0, slot1, slot2, slot3, slot4, slot5)
		slot1 = uv0(slot1, uv1.ELeaderboardUploadScoreMethod, "leaderboard_upload_score_method is required")

		if slot5 ~= nil and not uv2(slot5) then
			return uv3("Invalid callback, expected function or await")
		end

		if slot5 ~= nil then
			slot6 = uv6(uv4(uv5, slot0, slot1, slot2, slot3, slot4), slot5, 1106, uv7)
		end

		return slot6
	end

	uv2.upload_leaderboard_score = uv2.UploadLeaderboardScore
	slot39 = uv3(slot0, 32, "uint64_t(__thiscall*)(void*, uint64_t, uint64_t)")
	slot40 = {
		struct = uv10([[
			struct {
				int m_eResult;
				uint64_t m_hSteamLeaderboard;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_hSteamLeaderboard = "steam_leaderboard"
		}
	}

	function uv2.AttachLeaderboardUGC(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 1111, uv5)
		end

		return slot3
	end

	uv2.attach_leaderboard_ugc = uv2.AttachLeaderboardUGC
	slot41 = uv3(slot0, 33, "uint64_t(__thiscall*)(void*)")
	slot42 = {
		struct = uv10([[
			struct {
				bool m_bSuccess;
				int32_t m_cPlayers;
			} *
		]]),
		keys = {
			m_cPlayers = "players",
			m_bSuccess = "success"
		}
	}

	function uv2.GetNumberOfCurrentPlayers(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 1107, uv5)
		end

		return slot1
	end

	uv2.get_number_of_current_players = uv2.GetNumberOfCurrentPlayers
	slot43 = uv3(slot0, 34, "uint64_t(__thiscall*)(void*)")
	slot44 = {
		struct = uv10([[
			struct {
				uint64_t m_nGameID;
				int m_eResult;
			} *
		]]),
		keys = {
			m_nGameID = "game_id",
			m_eResult = "result"
		}
	}

	function uv2.RequestGlobalAchievementPercentages(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 1110, uv5)
		end

		return slot1
	end

	uv2.request_global_achievement_percentages = uv2.RequestGlobalAchievementPercentages
	slot45 = uv3(slot0, 35, "int(__thiscall*)(void*, char *, uint32_t, float *, bool *)")

	function uv2.GetMostAchievedAchievementInfo(slot0, slot1)
		slot2 = uv0()
		slot3 = uv1()

		return uv2(uv3, slot0, slot1, slot2, slot3), uv4(slot2), uv4(slot3)
	end

	uv2.get_most_achieved_achievement_info = uv2.GetMostAchievedAchievementInfo
	slot46 = uv3(slot0, 36, "int(__thiscall*)(void*, int, char *, uint32_t, float *, bool *)")

	function uv2.GetNextMostAchievedAchievementInfo(slot0, slot1, slot2)
		slot3 = uv0()
		slot4 = uv1()

		return uv2(uv3, slot0, slot1, slot2, slot3, slot4), uv4(slot3), uv4(slot4)
	end

	uv2.get_next_most_achieved_achievement_info = uv2.GetNextMostAchievedAchievementInfo
	slot47 = uv3(slot0, 37, "bool(__thiscall*)(void*, const char *, float *)")

	function uv2.GetAchievementAchievedPercent(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_achievement_achieved_percent = uv2.GetAchievementAchievedPercent
	slot48 = uv3(slot0, 38, "uint64_t(__thiscall*)(void*, int)")
	slot49 = {
		struct = uv10([[
			struct {
				uint64_t m_nGameID;
				int m_eResult;
			} *
		]]),
		keys = {
			m_nGameID = "game_id",
			m_eResult = "result"
		}
	}

	function uv2.RequestGlobalStats(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 1112, uv5)
		end

		return slot2
	end

	uv2.request_global_stats = uv2.RequestGlobalStats
	slot50 = uv3(slot0, 39, "bool(__thiscall*)(void*, const char *, int64_t *)")

	function uv2.GetGlobalStatInt64(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_global_stat_int64 = uv2.GetGlobalStatInt64
	slot51 = uv3(slot0, 40, "bool(__thiscall*)(void*, const char *, double *)")

	function uv2.GetGlobalStatDouble(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_global_stat_double = uv2.GetGlobalStatDouble
	slot52 = uv3(slot0, 41, "int32_t(__thiscall*)(void*, const char *, int64_t *, uint32_t)")

	function uv2.GetGlobalStatHistoryInt64(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_global_stat_history_int64 = uv2.GetGlobalStatHistoryInt64
	slot53 = uv3(slot0, 42, "int32_t(__thiscall*)(void*, const char *, double *, uint32_t)")

	function uv2.GetGlobalStatHistoryDouble(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_global_stat_history_double = uv2.GetGlobalStatHistoryDouble
	slot54 = uv3(slot0, 43, "bool(__thiscall*)(void*, const char *, int32_t *, int32_t *)")

	function uv2.GetAchievementProgressLimitsInt32(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv2.get_achievement_progress_limits_int32 = uv2.GetAchievementProgressLimitsInt32
	slot55 = uv3(slot0, 44, "bool(__thiscall*)(void*, const char *, float *, float *)")

	function uv2.GetAchievementProgressLimitsFloat(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv2.get_achievement_progress_limits_float = uv2.GetAchievementProgressLimitsFloat

	return uv2
end

slot153 = {
	version_number = 8,
	version = "STEAMAPPS_INTERFACE_VERSION008"
}

function slot62.ISteamApps()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 15, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMAPPS_INTERFACE_VERSION008")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "bool(__thiscall*)(void*)")

	function uv2.BIsSubscribed()
		return uv0(uv1)
	end

	uv2.is_subscribed = uv2.BIsSubscribed
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*)")

	function uv2.BIsLowViolence()
		return uv0(uv1)
	end

	uv2.is_low_violence = uv2.BIsLowViolence
	slot3 = uv3(slot0, 2, "bool(__thiscall*)(void*)")

	function uv2.BIsCybercafe()
		return uv0(uv1)
	end

	uv2.is_cybercafe = uv2.BIsCybercafe
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*)")

	function uv2.BIsVACBanned()
		return uv0(uv1)
	end

	uv2.is_vac_banned = uv2.BIsVACBanned
	slot5 = uv3(slot0, 4, "const char *(__thiscall*)(void*)")

	function uv2.GetCurrentGameLanguage()
		return uv0(uv1) ~= nil and uv2(slot0) or nil
	end

	uv2.get_current_game_language = uv2.GetCurrentGameLanguage
	slot6 = uv3(slot0, 5, "const char *(__thiscall*)(void*)")

	function uv2.GetAvailableGameLanguages()
		return uv0(uv1) ~= nil and uv2(slot0) or nil
	end

	uv2.get_available_game_languages = uv2.GetAvailableGameLanguages
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.BIsSubscribedApp(slot0)
		return uv0(uv1, slot0)
	end

	uv2.is_subscribed_app = uv2.BIsSubscribedApp
	slot8 = uv3(slot0, 7, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.BIsDlcInstalled(slot0)
		return uv0(uv1, slot0)
	end

	uv2.is_dlc_installed = uv2.BIsDlcInstalled
	slot9 = uv3(slot0, 8, "uint32_t(__thiscall*)(void*, unsigned int)")

	function uv2.GetEarliestPurchaseUnixTime(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_earliest_purchase_unix_time = uv2.GetEarliestPurchaseUnixTime
	slot10 = uv3(slot0, 9, "bool(__thiscall*)(void*)")

	function uv2.BIsSubscribedFromFreeWeekend()
		return uv0(uv1)
	end

	uv2.is_subscribed_from_free_weekend = uv2.BIsSubscribedFromFreeWeekend
	slot11 = uv3(slot0, 10, "int(__thiscall*)(void*)")

	function uv2.GetDLCCount()
		return uv0(uv1)
	end

	uv2.get_dlc_count = uv2.GetDLCCount
	slot12 = uv3(slot0, 11, "bool(__thiscall*)(void*, int, unsigned int *, bool *, char *, int)")

	function uv2.BGetDLCDataByIndex(slot0, slot1, slot2)
		slot3 = uv0()
		slot4 = uv1()

		return uv2(uv3, slot0, slot3, slot4, slot1, slot2), uv4(slot3), uv4(slot4)
	end

	uv2.get_dlc_data_by_index = uv2.BGetDLCDataByIndex
	slot13 = uv3(slot0, 12, "void(__thiscall*)(void*, unsigned int)")

	function uv2.InstallDLC(slot0)
		return uv0(uv1, slot0)
	end

	uv2.install_dlc = uv2.InstallDLC
	slot14 = uv3(slot0, 13, "void(__thiscall*)(void*, unsigned int)")

	function uv2.UninstallDLC(slot0)
		return uv0(uv1, slot0)
	end

	uv2.uninstall_dlc = uv2.UninstallDLC
	slot15 = uv3(slot0, 14, "void(__thiscall*)(void*, unsigned int)")

	function uv2.RequestAppProofOfPurchaseKey(slot0)
		return uv0(uv1, slot0)
	end

	uv2.request_app_proof_of_purchase_key = uv2.RequestAppProofOfPurchaseKey
	slot16 = uv3(slot0, 15, "bool(__thiscall*)(void*, char *, int)")

	function uv2.GetCurrentBetaName(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_current_beta_name = uv2.GetCurrentBetaName
	slot17 = uv3(slot0, 16, "bool(__thiscall*)(void*, bool)")

	function uv2.MarkContentCorrupt(slot0)
		return uv0(uv1, slot0)
	end

	uv2.mark_content_corrupt = uv2.MarkContentCorrupt
	slot18 = uv3(slot0, 17, "uint32_t(__thiscall*)(void*, unsigned int, unsigned int *, uint32_t)")

	function uv2.GetInstalledDepots(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_installed_depots = uv2.GetInstalledDepots
	slot19 = uv3(slot0, 18, "uint32_t(__thiscall*)(void*, unsigned int, char *, uint32_t)")

	function uv2.GetAppInstallDir(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_app_install_dir = uv2.GetAppInstallDir
	slot20 = uv3(slot0, 19, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.BIsAppInstalled(slot0)
		return uv0(uv1, slot0)
	end

	uv2.is_app_installed = uv2.BIsAppInstalled
	slot21 = uv3(slot0, 20, "void(__thiscall*)(void*, SteamID *)")

	function uv2.GetAppOwner()
		slot0 = uv0()

		uv1(uv2, slot0)

		return uv3(slot0)
	end

	uv2.get_app_owner = uv2.GetAppOwner
	slot22 = uv3(slot0, 21, "const char *(__thiscall*)(void*, const char *)")

	function uv2.GetLaunchQueryParam(slot0)
		return uv0(uv1, slot0) ~= nil and uv2(slot1) or nil
	end

	uv2.get_launch_query_param = uv2.GetLaunchQueryParam
	slot23 = uv3(slot0, 22, "bool(__thiscall*)(void*, unsigned int, uint64_t *, uint64_t *)")

	function uv2.GetDlcDownloadProgress(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv2.get_dlc_download_progress = uv2.GetDlcDownloadProgress
	slot24 = uv3(slot0, 23, "int(__thiscall*)(void*)")

	function uv2.GetAppBuildId()
		return uv0(uv1)
	end

	uv2.get_app_build_id = uv2.GetAppBuildId
	slot25 = uv3(slot0, 24, "void(__thiscall*)(void*)")

	function uv2.RequestAllProofOfPurchaseKeys()
		return uv0(uv1)
	end

	uv2.request_all_proof_of_purchase_keys = uv2.RequestAllProofOfPurchaseKeys
	slot26 = uv3(slot0, 25, "uint64_t(__thiscall*)(void*, const char *)")
	slot27 = {
		struct = uv10([[
			struct {
				int m_eResult;
				uint64_t m_ulFileSize;
				uint8_t m_FileSHA[20];
				uint32_t m_unFlags;
			} *
		]]),
		keys = {
			m_ulFileSize = "file_size",
			m_FileSHA = "file_sha",
			m_eResult = "result",
			m_unFlags = "flags"
		}
	}

	function uv2.GetFileDetails(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 1023, uv5)
		end

		return slot2
	end

	uv2.get_file_details = uv2.GetFileDetails
	slot28 = uv3(slot0, 26, "int(__thiscall*)(void*, char *, int)")

	function uv2.GetLaunchCommandLine(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_launch_command_line = uv2.GetLaunchCommandLine
	slot29 = uv3(slot0, 27, "bool(__thiscall*)(void*)")

	function uv2.BIsSubscribedFromFamilySharing()
		return uv0(uv1)
	end

	uv2.is_subscribed_from_family_sharing = uv2.BIsSubscribedFromFamilySharing
	slot30 = uv3(slot0, 28, "bool(__thiscall*)(void*, uint32_t *, uint32_t *)")

	function uv2.BIsTimedTrial()
		slot0 = uv0()
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot0), uv3(slot1)
	end

	uv2.is_timed_trial = uv2.BIsTimedTrial
	slot31 = uv3(slot0, 29, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.SetDlcContext(slot0)
		return uv0(uv1, slot0)
	end

	uv2.set_dlc_context = uv2.SetDlcContext

	return uv2
end

slot154 = {
	version_number = 6,
	version = "SteamNetworking006"
}

function slot62.ISteamNetworking()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 16, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "SteamNetworking006")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "bool(__thiscall*)(void*, SteamID, const void *, uint32_t, int, int)")

	function uv2.SendP2PPacket(slot0, slot1, slot2, slot3, slot4)
		return uv3(uv4, uv0(slot0, "steamid_remote is required"), slot1, slot2, uv1(slot3, uv2.EP2PSend, "p2p_send_type is required"), slot4)
	end

	uv2.send_p2p_packet = uv2.SendP2PPacket
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*, uint32_t *, int)")

	function uv2.IsP2PPacketAvailable(slot0)
		slot1 = uv0()

		return uv1(uv2, slot1, slot0), uv3(slot1)
	end

	uv2.is_p2p_packet_available = uv2.IsP2PPacketAvailable
	slot3 = uv3(slot0, 2, "bool(__thiscall*)(void*, void *, uint32_t, uint32_t *, SteamID *, int)")

	function uv2.ReadP2PPacket(slot0, slot1, slot2, slot3)
		slot4 = uv0()

		return uv1(uv2, slot0, slot1, slot4, slot2, slot3), uv3(slot4)
	end

	uv2.read_p2p_packet = uv2.ReadP2PPacket
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*, SteamID)")

	function uv2.AcceptP2PSessionWithUser(slot0)
		return uv1(uv2, uv0(slot0, "steamid_remote is required"))
	end

	uv2.accept_p2p_session_with_user = uv2.AcceptP2PSessionWithUser
	slot5 = uv3(slot0, 4, "bool(__thiscall*)(void*, SteamID)")

	function uv2.CloseP2PSessionWithUser(slot0)
		return uv1(uv2, uv0(slot0, "steamid_remote is required"))
	end

	uv2.close_p2p_session_with_user = uv2.CloseP2PSessionWithUser
	slot6 = uv3(slot0, 5, "bool(__thiscall*)(void*, SteamID, int)")

	function uv2.CloseP2PChannelWithUser(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_remote is required"), slot1)
	end

	uv2.close_p2p_channel_with_user = uv2.CloseP2PChannelWithUser
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, SteamID, P2PSessionState_t *)")

	function uv2.GetP2PSessionState(slot0)
		slot1 = uv1.P2PSessionState_t_arr(1)

		return uv2(uv3, uv0(slot0, "steamid_remote is required"), slot1), uv4(slot1)
	end

	uv2.get_p2p_session_state = uv2.GetP2PSessionState
	slot8 = uv3(slot0, 7, "bool(__thiscall*)(void*, bool)")

	function uv2.AllowP2PPacketRelay(slot0)
		return uv0(uv1, slot0)
	end

	uv2.allow_p2p_packet_relay = uv2.AllowP2PPacketRelay
	slot9 = uv3(slot0, 8, "unsigned int(__thiscall*)(void*, int, SteamIPAddress_t, uint16_t, bool)")

	function uv2.CreateListenSocket(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.create_listen_socket = uv2.CreateListenSocket
	slot10 = uv3(slot0, 9, "unsigned int(__thiscall*)(void*, SteamID, int, int, bool)")

	function uv2.CreateP2PConnectionSocket(slot0, slot1, slot2, slot3)
		return uv1(uv2, uv0(slot0, "steamid_target is required"), slot1, slot2, slot3)
	end

	uv2.create_p2p_connection_socket = uv2.CreateP2PConnectionSocket
	slot11 = uv3(slot0, 10, "unsigned int(__thiscall*)(void*, SteamIPAddress_t, uint16_t, int)")

	function uv2.CreateConnectionSocket(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.create_connection_socket = uv2.CreateConnectionSocket
	slot12 = uv3(slot0, 11, "bool(__thiscall*)(void*, unsigned int, bool)")

	function uv2.DestroySocket(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.destroy_socket = uv2.DestroySocket
	slot13 = uv3(slot0, 12, "bool(__thiscall*)(void*, unsigned int, bool)")

	function uv2.DestroyListenSocket(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.destroy_listen_socket = uv2.DestroyListenSocket
	slot14 = uv3(slot0, 13, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, bool)")

	function uv2.SendDataOnSocket(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.send_data_on_socket = uv2.SendDataOnSocket
	slot15 = uv3(slot0, 14, "bool(__thiscall*)(void*, unsigned int, uint32_t *)")

	function uv2.IsDataAvailableOnSocket(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.is_data_available_on_socket = uv2.IsDataAvailableOnSocket
	slot16 = uv3(slot0, 15, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, uint32_t *)")

	function uv2.RetrieveDataFromSocket(slot0, slot1, slot2)
		slot3 = uv0()

		return uv1(uv2, slot0, slot1, slot2, slot3), uv3(slot3)
	end

	uv2.retrieve_data_from_socket = uv2.RetrieveDataFromSocket
	slot17 = uv3(slot0, 16, "bool(__thiscall*)(void*, unsigned int, uint32_t *, unsigned int *)")

	function uv2.IsDataAvailable(slot0)
		slot1 = uv0()
		slot2 = uv1()

		return uv2(uv3, slot0, slot1, slot2), uv4(slot1), uv4(slot2)
	end

	uv2.is_data_available = uv2.IsDataAvailable
	slot18 = uv3(slot0, 17, "bool(__thiscall*)(void*, unsigned int, void *, uint32_t, uint32_t *, unsigned int *)")

	function uv2.RetrieveData(slot0, slot1, slot2)
		slot3 = uv0()
		slot4 = uv1()

		return uv2(uv3, slot0, slot1, slot2, slot3, slot4), uv4(slot3), uv4(slot4)
	end

	uv2.retrieve_data = uv2.RetrieveData
	slot19 = uv3(slot0, 18, "bool(__thiscall*)(void*, unsigned int, SteamID *, int *, SteamIPAddress_t *, uint16_t *)")

	function uv2.GetSocketInfo(slot0, slot1)
		slot2 = uv0()
		slot3 = uv1.SteamIPAddress_t_arr(1)
		slot4 = uv2()

		return uv3(uv4, slot0, slot1, slot2, slot3, slot4), uv5(slot2), uv5(slot3), uv5(slot4)
	end

	uv2.get_socket_info = uv2.GetSocketInfo
	slot20 = uv3(slot0, 19, "bool(__thiscall*)(void*, unsigned int, SteamIPAddress_t *, uint16_t *)")

	function uv2.GetListenSocketInfo(slot0)
		slot1 = uv0.SteamIPAddress_t_arr(1)
		slot2 = uv1()

		return uv2(uv3, slot0, slot1, slot2), uv4(slot1), uv4(slot2)
	end

	uv2.get_listen_socket_info = uv2.GetListenSocketInfo
	slot21 = uv3(slot0, 20, "int(__thiscall*)(void*, unsigned int)")

	function uv2.GetSocketConnectionType(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_socket_connection_type = uv2.GetSocketConnectionType
	slot22 = uv3(slot0, 21, "int(__thiscall*)(void*, unsigned int)")

	function uv2.GetMaxPacketSize(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_max_packet_size = uv2.GetMaxPacketSize

	return uv2
end

slot155 = {
	version_number = 3,
	version = "STEAMSCREENSHOTS_INTERFACE_VERSION003"
}

function slot62.ISteamScreenshots()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 18, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMSCREENSHOTS_INTERFACE_VERSION003")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "unsigned int(__thiscall*)(void*, void *, uint32_t, int, int)")

	function uv2.WriteScreenshot(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.write_screenshot = uv2.WriteScreenshot
	slot2 = uv3(slot0, 1, "unsigned int(__thiscall*)(void*, const char *, const char *, int, int)")

	function uv2.AddScreenshotToLibrary(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.add_screenshot_to_library = uv2.AddScreenshotToLibrary
	slot3 = uv3(slot0, 2, "void(__thiscall*)(void*)")

	function uv2.TriggerScreenshot()
		return uv0(uv1)
	end

	uv2.trigger_screenshot = uv2.TriggerScreenshot
	slot4 = uv3(slot0, 3, "void(__thiscall*)(void*, bool)")

	function uv2.HookScreenshots(slot0)
		return uv0(uv1, slot0)
	end

	uv2.hook_screenshots = uv2.HookScreenshots
	slot5 = uv3(slot0, 4, "bool(__thiscall*)(void*, unsigned int, const char *)")

	function uv2.SetLocation(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_location = uv2.SetLocation
	slot6 = uv3(slot0, 5, "bool(__thiscall*)(void*, unsigned int, SteamID)")

	function uv2.TagUser(slot0, slot1)
		return uv1(uv2, slot0, uv0(slot1, "steamid is required"))
	end

	uv2.tag_user = uv2.TagUser
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, unsigned int, uint64_t)")

	function uv2.TagPublishedFile(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.tag_published_file = uv2.TagPublishedFile
	slot8 = uv3(slot0, 7, "bool(__thiscall*)(void*)")

	function uv2.IsScreenshotsHooked()
		return uv0(uv1)
	end

	uv2.is_screenshots_hooked = uv2.IsScreenshotsHooked
	slot9 = uv3(slot0, 8, "unsigned int(__thiscall*)(void*, int, const char *, const char *)")

	function uv2.AddVRScreenshotToLibrary(slot0, slot1, slot2)
		return uv2(uv3, uv0(slot0, uv1.EVRScreenshotType, "type is required"), slot1, slot2)
	end

	uv2.add_vr_screenshot_to_library = uv2.AddVRScreenshotToLibrary

	return uv2
end

slot156 = {
	version_number = 1,
	version = "STEAMMUSIC_INTERFACE_VERSION001"
}

function slot62.ISteamMusic()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 29, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMMUSIC_INTERFACE_VERSION001")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "bool(__thiscall*)(void*)")

	function uv2.BIsEnabled()
		return uv0(uv1)
	end

	uv2.is_enabled = uv2.BIsEnabled
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*)")

	function uv2.BIsPlaying()
		return uv0(uv1)
	end

	uv2.is_playing = uv2.BIsPlaying
	slot3 = uv3(slot0, 2, "int(__thiscall*)(void*)")

	function uv2.GetPlaybackStatus()
		return uv0(uv1)
	end

	uv2.get_playback_status = uv2.GetPlaybackStatus
	slot4 = uv3(slot0, 3, "void(__thiscall*)(void*)")

	function uv2.Play()
		return uv0(uv1)
	end

	uv2.play = uv2.Play
	slot5 = uv3(slot0, 4, "void(__thiscall*)(void*)")

	function uv2.Pause()
		return uv0(uv1)
	end

	uv2.pause = uv2.Pause
	slot6 = uv3(slot0, 5, "void(__thiscall*)(void*)")

	function uv2.PlayPrevious()
		return uv0(uv1)
	end

	uv2.play_previous = uv2.PlayPrevious
	slot7 = uv3(slot0, 6, "void(__thiscall*)(void*)")

	function uv2.PlayNext()
		return uv0(uv1)
	end

	uv2.play_next = uv2.PlayNext
	slot8 = uv3(slot0, 7, "void(__thiscall*)(void*, float)")

	function uv2.SetVolume(slot0)
		return uv0(uv1, slot0)
	end

	uv2.set_volume = uv2.SetVolume
	slot9 = uv3(slot0, 8, "float(__thiscall*)(void*)")

	function uv2.GetVolume()
		return uv0(uv1)
	end

	uv2.get_volume = uv2.GetVolume

	return uv2
end

slot157 = {
	version_number = 1,
	version = "STEAMMUSICREMOTE_INTERFACE_VERSION001"
}

function slot62.ISteamMusicRemote()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 30, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMMUSICREMOTE_INTERFACE_VERSION001")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "bool(__thiscall*)(void*, const char *)")

	function uv2.RegisterSteamMusicRemote(slot0)
		return uv0(uv1, slot0)
	end

	uv2.register_steam_music_remote = uv2.RegisterSteamMusicRemote
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*)")

	function uv2.DeregisterSteamMusicRemote()
		return uv0(uv1)
	end

	uv2.deregister_steam_music_remote = uv2.DeregisterSteamMusicRemote
	slot3 = uv3(slot0, 2, "bool(__thiscall*)(void*)")

	function uv2.BIsCurrentMusicRemote()
		return uv0(uv1)
	end

	uv2.is_current_music_remote = uv2.BIsCurrentMusicRemote
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*, bool)")

	function uv2.BActivationSuccess(slot0)
		return uv0(uv1, slot0)
	end

	uv2.activation_success = uv2.BActivationSuccess
	slot5 = uv3(slot0, 4, "bool(__thiscall*)(void*, const char *)")

	function uv2.SetDisplayName(slot0)
		return uv0(uv1, slot0)
	end

	uv2.set_display_name = uv2.SetDisplayName
	slot6 = uv3(slot0, 5, "bool(__thiscall*)(void*, void *, uint32_t)")

	function uv2.SetPNGIcon_64x64(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_png_icon_64x64 = uv2.SetPNGIcon_64x64
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, bool)")

	function uv2.EnablePlayPrevious(slot0)
		return uv0(uv1, slot0)
	end

	uv2.enable_play_previous = uv2.EnablePlayPrevious
	slot8 = uv3(slot0, 7, "bool(__thiscall*)(void*, bool)")

	function uv2.EnablePlayNext(slot0)
		return uv0(uv1, slot0)
	end

	uv2.enable_play_next = uv2.EnablePlayNext
	slot9 = uv3(slot0, 8, "bool(__thiscall*)(void*, bool)")

	function uv2.EnableShuffled(slot0)
		return uv0(uv1, slot0)
	end

	uv2.enable_shuffled = uv2.EnableShuffled
	slot10 = uv3(slot0, 9, "bool(__thiscall*)(void*, bool)")

	function uv2.EnableLooped(slot0)
		return uv0(uv1, slot0)
	end

	uv2.enable_looped = uv2.EnableLooped
	slot11 = uv3(slot0, 10, "bool(__thiscall*)(void*, bool)")

	function uv2.EnableQueue(slot0)
		return uv0(uv1, slot0)
	end

	uv2.enable_queue = uv2.EnableQueue
	slot12 = uv3(slot0, 11, "bool(__thiscall*)(void*, bool)")

	function uv2.EnablePlaylists(slot0)
		return uv0(uv1, slot0)
	end

	uv2.enable_playlists = uv2.EnablePlaylists
	slot13 = uv3(slot0, 12, "bool(__thiscall*)(void*, int)")

	function uv2.UpdatePlaybackStatus(slot0)
		return uv2(uv3, uv0(slot0, uv1.AudioPlayback_Status, "status is required"))
	end

	uv2.update_playback_status = uv2.UpdatePlaybackStatus
	slot14 = uv3(slot0, 13, "bool(__thiscall*)(void*, bool)")

	function uv2.UpdateShuffled(slot0)
		return uv0(uv1, slot0)
	end

	uv2.update_shuffled = uv2.UpdateShuffled
	slot15 = uv3(slot0, 14, "bool(__thiscall*)(void*, bool)")

	function uv2.UpdateLooped(slot0)
		return uv0(uv1, slot0)
	end

	uv2.update_looped = uv2.UpdateLooped
	slot16 = uv3(slot0, 15, "bool(__thiscall*)(void*, float)")

	function uv2.UpdateVolume(slot0)
		return uv0(uv1, slot0)
	end

	uv2.update_volume = uv2.UpdateVolume
	slot17 = uv3(slot0, 16, "bool(__thiscall*)(void*)")

	function uv2.CurrentEntryWillChange()
		return uv0(uv1)
	end

	uv2.current_entry_will_change = uv2.CurrentEntryWillChange
	slot18 = uv3(slot0, 17, "bool(__thiscall*)(void*, bool)")

	function uv2.CurrentEntryIsAvailable(slot0)
		return uv0(uv1, slot0)
	end

	uv2.current_entry_is_available = uv2.CurrentEntryIsAvailable
	slot19 = uv3(slot0, 18, "bool(__thiscall*)(void*, const char *)")

	function uv2.UpdateCurrentEntryText(slot0)
		return uv0(uv1, slot0)
	end

	uv2.update_current_entry_text = uv2.UpdateCurrentEntryText
	slot20 = uv3(slot0, 19, "bool(__thiscall*)(void*, int)")

	function uv2.UpdateCurrentEntryElapsedSeconds(slot0)
		return uv0(uv1, slot0)
	end

	uv2.update_current_entry_elapsed_seconds = uv2.UpdateCurrentEntryElapsedSeconds
	slot21 = uv3(slot0, 20, "bool(__thiscall*)(void*, void *, uint32_t)")

	function uv2.UpdateCurrentEntryCoverArt(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.update_current_entry_cover_art = uv2.UpdateCurrentEntryCoverArt
	slot22 = uv3(slot0, 21, "bool(__thiscall*)(void*)")

	function uv2.CurrentEntryDidChange()
		return uv0(uv1)
	end

	uv2.current_entry_did_change = uv2.CurrentEntryDidChange
	slot23 = uv3(slot0, 22, "bool(__thiscall*)(void*)")

	function uv2.QueueWillChange()
		return uv0(uv1)
	end

	uv2.queue_will_change = uv2.QueueWillChange
	slot24 = uv3(slot0, 23, "bool(__thiscall*)(void*)")

	function uv2.ResetQueueEntries()
		return uv0(uv1)
	end

	uv2.reset_queue_entries = uv2.ResetQueueEntries
	slot25 = uv3(slot0, 24, "bool(__thiscall*)(void*, int, int, const char *)")

	function uv2.SetQueueEntry(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.set_queue_entry = uv2.SetQueueEntry
	slot26 = uv3(slot0, 25, "bool(__thiscall*)(void*, int)")

	function uv2.SetCurrentQueueEntry(slot0)
		return uv0(uv1, slot0)
	end

	uv2.set_current_queue_entry = uv2.SetCurrentQueueEntry
	slot27 = uv3(slot0, 26, "bool(__thiscall*)(void*)")

	function uv2.QueueDidChange()
		return uv0(uv1)
	end

	uv2.queue_did_change = uv2.QueueDidChange
	slot28 = uv3(slot0, 27, "bool(__thiscall*)(void*)")

	function uv2.PlaylistWillChange()
		return uv0(uv1)
	end

	uv2.playlist_will_change = uv2.PlaylistWillChange
	slot29 = uv3(slot0, 28, "bool(__thiscall*)(void*)")

	function uv2.ResetPlaylistEntries()
		return uv0(uv1)
	end

	uv2.reset_playlist_entries = uv2.ResetPlaylistEntries
	slot30 = uv3(slot0, 29, "bool(__thiscall*)(void*, int, int, const char *)")

	function uv2.SetPlaylistEntry(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.set_playlist_entry = uv2.SetPlaylistEntry
	slot31 = uv3(slot0, 30, "bool(__thiscall*)(void*, int)")

	function uv2.SetCurrentPlaylistEntry(slot0)
		return uv0(uv1, slot0)
	end

	uv2.set_current_playlist_entry = uv2.SetCurrentPlaylistEntry
	slot32 = uv3(slot0, 31, "bool(__thiscall*)(void*)")

	function uv2.PlaylistDidChange()
		return uv0(uv1)
	end

	uv2.playlist_did_change = uv2.PlaylistDidChange

	return uv2
end

slot158 = {
	version_number = 3,
	version = "STEAMHTTP_INTERFACE_VERSION003"
}

function slot62.ISteamHTTP()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 24, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMHTTP_INTERFACE_VERSION003")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "unsigned int(__thiscall*)(void*, int, const char *)")

	function uv2.CreateHTTPRequest(slot0, slot1)
		return uv2(uv3, uv0(slot0, uv1.EHTTPMethod, "http_request_method is required"), slot1)
	end

	uv2.create_http_request = uv2.CreateHTTPRequest
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*, unsigned int, uint64_t)")

	function uv2.SetHTTPRequestContextValue(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_http_request_context_value = uv2.SetHTTPRequestContextValue
	slot3 = uv3(slot0, 2, "bool(__thiscall*)(void*, unsigned int, uint32_t)")

	function uv2.SetHTTPRequestNetworkActivityTimeout(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_http_request_network_activity_timeout = uv2.SetHTTPRequestNetworkActivityTimeout
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function uv2.SetHTTPRequestHeaderValue(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.set_http_request_header_value = uv2.SetHTTPRequestHeaderValue
	slot5 = uv3(slot0, 4, "bool(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function uv2.SetHTTPRequestGetOrPostParameter(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.set_http_request_get_or_post_parameter = uv2.SetHTTPRequestGetOrPostParameter
	slot6 = uv3(slot0, 5, "bool(__thiscall*)(void*, unsigned int, uint64_t *)")
	slot7 = {
		struct = uv6([[
			struct {
				unsigned int m_hRequest;
				uint64_t m_ulContextValue;
				bool m_bRequestSuccessful;
				int m_eStatusCode;
				uint32_t m_unBodySize;
			} *
		]]),
		keys = {
			m_hRequest = "request",
			m_unBodySize = "body_size",
			m_eStatusCode = "status_code",
			m_bRequestSuccessful = "request_successful",
			m_ulContextValue = "context_value"
		}
	}

	function uv2.SendHTTPRequest(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		slot3 = uv3(uv4, slot0, uv2())

		if slot1 ~= nil then
			slot2 = uv5(slot2, slot1, 2101, uv6)
		end

		return slot3, uv7(slot2)
	end

	uv2.send_http_request = uv2.SendHTTPRequest
	slot8 = uv3(slot0, 6, "bool(__thiscall*)(void*, unsigned int, uint64_t *)")
	slot9 = {
		struct = uv6([[
			struct {
				unsigned int m_hRequest;
				uint64_t m_ulContextValue;
				bool m_bRequestSuccessful;
				int m_eStatusCode;
				uint32_t m_unBodySize;
			} *
		]]),
		keys = {
			m_hRequest = "request",
			m_unBodySize = "body_size",
			m_eStatusCode = "status_code",
			m_bRequestSuccessful = "request_successful",
			m_ulContextValue = "context_value"
		}
	}

	function uv2.SendHTTPRequestAndStreamResponse(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		slot3 = uv3(uv4, slot0, uv2())

		if slot1 ~= nil then
			slot2 = uv5(slot2, slot1, 2101, uv6)
		end

		return slot3, uv7(slot2)
	end

	uv2.send_http_request_and_stream_response = uv2.SendHTTPRequestAndStreamResponse
	slot10 = uv3(slot0, 7, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.DeferHTTPRequest(slot0)
		return uv0(uv1, slot0)
	end

	uv2.defer_http_request = uv2.DeferHTTPRequest
	slot11 = uv3(slot0, 8, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.PrioritizeHTTPRequest(slot0)
		return uv0(uv1, slot0)
	end

	uv2.prioritize_http_request = uv2.PrioritizeHTTPRequest
	slot12 = uv3(slot0, 9, "bool(__thiscall*)(void*, unsigned int, const char *, uint32_t *)")

	function uv2.GetHTTPResponseHeaderSize(slot0, slot1)
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot2)
	end

	uv2.get_http_response_header_size = uv2.GetHTTPResponseHeaderSize
	slot13 = uv3(slot0, 10, "bool(__thiscall*)(void*, unsigned int, const char *, uint8_t *, uint32_t)")

	function uv2.GetHTTPResponseHeaderValue(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.get_http_response_header_value = uv2.GetHTTPResponseHeaderValue
	slot14 = uv3(slot0, 11, "bool(__thiscall*)(void*, unsigned int, uint32_t *)")

	function uv2.GetHTTPResponseBodySize(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_http_response_body_size = uv2.GetHTTPResponseBodySize
	slot15 = uv3(slot0, 12, "bool(__thiscall*)(void*, unsigned int, uint8_t *, uint32_t)")

	function uv2.GetHTTPResponseBodyData(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_http_response_body_data = uv2.GetHTTPResponseBodyData
	slot16 = uv3(slot0, 13, "bool(__thiscall*)(void*, unsigned int, uint32_t, uint8_t *, uint32_t)")

	function uv2.GetHTTPStreamingResponseBodyData(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.get_http_streaming_response_body_data = uv2.GetHTTPStreamingResponseBodyData
	slot17 = uv3(slot0, 14, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.ReleaseHTTPRequest(slot0)
		return uv0(uv1, slot0)
	end

	uv2.release_http_request = uv2.ReleaseHTTPRequest
	slot18 = uv3(slot0, 15, "bool(__thiscall*)(void*, unsigned int, float *)")

	function uv2.GetHTTPDownloadProgressPct(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_http_download_progress_pct = uv2.GetHTTPDownloadProgressPct
	slot19 = uv3(slot0, 16, "bool(__thiscall*)(void*, unsigned int, const char *, uint8_t *, uint32_t)")

	function uv2.SetHTTPRequestRawPostBody(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.set_http_request_raw_post_body = uv2.SetHTTPRequestRawPostBody
	slot20 = uv3(slot0, 17, "unsigned int(__thiscall*)(void*, bool)")

	function uv2.CreateCookieContainer(slot0)
		return uv0(uv1, slot0)
	end

	uv2.create_cookie_container = uv2.CreateCookieContainer
	slot21 = uv3(slot0, 18, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.ReleaseCookieContainer(slot0)
		return uv0(uv1, slot0)
	end

	uv2.release_cookie_container = uv2.ReleaseCookieContainer
	slot22 = uv3(slot0, 19, "bool(__thiscall*)(void*, unsigned int, const char *, const char *, const char *)")

	function uv2.SetCookie(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.set_cookie = uv2.SetCookie
	slot23 = uv3(slot0, 20, "bool(__thiscall*)(void*, unsigned int, unsigned int)")

	function uv2.SetHTTPRequestCookieContainer(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_http_request_cookie_container = uv2.SetHTTPRequestCookieContainer
	slot24 = uv3(slot0, 21, "bool(__thiscall*)(void*, unsigned int, const char *)")

	function uv2.SetHTTPRequestUserAgentInfo(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_http_request_user_agent_info = uv2.SetHTTPRequestUserAgentInfo
	slot25 = uv3(slot0, 22, "bool(__thiscall*)(void*, unsigned int, bool)")

	function uv2.SetHTTPRequestRequiresVerifiedCertificate(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_http_request_requires_verified_certificate = uv2.SetHTTPRequestRequiresVerifiedCertificate
	slot26 = uv3(slot0, 23, "bool(__thiscall*)(void*, unsigned int, uint32_t)")

	function uv2.SetHTTPRequestAbsoluteTimeoutMS(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_http_request_absolute_timeout_ms = uv2.SetHTTPRequestAbsoluteTimeoutMS
	slot27 = uv3(slot0, 24, "bool(__thiscall*)(void*, unsigned int, bool *)")

	function uv2.GetHTTPRequestWasTimedOut(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.get_http_request_was_timed_out = uv2.GetHTTPRequestWasTimedOut

	return uv2
end

slot159 = {
	version_number = 16,
	version = "STEAMUGC_INTERFACE_VERSION016"
}

function slot62.ISteamUGC()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 27, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMUGC_INTERFACE_VERSION016")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "void(__thiscall*)(void*, uint64_t *, unsigned int, int, int, int, unsigned int, unsigned int, uint32_t)")

	function uv2.CreateQueryUserUGCRequest(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		slot7 = uv2()

		uv3(uv4, slot7, slot0, uv0(slot1, uv1.EUserUGCList, "list_type is required"), uv0(slot2, uv1.EUGCMatchingUGCType, "matching_ugc_type is required"), uv0(slot3, uv1.EUserUGCListSortOrder, "sort_order is required"), slot4, slot5, slot6)

		return uv5(slot7)
	end

	uv2.create_query_user_ugc_request = uv2.CreateQueryUserUGCRequest
	slot2 = uv3(slot0, 1, "void(__thiscall*)(void*, uint64_t *, int, int, unsigned int, unsigned int, uint32_t)")

	function uv2.CreateQueryAllUGCRequestPage(slot0, slot1, slot2, slot3, slot4)
		slot5 = uv2()

		uv3(uv4, slot5, uv0(slot0, uv1.EUGCQuery, "query_type is required"), uv0(slot1, uv1.EUGCMatchingUGCType, "matchinge_matching_ugc_type_file_type is required"), slot2, slot3, slot4)

		return uv5(slot5)
	end

	uv2.create_query_all_ugc_request_page = uv2.CreateQueryAllUGCRequestPage
	slot3 = uv3(slot0, 2, "void(__thiscall*)(void*, uint64_t *, int, int, unsigned int, unsigned int, const char *)")

	function uv2.CreateQueryAllUGCRequestCursor(slot0, slot1, slot2, slot3, slot4)
		slot5 = uv2()

		uv3(uv4, slot5, uv0(slot0, uv1.EUGCQuery, "query_type is required"), uv0(slot1, uv1.EUGCMatchingUGCType, "matchinge_matching_ugc_type_file_type is required"), slot2, slot3, slot4)

		return uv5(slot5)
	end

	uv2.create_query_all_ugc_request_cursor = uv2.CreateQueryAllUGCRequestCursor
	slot4 = uv3(slot0, 3, "void(__thiscall*)(void*, uint64_t *, uint64_t *, uint32_t)")

	function uv2.CreateQueryUGCDetailsRequest(slot0, slot1)
		slot2 = uv0()

		uv1(uv2, slot2, slot0, slot1)

		return uv3(slot2)
	end

	uv2.create_query_ugc_details_request = uv2.CreateQueryUGCDetailsRequest
	slot5 = uv3(slot0, 4, "uint64_t(__thiscall*)(void*, uint64_t)")
	slot6 = {
		struct = uv8([[
			struct {
				uint64_t m_handle;
				int m_eResult;
				uint32_t m_unNumResultsReturned;
				uint32_t m_unTotalMatchingResults;
				bool m_bCachedData;
				char m_rgchNextCursor[256];
			} *
		]]),
		keys = {
			m_unTotalMatchingResults = "total_matching_results",
			m_unNumResultsReturned = "num_results_returned",
			m_eResult = "result",
			m_rgchNextCursor = "next_cursor",
			m_bCachedData = "cached_data",
			m_handle = "handle"
		}
	}

	function uv2.SendQueryUGCRequest(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 3401, uv5)
		end

		return slot2
	end

	uv2.send_query_ugc_request = uv2.SendQueryUGCRequest
	slot7 = uv3(slot0, 5, "bool(__thiscall*)(void*, uint64_t, uint32_t, SteamUGCDetails_t *)")

	function uv2.GetQueryUGCResult(slot0, slot1)
		slot2 = uv0.SteamUGCDetails_t_arr(1)

		return uv1(uv2, slot0, slot1, slot2), uv3(slot2)
	end

	uv2.get_query_ugc_result = uv2.GetQueryUGCResult
	slot8 = uv3(slot0, 6, "uint32_t(__thiscall*)(void*, uint64_t, uint32_t)")

	function uv2.GetQueryUGCNumTags(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_query_ugc_num_tags = uv2.GetQueryUGCNumTags
	slot9 = uv3(slot0, 7, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t)")

	function uv2.GetQueryUGCTag(slot0, slot1, slot2, slot3, slot4)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4)
	end

	uv2.get_query_ugc_tag = uv2.GetQueryUGCTag
	slot10 = uv3(slot0, 8, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t)")

	function uv2.GetQueryUGCTagDisplayName(slot0, slot1, slot2, slot3, slot4)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4)
	end

	uv2.get_query_ugc_tag_display_name = uv2.GetQueryUGCTagDisplayName
	slot11 = uv3(slot0, 9, "bool(__thiscall*)(void*, uint64_t, uint32_t, char *, uint32_t)")

	function uv2.GetQueryUGCPreviewURL(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.get_query_ugc_preview_url = uv2.GetQueryUGCPreviewURL
	slot12 = uv3(slot0, 10, "bool(__thiscall*)(void*, uint64_t, uint32_t, char *, uint32_t)")

	function uv2.GetQueryUGCMetadata(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.get_query_ugc_metadata = uv2.GetQueryUGCMetadata
	slot13 = uv3(slot0, 11, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint64_t *, uint32_t)")

	function uv2.GetQueryUGCChildren(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.get_query_ugc_children = uv2.GetQueryUGCChildren
	slot14 = uv3(slot0, 12, "bool(__thiscall*)(void*, uint64_t, uint32_t, int, uint64_t *)")

	function uv2.GetQueryUGCStatistic(slot0, slot1, slot2)
		slot3 = uv2()

		return uv3(uv4, slot0, slot1, uv0(slot2, uv1.EItemStatistic, "stat_type is required"), slot3), uv5(slot3)
	end

	uv2.get_query_ugc_statistic = uv2.GetQueryUGCStatistic
	slot15 = uv3(slot0, 13, "uint32_t(__thiscall*)(void*, uint64_t, uint32_t)")

	function uv2.GetQueryUGCNumAdditionalPreviews(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_query_ugc_num_additional_previews = uv2.GetQueryUGCNumAdditionalPreviews
	slot16 = uv3(slot0, 14, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t, char *, uint32_t, int *)")

	function uv2.GetQueryUGCAdditionalPreview(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		slot7 = uv0()

		return uv1(uv2, slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7), uv3(slot7)
	end

	uv2.get_query_ugc_additional_preview = uv2.GetQueryUGCAdditionalPreview
	slot17 = uv3(slot0, 15, "uint32_t(__thiscall*)(void*, uint64_t, uint32_t)")

	function uv2.GetQueryUGCNumKeyValueTags(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_query_ugc_num_key_value_tags = uv2.GetQueryUGCNumKeyValueTags
	slot18 = uv3(slot0, 16, "bool(__thiscall*)(void*, uint64_t, uint32_t, uint32_t, char *, uint32_t, char *, uint32_t)")

	function uv2.GetQueryUGCKeyValueTag(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	end

	uv2.get_query_ugc_key_value_tag = uv2.GetQueryUGCKeyValueTag
	slot19 = uv3(slot0, 17, "bool(__thiscall*)(void*, uint64_t, uint32_t, const char *, char *, uint32_t)")

	function uv2.GetQueryFirstUGCKeyValueTag(slot0, slot1, slot2, slot3, slot4)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4)
	end

	uv2.get_query_first_ugc_key_value_tag = uv2.GetQueryFirstUGCKeyValueTag
	slot20 = uv3(slot0, 18, "bool(__thiscall*)(void*, uint64_t)")

	function uv2.ReleaseQueryUGCRequest(slot0)
		return uv0(uv1, slot0)
	end

	uv2.release_query_ugc_request = uv2.ReleaseQueryUGCRequest
	slot21 = uv3(slot0, 19, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.AddRequiredTag(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.add_required_tag = uv2.AddRequiredTag
	slot22 = uv3(slot0, 20, "bool(__thiscall*)(void*, uint64_t, const SteamParamStringArray_t *)")

	function uv2.AddRequiredTagGroup(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.add_required_tag_group = uv2.AddRequiredTagGroup
	slot23 = uv3(slot0, 21, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.AddExcludedTag(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.add_excluded_tag = uv2.AddExcludedTag
	slot24 = uv3(slot0, 22, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetReturnOnlyIDs(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_only_ids = uv2.SetReturnOnlyIDs
	slot25 = uv3(slot0, 23, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetReturnKeyValueTags(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_key_value_tags = uv2.SetReturnKeyValueTags
	slot26 = uv3(slot0, 24, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetReturnLongDescription(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_long_description = uv2.SetReturnLongDescription
	slot27 = uv3(slot0, 25, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetReturnMetadata(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_metadata = uv2.SetReturnMetadata
	slot28 = uv3(slot0, 26, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetReturnChildren(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_children = uv2.SetReturnChildren
	slot29 = uv3(slot0, 27, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetReturnAdditionalPreviews(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_additional_previews = uv2.SetReturnAdditionalPreviews
	slot30 = uv3(slot0, 28, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetReturnTotalOnly(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_total_only = uv2.SetReturnTotalOnly
	slot31 = uv3(slot0, 29, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function uv2.SetReturnPlaytimeStats(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_return_playtime_stats = uv2.SetReturnPlaytimeStats
	slot32 = uv3(slot0, 30, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetLanguage(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_language = uv2.SetLanguage
	slot33 = uv3(slot0, 31, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function uv2.SetAllowCachedResponse(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_allow_cached_response = uv2.SetAllowCachedResponse
	slot34 = uv3(slot0, 32, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetCloudFileNameFilter(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_cloud_file_name_filter = uv2.SetCloudFileNameFilter
	slot35 = uv3(slot0, 33, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetMatchAnyTag(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_match_any_tag = uv2.SetMatchAnyTag
	slot36 = uv3(slot0, 34, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetSearchText(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_search_text = uv2.SetSearchText
	slot37 = uv3(slot0, 35, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function uv2.SetRankedByTrendDays(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_ranked_by_trend_days = uv2.SetRankedByTrendDays
	slot38 = uv3(slot0, 36, "bool(__thiscall*)(void*, uint64_t, unsigned int, unsigned int)")

	function uv2.SetTimeCreatedDateRange(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.set_time_created_date_range = uv2.SetTimeCreatedDateRange
	slot39 = uv3(slot0, 37, "bool(__thiscall*)(void*, uint64_t, unsigned int, unsigned int)")

	function uv2.SetTimeUpdatedDateRange(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.set_time_updated_date_range = uv2.SetTimeUpdatedDateRange
	slot40 = uv3(slot0, 38, "bool(__thiscall*)(void*, uint64_t, const char *, const char *)")

	function uv2.AddRequiredKeyValueTag(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.add_required_key_value_tag = uv2.AddRequiredKeyValueTag
	slot41 = uv3(slot0, 39, "uint64_t(__thiscall*)(void*, uint64_t, uint32_t)")
	slot42 = {
		struct = uv8([[
			struct {
				SteamUGCDetails_t m_details;
				bool m_bCachedData;
			} *
		]]),
		keys = {
			m_details = "details",
			m_bCachedData = "cached_data"
		}
	}

	function uv2.RequestUGCDetails(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3402, uv5)
		end

		return slot3
	end

	uv2.request_ugc_details = uv2.RequestUGCDetails
	slot43 = uv3(slot0, 40, "uint64_t(__thiscall*)(void*, unsigned int, int)")
	slot44 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
				bool m_bUserNeedsToAcceptWorkshopLegalAgreement;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_bUserNeedsToAcceptWorkshopLegalAgreement = "user_needs_to_accept_workshop_legal_agreement",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.CreateItem(slot0, slot1, slot2)
		slot1 = uv0(slot1, uv1.EWorkshopFileType, "file_type is required")

		if slot2 ~= nil and not uv2(slot2) then
			return uv3("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv6(uv4(uv5, slot0, slot1), slot2, 3403, uv7)
		end

		return slot3
	end

	uv2.create_item = uv2.CreateItem
	slot45 = uv3(slot0, 41, "void(__thiscall*)(void*, uint64_t *, unsigned int, uint64_t)")

	function uv2.StartItemUpdate(slot0, slot1)
		slot2 = uv0()

		uv1(uv2, slot2, slot0, slot1)

		return uv3(slot2)
	end

	uv2.start_item_update = uv2.StartItemUpdate
	slot46 = uv3(slot0, 42, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetItemTitle(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_item_title = uv2.SetItemTitle
	slot47 = uv3(slot0, 43, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetItemDescription(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_item_description = uv2.SetItemDescription
	slot48 = uv3(slot0, 44, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetItemUpdateLanguage(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_item_update_language = uv2.SetItemUpdateLanguage
	slot49 = uv3(slot0, 45, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetItemMetadata(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_item_metadata = uv2.SetItemMetadata
	slot50 = uv3(slot0, 46, "bool(__thiscall*)(void*, uint64_t, int)")

	function uv2.SetItemVisibility(slot0, slot1)
		return uv2(uv3, slot0, uv0(slot1, uv1.ERemoteStoragePublishedFileVisibility, "visibility is required"))
	end

	uv2.set_item_visibility = uv2.SetItemVisibility
	slot51 = uv3(slot0, 47, "bool(__thiscall*)(void*, uint64_t, const SteamParamStringArray_t *)")

	function uv2.SetItemTags(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_item_tags = uv2.SetItemTags
	slot52 = uv3(slot0, 48, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetItemContent(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_item_content = uv2.SetItemContent
	slot53 = uv3(slot0, 49, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.SetItemPreview(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_item_preview = uv2.SetItemPreview
	slot54 = uv3(slot0, 50, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.SetAllowLegacyUpload(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_allow_legacy_upload = uv2.SetAllowLegacyUpload
	slot55 = uv3(slot0, 51, "bool(__thiscall*)(void*, uint64_t)")

	function uv2.RemoveAllItemKeyValueTags(slot0)
		return uv0(uv1, slot0)
	end

	uv2.remove_all_item_key_value_tags = uv2.RemoveAllItemKeyValueTags
	slot56 = uv3(slot0, 52, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.RemoveItemKeyValueTags(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.remove_item_key_value_tags = uv2.RemoveItemKeyValueTags
	slot57 = uv3(slot0, 53, "bool(__thiscall*)(void*, uint64_t, const char *, const char *)")

	function uv2.AddItemKeyValueTag(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.add_item_key_value_tag = uv2.AddItemKeyValueTag
	slot58 = uv3(slot0, 54, "bool(__thiscall*)(void*, uint64_t, const char *, int)")

	function uv2.AddItemPreviewFile(slot0, slot1, slot2)
		return uv2(uv3, slot0, slot1, uv0(slot2, uv1.EItemPreviewType, "type is required"))
	end

	uv2.add_item_preview_file = uv2.AddItemPreviewFile
	slot59 = uv3(slot0, 55, "bool(__thiscall*)(void*, uint64_t, const char *)")

	function uv2.AddItemPreviewVideo(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.add_item_preview_video = uv2.AddItemPreviewVideo
	slot60 = uv3(slot0, 56, "bool(__thiscall*)(void*, uint64_t, uint32_t, const char *)")

	function uv2.UpdateItemPreviewFile(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.update_item_preview_file = uv2.UpdateItemPreviewFile
	slot61 = uv3(slot0, 57, "bool(__thiscall*)(void*, uint64_t, uint32_t, const char *)")

	function uv2.UpdateItemPreviewVideo(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.update_item_preview_video = uv2.UpdateItemPreviewVideo
	slot62 = uv3(slot0, 58, "bool(__thiscall*)(void*, uint64_t, uint32_t)")

	function uv2.RemoveItemPreview(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.remove_item_preview = uv2.RemoveItemPreview
	slot63 = uv3(slot0, 59, "uint64_t(__thiscall*)(void*, uint64_t, const char *)")
	slot64 = {
		struct = uv8([[
			struct {
				int m_eResult;
				bool m_bUserNeedsToAcceptWorkshopLegalAgreement;
				uint64_t m_nPublishedFileId;
			} *
		]]),
		keys = {
			m_nPublishedFileId = "published_file_id",
			m_bUserNeedsToAcceptWorkshopLegalAgreement = "user_needs_to_accept_workshop_legal_agreement",
			m_eResult = "result"
		}
	}

	function uv2.SubmitItemUpdate(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3404, uv5)
		end

		return slot3
	end

	uv2.submit_item_update = uv2.SubmitItemUpdate
	slot65 = uv3(slot0, 60, "int(__thiscall*)(void*, uint64_t, uint64_t *, uint64_t *)")

	function uv2.GetItemUpdateProgress(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv2.get_item_update_progress = uv2.GetItemUpdateProgress
	slot66 = uv3(slot0, 61, "uint64_t(__thiscall*)(void*, uint64_t, bool)")
	slot67 = {
		struct = uv8([[
			struct {
				uint64_t m_nPublishedFileId;
				int m_eResult;
				bool m_bVoteUp;
			} *
		]]),
		keys = {
			m_bVoteUp = "vote_up",
			m_nPublishedFileId = "published_file_id",
			m_eResult = "result"
		}
	}

	function uv2.SetUserItemVote(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3408, uv5)
		end

		return slot3
	end

	uv2.set_user_item_vote = uv2.SetUserItemVote
	slot68 = uv3(slot0, 62, "uint64_t(__thiscall*)(void*, uint64_t)")
	slot69 = {
		struct = uv8([[
			struct {
				uint64_t m_nPublishedFileId;
				int m_eResult;
				bool m_bVotedUp;
				bool m_bVotedDown;
				bool m_bVoteSkipped;
			} *
		]]),
		keys = {
			m_bVoteSkipped = "vote_skipped",
			m_eResult = "result",
			m_bVotedDown = "voted_down",
			m_bVotedUp = "voted_up",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.GetUserItemVote(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 3409, uv5)
		end

		return slot2
	end

	uv2.get_user_item_vote = uv2.GetUserItemVote
	slot70 = uv3(slot0, 63, "uint64_t(__thiscall*)(void*, unsigned int, uint64_t)")
	slot71 = {
		struct = uv8([[
			struct {
				uint64_t m_nPublishedFileId;
				int m_eResult;
				bool m_bWasAddRequest;
			} *
		]]),
		keys = {
			m_bWasAddRequest = "was_add_request",
			m_nPublishedFileId = "published_file_id",
			m_eResult = "result"
		}
	}

	function uv2.AddItemToFavorites(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3407, uv5)
		end

		return slot3
	end

	uv2.add_item_to_favorites = uv2.AddItemToFavorites
	slot72 = uv3(slot0, 64, "uint64_t(__thiscall*)(void*, unsigned int, uint64_t)")
	slot73 = {
		struct = uv8([[
			struct {
				uint64_t m_nPublishedFileId;
				int m_eResult;
				bool m_bWasAddRequest;
			} *
		]]),
		keys = {
			m_bWasAddRequest = "was_add_request",
			m_nPublishedFileId = "published_file_id",
			m_eResult = "result"
		}
	}

	function uv2.RemoveItemFromFavorites(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3407, uv5)
		end

		return slot3
	end

	uv2.remove_item_from_favorites = uv2.RemoveItemFromFavorites
	slot74 = uv3(slot0, 65, "uint64_t(__thiscall*)(void*, uint64_t)")
	slot75 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.SubscribeItem(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 1313, uv5)
		end

		return slot2
	end

	uv2.subscribe_item = uv2.SubscribeItem
	slot76 = uv3(slot0, 66, "uint64_t(__thiscall*)(void*, uint64_t)")
	slot77 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.UnsubscribeItem(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 1315, uv5)
		end

		return slot2
	end

	uv2.unsubscribe_item = uv2.UnsubscribeItem
	slot78 = uv3(slot0, 67, "uint32_t(__thiscall*)(void*)")

	function uv2.GetNumSubscribedItems()
		return uv0(uv1)
	end

	uv2.get_num_subscribed_items = uv2.GetNumSubscribedItems
	slot79 = uv3(slot0, 68, "uint32_t(__thiscall*)(void*, uint64_t *, uint32_t)")

	function uv2.GetSubscribedItems(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_subscribed_items = uv2.GetSubscribedItems
	slot80 = uv3(slot0, 69, "uint32_t(__thiscall*)(void*, uint64_t)")

	function uv2.GetItemState(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_item_state = uv2.GetItemState
	slot81 = uv3(slot0, 70, "bool(__thiscall*)(void*, uint64_t, uint64_t *, char *, uint32_t, uint32_t *)")

	function uv2.GetItemInstallInfo(slot0, slot1, slot2)
		slot3 = uv0()
		slot4 = uv1()

		return uv2(uv3, slot0, slot3, slot1, slot2, slot4), uv4(slot3), uv4(slot4)
	end

	uv2.get_item_install_info = uv2.GetItemInstallInfo
	slot82 = uv3(slot0, 71, "bool(__thiscall*)(void*, uint64_t, uint64_t *, uint64_t *)")

	function uv2.GetItemDownloadInfo(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv2.get_item_download_info = uv2.GetItemDownloadInfo
	slot83 = uv3(slot0, 72, "bool(__thiscall*)(void*, uint64_t, bool)")

	function uv2.DownloadItem(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.download_item = uv2.DownloadItem
	slot84 = uv3(slot0, 73, "bool(__thiscall*)(void*, unsigned int, const char *)")

	function uv2.BInitWorkshopForGameServer(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.init_workshop_for_game_server = uv2.BInitWorkshopForGameServer
	slot85 = uv3(slot0, 74, "void(__thiscall*)(void*, bool)")

	function uv2.SuspendDownloads(slot0)
		return uv0(uv1, slot0)
	end

	uv2.suspend_downloads = uv2.SuspendDownloads
	slot86 = uv3(slot0, 75, "uint64_t(__thiscall*)(void*, uint64_t *, uint32_t)")
	slot87 = {
		struct = uv8([[
			struct {
				int m_eResult;
			} *
		]]),
		keys = {
			m_eResult = "result"
		}
	}

	function uv2.StartPlaytimeTracking(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3410, uv5)
		end

		return slot3
	end

	uv2.start_playtime_tracking = uv2.StartPlaytimeTracking
	slot88 = uv3(slot0, 76, "uint64_t(__thiscall*)(void*, uint64_t *, uint32_t)")
	slot89 = {
		struct = uv8([[
			struct {
				int m_eResult;
			} *
		]]),
		keys = {
			m_eResult = "result"
		}
	}

	function uv2.StopPlaytimeTracking(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3411, uv5)
		end

		return slot3
	end

	uv2.stop_playtime_tracking = uv2.StopPlaytimeTracking
	slot90 = uv3(slot0, 77, "uint64_t(__thiscall*)(void*)")
	slot91 = {
		struct = uv8([[
			struct {
				int m_eResult;
			} *
		]]),
		keys = {
			m_eResult = "result"
		}
	}

	function uv2.StopPlaytimeTrackingForAllItems(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 3411, uv5)
		end

		return slot1
	end

	uv2.stop_playtime_tracking_for_all_items = uv2.StopPlaytimeTrackingForAllItems
	slot92 = uv3(slot0, 78, "uint64_t(__thiscall*)(void*, uint64_t, uint64_t)")
	slot93 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
				uint64_t m_nChildPublishedFileId;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_nChildPublishedFileId = "child_published_file_id",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.AddDependency(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3412, uv5)
		end

		return slot3
	end

	uv2.add_dependency = uv2.AddDependency
	slot94 = uv3(slot0, 79, "uint64_t(__thiscall*)(void*, uint64_t, uint64_t)")
	slot95 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
				uint64_t m_nChildPublishedFileId;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_nChildPublishedFileId = "child_published_file_id",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.RemoveDependency(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3413, uv5)
		end

		return slot3
	end

	uv2.remove_dependency = uv2.RemoveDependency
	slot96 = uv3(slot0, 80, "uint64_t(__thiscall*)(void*, uint64_t, unsigned int)")
	slot97 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
				unsigned int m_nAppID;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_nAppID = "appid",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.AddAppDependency(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3414, uv5)
		end

		return slot3
	end

	uv2.add_app_dependency = uv2.AddAppDependency
	slot98 = uv3(slot0, 81, "uint64_t(__thiscall*)(void*, uint64_t, unsigned int)")
	slot99 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
				unsigned int m_nAppID;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_nAppID = "appid",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.RemoveAppDependency(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 3415, uv5)
		end

		return slot3
	end

	uv2.remove_app_dependency = uv2.RemoveAppDependency
	slot100 = uv3(slot0, 82, "uint64_t(__thiscall*)(void*, uint64_t)")
	slot101 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
				unsigned int m_rgAppIDs[32];
				uint32_t m_nNumAppDependencies;
				uint32_t m_nTotalNumAppDependencies;
			} *
		]]),
		keys = {
			m_nNumAppDependencies = "num_app_dependencies",
			m_eResult = "result",
			m_rgAppIDs = "appids",
			m_nTotalNumAppDependencies = "total_num_app_dependencies",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.GetAppDependencies(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 3416, uv5)
		end

		return slot2
	end

	uv2.get_app_dependencies = uv2.GetAppDependencies
	slot102 = uv3(slot0, 83, "uint64_t(__thiscall*)(void*, uint64_t)")
	slot103 = {
		struct = uv8([[
			struct {
				int m_eResult;
				uint64_t m_nPublishedFileId;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_nPublishedFileId = "published_file_id"
		}
	}

	function uv2.DeleteItem(slot0, slot1)
		if slot1 ~= nil and not uv0(slot1) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv4(uv2(uv3, slot0), slot1, 3417, uv5)
		end

		return slot2
	end

	uv2.delete_item = uv2.DeleteItem
	slot104 = uv3(slot0, 84, "bool(__thiscall*)(void*)")

	function uv2.ShowWorkshopEULA()
		return uv0(uv1)
	end

	uv2.show_workshop_eula = uv2.ShowWorkshopEULA
	slot105 = uv3(slot0, 85, "uint64_t(__thiscall*)(void*)")
	slot106 = {
		struct = uv8([[
			struct {
				int m_eResult;
				unsigned int m_nAppID;
				uint32_t m_unVersion;
				unsigned int m_rtAction;
				bool m_bAccepted;
				bool m_bNeedsAction;
			} *
		]]),
		keys = {
			m_nAppID = "appid",
			m_bNeedsAction = "needs_action",
			m_eResult = "result",
			m_bAccepted = "accepted",
			m_rtAction = "action",
			m_unVersion = "version"
		}
	}

	function uv2.GetWorkshopEULAStatus(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 3420, uv5)
		end

		return slot1
	end

	uv2.get_workshop_eula_status = uv2.GetWorkshopEULAStatus

	return uv2
end

slot160 = {
	version_number = 5,
	version = "STEAMHTMLSURFACE_INTERFACE_VERSION_005"
}

function slot62.ISteamHTMLSurface()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 31, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMHTMLSURFACE_INTERFACE_VERSION_005")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 1, "bool(__thiscall*)(void*)")

	function uv2.Init()
		return uv0(uv1)
	end

	uv2.init = uv2.Init
	slot2 = uv3(slot0, 2, "bool(__thiscall*)(void*)")

	function uv2.Shutdown()
		return uv0(uv1)
	end

	uv2.shutdown = uv2.Shutdown
	slot3 = uv3(slot0, 3, "uint64_t(__thiscall*)(void*, const char *, const char *)")
	slot4 = {
		struct = uv4([[
			struct {
				unsigned int unBrowserHandle;
			} *
		]]),
		keys = {
			unBrowserHandle = "browser_handle"
		}
	}

	function uv2.CreateBrowser(slot0, slot1, slot2)
		if slot2 ~= nil and not uv0(slot2) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot2 ~= nil then
			slot3 = uv4(uv2(uv3, slot0, slot1), slot2, 4501, uv5)
		end

		return slot3
	end

	uv2.create_browser = uv2.CreateBrowser
	slot5 = uv3(slot0, 4, "void(__thiscall*)(void*, unsigned int)")

	function uv2.RemoveBrowser(slot0)
		return uv0(uv1, slot0)
	end

	uv2.remove_browser = uv2.RemoveBrowser
	slot6 = uv3(slot0, 5, "void(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function uv2.LoadURL(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.load_url = uv2.LoadURL
	slot7 = uv3(slot0, 6, "void(__thiscall*)(void*, unsigned int, uint32_t, uint32_t)")

	function uv2.SetSize(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.set_size = uv2.SetSize
	slot8 = uv3(slot0, 7, "void(__thiscall*)(void*, unsigned int)")

	function uv2.StopLoad(slot0)
		return uv0(uv1, slot0)
	end

	uv2.stop_load = uv2.StopLoad
	slot9 = uv3(slot0, 8, "void(__thiscall*)(void*, unsigned int)")

	function uv2.Reload(slot0)
		return uv0(uv1, slot0)
	end

	uv2.reload = uv2.Reload
	slot10 = uv3(slot0, 9, "void(__thiscall*)(void*, unsigned int)")

	function uv2.GoBack(slot0)
		return uv0(uv1, slot0)
	end

	uv2.go_back = uv2.GoBack
	slot11 = uv3(slot0, 10, "void(__thiscall*)(void*, unsigned int)")

	function uv2.GoForward(slot0)
		return uv0(uv1, slot0)
	end

	uv2.go_forward = uv2.GoForward
	slot12 = uv3(slot0, 11, "void(__thiscall*)(void*, unsigned int, const char *, const char *)")

	function uv2.AddHeader(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.add_header = uv2.AddHeader
	slot13 = uv3(slot0, 12, "void(__thiscall*)(void*, unsigned int, const char *)")

	function uv2.ExecuteJavascript(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.execute_javascript = uv2.ExecuteJavascript
	slot14 = uv3(slot0, 13, "void(__thiscall*)(void*, unsigned int, int)")

	function uv2.MouseUp(slot0, slot1)
		return uv2(uv3, slot0, uv0(slot1, uv1.EHTMLMouseButton, "mouse_button is required"))
	end

	uv2.mouse_up = uv2.MouseUp
	slot15 = uv3(slot0, 14, "void(__thiscall*)(void*, unsigned int, int)")

	function uv2.MouseDown(slot0, slot1)
		return uv2(uv3, slot0, uv0(slot1, uv1.EHTMLMouseButton, "mouse_button is required"))
	end

	uv2.mouse_down = uv2.MouseDown
	slot16 = uv3(slot0, 15, "void(__thiscall*)(void*, unsigned int, int)")

	function uv2.MouseDoubleClick(slot0, slot1)
		return uv2(uv3, slot0, uv0(slot1, uv1.EHTMLMouseButton, "mouse_button is required"))
	end

	uv2.mouse_double_click = uv2.MouseDoubleClick
	slot17 = uv3(slot0, 16, "void(__thiscall*)(void*, unsigned int, int, int)")

	function uv2.MouseMove(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.mouse_move = uv2.MouseMove
	slot18 = uv3(slot0, 17, "void(__thiscall*)(void*, unsigned int, int32_t)")

	function uv2.MouseWheel(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.mouse_wheel = uv2.MouseWheel
	slot19 = uv3(slot0, 18, "void(__thiscall*)(void*, unsigned int, uint32_t, int, bool)")

	function uv2.KeyDown(slot0, slot1, slot2, slot3)
		return uv2(uv3, slot0, slot1, uv0(slot2, uv1.EHTMLKeyModifiers, "html_key_modifiers is required"), slot3)
	end

	uv2.key_down = uv2.KeyDown
	slot20 = uv3(slot0, 19, "void(__thiscall*)(void*, unsigned int, uint32_t, int)")

	function uv2.KeyUp(slot0, slot1, slot2)
		return uv2(uv3, slot0, slot1, uv0(slot2, uv1.EHTMLKeyModifiers, "html_key_modifiers is required"))
	end

	uv2.key_up = uv2.KeyUp
	slot21 = uv3(slot0, 20, "void(__thiscall*)(void*, unsigned int, uint32_t, int)")

	function uv2.KeyChar(slot0, slot1, slot2)
		return uv2(uv3, slot0, slot1, uv0(slot2, uv1.EHTMLKeyModifiers, "html_key_modifiers is required"))
	end

	uv2.key_char = uv2.KeyChar
	slot22 = uv3(slot0, 21, "void(__thiscall*)(void*, unsigned int, uint32_t)")

	function uv2.SetHorizontalScroll(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_horizontal_scroll = uv2.SetHorizontalScroll
	slot23 = uv3(slot0, 22, "void(__thiscall*)(void*, unsigned int, uint32_t)")

	function uv2.SetVerticalScroll(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_vertical_scroll = uv2.SetVerticalScroll
	slot24 = uv3(slot0, 23, "void(__thiscall*)(void*, unsigned int, bool)")

	function uv2.SetKeyFocus(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_key_focus = uv2.SetKeyFocus
	slot25 = uv3(slot0, 24, "void(__thiscall*)(void*, unsigned int)")

	function uv2.ViewSource(slot0)
		return uv0(uv1, slot0)
	end

	uv2.view_source = uv2.ViewSource
	slot26 = uv3(slot0, 25, "void(__thiscall*)(void*, unsigned int)")

	function uv2.CopyToClipboard(slot0)
		return uv0(uv1, slot0)
	end

	uv2.copy_to_clipboard = uv2.CopyToClipboard
	slot27 = uv3(slot0, 26, "void(__thiscall*)(void*, unsigned int)")

	function uv2.PasteFromClipboard(slot0)
		return uv0(uv1, slot0)
	end

	uv2.paste_from_clipboard = uv2.PasteFromClipboard
	slot28 = uv3(slot0, 27, "void(__thiscall*)(void*, unsigned int, const char *, bool, bool)")

	function uv2.Find(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.find = uv2.Find
	slot29 = uv3(slot0, 28, "void(__thiscall*)(void*, unsigned int)")

	function uv2.StopFind(slot0)
		return uv0(uv1, slot0)
	end

	uv2.stop_find = uv2.StopFind
	slot30 = uv3(slot0, 29, "void(__thiscall*)(void*, unsigned int, int, int)")

	function uv2.GetLinkAtPosition(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_link_at_position = uv2.GetLinkAtPosition
	slot31 = uv3(slot0, 30, "void(__thiscall*)(void*, const char *, const char *, const char *, const char *, unsigned int, bool, bool)")

	function uv2.SetCookie(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	end

	uv2.set_cookie = uv2.SetCookie
	slot32 = uv3(slot0, 31, "void(__thiscall*)(void*, unsigned int, float, int, int)")

	function uv2.SetPageScaleFactor(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.set_page_scale_factor = uv2.SetPageScaleFactor
	slot33 = uv3(slot0, 32, "void(__thiscall*)(void*, unsigned int, bool)")

	function uv2.SetBackgroundMode(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_background_mode = uv2.SetBackgroundMode
	slot34 = uv3(slot0, 33, "void(__thiscall*)(void*, unsigned int, float)")

	function uv2.SetDPIScalingFactor(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.set_dpi_scaling_factor = uv2.SetDPIScalingFactor
	slot35 = uv3(slot0, 34, "void(__thiscall*)(void*, unsigned int)")

	function uv2.OpenDeveloperTools(slot0)
		return uv0(uv1, slot0)
	end

	uv2.open_developer_tools = uv2.OpenDeveloperTools
	slot36 = uv3(slot0, 35, "void(__thiscall*)(void*, unsigned int, bool)")

	function uv2.AllowStartRequest(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.allow_start_request = uv2.AllowStartRequest
	slot37 = uv3(slot0, 36, "void(__thiscall*)(void*, unsigned int, bool)")

	function uv2.JSDialogResponse(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.js_dialog_response = uv2.JSDialogResponse
	slot38 = uv3(slot0, 37, "void(__thiscall*)(void*, unsigned int, const char **)")

	function uv2.FileLoadDialogResponse(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.file_load_dialog_response = uv2.FileLoadDialogResponse

	return uv2
end

slot161 = {
	version_number = 3,
	version = "STEAMINVENTORY_INTERFACE_V003"
}

function slot62.ISteamInventory()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 35, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMINVENTORY_INTERFACE_V003")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "int(__thiscall*)(void*, int)")

	function uv2.GetResultStatus(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_result_status = uv2.GetResultStatus
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*, int, SteamItemDetails_t *, uint32_t *)")

	function uv2.GetResultItems(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_result_items = uv2.GetResultItems
	slot3 = uv3(slot0, 2, "bool(__thiscall*)(void*, int, uint32_t, const char *, char *, uint32_t *)")

	function uv2.GetResultItemProperty(slot0, slot1, slot2, slot3, slot4)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4)
	end

	uv2.get_result_item_property = uv2.GetResultItemProperty
	slot4 = uv3(slot0, 3, "uint32_t(__thiscall*)(void*, int)")

	function uv2.GetResultTimestamp(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_result_timestamp = uv2.GetResultTimestamp
	slot5 = uv3(slot0, 4, "bool(__thiscall*)(void*, int, SteamID)")

	function uv2.CheckResultSteamID(slot0, slot1)
		return uv1(uv2, slot0, uv0(slot1, "steamid_expected is required"))
	end

	uv2.check_result_steamid = uv2.CheckResultSteamID
	slot6 = uv3(slot0, 5, "void(__thiscall*)(void*, int)")

	function uv2.DestroyResult(slot0)
		return uv0(uv1, slot0)
	end

	uv2.destroy_result = uv2.DestroyResult
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, int *)")

	function uv2.GetAllItems()
		slot0 = uv0()

		return uv1(uv2, slot0), uv3(slot0)
	end

	uv2.get_all_items = uv2.GetAllItems
	slot8 = uv3(slot0, 7, "bool(__thiscall*)(void*, int *, const uint64_t *, uint32_t)")

	function uv2.GetItemsByID(slot0, slot1)
		slot2 = uv0()

		return uv1(uv2, slot2, slot0, slot1), uv3(slot2)
	end

	uv2.get_items_by_id = uv2.GetItemsByID
	slot9 = uv3(slot0, 8, "bool(__thiscall*)(void*, int, void *, uint32_t *)")

	function uv2.SerializeResult(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.serialize_result = uv2.SerializeResult
	slot10 = uv3(slot0, 9, "bool(__thiscall*)(void*, int *, const void *, uint32_t, bool)")

	function uv2.DeserializeResult(slot0, slot1, slot2)
		slot3 = uv0()

		return uv1(uv2, slot3, slot0, slot1, slot2), uv3(slot3)
	end

	uv2.deserialize_result = uv2.DeserializeResult
	slot11 = uv3(slot0, 10, "bool(__thiscall*)(void*, int *, const int *, const uint32_t *, uint32_t)")

	function uv2.GenerateItems(slot0, slot1, slot2)
		slot3 = uv0()

		return uv1(uv2, slot3, slot0, slot1, slot2), uv3(slot3)
	end

	uv2.generate_items = uv2.GenerateItems
	slot12 = uv3(slot0, 11, "bool(__thiscall*)(void*, int *)")

	function uv2.GrantPromoItems()
		slot0 = uv0()

		return uv1(uv2, slot0), uv3(slot0)
	end

	uv2.grant_promo_items = uv2.GrantPromoItems
	slot13 = uv3(slot0, 12, "bool(__thiscall*)(void*, int *, int)")

	function uv2.AddPromoItem(slot0)
		slot1 = uv0()

		return uv1(uv2, slot1, slot0), uv3(slot1)
	end

	uv2.add_promo_item = uv2.AddPromoItem
	slot14 = uv3(slot0, 13, "bool(__thiscall*)(void*, int *, const int *, uint32_t)")

	function uv2.AddPromoItems(slot0, slot1)
		slot2 = uv0()

		return uv1(uv2, slot2, slot0, slot1), uv3(slot2)
	end

	uv2.add_promo_items = uv2.AddPromoItems
	slot15 = uv3(slot0, 14, "bool(__thiscall*)(void*, int *, uint64_t, uint32_t)")

	function uv2.ConsumeItem(slot0, slot1)
		slot2 = uv0()

		return uv1(uv2, slot2, slot0, slot1), uv3(slot2)
	end

	uv2.consume_item = uv2.ConsumeItem
	slot16 = uv3(slot0, 15, "bool(__thiscall*)(void*, int *, const int *, const uint32_t *, uint32_t, const uint64_t *, const uint32_t *, uint32_t)")

	function uv2.ExchangeItems(slot0, slot1, slot2, slot3, slot4, slot5)
		slot6 = uv0()

		return uv1(uv2, slot6, slot0, slot1, slot2, slot3, slot4, slot5), uv3(slot6)
	end

	uv2.exchange_items = uv2.ExchangeItems
	slot17 = uv3(slot0, 16, "bool(__thiscall*)(void*, int *, uint64_t, uint32_t, uint64_t)")

	function uv2.TransferItemQuantity(slot0, slot1, slot2)
		slot3 = uv0()

		return uv1(uv2, slot3, slot0, slot1, slot2), uv3(slot3)
	end

	uv2.transfer_item_quantity = uv2.TransferItemQuantity
	slot18 = uv3(slot0, 17, "void(__thiscall*)(void*)")

	function uv2.SendItemDropHeartbeat()
		return uv0(uv1)
	end

	uv2.send_item_drop_heartbeat = uv2.SendItemDropHeartbeat
	slot19 = uv3(slot0, 18, "bool(__thiscall*)(void*, int *, int)")

	function uv2.TriggerItemDrop(slot0)
		slot1 = uv0()

		return uv1(uv2, slot1, slot0), uv3(slot1)
	end

	uv2.trigger_item_drop = uv2.TriggerItemDrop
	slot20 = uv3(slot0, 19, "bool(__thiscall*)(void*, int *, SteamID, const uint64_t *, const uint32_t *, uint32_t, const uint64_t *, const uint32_t *, uint32_t)")

	function uv2.TradeItems(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
		slot7 = uv1()

		return uv2(uv3, slot7, uv0(slot0, "steamid_trade_partner is required"), slot1, slot2, slot3, slot4, slot5, slot6), uv4(slot7)
	end

	uv2.trade_items = uv2.TradeItems
	slot21 = uv3(slot0, 20, "bool(__thiscall*)(void*)")

	function uv2.LoadItemDefinitions()
		return uv0(uv1)
	end

	uv2.load_item_definitions = uv2.LoadItemDefinitions
	slot22 = uv3(slot0, 21, "bool(__thiscall*)(void*, int *, uint32_t *)")

	function uv2.GetItemDefinitionIDs(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv2.get_item_definition_ids = uv2.GetItemDefinitionIDs
	slot23 = uv3(slot0, 22, "bool(__thiscall*)(void*, int, const char *, char *, uint32_t *)")

	function uv2.GetItemDefinitionProperty(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.get_item_definition_property = uv2.GetItemDefinitionProperty
	slot24 = uv3(slot0, 23, "uint64_t(__thiscall*)(void*, SteamID)")
	slot25 = {
		struct = uv7([[
			struct {
				int m_result;
				SteamID m_steamID;
				int m_numEligiblePromoItemDefs;
				bool m_bCachedData;
			} *
		]]),
		keys = {
			m_steamID = "steamid",
			m_bCachedData = "cached_data",
			m_result = "result",
			m_numEligiblePromoItemDefs = "num_eligible_promo_item_defs"
		}
	}

	function uv2.RequestEligiblePromoItemDefinitionsIDs(slot0, slot1)
		slot0 = uv0(slot0, "steamid is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 4703, uv6)
		end

		return slot2
	end

	uv2.request_eligible_promo_item_definitions_ids = uv2.RequestEligiblePromoItemDefinitionsIDs
	slot26 = uv3(slot0, 24, "bool(__thiscall*)(void*, SteamID, int *, uint32_t *)")

	function uv2.GetEligiblePromoItemDefinitionIDs(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "steamid is required"), slot1, slot2)
	end

	uv2.get_eligible_promo_item_definition_ids = uv2.GetEligiblePromoItemDefinitionIDs
	slot27 = uv3(slot0, 25, "uint64_t(__thiscall*)(void*, const int *, const uint32_t *, uint32_t)")
	slot28 = {
		struct = uv7([[
			struct {
				int m_result;
				uint64_t m_ulOrderID;
				uint64_t m_ulTransID;
			} *
		]]),
		keys = {
			m_ulTransID = "trans_id",
			m_result = "result",
			m_ulOrderID = "order_id"
		}
	}

	function uv2.StartPurchase(slot0, slot1, slot2, slot3)
		if slot3 ~= nil and not uv0(slot3) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot3 ~= nil then
			slot4 = uv4(uv2(uv3, slot0, slot1, slot2), slot3, 4704, uv5)
		end

		return slot4
	end

	uv2.start_purchase = uv2.StartPurchase
	slot29 = uv3(slot0, 26, "uint64_t(__thiscall*)(void*)")
	slot30 = {
		struct = uv7([[
			struct {
				int m_result;
				char m_rgchCurrency[4];
			} *
		]]),
		keys = {
			m_result = "result",
			m_rgchCurrency = "currency"
		}
	}

	function uv2.RequestPrices(slot0)
		if slot0 ~= nil and not uv0(slot0) then
			return uv1("Invalid callback, expected function or await")
		end

		if slot0 ~= nil then
			slot1 = uv4(uv2(uv3), slot0, 4705, uv5)
		end

		return slot1
	end

	uv2.request_prices = uv2.RequestPrices
	slot31 = uv3(slot0, 27, "uint32_t(__thiscall*)(void*)")

	function uv2.GetNumItemsWithPrices()
		return uv0(uv1)
	end

	uv2.get_num_items_with_prices = uv2.GetNumItemsWithPrices
	slot32 = uv3(slot0, 28, "bool(__thiscall*)(void*, int *, uint64_t *, uint64_t *, uint32_t)")

	function uv2.GetItemsWithPrices(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.get_items_with_prices = uv2.GetItemsWithPrices
	slot33 = uv3(slot0, 29, "bool(__thiscall*)(void*, int, uint64_t *, uint64_t *)")

	function uv2.GetItemPrice(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv2.get_item_price = uv2.GetItemPrice
	slot34 = uv3(slot0, 30, "void(__thiscall*)(void*, uint64_t *)")

	function uv2.StartUpdateProperties()
		slot0 = uv0()

		uv1(uv2, slot0)

		return uv3(slot0)
	end

	uv2.start_update_properties = uv2.StartUpdateProperties
	slot35 = uv3(slot0, 31, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *)")

	function uv2.RemoveProperty(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.remove_property = uv2.RemoveProperty
	slot36 = uv3(slot0, 32, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, const char *)")

	function uv2.SetPropertyString(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.set_property_string = uv2.SetPropertyString
	slot37 = uv3(slot0, 33, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, bool)")

	function uv2.SetPropertyBool(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.set_property_bool = uv2.SetPropertyBool
	slot38 = uv3(slot0, 34, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, int64_t)")

	function uv2.SetPropertyInt64(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.set_property_int64 = uv2.SetPropertyInt64
	slot39 = uv3(slot0, 35, "bool(__thiscall*)(void*, uint64_t, uint64_t, const char *, float)")

	function uv2.SetPropertyFloat(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv2.set_property_float = uv2.SetPropertyFloat
	slot40 = uv3(slot0, 36, "bool(__thiscall*)(void*, uint64_t, int *)")

	function uv2.SubmitUpdateProperties(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv2.submit_update_properties = uv2.SubmitUpdateProperties
	slot41 = uv3(slot0, 37, "bool(__thiscall*)(void*, int *, const char *)")

	function uv2.InspectItem(slot0)
		slot1 = uv0()

		return uv1(uv2, slot1, slot0), uv3(slot1)
	end

	uv2.inspect_item = uv2.InspectItem

	return uv2
end

slot162 = {
	version_number = 2,
	version = "STEAMVIDEO_INTERFACE_V002"
}

function slot62.ISteamVideo()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 36, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMVIDEO_INTERFACE_V002")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "void(__thiscall*)(void*, unsigned int)")

	function uv2.GetVideoURL(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_video_url = uv2.GetVideoURL
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*, int *)")

	function uv2.IsBroadcasting()
		slot0 = uv0()

		return uv1(uv2, slot0), uv3(slot0)
	end

	uv2.is_broadcasting = uv2.IsBroadcasting
	slot3 = uv3(slot0, 2, "void(__thiscall*)(void*, unsigned int)")

	function uv2.GetOPFSettings(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_opf_settings = uv2.GetOPFSettings
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*, unsigned int, char *, int32_t *)")

	function uv2.GetOPFStringForApp(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv2.get_opf_string_for_app = uv2.GetOPFStringForApp

	return uv2
end

slot163 = {
	version_number = 1,
	version = "STEAMPARENTALSETTINGS_INTERFACE_VERSION001"
}

function slot62.ISteamParentalSettings()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 37, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMPARENTALSETTINGS_INTERFACE_VERSION001")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "bool(__thiscall*)(void*)")

	function uv2.BIsParentalLockEnabled()
		return uv0(uv1)
	end

	uv2.is_parental_lock_enabled = uv2.BIsParentalLockEnabled
	slot2 = uv3(slot0, 1, "bool(__thiscall*)(void*)")

	function uv2.BIsParentalLockLocked()
		return uv0(uv1)
	end

	uv2.is_parental_lock_locked = uv2.BIsParentalLockLocked
	slot3 = uv3(slot0, 2, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.BIsAppBlocked(slot0)
		return uv0(uv1, slot0)
	end

	uv2.is_app_blocked = uv2.BIsAppBlocked
	slot4 = uv3(slot0, 3, "bool(__thiscall*)(void*, unsigned int)")

	function uv2.BIsAppInBlockList(slot0)
		return uv0(uv1, slot0)
	end

	uv2.is_app_in_block_list = uv2.BIsAppInBlockList
	slot5 = uv3(slot0, 4, "bool(__thiscall*)(void*, int)")

	function uv2.BIsFeatureBlocked(slot0)
		return uv2(uv3, uv0(slot0, uv1.EParentalFeature, "feature is required"))
	end

	uv2.is_feature_blocked = uv2.BIsFeatureBlocked
	slot6 = uv3(slot0, 5, "bool(__thiscall*)(void*, int)")

	function uv2.BIsFeatureInBlockList(slot0)
		return uv2(uv3, uv0(slot0, uv1.EParentalFeature, "feature is required"))
	end

	uv2.is_feature_in_block_list = uv2.BIsFeatureInBlockList

	return uv2
end

slot164 = {
	version_number = 1,
	version = "STEAMREMOTEPLAY_INTERFACE_VERSION001"
}

function slot62.ISteamRemotePlay()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 40, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "STEAMREMOTEPLAY_INTERFACE_VERSION001")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "uint32_t(__thiscall*)(void*)")

	function uv2.GetSessionCount()
		return uv0(uv1)
	end

	uv2.get_session_count = uv2.GetSessionCount
	slot2 = uv3(slot0, 1, "unsigned int(__thiscall*)(void*, int)")

	function uv2.GetSessionID(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_session_id = uv2.GetSessionID
	slot3 = uv3(slot0, 2, "void(__thiscall*)(void*, SteamID *, unsigned int)")

	function uv2.GetSessionSteamID(slot0)
		slot1 = uv0()

		uv1(uv2, slot1, slot0)

		return uv3(slot1)
	end

	uv2.get_session_steamid = uv2.GetSessionSteamID
	slot4 = uv3(slot0, 3, "const char *(__thiscall*)(void*, unsigned int)")

	function uv2.GetSessionClientName(slot0)
		return uv0(uv1, slot0) ~= nil and uv2(slot1) or nil
	end

	uv2.get_session_client_name = uv2.GetSessionClientName
	slot5 = uv3(slot0, 4, "int(__thiscall*)(void*, unsigned int)")

	function uv2.GetSessionClientFormFactor(slot0)
		return uv0(uv1, slot0)
	end

	uv2.get_session_client_form_factor = uv2.GetSessionClientFormFactor
	slot6 = uv3(slot0, 5, "bool(__thiscall*)(void*, unsigned int, int *, int *)")

	function uv2.BGetSessionClientResolution(slot0)
		slot1 = uv0()
		slot2 = uv0()

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv2.get_session_client_resolution = uv2.BGetSessionClientResolution
	slot7 = uv3(slot0, 6, "bool(__thiscall*)(void*, SteamID)")

	function uv2.BSendRemotePlayTogetherInvite(slot0)
		return uv1(uv2, uv0(slot0, "steamid_friend is required"))
	end

	uv2.send_remote_play_together_invite = uv2.BSendRemotePlayTogetherInvite

	return uv2
end

slot165 = {
	version_number = 2,
	version = "SteamNetworkingMessages002"
}

function slot62.ISteamNetworkingMessages()
	slot0 = uv0("steamnetworkingsockets.dll", "SteamNetworkingMessages_LibV2", "void*(__thiscall*)(unsigned int, unsigned int)")()
	uv1.thisptr = slot0
	slot1 = uv2(slot0, 0, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, const void *, uint32_t, int, int)")

	function uv1.SendMessageToUser(slot0, slot1, slot2, slot3, slot4)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4)
	end

	uv1.send_message_to_user = uv1.SendMessageToUser
	slot2 = uv2(slot0, 1, "int(__thiscall*)(void*, int, SteamNetworkingMessage_t **, int)")

	function uv1.ReceiveMessagesOnChannel(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.receive_messages_on_channel = uv1.ReceiveMessagesOnChannel
	slot3 = uv2(slot0, 2, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &)")

	function uv1.AcceptSessionWithUser(slot0)
		return uv0(uv1, slot0)
	end

	uv1.accept_session_with_user = uv1.AcceptSessionWithUser
	slot4 = uv2(slot0, 3, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &)")

	function uv1.CloseSessionWithUser(slot0)
		return uv0(uv1, slot0)
	end

	uv1.close_session_with_user = uv1.CloseSessionWithUser
	slot5 = uv2(slot0, 4, "bool(__thiscall*)(void*, const SteamNetworkingIdentity &, int)")

	function uv1.CloseChannelWithUser(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.close_channel_with_user = uv1.CloseChannelWithUser
	slot6 = uv2(slot0, 5, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, SteamNetConnectionInfo_t *, SteamNetConnectionRealTimeStatus_t *)")

	function uv1.GetSessionConnectionInfo(slot0)
		slot1 = uv0.SteamNetConnectionInfo_t_arr(1)
		slot2 = uv0.SteamNetConnectionRealTimeStatus_t_arr(1)

		return uv1(uv2, slot0, slot1, slot2), uv3(slot1), uv3(slot2)
	end

	uv1.get_session_connection_info = uv1.GetSessionConnectionInfo

	return uv1
end

slot166 = {
	version_number = 12,
	version = "SteamNetworkingSockets012"
}

function slot62.ISteamNetworkingSockets()
	slot0 = uv0("steamnetworkingsockets.dll", "SteamNetworkingSockets_LibV12", "void*(__thiscall*)(unsigned int, unsigned int)")()
	uv1.thisptr = slot0
	slot1 = uv2(slot0, 0, "unsigned int(__thiscall*)(void*, const SteamNetworkingIPAddr &, int, const SteamNetworkingConfigValue_t *)")

	function uv1.CreateListenSocketIP(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.create_listen_socket_ip = uv1.CreateListenSocketIP
	slot2 = uv2(slot0, 1, "unsigned int(__thiscall*)(void*, const SteamNetworkingIPAddr &, int, const SteamNetworkingConfigValue_t *)")

	function uv1.ConnectByIPAddress(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.connect_by_ip_address = uv1.ConnectByIPAddress
	slot3 = uv2(slot0, 2, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")

	function uv1.CreateListenSocketP2P(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.create_listen_socket_p2p = uv1.CreateListenSocketP2P
	slot4 = uv2(slot0, 3, "unsigned int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, int, const SteamNetworkingConfigValue_t *)")

	function uv1.ConnectP2P(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv1.connect_p2p = uv1.ConnectP2P
	slot5 = uv2(slot0, 4, "int(__thiscall*)(void*, unsigned int)")

	function uv1.AcceptConnection(slot0)
		return uv0(uv1, slot0)
	end

	uv1.accept_connection = uv1.AcceptConnection
	slot6 = uv2(slot0, 5, "bool(__thiscall*)(void*, unsigned int, int, const char *, bool)")

	function uv1.CloseConnection(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv1.close_connection = uv1.CloseConnection
	slot7 = uv2(slot0, 6, "bool(__thiscall*)(void*, unsigned int)")

	function uv1.CloseListenSocket(slot0)
		return uv0(uv1, slot0)
	end

	uv1.close_listen_socket = uv1.CloseListenSocket
	slot8 = uv2(slot0, 7, "bool(__thiscall*)(void*, unsigned int, int64_t)")

	function uv1.SetConnectionUserData(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.set_connection_user_data = uv1.SetConnectionUserData
	slot9 = uv2(slot0, 8, "int64_t(__thiscall*)(void*, unsigned int)")

	function uv1.GetConnectionUserData(slot0)
		return uv0(uv1, slot0)
	end

	uv1.get_connection_user_data = uv1.GetConnectionUserData
	slot10 = uv2(slot0, 9, "void(__thiscall*)(void*, unsigned int, const char *)")

	function uv1.SetConnectionName(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.set_connection_name = uv1.SetConnectionName
	slot11 = uv2(slot0, 10, "bool(__thiscall*)(void*, unsigned int, char *, int)")

	function uv1.GetConnectionName(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.get_connection_name = uv1.GetConnectionName
	slot12 = uv2(slot0, 11, "int(__thiscall*)(void*, unsigned int, const void *, uint32_t, int, int64_t *)")

	function uv1.SendMessageToConnection(slot0, slot1, slot2, slot3)
		slot4 = uv0()

		return uv1(uv2, slot0, slot1, slot2, slot3, slot4), uv3(slot4)
	end

	uv1.send_message_to_connection = uv1.SendMessageToConnection
	slot13 = uv2(slot0, 12, "void(__thiscall*)(void*, int, SteamNetworkingMessage_t *const *, int64_t *)")

	function uv1.SendMessages(slot0, slot1)
		slot2 = uv0()

		uv1(uv2, slot0, slot1, slot2)

		return uv3(slot2)
	end

	uv1.send_messages = uv1.SendMessages
	slot14 = uv2(slot0, 13, "int(__thiscall*)(void*, unsigned int)")

	function uv1.FlushMessagesOnConnection(slot0)
		return uv0(uv1, slot0)
	end

	uv1.flush_messages_on_connection = uv1.FlushMessagesOnConnection
	slot15 = uv2(slot0, 14, "int(__thiscall*)(void*, unsigned int, SteamNetworkingMessage_t **, int)")

	function uv1.ReceiveMessagesOnConnection(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.receive_messages_on_connection = uv1.ReceiveMessagesOnConnection
	slot16 = uv2(slot0, 15, "bool(__thiscall*)(void*, unsigned int, SteamNetConnectionInfo_t *)")

	function uv1.GetConnectionInfo(slot0)
		slot1 = uv0.SteamNetConnectionInfo_t_arr(1)

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv1.get_connection_info = uv1.GetConnectionInfo
	slot17 = uv2(slot0, 16, "int(__thiscall*)(void*, unsigned int, SteamNetConnectionRealTimeStatus_t *, int, SteamNetConnectionRealTimeLaneStatus_t *)")

	function uv1.GetConnectionRealTimeStatus(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv1.get_connection_real_time_status = uv1.GetConnectionRealTimeStatus
	slot18 = uv2(slot0, 17, "int(__thiscall*)(void*, unsigned int, char *, int)")

	function uv1.GetDetailedConnectionStatus(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.get_detailed_connection_status = uv1.GetDetailedConnectionStatus
	slot19 = uv2(slot0, 18, "bool(__thiscall*)(void*, unsigned int, SteamNetworkingIPAddr *)")

	function uv1.GetListenSocketAddress(slot0)
		slot1 = uv0.SteamNetworkingIPAddr_arr(1)

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv1.get_listen_socket_address = uv1.GetListenSocketAddress
	slot20 = uv2(slot0, 19, "bool(__thiscall*)(void*, unsigned int *, unsigned int *, bool, const SteamNetworkingIdentity *, const SteamNetworkingIdentity *)")

	function uv1.CreateSocketPair(slot0, slot1, slot2)
		slot3 = uv0()
		slot4 = uv0()

		return uv1(uv2, slot3, slot4, slot0, slot1, slot2), uv3(slot3), uv3(slot4)
	end

	uv1.create_socket_pair = uv1.CreateSocketPair
	slot21 = uv2(slot0, 20, "int(__thiscall*)(void*, unsigned int, int, const int *, const uint16_t *)")

	function uv1.ConfigureConnectionLanes(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv1.configure_connection_lanes = uv1.ConfigureConnectionLanes
	slot22 = uv2(slot0, 21, "bool(__thiscall*)(void*, SteamNetworkingIdentity *)")

	function uv1.GetIdentity()
		slot0 = uv0.SteamNetworkingIdentity_arr(1)

		return uv1(uv2, slot0), uv3(slot0)
	end

	uv1.get_identity = uv1.GetIdentity
	slot23 = uv2(slot0, 22, "int(__thiscall*)(void*)")

	function uv1.InitAuthentication()
		return uv0(uv1)
	end

	uv1.init_authentication = uv1.InitAuthentication
	slot24 = uv2(slot0, 23, "int(__thiscall*)(void*, SteamNetAuthenticationStatus_t *)")

	function uv1.GetAuthenticationStatus()
		slot0 = uv0.SteamNetAuthenticationStatus_t_arr(1)

		return uv1(uv2, slot0), uv3(slot0)
	end

	uv1.get_authentication_status = uv1.GetAuthenticationStatus
	slot25 = uv2(slot0, 24, "unsigned int(__thiscall*)(void*)")

	function uv1.CreatePollGroup()
		return uv0(uv1)
	end

	uv1.create_poll_group = uv1.CreatePollGroup
	slot26 = uv2(slot0, 25, "bool(__thiscall*)(void*, unsigned int)")

	function uv1.DestroyPollGroup(slot0)
		return uv0(uv1, slot0)
	end

	uv1.destroy_poll_group = uv1.DestroyPollGroup
	slot27 = uv2(slot0, 26, "bool(__thiscall*)(void*, unsigned int, unsigned int)")

	function uv1.SetConnectionPollGroup(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.set_connection_poll_group = uv1.SetConnectionPollGroup
	slot28 = uv2(slot0, 27, "int(__thiscall*)(void*, unsigned int, SteamNetworkingMessage_t **, int)")

	function uv1.ReceiveMessagesOnPollGroup(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.receive_messages_on_poll_group = uv1.ReceiveMessagesOnPollGroup
	slot29 = uv2(slot0, 28, "bool(__thiscall*)(void*, const void *, int, SteamDatagramRelayAuthTicket *)")

	function uv1.ReceivedRelayAuthTicket(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.received_relay_auth_ticket = uv1.ReceivedRelayAuthTicket
	slot30 = uv2(slot0, 29, "int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, SteamDatagramRelayAuthTicket *)")

	function uv1.FindRelayAuthTicketForServer(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.find_relay_auth_ticket_for_server = uv1.FindRelayAuthTicketForServer
	slot31 = uv2(slot0, 30, "unsigned int(__thiscall*)(void*, const SteamNetworkingIdentity &, int, int, const SteamNetworkingConfigValue_t *)")

	function uv1.ConnectToHostedDedicatedServer(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv1.connect_to_hosted_dedicated_server = uv1.ConnectToHostedDedicatedServer
	slot32 = uv2(slot0, 31, "uint16_t(__thiscall*)(void*)")

	function uv1.GetHostedDedicatedServerPort()
		return uv0(uv1)
	end

	uv1.get_hosted_dedicated_server_port = uv1.GetHostedDedicatedServerPort
	slot33 = uv2(slot0, 32, "unsigned int(__thiscall*)(void*)")

	function uv1.GetHostedDedicatedServerPOPID()
		return uv0(uv1)
	end

	uv1.get_hosted_dedicated_server_pop_id = uv1.GetHostedDedicatedServerPOPID
	slot34 = uv2(slot0, 33, "int(__thiscall*)(void*, SteamDatagramHostedAddress *)")

	function uv1.GetHostedDedicatedServerAddress()
		slot0 = uv0.SteamDatagramHostedAddress_arr(1)

		return uv1(uv2, slot0), uv3(slot0)
	end

	uv1.get_hosted_dedicated_server_address = uv1.GetHostedDedicatedServerAddress
	slot35 = uv2(slot0, 34, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")

	function uv1.CreateHostedDedicatedServerListenSocket(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.create_hosted_dedicated_server_listen_socket = uv1.CreateHostedDedicatedServerListenSocket
	slot36 = uv2(slot0, 35, "int(__thiscall*)(void*, SteamDatagramGameCoordinatorServerLogin *, int *, void *)")

	function uv1.GetGameCoordinatorServerLogin(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.get_game_coordinator_server_login = uv1.GetGameCoordinatorServerLogin
	slot37 = uv2(slot0, 36, "unsigned int(__thiscall*)(void*, void* *, const SteamNetworkingIdentity *, int, int, const SteamNetworkingConfigValue_t *)")

	function uv1.ConnectP2PCustomSignaling(slot0, slot1, slot2, slot3, slot4)
		return uv0(uv1, slot0, slot1, slot2, slot3, slot4)
	end

	uv1.connect_p2p_custom_signaling = uv1.ConnectP2PCustomSignaling
	slot38 = uv2(slot0, 37, "bool(__thiscall*)(void*, const void *, int, void* *)")

	function uv1.ReceivedP2PCustomSignal(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.received_p2p_custom_signal = uv1.ReceivedP2PCustomSignal
	slot39 = uv2(slot0, 38, "bool(__thiscall*)(void*, int *, void *, char * &)")

	function uv1.GetCertificateRequest(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.get_certificate_request = uv1.GetCertificateRequest
	slot40 = uv2(slot0, 39, "bool(__thiscall*)(void*, const void *, int, char * &)")

	function uv1.SetCertificate(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.set_certificate = uv1.SetCertificate
	slot41 = uv2(slot0, 40, "void(__thiscall*)(void*, const SteamNetworkingIdentity *)")

	function uv1.ResetIdentity(slot0)
		return uv0(uv1, slot0)
	end

	uv1.reset_identity = uv1.ResetIdentity
	slot42 = uv2(slot0, 41, "void(__thiscall*)(void*)")

	function uv1.RunCallbacks()
		return uv0(uv1)
	end

	uv1.run_callbacks = uv1.RunCallbacks
	slot43 = uv2(slot0, 42, "bool(__thiscall*)(void*, int)")

	function uv1.BeginAsyncRequestFakeIP(slot0)
		return uv0(uv1, slot0)
	end

	uv1.begin_async_request_fake_ip = uv1.BeginAsyncRequestFakeIP
	slot44 = uv2(slot0, 43, "void(__thiscall*)(void*, int, SteamNetworkingFakeIPResult_t *)")

	function uv1.GetFakeIP(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.get_fake_ip = uv1.GetFakeIP
	slot45 = uv2(slot0, 44, "unsigned int(__thiscall*)(void*, int, int, const SteamNetworkingConfigValue_t *)")

	function uv1.CreateListenSocketP2PFakeIP(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.create_listen_socket_p2p_fake_ip = uv1.CreateListenSocketP2PFakeIP
	slot46 = uv2(slot0, 45, "int(__thiscall*)(void*, unsigned int, SteamNetworkingIPAddr *)")

	function uv1.GetRemoteFakeIPForConnection(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.get_remote_fake_ip_for_connection = uv1.GetRemoteFakeIPForConnection
	slot47 = uv2(slot0, 46, "ISteamNetworkingFakeUDPPort *(__thiscall*)(void*, int)")

	function uv1.CreateFakeUDPPort(slot0)
		return uv0(uv1, slot0)
	end

	uv1.create_fake_udp_port = uv1.CreateFakeUDPPort

	return uv1
end

slot167 = {
	version_number = 4,
	version = "SteamNetworkingUtils004"
}

function slot62.ISteamNetworkingUtils()
	slot0 = uv0("steamnetworkingsockets.dll", "SteamNetworkingUtils_LibV4", "void*(__thiscall*)(unsigned int, unsigned int)")()
	uv1.thisptr = slot0
	slot1 = uv2(slot0, 0, "SteamNetworkingMessage_t *(__thiscall*)(void*, int)")

	function uv1.AllocateMessage(slot0)
		return uv0(uv1, slot0)
	end

	uv1.allocate_message = uv1.AllocateMessage
	slot2 = uv2(slot0, 1, "int(__thiscall*)(void*, SteamRelayNetworkStatus_t *)")

	function uv1.GetRelayNetworkStatus()
		slot0 = uv0.SteamRelayNetworkStatus_t_arr(1)

		return uv1(uv2, slot0), uv3(slot0)
	end

	uv1.get_relay_network_status = uv1.GetRelayNetworkStatus
	slot3 = uv2(slot0, 2, "float(__thiscall*)(void*, SteamNetworkPingLocation_t &)")

	function uv1.GetLocalPingLocation(slot0)
		return uv0(uv1, slot0)
	end

	uv1.get_local_ping_location = uv1.GetLocalPingLocation
	slot4 = uv2(slot0, 3, "int(__thiscall*)(void*, const SteamNetworkPingLocation_t &, const SteamNetworkPingLocation_t &)")

	function uv1.EstimatePingTimeBetweenTwoLocations(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.estimate_ping_time_between_two_locations = uv1.EstimatePingTimeBetweenTwoLocations
	slot5 = uv2(slot0, 4, "int(__thiscall*)(void*, const SteamNetworkPingLocation_t &)")

	function uv1.EstimatePingTimeFromLocalHost(slot0)
		return uv0(uv1, slot0)
	end

	uv1.estimate_ping_time_from_local_host = uv1.EstimatePingTimeFromLocalHost
	slot6 = uv2(slot0, 5, "void(__thiscall*)(void*, const SteamNetworkPingLocation_t &, char *, int)")

	function uv1.ConvertPingLocationToString(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.convert_ping_location_to_string = uv1.ConvertPingLocationToString
	slot7 = uv2(slot0, 6, "bool(__thiscall*)(void*, const char *, SteamNetworkPingLocation_t &)")

	function uv1.ParsePingLocationString(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.parse_ping_location_string = uv1.ParsePingLocationString
	slot8 = uv2(slot0, 7, "bool(__thiscall*)(void*, float)")

	function uv1.CheckPingDataUpToDate(slot0)
		return uv0(uv1, slot0)
	end

	uv1.check_ping_data_up_to_date = uv1.CheckPingDataUpToDate
	slot9 = uv2(slot0, 8, "int(__thiscall*)(void*, unsigned int, unsigned int *)")

	function uv1.GetPingToDataCenter(slot0)
		slot1 = uv0()

		return uv1(uv2, slot0, slot1), uv3(slot1)
	end

	uv1.get_ping_to_data_center = uv1.GetPingToDataCenter
	slot10 = uv2(slot0, 9, "int(__thiscall*)(void*, unsigned int)")

	function uv1.GetDirectPingToPOP(slot0)
		return uv0(uv1, slot0)
	end

	uv1.get_direct_ping_to_pop = uv1.GetDirectPingToPOP
	slot11 = uv2(slot0, 10, "int(__thiscall*)(void*)")

	function uv1.GetPOPCount()
		return uv0(uv1)
	end

	uv1.get_pop_count = uv1.GetPOPCount
	slot12 = uv2(slot0, 11, "int(__thiscall*)(void*, unsigned int *, int)")

	function uv1.GetPOPList(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.get_pop_list = uv1.GetPOPList
	slot13 = uv2(slot0, 12, "long long(__thiscall*)(void*)")

	function uv1.GetLocalTimestamp()
		return uv0(uv1)
	end

	uv1.get_local_timestamp = uv1.GetLocalTimestamp
	slot14 = uv2(slot0, 13, "void(__thiscall*)(void*, int, void (__thiscall*)(int, const char *))")

	function uv1.SetDebugOutputFunction(slot0, slot1)
		return uv2(uv3, uv0(slot0, uv1.ESteamNetworkingSocketsDebugOutputType, "detail_level is required"), slot1)
	end

	uv1.set_debug_output_function = uv1.SetDebugOutputFunction
	slot15 = uv2(slot0, 14, "int(__thiscall*)(void*, uint32_t)")

	function uv1.GetIPv4FakeIPType(slot0)
		return uv0(uv1, slot0)
	end

	uv1.get_i_pv4_fake_ip_type = uv1.GetIPv4FakeIPType
	slot16 = uv2(slot0, 15, "int(__thiscall*)(void*, const SteamNetworkingIPAddr &, SteamNetworkingIdentity *)")

	function uv1.GetRealIdentityForFakeIP(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.get_real_identity_for_fake_ip = uv1.GetRealIdentityForFakeIP
	slot17 = uv2(slot0, 16, "bool(__thiscall*)(void*, int, int, intptr_t, int, const void *)")

	function uv1.SetConfigValue(slot0, slot1, slot2, slot3, slot4)
		return uv2(uv3, uv0(slot0, uv1.ESteamNetworkingConfigValue, "value is required"), uv0(slot1, uv1.ESteamNetworkingConfigScope, "scope_type is required"), slot2, uv0(slot3, uv1.ESteamNetworkingConfigDataType, "data_type is required"), slot4)
	end

	uv1.set_config_value = uv1.SetConfigValue
	slot18 = uv2(slot0, 17, "int(__thiscall*)(void*, int, int, intptr_t, int *, void *, size_t *)")

	function uv1.GetConfigValue(slot0, slot1, slot2, slot3, slot4)
		slot5 = uv2()

		return uv3(uv4, uv0(slot0, uv1.ESteamNetworkingConfigValue, "value is required"), uv0(slot1, uv1.ESteamNetworkingConfigScope, "scope_type is required"), slot2, slot5, slot3, slot4), uv5(slot5)
	end

	uv1.get_config_value = uv1.GetConfigValue
	slot19 = uv2(slot0, 18, "const char *(__thiscall*)(void*, int, int *, int *)")

	function uv1.GetConfigValueInfo(slot0)
		return uv3(uv4, uv0(slot0, uv1.ESteamNetworkingConfigValue, "value is required"), uv2(), uv2()) ~= nil and uv5(slot3) or nil, uv6(slot1), uv6(slot2)
	end

	uv1.get_config_value_info = uv1.GetConfigValueInfo
	slot20 = uv2(slot0, 19, "int(__thiscall*)(void*, int, bool)")

	function uv1.IterateGenericEditableConfigValues(slot0, slot1)
		return uv2(uv3, uv0(slot0, uv1.ESteamNetworkingConfigValue, "current is required"), slot1)
	end

	uv1.iterate_generic_editable_config_values = uv1.IterateGenericEditableConfigValues
	slot21 = uv2(slot0, 20, "void(__thiscall*)(void*, const SteamNetworkingIPAddr &, char *, uint32_t, bool)")

	function uv1.SteamNetworkingIPAddr_ToString(slot0, slot1, slot2, slot3)
		return uv0(uv1, slot0, slot1, slot2, slot3)
	end

	uv1.steam_networking_ip_addr_to_string = uv1.SteamNetworkingIPAddr_ToString
	slot22 = uv2(slot0, 21, "bool(__thiscall*)(void*, SteamNetworkingIPAddr *, const char *)")

	function uv1.SteamNetworkingIPAddr_ParseString(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.steam_networking_ip_addr_parse_string = uv1.SteamNetworkingIPAddr_ParseString
	slot23 = uv2(slot0, 22, "int(__thiscall*)(void*, const SteamNetworkingIPAddr &)")

	function uv1.SteamNetworkingIPAddr_GetFakeIPType(slot0)
		return uv0(uv1, slot0)
	end

	uv1.steam_networking_ip_addr_get_fake_ip_type = uv1.SteamNetworkingIPAddr_GetFakeIPType
	slot24 = uv2(slot0, 23, "void(__thiscall*)(void*, const SteamNetworkingIdentity &, char *, uint32_t)")

	function uv1.SteamNetworkingIdentity_ToString(slot0, slot1, slot2)
		return uv0(uv1, slot0, slot1, slot2)
	end

	uv1.steam_networking_identity_to_string = uv1.SteamNetworkingIdentity_ToString
	slot25 = uv2(slot0, 24, "bool(__thiscall*)(void*, SteamNetworkingIdentity *, const char *)")

	function uv1.SteamNetworkingIdentity_ParseString(slot0, slot1)
		return uv0(uv1, slot0, slot1)
	end

	uv1.steam_networking_identity_parse_string = uv1.SteamNetworkingIdentity_ParseString

	return uv1
end

slot168 = {
	version_number = 1,
	version = "SteamGameServerStats001"
}

function slot62.ISteamGameServerStats()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 14, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "SteamGameServerStats001")
	uv2.thisptr = slot0
	slot1 = uv3(slot0, 0, "uint64_t(__thiscall*)(void*, SteamID)")
	slot2 = {
		struct = uv4([[
			struct {
				int m_eResult;
				SteamID m_steamIDUser;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_steamIDUser = "steamid_user"
		}
	}

	function uv2.RequestUserStats(slot0, slot1)
		slot0 = uv0(slot0, "steamid_user is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 1800, uv6)
		end

		return slot2
	end

	uv2.request_user_stats = uv2.RequestUserStats
	slot3 = uv3(slot0, 1, "bool(__thiscall*)(void*, SteamID, const char *, int32_t *)")

	function uv2.GetUserStatInt32(slot0, slot1)
		slot2 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_user is required"), slot1, slot2), uv4(slot2)
	end

	uv2.get_user_stat_int32 = uv2.GetUserStatInt32
	slot4 = uv3(slot0, 2, "bool(__thiscall*)(void*, SteamID, const char *, float *)")

	function uv2.GetUserStatFloat(slot0, slot1)
		slot2 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_user is required"), slot1, slot2), uv4(slot2)
	end

	uv2.get_user_stat_float = uv2.GetUserStatFloat
	slot5 = uv3(slot0, 3, "bool(__thiscall*)(void*, SteamID, const char *, bool *)")

	function uv2.GetUserAchievement(slot0, slot1)
		slot2 = uv1()

		return uv2(uv3, uv0(slot0, "steamid_user is required"), slot1, slot2), uv4(slot2)
	end

	uv2.get_user_achievement = uv2.GetUserAchievement
	slot6 = uv3(slot0, 4, "bool(__thiscall*)(void*, SteamID, const char *, int32_t)")

	function uv2.SetUserStatInt32(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), slot1, slot2)
	end

	uv2.set_user_stat_int32 = uv2.SetUserStatInt32
	slot7 = uv3(slot0, 5, "bool(__thiscall*)(void*, SteamID, const char *, float)")

	function uv2.SetUserStatFloat(slot0, slot1, slot2)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), slot1, slot2)
	end

	uv2.set_user_stat_float = uv2.SetUserStatFloat
	slot8 = uv3(slot0, 6, "bool(__thiscall*)(void*, SteamID, const char *, float, double)")

	function uv2.UpdateUserAvgRateStat(slot0, slot1, slot2, slot3)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), slot1, slot2, slot3)
	end

	uv2.update_user_avg_rate_stat = uv2.UpdateUserAvgRateStat
	slot9 = uv3(slot0, 7, "bool(__thiscall*)(void*, SteamID, const char *)")

	function uv2.SetUserAchievement(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), slot1)
	end

	uv2.set_user_achievement = uv2.SetUserAchievement
	slot10 = uv3(slot0, 8, "bool(__thiscall*)(void*, SteamID, const char *)")

	function uv2.ClearUserAchievement(slot0, slot1)
		return uv1(uv2, uv0(slot0, "steamid_user is required"), slot1)
	end

	uv2.clear_user_achievement = uv2.ClearUserAchievement
	slot11 = uv3(slot0, 9, "uint64_t(__thiscall*)(void*, SteamID)")
	slot12 = {
		struct = uv4([[
			struct {
				int m_eResult;
				SteamID m_steamIDUser;
			} *
		]]),
		keys = {
			m_eResult = "result",
			m_steamIDUser = "steamid_user"
		}
	}

	function uv2.StoreUserStats(slot0, slot1)
		slot0 = uv0(slot0, "steamid_user is required")

		if slot1 ~= nil and not uv1(slot1) then
			return uv2("Invalid callback, expected function or await")
		end

		if slot1 ~= nil then
			slot2 = uv5(uv3(uv4, slot0), slot1, 1801, uv6)
		end

		return slot2
	end

	uv2.store_user_stats = uv2.StoreUserStats

	return uv2
end

slot169 = {}
slot61.ISteamNetworkingFakeUDPPort = slot169

slot56("ISteamNetworkingFakeUDPPort", [[
		typedef struct _ISteamNetworkingFakeUDPPort {
			void* vtbl;
			struct {
			} vtbl_storage[1];
		} ISteamNetworkingFakeUDPPort;
	]])

slot170 = slot4("struct _ISteamNetworkingFakeUDPPort[1]")
slot171 = slot4("struct _ISteamNetworkingFakeUDPPort*")
slot172, slot173 = nil
slot174 = {}

function slot169.new(slot0)
	if uv0(slot0) ~= "table" then
		return uv1("Invalid user_callbacks, expected table", 2)
	end

	if uv2 == nil then
		uv3 = {}
		uv2 = {}
	end

	for slot4, slot5 in uv4(slot0) do
		if uv2[slot4] == nil then
			return uv1("Unknown callback: " .. uv5(slot4), 2)
		elseif uv0(slot5) ~= "function" then
			return uv1(uv6("Invalid callback type for %s: %s", uv5(slot4), uv0(slot5)), 2)
		end
	end

	for slot7, slot8 in uv4(uv2) do
		if slot0[slot7] ~= nil then
			uv3[slot7][uv10(uv8(uv9, uv7()))] = slot0[slot7]
		end
	end

	for slot7, slot8 in uv4(uv2) do
		slot2.vtbl_storage[0][slot7] = slot8
	end

	slot2.vtbl = slot2.vtbl_storage
	uv11[slot3] = slot1

	return slot2
end

function slot63.ISteamFriends()
	slot0 = vtable_bind("steamclient.dll", "SteamClient020", 8, "void*(__thiscall*)(void*, int, int, const char *)")(uv0, uv1, "SteamFriends002")
	slot1 = uv2(slot0, 3, "void(__thiscall*)(void*, int)")

	function uv3.ISteamFriends.SetPersonaState(slot0)
		return uv2(uv3, uv0(slot0, uv1.EPersonaState, "ePersonaState is required"))
	end

	uv3.ISteamFriends.set_persona_state = uv3.ISteamFriends.SetPersonaState
	slot2 = uv2(slot0, 13, "bool(__thiscall*)(void*, SteamID)")

	function uv3.ISteamFriends.AddFriend(slot0)
		return uv1(uv2, uv0(slot0, "steamIDFriend is required"))
	end

	uv3.ISteamFriends.add_friend = uv3.ISteamFriends.AddFriend
	slot3 = uv2(slot0, 14, "bool(__thiscall*)(void*, SteamID)")

	function uv3.ISteamFriends.RemoveFriend(slot0)
		return uv1(uv2, uv0(slot0, "steamIDFriend is required"))
	end

	uv3.ISteamFriends.remove_friend = uv3.ISteamFriends.RemoveFriend
	slot4 = uv2(slot0, 19, "bool(__thiscall*)(void*, SteamID, int, const char*, int)")

	function uv3.ISteamFriends.SendMsgToFriend(slot0, slot1, slot2)
		return uv4(uv5, uv0(slot0, "steamIDFriend is required"), uv1(slot1, uv2.EChatEntryType, "eFriendMsgType is required"), slot2, uv3(slot2))
	end

	uv3.ISteamFriends.send_msg_to_friend = uv3.ISteamFriends.SendMsgToFriend
	slot5 = uv3.ISteamFriends.GetFriendPersonaState
	slot6 = uv3.ISteamUser.GetSteamID()

	function uv3.ISteamFriends.GetPersonaState()
		return uv0(uv1)
	end

	uv3.ISteamFriends.get_persona_state = uv3.ISteamFriends.GetPersonaState
end

function slot63.ISteamMatchmaking()
	slot0 = vtable_bind("matchmaking.dll", "MATCHFRAMEWORK_001", 13, "void*(__thiscall*)(void*)")
	slot1 = vtable_thunk(4, "SteamID(__thiscall*)(void*)")

	function uv0.ISteamMatchmaking.GetLobbyID()
		if uv0() ~= nil and uv1(slot0) ~= nil and slot1.accountid > 0 then
			return slot1
		end
	end
end

function slot63.ISteamNetworkingUtils()
	slot0 = uv0("steamnetworkingsockets.dll", "SteamDatagram_GetNetworkConfigURL", "char *(__thiscall*)(unsigned int, unsigned int)")

	function uv1.ISteamNetworkingUtils.SteamDatagram_GetNetworkConfigURL()
		if uv0() ~= nil then
			return uv1.string(slot0)
		end
	end
end

client.set_event_callback("shutdown", function ()
	for slot3, slot4 in uv0(uv1) do
		uv4(uv2(uv3, slot4))
	end

	for slot3, slot4 in uv0(uv5) do
		uv6(uv2(uv3, slot4))
	end
end)

return slot61
