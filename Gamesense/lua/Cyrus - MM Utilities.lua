--client.exec('clear')
local err = false
local requiredLibs = {
	[1] = {
		Module = 'gamesense/uix',
		Link = 'https://gamesense.pub/forums/viewtopic.php?id=18881'
	},
	[2] = {
		Module = 'gamesense/http',
		Link = 'https://gamesense.pub/forums/viewtopic.php?id=19253'
	}
}

for k in ipairs(requiredLibs) do
	if (not pcall(require, requiredLibs[k].Module)) then
		local base = requiredLibs[k]

		if (not err) then
			err = true
		end

		print(string.format('Missing Module: %s, subscribe to it here: %s', base.Module, base.Link))
	end
end

if (err) then error('read above [you are missing some module(s)]') return end

local uix, http = require('gamesense/uix'), require('gamesense/http')

local cache = {
	maxPlayers = globals.maxplayers,
	map = globals.mapname,
	tickcount = globals.tickcount,
	open = panorama.open,

	readDB = database.read,
	writeDB = database.write,

	get = ui.get,
	set = ui.set,
	setVisible = ui.set_visible,
	button = ui.new_button,
	checkbox = uix.new_checkbox,
	slider = ui.new_slider,
	combobox = ui.new_combobox,
	textbox = ui.new_textbox,
	multiselect = ui.new_multiselect,
	hotkey = ui.new_hotkey,
	label = ui.new_label,
	callback = ui.set_callback,

	colourLog = client.color_log,
	delay = client.delay_call,
	randInt = client.random_int,
	registerEvent = client.set_event_callback,
	unregisterEvent = client.unset_event_callback,
	exec = client.exec,
	findSig = client.find_signature,
	colourLog = client.color_log,
	uidToEntIndex = client.userid_to_entindex,
	unixTime = client.unix_time,
	systemTime = client.system_time,

	getProp = entity.get_prop,
	me = entity.get_local_player,
	playerResource = entity.get_player_resource,
	getName = entity.get_player_name,
	getClassName = entity.get_classname,
	sid64 = entity.get_steam64,
	isEnemy = entity.is_enemy,
	getAllEnts = entity.get_all,
	gameRules = entity.get_game_rules,

	format = string.format
}

local C = {
	EscapedSequenceChars = {
		ZeroWidthCharacter = '\u{200C}',
		NoBreakSpace = '\u{00A0}'
	},
	Config = {
		Panel = 'LUA',
		Side = 'A'
	},
	Panorama = {
		MyPersonaAPI = cache.open().MyPersonaAPI,
		LobbyAPI = cache.open().LobbyAPI,
		PartyListAPI = cache.open().PartyListAPI,
		MatchInfoAPI = cache.open().MatchInfoAPI,
		GameStateAPI = cache.open().GameStateAPI,
		CompetitiveMatchAPI = cache.open().CompetitiveMatchAPI
	},
	MapList = {
		['ar_baggage'] = 'Baggage',
		['ar_dizzy'] = 'Dizzy',
		['ar_lunacy'] = 'Lunacy',
		['ar_monastery'] = 'Monastery',
		['ar_shoots'] = 'Shoots',
		['cs_agency'] = 'Agency',
		['cs_assault'] = 'Assault',
		['cs_italy'] = 'Italy',
		['cs_militia'] = 'militia',
		['cs_office'] = 'Office',
		['de_anubis'] = 'Anubis',
		['de_bank'] = 'Bank',
		['de_cache'] = 'Cache',
		['de_cbble'] = 'Cobblestone',
		['de_chlorine'] = 'Chlorine',
		['de_dust2'] = 'Dust II',
		['de_inferno'] = 'Inferno',
		['de_lake'] = 'Lake',
		['de_mirage'] = 'Mirage',
		['de_nuke'] = 'Nuke',
		['de_overpass'] = 'Overpass',
		['de_safehouse'] = 'Safehouse',
		['de_shortdust'] = 'Shortdust',
		['de_shortnuke'] = 'Shortnuke',
		['de_stmarc'] = 'St. Marc',
		['de_sugarcane'] = 'Sugarcane',
		['de_train'] = 'Train',
		['de_vertigo'] = 'Vertigo',
		['dz_blacksite'] = 'Blacksite',
		['dz_junglety'] = 'Junglety',
		['dz_sirocco'] = 'Sirocco',
		['gd_cbble'] = 'Cobblestone',
		['gd_rialto'] = 'Rialto'
	},
	CountryCodes = {
		['Afrikaans'] = 'af',
		['Irish'] = 'ga',
		['Albanian'] = 'sq',
		['Italian'] = 'it',
		['Arabic'] = 'ar',
		['Japanese'] = 'ja',
		['Azerbaijani'] = 'az',
		['Kannada'] = 'kn',
		['Basque'] = 'eu',
		['Korean'] = 'ko',
		['Bengali'] = 'bn',
		['Latin'] = 'la',
		['Belarusian'] = 'be',
		['Latvian'] = 'lv',
		['Bulgarian'] = 'bg',
		['Lithuanian'] = 'lt',
		['Catalan'] = 'ca',
		['Macedonian'] = 'mk',
		['Chinese'] = 'zh-CN',
		['Malay'] = 'ms',
		['Chinese'] = 'zh-TW',
		['Maltese'] = 'mt',
		['Croatian'] = 'hr',
		['Norwegian'] = 'no',
		['Czech'] = 'cs',
		['Persian'] = 'fa',
		['Danish'] = 'da',
		['Polish'] = 'pl',
		['Dutch'] = 'nl',
		['Portuguese'] = 'pt',
		['English'] = 'en',
		['Romanian'] = 'ro',
		['Esperanto'] = 'eo',
		['Russian'] = 'ru',
		['Estonian'] = 'et',
		['Serbian'] = 'sr',
		['Filipino'] = 'tl',
		['Slovak'] = 'sk',
		['Finnish'] = 'fi',
		['Slovenian'] = 'sl',
		['French'] = 'fr',
		['Spanish'] = 'es',
		['Galician'] = 'gl',
		['Swahili'] = 'sw',
		['Georgian'] = 'ka',
		['Swedish'] = 'sv',
		['German'] = 'de',
		['Tamil'] = 'ta',
		['Greek'] = 'el',
		['Telugu'] = 'te',
		['Gujarati'] = 'gu',
		['Thai'] = 'th',
		['Haitian'] = 'ht',
		['Turkish'] = 'tr',
		['Hebrew'] = 'iw',
		['Ukrainian'] = 'uk',
		['Hindi'] = 'hi',
		['Urdu'] = 'ur',
		['Hungarian'] = 'hu',
		['Vietnamese'] = 'vi',
		['Icelandic'] = 'is',
		['Welsh'] = 'cy',
		['Indonesian'] = 'id',
		['Yiddish'] = 'yi'
	},
	Colours = {
		White = '\x01',
		Red	= '\x02',
		Purple = '\x03',
		Green = '\x04',
		YellowGreen	= '\x05',
		LightGreen = '\x06',
		LightRed = '\x07',
		Gray = '\x08',
		Gray2 = '\x0A',
		LightYellow = '\x09',
		Blue = '\x0B',
		DarkBlue = '\x0C',
		Gold = '\x10',
		RGB = {
			White = {
				r = 255,
				g = 255,
				b = 255
			},
			Yellow = {
				r = 234,
				g = 237,
				b = 37
			},
			Green = {
				r = 126,
				g = 215,
				b = 135
			},
			Red = {
				r = 200,
				g = 82,
				b = 76
			},
			Blue = {
				r = 105,
				g = 140,
				b = 255
			},
			Orange = {
				r = 200,
				g = 140,
				b = 56
			},
		},
		Discord = {
			Win = 7855479, -- GREEN
			Loss = 16738657, -- RED
			CT = 2003199, -- CT
			T = 16757575, -- T
			Draw = 9868950 -- GREY
		},
		PlayerColours = {
			yellow = '#F8F62D',
			y = '#F8F62D',

			purple = '#A119F0',
			p = '#A119F0',

			green = '#00B562',
			g = '#00B562',

			blue = '#5CA8FF',
			b = '#5CA8FF',

			orange = '#FF9B25',
			o = '#FF9B25'
		}
	},
	DB = {
		Ping = {
			ID = 'cyrus.ping.id',
			Start = 'cyrus.ping.start',
			End = 'cyrus.ping.end',
			TimeZone = 'cyrus.ping.timezone'
		}
	},
	Ranks = {
		MM = {
			'SI',
			'S2',
			'S3',
			'S4',
			'SE',
			'SEM',

			'GN1',
			'GN2',
			'GN3',
			'GNM',
			'MG1',
			'MG2',

			'MGE',
			'DMG',
			'LE',
			'LEM',
			'SMFC',
			'GE'
		},
		DZ = {
			'Lab Rat I',
			'Lab Rat II',

			'Sprinting Hare I',
			'Sprinting Hare II',

			'Wild Scout I',
			'Wild Scout II',
			'Wild Scout Elite',

			'Hunter Fox I',
			'Hunter Fox II',
			'Hunter Fox III',
			'Hunter Fox Elite',

			'Timber Wolf',
			'Ember Wolf',
			'Wildfire Wolf',

			'The Howling Alpha'
		}
	},
	Votes = {
		IndicesNoteam = {
			[0] = "kick",
			[1] = "changelevel",
			[3] = "scrambleteams",
			[4] = "swapteams",
		},
		IndicesTeam = {
			[1] = 'starttimeout',
			[2] = 'surrender'
		},
		Descriptions = {
			changelevel = 'change the map',
			scrambleteams = 'scramble the teams',
			starttimeout = 'start a timeout',
			surrender = 'surrender',
			kick = 'kick'
		},
		ongoingVotes = {},
		VoteOptions = {}
	},
	Chat = {
		Prefix = '!',
		Spam = {
			LastChatMessage = 0,
			LastRadioMessage = 0,
			RadioMessage = 'getout',
			DefaultMessage = 'your tears are currently being harvested',
			Types = {
				['Kill'] = 'Off',
				['Death'] = 'Off',
				['Chat'] = 'Off'
			}
		},
		Words = {
			Openers = {
				'get fucked',
				'eat shit',
				'fuck a baboon',
				'suck my dingleberries',
				'choke on steaming cum',
				'die in a fire',
				'gas yourself',
				'sit on garden shears',
				'choke on scrotum',
				'shove a brick up your ass',
				'swallow barbed wire',
				'move to sweden',
				'fuck a pig',
				'bow to me',
				'suck my ball sweat',
				'come back when you aren\'t garbage',
				'i will piss on everything you love',
				'kill yourself',
				'livestream suicide',
				'neck yourself',
				'go be black somewhere else',
				'rotate on it',
				'choke on it',
				'blow it out your ass',
				'go browse tumblr',
				'go back to casual',
				'sit on horse cock',
				'drive off a cliff',
				'rape yourself',
				'get raped by niggers',
				'fuck right off',
				'you mother is a whore',
				'come at me',
				'go work the corner',
				'you are literal cancer',
				'why haven\'t you killed yourself yet',
				'why do you even exist',
				'shoot your balls off with a shotgun',
				'sterilize yourself',
				'convert to islam',
				'drink bleach',
				'remove yourself',
				'choke on whale cock',
				'suck shit',
				'suck a cock',
				'lick my sphincter',
				'set yourself on fire',
				'drink jenkem',
				'get beaten to death by your dad',
				'choke on your uncle\'s cock',
				'get sat on by a 200kg feminist',
				'blow off',
				'join isis',
				'stick your cock in a blender',
				'OD yourself on meth',
				'lie under a truck',
				'lick a wall socket',
				'swallow hot coals',
				'die slowly',
				'explode yourself',
				'swing from the noose',
				'end yourself',
				'take your best shot',
				'get shot in a gay bar',
				'drink pozzed cum',
				'marry a muslim',
				'rub your dick on a cheese grater',
				'wrap a rake with barbed wire and sodomize yourself',
				'close your gaping cunt',
			},
			Joiners = {
				'cancer infested',
				'cock sucking',
				'fuck faced',
				'cunt eyed',
				'nigger fucking',
				'candy ass',
				'fairy ass fucking',
				'shit licking',
				'unlovable',
				'disgusting',
				'degenerate',
				'fuck headed',
				'dick lipped',
				'autismal',
				'gook eyed',
				'mongoloided',
				'cunt faced',
				'dick fisted',
				'worthless',
				'hillary loving',
				'maggot infested',
				'boot lipped',
				'chink eyed',
				'shit skinned',
				'nigger headed',
				'lgbt supporting',
				'cum stained',
			},
			Enders = {
				'fuck face',
				'poofter',
				'jew cunt',
				'fagmaster',
				'goat rapist',
				'rag head',
				'cock cheese',
				'vaginaphobe',
				'coon',
				'nigger',
				'slag cunt',
				'garbage man',
				'paeodophile',
				'kiddy toucher',
				'pony fucker',
				'tumblrite',
				'sperglord',
				'gorilla\'s dick',
				'shit licker',
				'shit slick',
				'redditor',
				'pig fucker',
				'spastic',
				'cuckold',
				'chode gobbler',
				'fuckwit',
				'retard',
				'mongoloid',
				'elephants cunt',
				'cunt',
				'gook',
				'fag lord',
				'shit stain',
				'mpgh skid',
				'batch coder',
				'pony fucker',
				'furfag',
				'half caste',
				'double nigger',
				'cock socket',
				'cunt rag',
				'anal wart',
				'maggot',
				'knob polisher',
				'fudge packer',
				'cock slave',
				'trashmaster',
				'shitskin',
				'curry muncher',
				'gator bait',
				'bootlip',
				'camel jockey',
				'wog cunt',
				'hooknosed kike',
				'feminist',
				'wop cunt',
				'abo',
				'porch monkey',
				'dago',
				'anal secretion',
				'pig cunt',
				'insect',
				'sub human',
				'mental defect',
				'fat whore',
				'cunt rag',
				'cotton picker',
				'bum tickling fag',
				'degenerate faggot',
				'smegma lump',
				'darkie',
				'fuck toy',
				'underage midget cunt',
				'twelvie',
				'faggot teenager',
				'ankle biter',
				'fat cunt american',
				'bernie loving washout',
				'fucking failure',
				'cum dumpster',
				'waste of skin',
				'petrol sniffing coon',
				'jenkem bottle',
				'dirty jew',
				'casual retard',
				'cuck master',
				'barrel of piss',
				'tankard of shit',
				'cock wart',
			},
			CancerStrike = {
				'LOL fuk u silver scUm',
				'nice aim doEs It cume in NOT N00be?',
				'u r terible my doode',
				'u almost hit me that time LOL',
				'ur aim iz a joke my man',
				'get shrekt skrub xdddd',
				'u just got shitted on kidddd',
				'i bet u r silver on csgo xD',
				'u never stood a chance against my pSkillz',
				'ur just 2bad to kill me :^(',
				'dam im good',
				'u wil never beat aimware hax kidd :^)',
				'eat shit and die xdd',
				'i laugh at ur shit skillz :D',
				'get fukn owned kid xd',
				'i kill u every time u shud try harder :^(',
				'all u can do is die LOL',
				'N00bez like u cant beat me LOL',
				'u tried but im jus 2 gud 4 u',
				'u cant even hit me LOL uninstall kid xd',
				'git GUD skrub u r an embarasment',
				'pathetic LOL',
				'2 bad so sad u just bad :^(',
				'im global elit in csgo xd',
				'thx 4 free kill loser :D',
				'r u even trying???',
				'top kekt u got rekt',
				'fuken smashed kunt :D',
				'u shud add me so i can teach u how 2 shoot LOL',
				'ur jus 2 weak and sad to beat me xd',
				'looks liek ur sad life isnt working out 2 well 4 u :D',
				'dats all u got??? LOL!',
			},
			SuperCancerStrike = {
				'dont upsetti hav some spagetti',
				'eat my asse like a bufet (3 corse meal xd)',
				'i ownt u in ur gay butth0le',
				'umade noobe?',
				'le troled hard',
				'go wach naturo and play wif urself fag REKT',
				'LOL i fuckd u so hard just like ur mum lst nit fag',
				'u play liek a blynd stefen hawkin haha',
				'ARE U GUEYS NEW??',
				'are u as bad at life as u are in csgo??',
				'omg this is 2 ezy are U even trying??',
				'why dont u go play halo an fist ur butthol faget',
				'hey granma is that u???? LOL so bad',
				'time for you 2 uninstale the game shit stane',
				'congrtulations ur the worlds worst csgo player',
				'dose ur aim come in NOT NOOBE? LMAO',
				'lol i troled u so hard *OWNED*',
				'\'i lik 2 eat daddys logs of poo for lucnh while jackn off 2 naturo\'- u',
				'take a se4t faget $hitstain u got OWNDE',
				'LOL scrub ur gettin rekt hardcroe',
				'R u mad becouse ur bad nooby?',
				'LMAO did u go to da buthurt king an g3t urself a butthurt with fries?!?',
				'why dont u go and play manoppoly you noob',
				'you hav no lyfe you cant evan play csgo propaly',
				'im hi rite now on ganj but im stil ownen u xD',
				'if u want my cum bake ask ur mum LOL',
				'butdocter prognoses: OWND',
				'cry 2 ur dads dick forver noob',
				'lol troled autismal faget',
				'LOL N3RD owned',
				'\'i love to drink sprems all day\'- u',
				'crushd nerd do u want a baindaid for that LOL',
				'lol rectal rekage ur so sh1t lol',
				'ass states - [_] NOT REKT [X] REKT',
				'lmao do u even try????',
				'are u slippan off ur chaire cos ur ass is bleeding so hard??',
				'u better get a towel for all ur tears faget',
				'u got ass asassenated by me rofl',
				'u wont shit agen thats how rekt ur ass is',
				'i bet youre anus is sore from me ownen u LOL',
				'im gonna record a fragshow so i can watch me pwn u ova and ova LMAO',
				'i almost feel sorry for you hahahaha',
				'lol why dont u play COD so i can own you there too',
				'how dose it feel to be owneded so hartd??',
				'rekt u lol another one for the fraghsow',
				'if i was as bade as u i would kil myself',
				'dont fell bad not ervry one can be goode',
				'do u need some loob for ur butt so it doesnt hurt so much when i fuck u',
				'spesciall delivary for CAPTEN BUTTHURT',
				'wats wrong cant play wif ur dads dik in ur mouth????',
				'maybe if u put down the cheseburgers u could kill me lol fat nerd',
				'getting mad u virgan nerd??',
				'butt docta prognosis: buttfustrated',
				'<<< OWEND U >>>',
				'if u were a fish you wuld be a sperm whael LOL',
				'>mfw i ownd u',
				'rekt u noob *OWNED*',
				'ur gonna have 2 wear dipers now cos ur ass got SHREDED by me',
				'y dont u take a short strole to the fagot store and buy some skills scrub',
				'school3d by a 13yo lol u r rely bad',
				'ur pathetic nerd its like u have parkensons',
				'u just got promoted 2 cumcaptain prestige',
				'lol pwnd',
				'u just got butt raped lol TROLLED U',
				'did u learn 2 aim from stevie wondar??? LOL',
				'tell ur mum to hand the keyboard and mosue back',
				'how does it feel to be shit on by a 13 yer old',
				'r u into scat porns or some thing cos it feel\'s like u want me 2 shit on u',
				'u play csgo like my granpa and hes ded',
				'are u new or just bad?? noobe',
				'u play csgo lik a midget playin basket ball',
				'welcome to the noob scoole bus first stop ur house <<PWND>>',
				'>mfw i rek u',
				'\'i got my ass kiked so hard im shittn out my mouf\' - u',
				'<-(0.0)-< dats u gettn ownd LOL',
				'u just got ur ass ablitterated <<<RECKT>>>',
				'c=3 (dats ur tiney dik rofl)',
				'just leeve the game and let the real mans play',
				'ur so bad u make ur noobe team look good',
				'CONGRASTULATIONS YOU GOT FRIST PRIZE IN BEING BUTT MAD (BUT LAST IN PENIS SIZE LMAO)',
				'im not even trying to pwn u its just so easy',
				'im only 13 an im better than u haha XD',
				'u just got raped',
				'some one an ambulance cos u just got DE_STROYED',
				'i hope u got birth control coz u got rapped',
				'lol pwnd scrubb',
				'you play lik a girl',
				'\'i got fukd so hard dat im cummin shit n shittn cum\'- u',
				'ur gonna need tampons for ur ass afta that ownage',
				'{{ scoooled u }}',
				'(O.o) ~c======3 dats me jizzan on u',
				'dont worry at least ur tryan XD',
				'cya noob send me a post card from pwnd city ROFL',
				'its ok if u keep practasing u will get bettar lol #rekt',
				'\'evry time i fart 1 liter of cum sqerts out\' - u',
				'rofl i pwnd u scrub #420 #based #mlgskill',
				'u fail just like ur dads condom',
				'if i pwnd u any harder it wud be animal abuse',
				'uploaden this fragshow roflmao',
			},
			Questions = {
				'whats the max tabs you can have open on a vpn',
				'whats the time',
				'is it possible to make a clock in binary',
				'how many cars can you drive at once',
				'did you know there\'s more planes on the ground than there is submarines in the air',
				'how many busses can you fit on 1 bus',
				'how many tables does it take to support a chair',
				'how many doors does it take to screw a screw',
				'how long can you hold your eyes closed in bed',
				'how long can you hold your breath for under spagetti',
				'whats the fastest time to deliver the mail as a mail man',
				'how many bees does it take to make a wasp make honey',
				'If I paint the sun blue will it turn blue',
				'how many beavers does it take to build a dam',
				'how much wood does it take to build a computer',
				'can i have ur credit card number',
				'is it possible to blink and jump at the same time',
				'did you know that dinosaurs were, on average, large',
				'how many thursdays does it take to paint an elephant purple',
				'if cars could talk how fast would they go',
				'did you know theres no oxygen in space',
				'do toilets flush the other way in australia',
				'if i finger paint will i get a splinter',
				'can you build me an ant farm',
				'did you know australia hosts 4 out of 6 of the deadliest spiders in the world',
				'is it possible to ride a bike in space',
				'can i make a movie based around your life',
				'how many pants can you put on while wearing pants',
				'if I paint a car red can it wear pants',
				'how come no matter what colour the liquid is the froth is always white',
				'can a hearse driver drive a corpse in the car pool lane',
				'how come the sun is cold at night',
				'why is it called a TV set when there is only one',
				'if i blend strawberries can i have ur number',
				'if I touch the moon will it be as hot as the sun',
				'did u know ur dad is always older than u',
				'did u know the burger king logo spells burger king',
				'did u know if u chew on broken glass for a few mins, it starts to taste like blood',
				'did u know running is faster than walking',
				'did u know the colour blue is called blue because its blue',
				'did u know a shooting star isnt a star',
				'did u know shooting stars dont actually have guns',
				'did u know the great wall of china is in china',
				'statistictal fact: 100% of non smokers die',
				'did u kmow if you eat you poop it out',
				'did u know rain clouds r called rain clouds cus they are clouds that rain',
				'if cows drink milk is that cow a cannibal',
				'did u know you cant win a staring contest with a stuffed animal',
				'did u know if a race car is at peak speed and hits someone they\'ll die',
				'did u know the distance between the sun and earth is the same distance as the distance between the earth and the sun',
				'did u know flat screen tvs arent flat',
				'did u know aeroplane mode on ur phone doesnt make ur phone fly',
				'did u know too many birthdays can kill you',
				'did u know rock music isnt for rocks',
				'did u know if you eat enough ice you can stop global warming',
				'if ww2 happened before vietnam would that make vietnam world war 2',
				'did u know 3.14 isn\'t a real pie',
				'did u know 100% of stair accidents happen on stairs',
				'can vampires get AIDS',
				'what type of bird was a dodo',
				'did u know dog backwards is god',
				'did you know on average a dog barks more than a cat',
				'did u know racecar backwards is racecar'
			}
		}
	},
	ChangeLogs = {
		'',
		'===== 2.0 (July 15 2020) =====',
		'Completely rewrote Cyrus'
	}
}

C.Libs = {
	ChatPrint = {
		Initialise = function()
			local ffi = require("ffi")
			ffi.cdef[[
				typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
				typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);
			]]

			local signature_gHud = '\xB9\xCC\xCC\xCC\xCC\x88\x46\x09'
			local signature_FindElement = '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28'

			local match = cache.findSig('client_panorama.dll', signature_gHud) or error('sig1 not found') -- returns void***
			local char_match = ffi.cast('char*', match) + 1
			local hud = ffi.cast('void**', char_match)[0] or error('hud is nil') -- returns void**

			match = cache.findSig('client_panorama.dll', signature_FindElement) or error('FindHudElement not found')
			local find_hud_element = ffi.cast('FindHudElement_t', match)
			local hudchat = find_hud_element(hud, 'CHudChat') or error('CHudChat not found')
			local chudchat_vtbl = hudchat[0] or error('CHudChat instance vtable is nil')
			local raw_print_to_chat = chudchat_vtbl[27] -- void*
			local print_to_chat = ffi.cast('ChatPrintf_t', raw_print_to_chat)

			local function Send(text)
				print_to_chat(hudchat, 0, 0, text)
			end

			C.Libs.ChatPrint.Send = Send
		end
	}
}

for _, lib in pairs(C.Libs) do
	lib.Initialise()
end

C.Notifications = {
	UIToggle = function(name, bool)
		if (C.UI.ShowUIMessages.Element:get()) then
			local col = C.Colours
			local toggleMsg = bool and col.LightGreen .. 'Enabled' or col.LightRed .. 'Disabled'
			local tab = cache.get(C.UI.NotificationType.Element)
			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = name, bool = bool})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s%s%s was %s', col.Blue, col.White, col.Gold, name, col.White, toggleMsg))
			end
		end
	end,
	UIChange = function(name, tab)
		if (C.UI.ShowUIMessages.Element:get()) then
			local col = C.Colours
			local options = cache.get(C.UI.NotificationType.Element)

			for _, v in pairs(options) do
				if (#tab > 0) then
					local tmpArr = {}

					for _, msg in pairs(tab) do
						table.insert(tmpArr, (v == 'Console' and msg or (col.Purple .. msg .. col.White)))
					end

					tmpArr = table.concat(tmpArr, ', ')

					if (v == 'Chat Print') then
						C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s%s%s set to (%s)', col.Blue, col.White, col.Gold, name, col.White, tmpArr))
					else
						C.Notifications.Console.Log({text = cache.format('%s was set to (%s)', name, tmpArr), bool = true})
					end
				else
					if (v == 'Chat Print') then
						C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s%s%s was %sDisabled', col.Blue, col.White, col.Gold, name, col.White, col.Red))
					else
						C.Notifications.Console.Log({text = cache.format('%s was disabled', name), bool = false})
					end
				end
			end
		end
	end,
	Votes = {
		Kick = function(tab)
			local col = C.Colours
			local team = tab.team
			local teamInitials = team == 2 and 'T' or 'CT'
			local teamCol = team == 2 and col.LightYellow or col.Blue
			local description = tab.description
			local descriptionFormatted = cache.format('%s', col.Purple .. description)
			local teamFormatted = cache.format('%s%s', teamCol .. teamInitials, col.White)
			local target = tab.target
			local targetFormatted = cache.format('%s', teamCol .. target)
			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Vote - The %s\'s started a vote to %s %s', teamInitials, description, target), normal_log = true})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s The %s\'s started a vote to %s %s', col.Blue, col.White, col.Gold .. 'Vote' .. col.White .. ' -', teamFormatted, descriptionFormatted, targetFormatted))
			end
		end,
		Start = function(tab)
			local col = C.Colours
			local player = tab.player
			local playerFormatted = cache.format('%s%s%s', tab.team == 3 and col.Blue or col.LightYellow, player, col.White)
			local description = tab.description
			local descriptionFormatted = cache.format('%s', col.Purple .. description)
			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Vote - %s called a vote to %s', player, description), normal_log = true})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s %s called a vote to %s', col.Blue, col.White, col.Gold .. 'Vote' .. col.White .. ' -', playerFormatted, descriptionFormatted))
			end
		end,
		Vote = function(tab)
			local col = C.Colours
			local player = tab.player
			local playerFormatted = cache.format('%s%s%s', tab.team == 3 and col.Blue or col.LightYellow, player, col.White)
			local vote = tab.vote
			local voteFormatted = cache.format('%s%s', vote and col.Green .. 'Yes' or col.Red .. 'No', col.White)
			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Vote - %s voted %s', player, vote and 'Yes' or 'No'), bool = vote})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %sVote %s- %s voted %s', col.Blue, col.White, col.Gold, col.White, playerFormatted, voteFormatted))
			end
		end
	},
	Logs = {
		Hit = function(tab)
			C.Vars.HitLog.AimHit = true

			local hit = tab.hit
			local fired = tab.fired
			local col = C.Colours
			local name = cache.getName(hit.target)
			local nameFormatted = col.Gold .. name .. col.White
			local hitbox = C.Vars.HitLog.HitGroups[hit.hitgroup + 1]
			local hitboxFormatted = col.Purple .. hitbox .. col.White
			local firedAtHitbox = C.Vars.HitLog.HitGroups[fired.hitgroup + 1]
			local firedAtHitboxFormatted = col.Blue .. firedAtHitbox .. col.White
			local hitchance = math.floor(fired.hit_chance)
			local hitchanceFormatted = col.LightRed .. hitchance .. col.White
			local hitDamage = hit.damage
			local hitDamageFormatted = col.LightRed .. hitDamage .. col.White
			local firedDamage = fired.damage
			local firedDamageFormatted = col.LightGreen .. firedDamage .. col.White
			local health = cache.getProp(hit.target, 'm_iHealth') or -1
			local healthFormatted = col.LightRed .. health .. col.White

			local flags = {
				fired.boosted and 'B' or '',
				fired.extrapolated and 'E' or '',
				fired.high_priority and 'H' or '',
				fired.interpolated and 'I' or '',
				fired.teleported and 'T' or ''
			}

			flags = table.concat(flags)

			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Hit %s\'s %s (fired: %s, hc: %s, dmg: %s) for %s (%s) (%s hp)', name, hitbox, firedAtHitbox, hitchance, firedDamage, hitDamage, flags, health), normal_log = true})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] Hit %s\'s %s (fired: %s, hc: %s, dmg: %s) for: %s (%s) (%s hp)', col.Blue, col.White, nameFormatted, hitboxFormatted, firedAtHitboxFormatted, hitchanceFormatted, firedDamageFormatted, hitDamageFormatted, flags, healthFormatted))
			end

			cache.delay(0, function()
				C.Vars.HitLog.AimHit = false
			end)
		end,
		HitNormal = function(tab)
			if (not C.Vars.HitLog.AimHit) then
				local hit = tab
				local col = C.Colours
				local name = cache.getName(hit.victim)
				local nameFormatted = col.Gold .. name .. col.White
				local hitbox = C.Vars.HitLog.HitGroups[hit.hitgroup + 1]
				local formattedHitbox = col.Purple .. (hitbox == 'generic' and 'body' or hitbox) .. col.White
				local hitDamage = hit.dmg_health
				local hitDamageFormatted = col.Green .. hitDamage .. col.White
				local hpRemaining = hit.health
				local hpRemainingFormatted = col.LightRed .. hpRemaining .. col.White
				local options = cache.get(C.UI.NotificationType.Element)
				local hasValue = C.Funcs.TableHasValue

				if (hasValue(options, 'Console')) then
					C.Notifications.Console.Log({text = cache.format('Hit %s\'s %s for %s dmg (%s hp remaining)', name, hitbox == 'generic' and 'body' or hitbox, hitDamage, hpRemaining), normal_log = true})
				end

				if (hasValue(options, 'Chat Print')) then
					C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] Hit %s\'s %s for %s dmg (%s hp remaining)', col.Blue, col.White, nameFormatted, formattedHitbox, hitDamageFormatted, hpRemainingFormatted))
				end
			end
		end,
		Miss = function(tab)
			local miss = tab.miss
			local fired = tab.fired
			local col = C.Colours
			local name = cache.getName(miss.target)
			local nameFormatted = col.Gold .. name .. col.White
			local hitbox = C.Vars.HitLog.HitGroups[miss.hitgroup + 1]
			local hitboxFormatted = col.Purple .. hitbox .. col.White
			local reason = miss.reason
			local reasonFormatted = col.Green .. miss.reason .. col.White
			local hitchance = math.floor(miss.hit_chance)
			local hitchanceFormatted = col.LightRed .. hitchance .. col.White
			local damage = fired.damage
			local damageFormatted = col.LightRed .. damage .. col.White
			local flags = {
				fired.boosted and 'B' or '',
				fired.extrapolated and 'E' or '',
				fired.high_priority and 'H' or '',
				fired.interpolated and 'I' or '',
				fired.teleported and 'T' or ''
			}

			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			flags = table.concat(flags)

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Missed %s\'s %s (r: %s, hc: %s, dmg: %s) (%s)', name, hitbox, reason, hitchance, damage, flags), normal_log = true})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] Missed %s\'s %s (r: %s, hc: %s, dmg: %s) (%s)', col.Blue, col.White, nameFormatted, hitboxFormatted, reasonFormatted, hitchanceFormatted, damageFormatted, flags))
			end
		end,
		TeamDamage = function(tab)
			local col = C.Colours
			local victim = tab.victim
			local victimFormatted = col.Purple .. victim .. col.White
			local attacker = tab.attacker
			local attackerFormatted = col.Green .. attacker .. col.White
			local dmg = tab.damage
			local dmgFormatted = col.LightRed .. dmg .. col.White
			local totalDmg, maxDmg = tab.totalDamage, cvar.mp_td_dmgtokick:get_int()
			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Team Damage: %s hurt %s for %s (%s/%s)', attacker, victim, dmg, totalDmg,  maxDmg), normal_log = true})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s: %s hurt %s for %s (%s/%s)', col.Blue, col.White, col.Gold .. 'Team Damage' .. col.White, attackerFormatted, victimFormatted, dmgFormatted, totalDmg, maxDmg))
			end
		end,
		TeamKill = function(tab)
			local col = C.Colours
			local victim = tab.victim
			local victimFormatted = col.Purple .. victim .. col.White
			local attacker = tab.attacker
			local attackerFormatted = col.Green .. attacker .. col.White
			local totalKills = tab.totalKills

			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Team Kill: %s killed %s (%s/3)', attacker, victim, totalKills), normal_log = true})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s: %s killed %s (%s/3)', col.Blue, col.White, col.Gold .. 'Team Kill' .. col.White, attackerFormatted, victimFormatted, totalKills))
			end
		end
	},
	RankDump = function(tab)
		local col = C.Colours
		local name = tab.name
		local nameFormatted = (tab.team == 3 and col.Blue or col.LightYellow) .. name .. col.White
		local wins = tab.wins
		local winsFormatted = col.Purple .. wins .. col.White
		local rank = tab.rank
		local rankFormatted = col.Red .. rank .. col.White
		local options = cache.get(C.UI.NotificationType.Element)
		local hasValue = C.Funcs.TableHasValue

		if (hasValue(options, 'Console')) then
			C.Notifications.Console.Log({text = cache.format('%s has %s wins (%s)', name, wins, rank), normal_log = true})
		end

		if (hasValue(options, 'Chat Print')) then
			C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] %s has %s wins (%s)', col.Blue, col.White, nameFormatted, winsFormatted, rankFormatted))
		end
	end,
	Console = {
		Help = function(tab)
			local text = tab.text
			local bool = tab.bool or false
			local usage = tab.usage
			local col = C.Colours.RGB
			local green, white, blue, red, orange = col.Green, col.White, col.Blue, col.Red, col.Orange

			local log = cache.colourLog

			if (bool) then
				log(white.r, white.g, white.b, '[\0')
				log(blue.r, blue.g, blue.b, 'Cyrus\0')
				log(white.r, white.g, white.b, '] \0')

				log(green.r, green.g, green.b, text .. ' ')
			else
				log(orange.r, orange.g, orange.b, cache.format('\t %s\0', text))
				log(white.r, white.g, white.b, cache.format('%s\0', #usage > 0 and ' - ' or ''))
				log(green.r, green.g, green.b, cache.format('%s ', usage))
			end
		end,
		Log = function(tab)
			local text = tab.text
			local bool = tab.bool or false
			local normalLog = tab.normal_log or false
			local col = C.Colours.RGB
			local green, white, blue, red, orange = col.Green, col.White, col.Blue, col.Red, col.Orange

			local log = cache.colourLog

			local colToUse = {
				[1] = (normalLog and white.r or (bool and green.r or red.r)),
				[2] = (normalLog and white.g or (bool and green.g or red.g)),
				[3] = (normalLog and white.b or (bool and green.b or red.b))
			}

			log(white.r, white.g, white.b, '[\0')
			log(blue.r, blue.g, blue.b, 'Cyrus\0')
			log(white.r, white.g, white.b, '] - \0')

			log(colToUse[1], colToUse[2], colToUse[3], text .. ' ')
		end
	},
	Translate = {
		Chat = function(tab)
			local col = C.Colours
			local text = tab.error and tab.error or (tab.og_text and tab.og_text or tab.translated_text)
			local toLanguage = tab.error and 'Error' or (tab.og_text and 'OG Msg' or tab.to_lang)
			local toLanguageFormatted = col.Red .. toLanguage .. col.White
			local detectedLang = tab.from_lang or 'n/a'
			local options = cache.get(C.UI.NotificationType.Element)
			local hasValue = C.Funcs.TableHasValue

			if (hasValue(options, 'Console')) then
				C.Notifications.Console.Log({text = cache.format('Translate: [%s] %s', toLanguage, text), normal_log = true})
			end

			if (hasValue(options, 'Chat Print')) then
				C.Libs.ChatPrint.Send(cache.format('[%sCyrus%s] [%s] %s', col.Blue, col.White, toLanguageFormatted, text))
			end
		end
	}
}

C.ConCommands = {
	['help'] = {
		Usage = ''
	},
	['set_discord_id'] = {
		Usage = '<your discord id here>'
	},
	['set_start_webhook'] = {
		Usage = '<channel webhook here>'
	},
	['set_end_webhook'] = {
		Usage = '<channel webhook here>'
	},
	['party_say'] = {
		Usage = '<text here>'
	},
	['tsay'] = {
		Usage = '<country code> <text to translate>'
	},
	['language_codes'] = {
		Usage = ''
	},
	['changelogs'] = {
		Usage = ''
	},
	['set_timezone'] = {
		Usage = '<UTC Timezone>'
	},
	['test_discord'] = {
		Usage = ''
	}
}

C.Vars = {
	TeamKillData = {},
	HitLog = {
		HitGroups = {
			'generic',
			'head',
			'chest',
			'stomach',
			'left arm',
			'right arm',
			'left leg',
			'right leg',
			'neck',
			'?',
			'gear'
		},
		ShotInfo = {},
		AimHit = false
	},
	BuyBot = {
		WeaponData = {
			['glock'] = {
				ent = 'glock',
				cost = 200
			},
			['p2k'] = {
				ent = 'hkp2000',
				cost = 200
			},
			['p2000'] = {
				ent = 'hkp2000',
				cost = 200
			},
			['usp'] = {
				ent = 'usp_silencer',
				cost = 200
			},
			['dualies'] = {
				ent = 'elite',
				cost = 400
			},
			['p250'] = {
				ent = 'p250',
				cost = 300
			},
			['tec9'] = {
				ent = 'tec9',
				cost = 500
			},
			['57'] = {
				ent = 'fn57',
				cost = 500
			},
			['deagle'] = {
				ent = 'deagle',
				cost = 700
			},
			['r8'] = {
				ent = 'deagle',
				cost = 600
			},

			['galil'] = {
				ent = 'galilar',
				cost = 2000
			},
			['famas'] = {
				ent = 'famas',
				cost = 2050
			},
			['ak'] = {
				ent = 'ak47',
				cost = 2700
			},
			['ak47'] = {
				ent = 'ak47',
				cost = 2700
			},
			['ak-47'] = {
				ent = 'ak47',
				cost = 2700
			},
			['m4a4'] = {
				ent = 'm4a1',
				cost = 3100
			},
			['m4a1'] = {
				ent = 'm4a1_silencer',
				cost = 2900
			},
			['scout'] = {
				ent = 'ssg08',
				cost = 1700
			},
			['ssg'] = {
				ent = 'ssg08',
				cost = 1700
			},
			['aug'] = {
				ent = 'aug',
				cost = 3300
			},
			['sg553'] = {
				ent = 'sg556',
				cost = 3000
			},
			['sg'] = {
				ent = 'sg556',
				cost = 3000
			},
			['awp'] = {
				ent = 'awp',
				cost = 4750
			},
			['dak'] = {
				ent = 'scar20',
				cost = 5000
			},
			['auto'] = {
				ent = 'scar20',
				cost = 5000
			},

			['nova'] = {
				ent = 'nova',
				cost = 1050
			},
			['xm10'] = {
				ent = 'xm1014',
				cost = 2000
			},
			['sawedoff'] = {
				ent = 'mag7',
				cost = 1100
			},
			['mag7'] = {
				ent = 'mag7',
				cost = 1300
			},
			['m249'] = {
				ent = 'm249',
				cost = 5200
			},
			['negev'] = {
				ent = 'negev',
				cost = 1700
			},


			['mac10'] = {
				ent = 'mac10',
				cost = 1050
			},
			['mp9'] = {
				ent = 'mp9',
				cost = 1250
			},
			['mp7'] = {
				ent = 'mp7',
				cost = 1500
			},
			['ump'] = {
				ent = 'ump45',
				cost = 1200
			},
			['p90'] = {
				ent = 'p90',
				cost = 2350
			},
			['bizon'] = {
				ent = 'bizon',
				cost = 1400
			}
		}
	},
	UseSpam = {
		LastUse = 0,
		Use = false
	},
	Translator = {
		OnCooldown = false,
		CooldownTimer = 300,
		LatestTranslation = {
			translated_text = '',
			og_text = '',
			from_lang = '',
			to_lang = '',
			last_message = ''
		}
	},
	LastRoundData = {
		reason = -1,
		message = '',
		winner = -1
	},
	RoundEndReasons = {
		[1] = 'The bomb detonated',
		[2] = 'vip escaped', -- not used in csgo
		[3] = 'vip was assassinated?', -- not used in csgo
		[4] = 'The terrorists escaped',
		[5] = 'The CT\'s pevented most of the terrorists from escaping?',
		[6] = 'Escaping terrorists have all been neutralized',
		[7] = 'The bomb was defused',
		[8] = 'The Counter-Terrorists Win!',
		[9] = 'The Terrorists Win!',
		[10] = 'Round Draw!',
		[11] = 'All hostages have been resuced',
		[12] = 'Target has been saved?',
		[13] = 'Hostages have not been rescued',
		[14] = 'Terrorists have not escaped!',
		[15] = 'VIP has not escaped', -- not used in csgo
		[16] = 'Game Commencing',

		[17] = 'Terrorists Surrender',
		[18] = 'CTs Surrender',
		[19] = 'Terrorists planted the bomb',
		[20] = 'CTs reached the hostage'
	}
}

C.Funcs = {
	EmptyFunc = function() end,
	StringExplode = function(separator, str)
		local ret = {}
		local currentPos = 1

		for i = 1, #str do
			local startPos, endPos = string.find(str, separator, currentPos)
			if ( not startPos ) then break end
			ret[ i ] = string.sub( str, currentPos, startPos - 1 )
			currentPos = endPos + 1
		end

		ret[#ret + 1] = string.sub( str, currentPos )

		return ret
	end,
	GetShitPost = function(type)
		local rand = C.Funcs.GetRandomTableElement
		local words = C.Chat.Words

		if (type == 'Insult') then
			return cache.format('%s you %s %s', rand(words.Openers), rand(words.Joiners), rand(words.Enders))
		elseif (type == 'Insult (Caps)') then
			return string.upper(cache.format('%s you %s %s', rand(words.Openers), rand(words.Joiners), rand(words.Enders)))
		elseif (type == 'Cancer Strike') then
			return rand(words.CancerStrike)
		elseif (type == 'Super Cancer Strike') then
			return rand(words.SuperCancerStrike)
		else
			return rand(words.Questions) .. '?'
		end
	end,
	GetRandomTableElement = function(tab)
		return tab[ cache.randInt(1, #tab) ]
	end,
	GetTableSize = function(tab)
		local i = 0

		for k, v in pairs(tab) do
			i = i + 1
		end

		return i
	end,
	TableHasValue = function(table, value)
		if (type(table) ~= 'table') then
			return false
		end

		for _, v in pairs(table) do
			if (value == v) then
				return true
			end
		end

		return false
	end,
	GetPlayerProperty = function(index, property)
		return cache.getProp(cache.playerResource(), property, index)
	end,
	GetTeam = function(player)
		return C.Funcs.GetPlayerProperty(player, 'm_iTeam')
	end,
	GetSteamID64 = function(player)
		local id = cache.sid64(player)
		local y
		local z

		if ((id % 2) == 0) then
			y = 0
			z = (id / 2)
		else
			y = 1
			z = ((id - 1) / 2)
		end

		return cache.format('7656119%s', ((z * 2) + (7960265728 + y)))
	end,
	HasTaser = function(player)
		for i = 0, 9 do
			if (cache.getClassName(cache.getProp(player, 'm_hMyWeapons', i)) == 'CWeaponTaser') then
				return true
			end
		end

		return false
	end,
	GetCompRank = function(player)
		local rankID = C.Funcs.GetPlayerProperty(player, 'm_iCompetitiveRanking')

		return (string.find(cache.map(), 'dz') and C.Ranks.DZ[rankID] or C.Ranks.MM[rankID]) or 'no rank'
	end,
	GetCompWins = function(player)
		return C.Funcs.GetPlayerProperty(player, 'm_iCompetitiveWins')
	end,
	IsConnected = function(player)
		return player ~= nil and C.Funcs.GetPlayerProperty(player, 'm_bConnected') == 1 or false
	end,
	IsHuman = function(player)
		return C.Funcs.GetPlayerProperty(player, 'm_bConnected') == 1
	end,
	IsBot = function(player)
		local difficulty = C.Funcs.GetPlayerProperty(player, 'm_iBotDifficulty')

		return difficulty >= 0 and difficulty <= 4
	end,
	GetMoney = function(player)
		return cache.getProp(player, 'm_iAccount')
	end,
	GetMapName = function(map)
		return C.MapList[map] or map
	end,
	GetConnectedPlayers = function()
		local T, CT = {}, {}

		for i = 1, cache.maxPlayers() do
			local team = C.Funcs.GetTeam(i)

			if (team ~= nil and (team == 2 or team == 3) and C.Funcs.IsConnected(i)) then
				if (team == 2) then
					T[#T + 1] = i
				elseif (team == 3) then
					CT[#CT + 1] = i
				end
			end
		end

		return {t = T, ct = CT}
	end,
	GetDiscordTeamIcon = function()
		local myTeam = C.Funcs.GetTeam(cache.me())

		return 'https://muslimhack.net/cs/' .. (myTeam == 3 and 'ct' or 't') .. '.png'
	end,
	GetTeamInitials = function()
		local myTeam = C.Funcs.GetTeam(cache.me())

		return (myTeam == 3) and 'CT' or 'T', (myTeam == 3) and 'T' or 'CT'
	end,
	GetDiscordPingMsgStart = function()
		local str = ''
		local teamInitials, enemyInitials =  C.Funcs.GetTeamInitials()

		local data = {
			[teamInitials] = {
				msg = '',
				players = 0
			},
			[enemyInitials] = {
				msg = '',
				players = 0
			}
		}

		local getTeam = C.Funcs.GetTeam
		local getName = cache.getName
		local getCompRank = C.Funcs.GetCompRank
		local sid3To64 = C.Funcs.SteamID3To64
		local isBot = C.Funcs.IsBot
		local getSteamID64 = C.Funcs.GetSteamID64
		local myTeam = getTeam(cache.me())

		for _, v in pairs(C.Funcs.GetConnectedPlayers()) do
			for _, player in pairs(v) do
				local nick = getName(player)
				local playerTeam = getTeam(player)
				local sid64 = getSteamID64(player)
				local rank = getCompRank(player)
				local ref = data[(playerTeam == myTeam and teamInitials or enemyInitials)]

				if (isBot(player)) then
					ref.msg = cache.format([[● %s (BOT)\n%s]], nick, ref.msg)
				else
					ref.msg = cache.format([[● %s ([%s](<https://steamcommunity.com/profiles/%s/>)) (%s) \n%s]], nick, sid64, sid64, rank, ref.msg)
				end

				ref.players = ref.players + 1
			end
		end

		for _, v in pairs(data) do
			if (v.players < 1) then
				v.msg = 'n/a'
			end
		end

		return data[teamInitials].msg, data[enemyInitials].msg
	end,
	GetDiscordPingMsgEnd = function()
		local str = ''
		local teamInitials, enemyInitials =  C.Funcs.GetTeamInitials()
		local getTeam = C.Funcs.GetTeam
		local getName = cache.getName
		local getCompRank = C.Funcs.GetCompRank
		local getSteamID64 = C.Funcs.GetSteamID64
		local isBot = C.Funcs.IsBot

		local myTeam = getTeam(cache.me())
		local getProp = C.Funcs.GetPlayerProperty

		local data = {
			[teamInitials] = {
				msg = '',
				players = {}
			},
			[enemyInitials] = {
				msg = '',
				players = {}
			}
		}

		for i = 1, cache.maxPlayers() do
			local playerTeam = C.Funcs.GetTeam(i)

			if ((playerTeam == 2 or playerTeam == 3) and C.Funcs.IsConnected(i)) then
				local ref = data[(playerTeam == myTeam) and teamInitials or enemyInitials]
				local score = C.Funcs.GetPlayerProperty(i, 'm_iScore')

				table.insert(ref.players, {player = i, score = score})
			end
		end

		table.sort(data[teamInitials].players, function(a,b) return a.score > b.score end)
		table.sort(data[enemyInitials].players, function(a,b) return a.score > b.score end)

		for _, v in pairs(data) do
			for index, player in pairs(v.players) do
				player = player.player
				local nick = getName(player)
				local rank = getCompRank(player)
				local playerTeam = getTeam(player)
				local sid64 = getSteamID64(player)
				local ref = data[(playerTeam == myTeam) and teamInitials or enemyInitials]
				local kills, deaths, assists, mvp = getProp(player, 'm_iKills'), getProp(player, 'm_iAssists'), getProp(player, 'm_iDeaths'), getProp(player, 'm_iMVPs')

				if (isBot(player)) then
					ref.msg = cache.format('%s ● %s (BOT)', ref.msg, nick)
				else
					ref.msg = cache.format('%s ● %s ([%s](<https://steamcommunity.com/profiles/%s/>)) (%s)', ref.msg, nick, sid64, sid64, rank)
				end

				ref.msg = cache.format([[%s (%s/%s/%s) (mvp: %s score %s)\n]], ref.msg, kills, assists, deaths, mvp, v.players[index].score)
			end
		end

		for _, v in pairs(data) do
			if (#v.players < 1) then
				v.msg = 'n/a'
			end
		end

		return data[teamInitials].msg, data[enemyInitials].msg
	end,
	TabIndexOverflow = function(seed, table)
		for i = 1, #table do
			if seed - table[i] <= 0 then
				return i, seed
			end
			seed = seed - table[i]
		end
	end,
	GetDate = function()
		local unix = cache.unixTime()

		assert(unix == nil or type(unix) == "number" or unix:find("/Date%((%d+)"), "Please input a valid number to \"getDate\"")
		unix = (type(unix) == "string" and unix:match("/Date%((%d+)") / 1000 or unix or os.time())

		local dayCount, year, days, month = function(yr) return (yr % 4 == 0 and (yr % 100 ~= 0 or yr % 400 == 0)) and 366 or 365 end, 1970, math.ceil(unix/86400)

		while days >= dayCount(year) do days = days - dayCount(year) year = year + 1 end

		month, days = C.Funcs.TabIndexOverflow(days, {31,(dayCount(year) == 366 and 29 or 28),31,30,31,30,31,31,30,31,30,31})

		return days, month, year
	end,
	GetTeamRounds = function()
		local myTeam = C.Funcs.GetTeam(cache.me())
		local gameData = C.Panorama.GameStateAPI.GetScoreDataJSO().teamdata

		return gameData[(myTeam == 2) and 'TERRORIST' or 'CT'].score, gameData[(myTeam == 2) and 'CT' or 'TERRORIST'].score
	end,
	ResetLastRoundData = function()
		LastRoundData = {
			reason = '',
			message = '',
			winner = nil
		}
	end,
	GetChatMode = function()
		return (C.UI.TeamChat.Element:get() and 'say_team' or 'say') .. ' '
	end,
	GetPlayerColour = function()
		return C.Panorama.GameStateAPI.GetPlayerColor(C.Panorama.MyPersonaAPI.GetXuid())
	end,
	IsOnDedicatedServer = function()
		return cache.getProp(cache.gameRules(), 'm_bIsValveDS') == 1
	end,
	PartyChatSay = function(text)
		C.Panorama.PartyListAPI.SessionCommand('Game::Chat', cache.format('run all xuid %s chat %s', C.Panorama.MyPersonaAPI.GetXuid(), text))
	end,
	HandleChatTranslation = function(tab)
		if (not C.Vars.Translator.OnCooldown) then
			local toLang = tab.to_lang or cache.get(C.UI.Translator.Hidden.To)
			local chatSay = tab.chat
			local teamChat = tab.team_chat
			local showTranslation = tab.show_translation

			local payload = {
				client = 'gtx',
				sl = cache.get(C.UI.Translator.Hidden.Source),
				tl = toLang,
				dt = 't',
				q = tab.text
			}

			http.get('https://translate.googleapis.com/translate_a/single', {params = payload}, function(success, response)
				if (response.status == 429) then -- too many req
					C.Vars.Translator.OnCooldown = true

					cache.delay(C.Vars.Translator.CooldownTimer, function()
						C.Vars.Translator.OnCooldown = false
					end)

					C.Notifications.Translate.Chat({to_lang = 'Error', from_lang = 'Error', error = 'You got rate limited by google for spamming api requests [avoid using chat spammer w/ translator]'})
					C.Vars.Translator.LatestTranslation = {last_message = tab.text, translated_text = tab.text, og_text = tab.text, from_lang = detectedLanguage, to_lang = toLang}
					cache.exec(teamChat and teamChat or C.Funcs.GetChatMode(), tab.text)
				elseif (response.status == 200) then -- good req
					local tab = json.parse(response.body)

					if (tab[1][1][1] and tab[1][1][2] and tab[9][1][1]) then
						local translatedText = tab[1][1][1]
						local fromText = tab[1][1][2]
						local detectedLanguage = tab[9][1][1]

						if (chatSay) then
							cache.exec((teamChat and teamChat or C.Funcs.GetChatMode()), translatedText)

							if (C.UI.Translator.Hidden.ShowOGMessage:get()) then
								C.Notifications.Translate.Chat({translated_text = translatedText, og_text = payload.q, from_lang = detectedLanguage, to_lang = toLang})
							end

							cache.delay(0, function()
								C.Funcs.ResetTranslationData()
							end)
						end

						if (showTranslation) then
							C.Notifications.Translate.Chat({translated_text = translatedText, from_lang = detectedLanguage, to_lang = detectedLanguage})
						end

						C.Vars.Translator.LatestTranslation = {last_message = translatedText, translated_text = translatedText, og_text = payload.q, from_lang = detectedLanguage, to_lang = toLang}

					else
						C.Notifications.Translate.Chat({to_lang = 'Error', from_lang = 'Error', error = 'Whack message / language used [send message + language used on forum]'})
						C.Vars.Translator.LatestTranslation = {last_message = tab.text, translated_text = tab.text, og_text = tab.text, from_lang = detectedLanguage, to_lang = toLang}
						cache.exec(teamChat and teamChat or C.Funcs.GetChatMode(), tab.text)
					end
				else
					C.Notifications.Translate.Chat({to_lang = 'Error', from_lang = 'Error', error = 'Whack request [send the message + language used on forum]'})
					C.Vars.Translator.LatestTranslation = {last_message = tab.text, translated_text = tab.text, og_text = tab.text, from_lang = detectedLanguage, to_lang = toLang}
					cache.exec(teamChat and teamChat or C.Funcs.GetChatMode(), tab.text)
				end
			end)
		else
			C.Notifications.Translate.Chat({to_lang = 'Error', from_lang = 'Error', error = 'You are rate limited & cannot use the translation feature'})
			C.Vars.Translator.LatestTranslation = {last_message = tab.text, translated_text = tab.text, og_text = tab.text, from_lang = detectedLanguage, to_lang = toLang}
			cache.exec(teamChat and teamChat or C.Funcs.GetChatMode(), tab.text)
		end
	end,
	ResetTranslationData = function()
		C.Vars.Translator.LatestTranslation.translated_text = ''
		C.Vars.Translator.LatestTranslation.og_text = ''
		C.Vars.Translator.LatestTranslation.from_lang = ''
		C.Vars.Translator.LatestTranslation.to_lang = ''
	end,
	GetDiscordTimeFormatted = function()
		local day, month, year = C.Funcs.GetDate()
		local hours, minutes, seconds = cache.systemTime()
		local timezone = cache.readDB(C.DB.Ping.TimeZone)

		local checkFormat = function(data) return (data < 10) and '0' .. data or data end

		return cache.format('%s-%s-%sT%s:%s:%s%s', checkFormat(year), checkFormat(month), checkFormat(day), checkFormat(hours), checkFormat(minutes), checkFormat(seconds), timezone)
	end,
	CheckDiscordDB = function(bool)
		local log = C.Notifications.Console.Log
		local db, read = C.DB.Ping, cache.readDB
		local id, start_hook, end_hook, timezone = read(db.ID), read(db.Start), read(db.End), read(db.TimeZone)

		if (id == nil or start_hook == nil or end_hook == nil or timezone == nil) then
			if (bool) then
				if (id == nil) then
					log({text = 'Your discord ID is not set. Set it using cyrus_set_discord_id', normal_log = true})
				end

				if (start_hook == nil) then
					log({text = 'Your discord start webhook is not set. Set it using cyrus_set_start_webhook', normal_log = true})
				end

				if (end_hook == nil) then
					log({text = 'Your discord start webhook is not set. Set it using cyrus_set_end_webhook', normal_log = true})
				end

				if (timezone == nil) then
					log({text = 'Your timezone is not set. Set it using cyrus_set_timezone', normal_log = true})
				end
			end

			return false
		else
			return true
		end
	end,
	GetRoundEndReason = function()
		return C.Vars.RoundEndReasons[C.Vars.LastRoundData.Reason] or '?'
	end,
	ResetSpamData = function()
		C.Chat.Spam.LastRadioMessage = 0
		C.Chat.Spam.LastChatMessage = 0
		C.Vars.UseSpam.LastUse = 0
	end
}

C.Events = {
	ShowUIMessages = {
		Callback = function(e)
			C.Notifications.UIToggle('Show UI Changes', cache.get(e))
		end
	},
	NotificationType = {
		Callback = function(e)
			C.Notifications.UIChange('Notification Type', cache.get(e))
		end
	},
	AFKMode = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('AFK Mode', value)
			cache.exec((value and '+' or '-') .. 'duck')
		end
	},
	RadioSpam = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Radio Spam', value)

			cache.setVisible(C.UI.RadioSpam.Hidden.Speed, value)
		end,
		run_command = function(cmd)
			if (C.Funcs.IsConnected(cache.me())) then
				if (cache.tickcount() >= C.Chat.Spam.LastRadioMessage + cache.get(C.UI.RadioSpam.Hidden.Speed)) then
					cache.exec(C.Chat.Spam.RadioMessage)

					C.Chat.Spam.LastRadioMessage = cache.tickcount()
				end
			end
		end,
		round_end = C.Funcs.ResetSpamData,
		cs_win_panel_match = C.Funcs.ResetSpamData,
		round_announce_match_start = C.Funcs.ResetSpamData,
		cs_win_panel_match = C.Funcs.ResetSpamData
	},
	VoteRevealer = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Vote Revealer', value)
		end,
		vote_options = function(e)
			C.Votes.VoteOptions = {e.option1, e.option2, e.option3, e.option4, e.option5}
			for i = #C.Votes.VoteOptions, 1, -1 do
				if (C.Votes.VoteOptions[i] == '') then
					table.remove(C.Votes.VoteOptions, i)
				end
			end
		end,
		vote_cast = function(e)
			cache.delay(0.3, function()
				local team = e.team
				local base = C.Votes
				local getTeam = C.Funcs.GetTeam

				if (base.VoteOptions) then
					local controller
					local voteControllers = cache.getAllEnts('CVoteController')

					for i = 1, #voteControllers do
						if cache.getProp(voteControllers[i], 'm_iOnlyTeamToVote') == team then
							controller = voteControllers[i]
							break
						end
					end

					if (controller) then
						local ongoingVote = {
							team = team,
							options = base.VoteOptions,
							controller = controller,
							IssueIndex = cache.getProp(controller, 'm_iActiveIssueIndex'),
							votes = {}
						}

						for i = 1, #C.Votes.VoteOptions do
							ongoingVote.votes[base.VoteOptions[i]] = {}
						end

						ongoingVote.type = base.IndicesNoteam[ongoingVote.IssueIndex]

						if (team ~= -1 and base.IndicesTeam[ongoingVote.IssueIndex]) then
							ongoingVote.type = base.IndicesTeam[ongoingVote.IssueIndex]
						end

						base.ongoingVotes.team = ongoingVote
					end

					base.VoteOptions = nil
				end

				local ongoingVote = base.ongoingVotes.team

				if (ongoingVote) then
					local player = e.entityid
					local voteText = ongoingVote.options[e.vote_option + 1]

					table.insert(ongoingVote.votes[voteText], player)

					if (voteText == 'Yes' and ongoingVote.caller == nil) then
						ongoingVote.caller = player

						if (ongoingVote.type ~= 'kick') then
							C.Notifications.Votes.Start({player = cache.getName(player) or 'n/a', description = C.Votes.Descriptions[ongoingVote.type], team = e.team})
						end
					end

					if (ongoingVote.type == 'kick') then
						if (voteText == 'No') then
							if (ongoingVote.target == nil) then
								ongoingVote.target = player

								C.Notifications.Votes.Kick({target = cache.getName(player), description = C.Votes.Descriptions[ongoingVote.type], team = e.team})
							end
						end
					end

					C.Notifications.Votes.Vote({player = cache.getName(player) or 'n/a', vote = (voteText == 'Yes'), team = e.team})
				end
			end)
		end,
		run_command = function(cmd)
			for team, vote in pairs(C.Votes.ongoingVotes) do
				if (cache.getProp(vote.controller, 'm_iActiveIssueIndex') ~= vote.IssueIndex) then
					C.Votes.ongoingVotes.team = nil
				end
			end
		end
	},
	TeamChat = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Team Chat Messages', value)
		end
	},
	UseSpam = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Use Spam', value)

			cache.setVisible(C.UI.UseSpam.Hidden.Speed, value)
			cache.setVisible(C.UI.UseSpam.Hidden.Key, value)
		end,
		setup_command = function(cmd)
			if (C.Funcs.IsConnected(cache.me())) then
				local base = C.Vars.UseSpam

				if (cache.get(C.UI.UseSpam.Hidden.Key)) then
					if (cache.tickcount() >= (base.LastUse + cache.get(C.UI.UseSpam.Hidden.Speed))) then
						cmd.in_use = base.Use
						base.Use = not base.Use
						base.LastUse = cache.tickcount()
					end
				end
			end
		end,
		round_end = C.Funcs.ResetSpamData,
		cs_win_panel_match = C.Funcs.ResetSpamData,
		round_announce_match_start = C.Funcs.ResetSpamData,
		cs_win_panel_match = C.Funcs.ResetSpamData
	},
	PlasmaShot = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Plasma Shot', value)

			cache.setVisible(C.UI.PlasmaShot.Hidden.Key, value)
		end,
		weapon_fire = function(e)
			if (C.Funcs.IsConnected(cache.me())) then
				local me = cache.me()
				local shooter = cache.uidToEntIndex(e.userid)

				if (shooter == me  and C.Funcs.HasTaser(me) and cache.get(C.UI.PlasmaShot.Hidden.Key)) then
					cache.exec('use weapon_taser')

					cache.delay(0.01, function()
						cache.exec('lastinv')
					end)
				end
			end
		end
	},
	AutoDC = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Auto DC @ Match End', value)
		end,
		cs_win_panel_match = function(e)
			cache.delay(0.1, function()
				cache.exec('disconnect')
			end)
		end
	},
	AvoidPMB = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Auto DC @ Match Start', value)

			C.Vars.AvoidPBMChangeUI = value
		end,
		paint_ui = function(e)
			if (C.Panorama.PartyListAPI.IsPartySessionActive()) then
				if (cache.tickcount() == 0) then
					C.Panorama.LobbyAPI.CloseSession()
				end

				if (cache.tickcount() == 40) then
					cache.exec('disconnect')

					cache.delay(1, function()
						C.Panorama.CompetitiveMatchAPI.ActionReconnectToOngoingMatch()
					end)
				end
			end
		end
	},
	DiscordPingStart = {
		Callback = function(ref, value)
			if (C.Funcs.CheckDiscordDB(false)) then
				C.Notifications.UIToggle('Discord Ping [Match Start]', value)
			else
				if (value and not C.Funcs.CheckDiscordDB(true)) then
					cache.delay(0, function()
						C.UI.DiscordPingStart.Element:set(false)
					end)
				end
			end
		end,
		round_announce_match_start = function()
			if (C.Funcs.IsConnected(cache.me())) then
				if (C.Funcs.IsOnDedicatedServer()) then
					local myTeamInitials, enemyTeamInititals = C.Funcs.GetTeamInitials()
					local myTeam, enemyTeam = C.Funcs.GetDiscordPingMsgStart()
					local iconURL = C.Funcs.GetDiscordTeamIcon()

					local payload = cache.format([[
						{
							"content": "<@%s>, your match started!",
							"embeds": [
								{
									"title": "Match Information",
									"description": "Your match for CS:GO has started.",
									"color": %s,
									"fields": [
										{
										"name": "Map",
										"value": "%s"
										},
										{
										"name": "Your Team (%s)",
										"value": "%s"
										},
										{
										"name": "Enemy Team (%s)",
										"value": "%s"
										}
									],
									"footer": {
										"text": "Cyrus - MM Utilities",
										"icon_url": "%s"
									},
									"timestamp": "%s",
									"thumbnail": {
										"url": "%s"
									}
								}
							]
						}]], cache.readDB(C.DB.Ping.ID), (myTeamInitials == 'CT') and C.Colours.Discord.CT or C.Colours.Discord.T, C.Funcs.GetMapName(cache.map()), myTeamInitials, myTeam, enemyTeamInititals, enemyTeam, iconURL, C.Funcs.GetDiscordTimeFormatted(), iconURL)

					http.request('POST', cache.readDB(C.DB.Ping.Start),
						{
							['headers'] = {
								['Content-Length'] = payload:len(),
								['Content-Type'] = 'application/json'
							},
							['body'] = payload
						},
						C.Funcs.EmptyFunc
					)
				end
			end
		end
	},
	DiscordPingEnd = {
		Callback = function(ref, value)
			if (C.Funcs.CheckDiscordDB(false)) then
				C.Notifications.UIToggle('Discord Ping [Match End]', value)
			else
				if (value and not C.Funcs.CheckDiscordDB(true)) then
					cache.delay(0, function()
						C.UI.DiscordPingEnd.Element:set(false)
					end)
				end
			end
		end,
		cs_win_panel_match = function()
			if (C.Funcs.IsConnected(cache.me())) then
				cache.delay(0.08, function()
					local myTeam, enemyTeam = C.Funcs.GetDiscordPingMsgEnd()
					local myTeamScore, enemyTeamScore = C.Funcs.GetTeamRounds()
					local myTeamInitials, enemyTeamInititals = C.Funcs.GetTeamInitials()
					local iconURL = C.Funcs.GetDiscordTeamIcon()
					local lastRoundReason = C.Vars.LastRoundData.reason
					local lastRoundWinner = C.Vars.LastRoundData.winner
					local team = C.Funcs.GetTeam(cache.me())
					local win =	(lastRoundWinner == team)
					local colToUse = (lastRoundReason == 10 and C.Colours.Discord.Draw or ((win) and C.Colours.Discord.Win or C.Colours.Discord.Loss))
					local surrenderMsg = ''

					if (lastRoundReason == 17 or lastRoundReason == 18) then
						if (lastRoundReason == 17) then
							surrenderMsg = cache.format('%s team surrendered', (team == 3 and win and 'Enemy' or 'Your'))
						elseif (lastRoundReason == 18) then
							surrenderMsg = cache.format('%s team surrendered', (team == 3 and not win and 'Your' or 'Enemy'))
						end
					end

					local msg = (lastRoundReason == 10 and 'Drew' or ((win) and 'Won' or 'Lost') .. (surrenderMsg ~= '' and ', ' .. surrenderMsg or ''))

					local payload = cache.format([[
						{
							"content": "<@%s>, Your match has finished!",
							"embeds": [
								{
									"title": "Match Information",
									"description": "You %s the match",
									"color": %s,
									"fields": [
										{
										"name": "Map",
										"value": "%s"
										},
										{
											"name": "Score",
											"value": "%s:%s"
										},
										{
										"name": "Your Team (%s)",
										"value": "%s"
										},
										{
										"name": "Enemy Team (%s)",
										"value": "%s"
										}
									],
									"footer": {
										"text": "Cyrus - MM Utilities",
										"icon_url": "%s"
									},
									"timestamp": "%s",
									"thumbnail": {
										"url": "%s"
									}
								}
							]
						}]], cache.readDB(C.DB.Ping.ID), msg, colToUse, C.Funcs.GetMapName(cache.map()), myTeamScore, enemyTeamScore, myTeamInitials, myTeam, enemyTeamInititals, enemyTeam, iconURL, C.Funcs.GetDiscordTimeFormatted(), iconURL)

					http.request('POST', cache.readDB(C.DB.Ping.End),
						{
							['headers'] = {
								['Content-Length'] = payload:len(),
								['Content-Type'] = 'application/json'
							},
							['body'] = payload
						},
						C.Funcs.EmptyFunc
					)

					print('woo')

					C.Funcs.ResetLastRoundData()
				end)
			end
		end,
		round_end = function(e)
			C.Vars.LastRoundData = {
				reason = e.reason,
				message = e.message,
				winner = e.winner
			}
		end
	},
	Spam = {
		Callback = function(e)
			local type = cache.get(e)
			local on = (type ~= '-')
			local msg, speed = C.UI.Spam.Hidden.Message, C.UI.Spam.Hidden.Speed

			cache.setVisible(msg, on)
			cache.setVisible(speed, (type == 'Chat'))

			if (on) then
				cache.set(msg, C.Chat.Spam.Types[type])
			end
		end,
		Hidden = {
			Message = {
				Callback = function(e)
					local type, msg = cache.get(C.UI.Spam.Element), cache.get(e)
					local off = (msg == 'Off')
					local base = C.Events.Spam[type]
					local baseReset = C.Events.Spam.ResetEvents

					if (type ~= '-') then
						if (C.Chat.Spam.Types[type] ~= msg) then
							C.Notifications.UIChange(cache.format('%s %s', type, (type == 'Chat' and 'Spam' or 'Say')), {msg})
						end

						C.Chat.Spam.Types[type] = msg
					end

					if (base) then
						if (not off) then
							if (type == 'Kill') then
								base.Name = 'player_death'
								base.EventFunc = base.player_death
							elseif (type == 'Death') then
								base.Name = 'player_death'
								base.EventFunc = base.player_death
							else
								base.Name = 'run_command'
								base.EventFunc = base.run_command
							end

							for k,v in pairs(baseReset.Events) do
								baseReset.Events[k].Event = cache.registerEvent(baseReset.Events[k].Name, baseReset.EventFunc)
							end

							base.Event = cache.registerEvent(base.Name, base.EventFunc)
						else
							cache.unregisterEvent(base.Name, base.EventFunc)

							for k,v in pairs(baseReset.Events) do
								cache.registerEvent(baseReset.Events[k].Name, baseReset.EventFunc)

								baseReset.Events[k].Event = nil
							end

							base.Name = ''
							base.EventFunc = C.Funcs.EmptyFunc()
							base.Event = nil
						end
					end
				end
			}
		},
		['Kill'] = {
			player_death = function(e)
				if (C.Funcs.IsConnected(cache.me())) then
					if (e.userid and e.attacker) then
						local attacker = cache.uidToEntIndex(e.attacker)
						local victim = cache.uidToEntIndex(e.userid)
						local me = cache.me()

						if (attacker == me and cache.isEnemy(victim)) then
							cache.exec(C.Funcs.GetChatMode(), C.Funcs.GetShitPost(C.Chat.Spam.Types['Kill']))
						end
					end
				end
			end
		},
		['Death'] = {
			player_death = function(e)
				if (C.Funcs.IsConnected(cache.me())) then
					if (e.userid and e.attacker) then
						local attacker = cache.uidToEntIndex(e.attacker)
						local victim = cache.uidToEntIndex(e.userid)
						local me = cache.me()
						local chatMode = C.Funcs.GetChatMode()

						if (cache.isEnemy(attacker) and victim == me) then
							cache.exec(C.Funcs.GetChatMode(), C.Funcs.GetShitPost(C.Chat.Spam.Types['Death']))
						end
					end
				end
			end
		},
		['Chat'] = {
			run_command = function(e)
				if (C.Funcs.IsConnected(cache.me())) then
					if (cache.tickcount() >= (C.Chat.Spam.LastChatMessage + cache.get(C.UI.Spam.Hidden.Speed))) then
						cache.exec(C.Funcs.GetChatMode(), C.Funcs.GetShitPost(C.Chat.Spam.Types['Chat']))

						C.Chat.Spam.LastChatMessage = cache.tickcount()
					end
				end
			end
		},
		ResetEvents = {
			EventFunc = C.Funcs.ResetSpamData,
			Events = {
				{Name = 'round_end'},
				{Name = 'cs_win_panel_match'},
				{Name = 'round_announce_match_start'}
			}
		}

	},
	ShitPostList = {
		Callback = function(e)
			C.Notifications.UIChange('Shitpost', {cache.get(e)})
		end
	},
	ExecuteShitPost = {
		Callback = function(e)
			if (C.Funcs.IsConnected(cache.me())) then
				local spamType = cache.get(C.UI.ShitPostList.Element)
				cache.exec(C.Funcs.GetChatMode(), C.Funcs.GetShitPost(spamType))
			end
		end
	},
	ChatCommands = {
		ActiveCommands = {},
		Callback = function(e)
			local tab = cache.get(e)
			local activeCommands = C.Events.ChatCommands.ActiveCommands

			if (C.Funcs.GetTableSize(activeCommands) > 0) then
				for k, v in pairs(activeCommands) do
					local cmd = tostring(k)
					local base = C.Events.ChatCommands[cmd:lower()]

					if (not C.Funcs.TableHasValue(tab, cmd) and base.Name ~= nil) then
						cache.unregisterEvent(base.Name, base.EventFunc)

						base.Name = nil
						base.Event = nil
						base.EventFunc = C.Funcs.EmptyFunc()

						activeCommands[cmd] = false
					end
				end
			end

			if (#tab > 0) then
				for k, v in pairs(tab) do
					local cmd = tostring(v)
					local base = C.Events.ChatCommands[cmd:lower()]

					if (not base.Name) then
						base.Name = base.EventName
						base.EventFunc = base[base.Name]
						base.Event = cache.registerEvent(base.Name, base.EventFunc)

						activeCommands[cmd] = true
					end
				end
			end

			C.Notifications.UIChange('Usable Commands', tab)
		end,
		['buy'] = {
			EventName = 'player_chat',
			player_chat = function(e)
				if (C.Funcs.IsConnected(cache.me())) then
					local text = e.text
					local prefix = C.Chat.Prefix

					if (text:sub(1, #prefix) == prefix) then
						text = C.Funcs.StringExplode(' ', text)
						local cmd = text[1]:sub(#prefix + 1, -1)

						if (cmd == 'buy') then
							local speaker = e.entity
							local me = cache.me()

							if (speakerTeam == myTeam and speaker ~= me) then
								local col = text[2]
								local wep = text[3]

								if (C.Colours.PlayerColours[col] == C.Funcs.GetPlayerColour()) then
									if (#wep >= 2 and #wep <= 8) then
										local base = C.Vars.BuyBot.WeaponData[wep]
										local mode = C.Funcs.GetChatMode()

										if (base) then
											local money = C.Funcs.GetMoney(cache.me())
											local ent, cost = base.ent, base.cost

											if (money >= cost) then
												cache.exec('buy ' .. ent)
												cache.delay(1, function()
													cache.exec('slot0')

													cache.delay(0.01, function()
														cache.exec('drop')
													end)
												end)
											else
												cache.delay(mode, 'I\'m too much of a poor fag to afford it :^(')
											end
										else
											cache.exec(mode, cache.format('Invalid weapon name provided \'%s\'', wep))
										end
									end
								end
							end
						end
					end
				end
			end
		},
		['ranks'] = {
			EventName = 'player_chat',
			player_chat = function(e)
				if (C.Funcs.IsConnected(cache.me())) then
					local text = e.text
					local prefix = C.Chat.Prefix

					if (text:sub(1, #prefix) == prefix) then
						text = C.Funcs.StringExplode(' ', text)
						local cmd = text[1]:sub(#prefix + 1, -1)

						if (cmd == 'ranks') then
							local me = cache.me()
							local getTeam = C.Funcs.GetTeam
							local targetTeam = cache.get(C.UI.RankDump.TargetTeam)
							local myTeam = getTeam(me)

							if (getTeam(e.entity) == myTeam) then
								local totalPlayers = 1
								local getName = cache.getName
								local getCompWins = C.Funcs.GetCompWins
								local getCompRank = C.Funcs.GetCompRank
								local chatMode = e.teamonly and 'say_team ' or C.Funcs.GetChatMode()

								for _, arr in pairs(C.Funcs.GetConnectedPlayers()) do
									for _, player in pairs(arr) do
										local team = getTeam(player)

										if (targetTeam == 'Team' and myTeam == team) or (targetTeam == 'Enemy' and myTeam ~= team) or targetTeam =='All' then
											cache.delay(totalPlayers, function()
												cache.exec(chatMode, cache.format('%s has %s wins (%s)', getName(player), getCompWins(player), getCompRank(player)))
											end)

											totalPlayers = totalPlayers + 1
										end
									end
								end
							end
						end
					end
				end
			end
		},
		['tsay'] = {
			EventName = 'string_cmd',
			string_cmd = function(e)
				if (C.Funcs.IsConnected(cache.me())) then
					if (not C.UI.Translator.Hidden.Outgoing:get()) then
						local text = e.text
						local command, message = text:match('^(.-) (.*)$')

						if ((command == 'say' or command == 'say_team') and message ~= nil and message ~= '') then
							if (message:find(C.Chat.Prefix .. 'tsay') ~= nil) then
								if (C.Vars.Translator.LatestTranslation.translated_text == '' and C.Vars.Translator.LatestTranslation.last_message ~= message) then

									if (message:find('"', 1) and message:find('"', -1)) then
										message = message:sub(2, -2)
									end

									message = C.Funcs.StringExplode(' ', message)
									table.remove(message, 1)

									local toLang = message[1]
									table.remove(message, 1)

									local payload = {
										text = table.concat(message, ' '),
										to_lang = toLang,
										chat = true,
										team_chat = (command == 'say_team' and 'say_team' or 'say') .. ' '
									}

									C.Funcs.HandleChatTranslation(payload)

									e.text = ''
								end
							end
						end
					end
				end
			end
		}
	},
	ShotLogs = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Shot Logs', value)
		end,
		aim_fire = function(e)
			C.Vars.HitLog.ShotInfo[e.id] = e
		end,
		aim_hit = function(e)
			C.Notifications.Logs.Hit({hit = e, fired = C.Vars.HitLog.ShotInfo[e.id]})
		end,
		aim_miss = function(e)
			C.Notifications.Logs.Miss({miss = e, fired = C.Vars.HitLog.ShotInfo[e.id]})
		end,
		player_hurt = function(e)
			if (C.Funcs.IsConnected(cache.me())) then
				cache.delay(0, function()
					if (e.userid and e.attacker) then
						local me = cache.me()
						local getTeam = C.Funcs.GetTeam
						local victim = cache.uidToEntIndex(e.userid)
						local attacker = cache.uidToEntIndex(e.attacker)

						if (attacker == me and getTeam(me) ~= getTeam(victim)) then
							C.Notifications.Logs.HitNormal({attacker = attacker, victim = victim, hitgroup = e.hitgroup, health = e.health, dmg_health = e.dmg_health})
						end
					end
				end)
			end
		end,
		ResetShotData = function(e)
			cache.delay(0, function()
				C.Vars.HitLog.ShotInfo = {}
			end)
		end
	},
	TeamDamageLogs = {
		Callback = function(ref, value)
			C.Notifications.UIToggle('Team Damage Logs', value)
		end,
		player_hurt = function(e)
			if (C.Funcs.IsConnected(cache.me())) then
				if (e.userid and e.attacker) then
					local me = cache.me()
					local attackerID = e.attacker
					local victim = cache.uidToEntIndex(e.userid)
					local attacker = cache.uidToEntIndex(attackerID)
					local getTeam = C.Funcs.GetTeam

					if (getTeam(attacker) == getTeam(me) and getTeam(victim) == getTeam(me) and attacker ~= victim) then
						local nick = cache.getName(victim)

						if (not C.Vars.TeamKillData[attackerID]) then
							C.Vars.TeamKillData[attackerID] = {
								Kills = 0,
								Damage = 0
							}
						end

						C.Vars.TeamKillData[attackerID].Damage = C.Vars.TeamKillData[attackerID].Damage + e.dmg_health

						C.Notifications.Logs.TeamDamage({victim = nick, attacker = cache.getName(attacker), damage = e.dmg_health, totalDamage = C.Vars.TeamKillData[attackerID].Damage})
					end
				end
			end
		end,
		player_death = function(e)
			if (C.Funcs.IsConnected(cache.me())) then
				if (e.userid and e.attacker) then
					local me = cache.me()
					local attackerID = e.attacker
					local victim = cache.uidToEntIndex(e.userid)
					local attacker = cache.uidToEntIndex(attackerID)
					local getTeam = C.Funcs.GetTeam

					if (getTeam(attacker) == getTeam(me) and getTeam(victim) == getTeam(me) and attacker ~= victim) then
						local nick = cache.getName(victim)

						if (not C.Vars.TeamKillData[attackerID]) then
							C.Vars.TeamKillData[attackerID] = {
								Kills = 0,
								Damage = 0
							}
						end

						C.Vars.TeamKillData[attackerID].Kills = C.Vars.TeamKillData[attackerID].Kills + 1

						C.Notifications.Logs.TeamKill({victim = nick, attacker = cache.getName(attacker), totalKills = C.Vars.TeamKillData[attackerID].Kills})
					end
				end
			end
		end,
		ResetTeamDmgData = function()
			C.Vars.TeamKillData = {}
		end
	},
	RankDump = {
		Callback = function()
			if (C.Funcs.IsConnected(cache.me())) then
				local myTeam = C.Funcs.GetTeam(cache.me())
				local targetTeam = cache.get(C.UI.RankDump.TargetTeam)
				local getTeam = C.Funcs.GetTeam
				local getName = cache.getName
				local getCompWins = C.Funcs.GetCompWins
				local getCompRank = C.Funcs.GetCompRank
				local sendNotification = C.Notifications.RankDump

				for _, arr in pairs(C.Funcs.GetConnectedPlayers()) do
					for _, player in pairs(arr) do
						local team = getTeam(player)
						local nick = getName(player)
						local wins = getCompWins(player)
						local rank = getCompRank(player)
						local tab = {name = getName(player), team = team, wins = getCompWins(player), rank = getCompRank(player)}

						if (targetTeam == 'Team' and myTeam == team) or (targetTeam == 'Enemy' and myTeam ~= team) or targetTeam =='All' then
							sendNotification(tab)
						end
					end
				end
			end
		end,
		TargetTeamCallback = function(e)
			C.Notifications.UIChange('Rank Dump Team', {cache.get(e)})
		end
	},
	Translator = {
		Callback = function(ref, value)
			local base = C.UI.Translator.Hidden
			local get = cache.get

			if (get(base.Local) == '') then
				cache.set(base.Local, 'en')
			end

			if (get(base.Source) == '') then
				cache.set(base.Source, 'auto')
			end

			if (get(base.To) == '') then
				cache.set(base.To, 'ru')
			end

			for _, element in pairs(C.UI.Translator.Hidden) do
				if (type(element) == 'table') then
					if (value) then
						element:show()
					else
						element:hide()
					end
				else
					cache.setVisible(element, value)
				end
			end

			C.Notifications.UIToggle('Translator', value)
		end,
		Callback_incoming = function(ref, value)
			C.Notifications.UIToggle('Translate Incoming Messages', value)
		end,
		Callback_outgoing = function(ref, value)
			C.Notifications.UIToggle('Translate Outgoing Messages', value)
		end,
		Callback_showogmsg = function(ref, value)
			C.Notifications.UIToggle('Show OG Messages', value)
		end,
		player_chat = function(e)
			if (e.entity ~= cache.me()) then
				local text, name = e.text, e.name
				local payload = {
					text = text,
					to_lang = cache.get(C.UI.Translator.Hidden.Local),
					show_translation = true
				}

				C.Funcs.HandleChatTranslation(payload)
			end
		end,
		string_cmd = function(e)
			if (C.Funcs.IsConnected(cache.me())) then
				local text = e.text
				local command, message = text:match('^(.-) (.*)$')

				if ((command == 'say' or command == 'say_team') and message ~= nil and message ~= '') then
					if (message:find(C.Chat.Prefix .. 'tsay') ~= nil) then
						e.text = ''
					end

					if (C.Vars.Translator.LatestTranslation.translated_text == '' and C.Vars.Translator.LatestTranslation.last_message ~= message) then

						if (message:find('"', 1) and message:find('"', -1)) then
							message = message:sub(2, -2)
						end

						local payload = {
							text = message,
							to_lang = cache.get(C.UI.Translator.Hidden.To),
							chat = true,
							team_chat = (command == 'say_team' and 'say_team' or 'say') .. ' '
						}

						C.Funcs.HandleChatTranslation(payload)

						e.text = ''
					end
				end
			end
		end,
	},
	ConCommands = {
		['help'] = function()
			local log = C.Notifications.Console.Help

			C.Notifications.Console.Log({text = 'The following commands are available: ', usage = '', normal_log = true})

			for cmd, v in pairs(C.ConCommands) do
				log({text = cmd, usage = v.Usage})
			end

			log({text = '', usage = ''})
		end,
		['set_discord_id'] = function(tab)
			local id = tab[1]
			local log = C.Notifications.Console.Log

			if (id == nil or id == '' or #id < 15 or #id > 20) then
				log({text = 'Invalid use, example usage: cyrus_set_discord_id 123456789012345'})
			else
				cache.writeDB(C.DB.Ping.ID, id)
				log({text = cache.format('Set your discord id to %s', id), normal_log = true})
			end
		end,
		['set_start_webhook'] = function(tab)
			local webhook = tab[1]
			local log = C.Notifications.Console.Log

			if (webhook == nil or webhook == '' or #webhook < 20) then
				log({text = 'Invalid use, exmaple usage: cyrus_set_start_webhook https://discordapp.com/api/webhooks/xxxxxxxxxxx/xxxxxxxxxxxxxxxx-xxxx'})
			else
				cache.writeDB(C.DB.Ping.Start, webhook)
				log({text = cache.format('Set your discord channel start ping webhook to %s', webhook), normal_log = true})
			end
		end,
		['set_end_webhook'] = function(tab)
			local webhook = tab[1]
			local log = C.Notifications.Console.Log

			if (webhook == nil or webhook == '' or #webhook < 20) then
				log({text = 'Invalid use, exmaple usage: cyrus_set_end_webhook https://discordapp.com/api/webhooks/xxxxxxxxxxx/xxxxxxxxxxxxxxxx-xxxx'})
			else
				cache.writeDB(C.DB.Ping.End, webhook)
				log({text = cache.format('Set your discord channel end ping webhook to %s', webhook), normal_log = true})
			end
		end,
		['set_timezone'] = function(tab)
			local timezone = tab[1]
			local log = C.Notifications.Console.Log

			if (timezone == nil or timezone == '' or #timezone ~= 6) then
				log({text = 'Invalid use, exmaple usage: cyrus_set_timezone +10:00 NOTE: Make sure the timezone is UTC & add 0\'s to numbers less than 10. EG -09:05, +03:30 etc'})
			else
				cache.writeDB(C.DB.Ping.TimeZone, timezone)
				log({text = cache.format('Set your timezone to %s', timezone), normal_log = true})
			end
		end,
		['test_discord'] = function(tab)
			if (C.Funcs.CheckDiscordDB()) then
				local db, read = C.DB.Ping, cache.readDB
				local timestamp = C.Funcs.GetDiscordTimeFormatted()
				local id, start_hook, end_hook, timezone = read(db.ID), read(db.Start), read(db.End), read(db.TimeZone)

				local start_payload = cache.format([[
					{
						"content": "<@%s>, hello!",
						"embeds": [
						  {
							"title": "Example START Message",
							"description": "If you're seeing this, you've set up Cyrus successfully! Make sure to check that you set your timezone correctly.",
							"color": 4437377,
							"footer": {
							  "text": "Cyrus - MM Utilities"
							},
							"timestamp": "%s"
						  }
						]
					  }]], id, timestamp)

				http.request('POST', start_hook,
					{
						['headers'] = {
							['Content-Length'] = start_payload:len(),
							['Content-Type'] = 'application/json'
						},
						['body'] = start_payload
					},
					C.Funcs.EmptyFunc
				)

				local end_payload = cache.format([[
					{
						"content": "<@%s>, hello!",
						"embeds": [
						  {
							"title": "Example END Message",
							"description": "If you're seeing this, you've set up Cyrus successfully! Make sure to check that you set your timezone correctly.",
							"color": 4437377,
							"footer": {
							  "text": "Cyrus - MM Utilities"
							},
							"timestamp": "%s"
						  }
						]
					  }]], id, timestamp)

				http.request('POST', end_hook,
					{
						['headers'] = {
							['Content-Length'] = end_payload:len(),
							['Content-Type'] = 'application/json'
						},
						['body'] = end_payload
					},
					C.Funcs.EmptyFunc
				)
			end
		end,
		['party_say'] = function(tab)
			local msg = table.concat(tab, C.EscapedSequenceChars.NoBreakSpace)

			if (msg == nil or msg == '') then
				C.Notifications.Console.Log({text = 'Invalid use, example usage: cyrus_party_say Hello, World!', normal_log = true})
			else
				C.Funcs.PartyChatSay(msg)
			end
		end,
		['tsay'] = function(tab)
			if (C.Funcs.IsConnected(cache.me())) then
				local toLanguage = tab[1]

				table.remove(tab, 1)

				local text = table.concat(tab, ' ')

				local payload = {
					text = text,
					to_lang = toLanguage,
					chat = true
				}

				C.Funcs.HandleChatTranslation(payload)
			end
		end,
		['language_codes'] = function(tab)
			local countries = {'\n'}

			for k, v in pairs(C.CountryCodes) do
				table.insert(countries, cache.format('%s - %s\n', k, v))
			end

			C.Notifications.Console.Log({text = table.concat(countries), normal_log = true})
		end,
		['changelogs'] = function(tab)
			local col = C.Colours.RGB
			local green, white, blue, red, orange = col.Green, col.White, col.Blue, col.Red, col.Orange
			local log = cache.colourLog

			log(white.r, white.g, white.b, '[\0')
			log(blue.r, blue.g, blue.b, 'Cyrus\0')
			log(white.r, white.g, white.b, '] - \0')
			log(orange.r, white.g, orange.b, 'by x0m\0')

			for _, v in pairs(C.ChangeLogs) do
				if (v:find('=') == 1) then
					log(red.r, red.g, red.b, cache.format('\t%s ', v))
				elseif (v ~= '') then
					log(green.r, green.g, green.b, cache.format('\t• %s ', v))
				else
					log(green.r, green.g, green.b, ' ')
				end
			end

		end,
	},
	ConsoleInput = {
		Callback = function(text)
			if (text:sub(1, #'cyrus') == 'cyrus') then
				text = C.Funcs.StringExplode(' ', text)
				local cmd = text[1]:sub(#'cyrus_' + 1, -1):lower()

				table.remove(text, 1)

				if (C.ConCommands[cmd]) then
					C.Events.ConCommands[cmd](text)
				else
					C.Notifications.Console.Log({text = 'Invalid command entered, see cyrus_help for list of commands', normal_log = true})
				end

				return true
			end
		end
	}
}

C.UI = {
	LabelStart = {
		Element = cache.label(C.Config.Panel, C.Config.Side, '------------------[Start Cyrus]----------------')
	},
	ShowUIMessages = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Show UI Changes')
	},
	AFKMode = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'AFK Mode')
	},
	RadioSpam = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Radio Spam'),
		Hidden = {
			Speed = cache.slider(C.Config.Panel, C.Config.Side, 'Spam Delay', 20, 100, 50, true, '%')
		}
	},
	VoteRevealer = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Vote Revealer')
	},
	UseSpam = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Use Spam'),
		Hidden = {
			Speed = cache.slider(C.Config.Panel, C.Config.Side, 'Spam Delay', 1, 100, 5, true, '%'),
			Key = cache.hotkey(C.Config.Panel, C.Config.Side, 'Spam Key', true)
		}
	},
	PlasmaShot = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Plasma Shot'),
		Hidden = {
			Key = cache.hotkey(C.Config.Panel, C.Config.Side, 'Key', true)
		}
	},
	AutoDC = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Auto DC @ Match End')
	},
	AvoidPMB = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Auto DC @ Match Start [if in party]')
	},
	DiscordPingStart = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Discord Ping [Match Start]')
	},
	DiscordPingEnd = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Discord Ping [Match End]')
	},
	ShotLogs = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Shot Logs')
	},
	TeamDamageLogs = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Team Damage Logs')
	},
	TeamChat = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Team Chat Messages')
	},
	Translator = {
		Element = cache.checkbox(C.Config.Panel, C.Config.Side, 'Translator'),
		Hidden = {
			Incoming = cache.checkbox(C.Config.Panel, C.Config.Side, 'Translate Incoming Messages'),
			Outgoing = cache.checkbox(C.Config.Panel, C.Config.Side, 'Translate Outgoing Messages'),
			ShowOGMessage = cache.checkbox(C.Config.Panel, C.Config.Side, 'Show OG Messages'),

			LabelLocal = cache.label(C.Config.Panel, C.Config.Side, 'Local Language'),
			Local = cache.textbox(C.Config.Panel, C.Config.Side, 'en'),

			LabelSource = cache.label(C.Config.Panel, C.Config.Side, 'From Language'),
			Source = cache.textbox(C.Config.Panel, C.Config.Side, 'auto'),

			LabelTo = cache.label(C.Config.Panel, C.Config.Side, 'To Language'),
			To = cache.textbox(C.Config.Panel, C.Config.Side, 'ru')
		}
	},

	NotificationType = {
		Element = cache.multiselect(C.Config.Panel, C.Config.Side, 'Notification Type', {'Chat Print', 'Console'})
	},
	ChatCommands = {
		Element = cache.multiselect(C.Config.Panel, C.Config.Side, 'Chat Commands', {'Buy', 'Ranks', 'Tsay'})
	},
	Spam = {
		Element = cache.combobox(C.Config.Panel, C.Config.Side, 'Spam Type', {'-', 'Kill', 'Death', 'Chat'}),
		Hidden = {
			Message = cache.combobox(C.Config.Panel, C.Config.Side, 'Message', {'Off', 'Insult', 'Insult (Caps)', 'Cancer Strike', 'Super Cancer Strike', 'Annoying Question'}),
			Speed = cache.slider(C.Config.Panel, C.Config.Side, 'Spam Delay', 5, 100, 50, true, '%')
		}
	},
	ShitPostList = {
		Element = cache.combobox(C.Config.Panel, C.Config.Side, 'Shitpost List', {'Insult', 'Insult (Caps)', 'Cancer Strike', 'Super Cancer Strike', 'Annoying Question'})
	},
	ExecuteShitPost = {
		Element = cache.button(C.Config.Panel, C.Config.Side, 'Execute Shitpost', C.Events.ExecuteShitPost.Callback)
	},

	RankDump = {
		TargetTeam = cache.combobox(C.Config.Panel, C.Config.Side, 'Rank Dump Team', {'Enemy', 'Team', 'All'}),
		Element = cache.button(C.Config.Panel, C.Config.Side, 'Dump Rank + Wins', C.Events.RankDump.Callback)
	},

	LabelEnd = {
		Element = cache.label(C.Config.Panel, C.Config.Side, '-------------------[End Cyrus]-----------------')
	}
}

C.UI.ShowUIMessages.Element:on('change', C.Events.ShowUIMessages.Callback)

C.UI.AFKMode.Element:on('change', C.Events.AFKMode.Callback)

C.UI.RadioSpam.Element:on('round_end', C.Events.RadioSpam.round_end)
C.UI.RadioSpam.Element:on('cs_win_panel_match', C.Events.RadioSpam.cs_win_panel_match)
C.UI.RadioSpam.Element:on('round_announce_match_start', C.Events.RadioSpam.round_announce_match_start)
C.UI.RadioSpam.Element:on('run_command', C.Events.RadioSpam.run_command)
C.UI.RadioSpam.Element:on('change', C.Events.RadioSpam.Callback)

C.UI.VoteRevealer.Element:on('run_command', C.Events.VoteRevealer.run_command)
C.UI.VoteRevealer.Element:on('vote_options', C.Events.VoteRevealer.vote_options)
C.UI.VoteRevealer.Element:on('vote_cast', C.Events.VoteRevealer.vote_cast)
C.UI.VoteRevealer.Element:on('change', C.Events.VoteRevealer.Callback)

C.UI.TeamChat.Element:on('change', C.Events.TeamChat.Callback)

C.UI.UseSpam.Element:on('round_end', C.Events.UseSpam.round_end)
C.UI.UseSpam.Element:on('cs_win_panel_match', C.Events.UseSpam.cs_win_panel_match)
C.UI.UseSpam.Element:on('round_announce_match_start', C.Events.UseSpam.round_announce_match_start)
C.UI.UseSpam.Element:on('setup_command', C.Events.UseSpam.setup_command)
C.UI.UseSpam.Element:on('change', C.Events.UseSpam.Callback)

C.UI.PlasmaShot.Element:on('weapon_fire', C.Events.PlasmaShot.weapon_fire)
C.UI.PlasmaShot.Element:on('change', C.Events.PlasmaShot.Callback)

C.UI.AutoDC.Element:on('cs_win_panel_match', C.Events.AutoDC.cs_win_panel_match)
C.UI.AutoDC.Element:on('change', C.Events.AutoDC.Callback)

C.UI.AvoidPMB.Element:on('paint_ui', C.Events.AvoidPMB.paint_ui)
C.UI.AvoidPMB.Element:on('change', C.Events.AvoidPMB.Callback)

C.UI.DiscordPingStart.Element:on('round_announce_match_start', C.Events.DiscordPingStart.round_announce_match_start)
C.UI.DiscordPingStart.Element:on('change', C.Events.DiscordPingStart.Callback)

C.UI.DiscordPingEnd.Element:on('cs_win_panel_match', C.Events.DiscordPingEnd.cs_win_panel_match)
C.UI.DiscordPingEnd.Element:on('round_end', C.Events.DiscordPingEnd.round_end)
C.UI.DiscordPingEnd.Element:on('change', C.Events.DiscordPingEnd.Callback)

cache.callback(C.UI.NotificationType.Element, C.Events.NotificationType.Callback)

cache.callback(C.UI.Spam.Element, C.Events.Spam.Callback)
cache.callback(C.UI.Spam.Hidden.Message, C.Events.Spam.Hidden.Message.Callback)

cache.callback(C.UI.ShitPostList.Element, C.Events.ShitPostList.Callback)

cache.callback(C.UI.ExecuteShitPost.Element, C.Events.ExecuteShitPost.Callback)

cache.callback(C.UI.ChatCommands.Element, C.Events.ChatCommands.Callback)

C.UI.ShotLogs.Element:on('aim_fire', C.Events.ShotLogs.aim_fire)
C.UI.ShotLogs.Element:on('aim_miss', C.Events.ShotLogs.aim_miss)
C.UI.ShotLogs.Element:on('aim_hit', C.Events.ShotLogs.aim_hit)
C.UI.ShotLogs.Element:on('player_hurt', C.Events.ShotLogs.player_hurt)
C.UI.ShotLogs.Element:on('round_end', C.Events.ShotLogs.ResetShotData)
C.UI.ShotLogs.Element:on('change', C.Events.ShotLogs.Callback)

C.UI.TeamDamageLogs.Element:on('round_announce_match_start', C.Events.ShotLogs.ResetTeamDmgData)
C.UI.TeamDamageLogs.Element:on('cs_win_panel_match', C.Events.ShotLogs.ResetTeamDmgData)
C.UI.TeamDamageLogs.Element:on('player_death', C.Events.TeamDamageLogs.player_death)
C.UI.TeamDamageLogs.Element:on('player_hurt', C.Events.TeamDamageLogs.player_hurt)
C.UI.TeamDamageLogs.Element:on('change', C.Events.TeamDamageLogs.Callback)

cache.callback(C.UI.RankDump.TargetTeam, C.Events.RankDump.TargetTeamCallback)

C.UI.Translator.Hidden.Incoming:on('player_chat', C.Events.Translator.player_chat)
C.UI.Translator.Hidden.Incoming:on('change', C.Events.Translator.Callback_incoming)

C.UI.Translator.Hidden.Outgoing:on('string_cmd', C.Events.Translator.string_cmd)
C.UI.Translator.Hidden.Outgoing:on('change', C.Events.Translator.Callback_outgoing)

C.UI.Translator.Hidden.ShowOGMessage:on('change', C.Events.Translator.Callback_showogmsg)

C.UI.Translator.Element:on('change', C.Events.Translator.Callback)

cache.registerEvent('console_input', C.Events.ConsoleInput.Callback)

for _, v in pairs(C.UI) do
	if (v.Hidden) then
		for _, element in pairs(v.Hidden) do
			if (type(element) == 'table') then
				element:hide()
			else
				cache.setVisible(element, false)
			end
		end
	end
end