local killsays = {
	"Open up the sky!",
	"Prepare for hellfire!",
	"Deep fried!",
	"Don’t get in my way!",
	"Welcome to my world.",
	"Watch them run.",
	"Scatter!",
	"Boo,",
	"You thought you were safe.",
	"Behind you.",
	"Look behind you.",
	"Damn!",
	"Teleport stopped.",
	"Initiated!",
	"You should run…",
	"Area clear!",
	"Caught one.",
	"Caught two.",
	"Caught three.",
	"Caught four.",
	"Got them all!",
	"Trapped and zapped!",
	"Fish in a barrel.",
	"Where is everyone hiding?",
	"I know exactly where you are.",
	"Give me a corpse!",
	"I am the hunter!",
	"Nowhere to run!",
	"Your duty is not over!",
	"You will not kill my allies!",
	"Come on, let’s go!",
	"Joke’s over, you’re dead!",
	"Watch this!",
	"Get out of my way!",
	"Give me those back.",
	"They will cower!",
	"All mine.",
	"Oh, the rush.",
	"More, more!",
	"Here comes the party!",
	"Fire in the hole!",
	"Obliterated!",
	"Boom!",
	"You see that?",
	"Oh, that worked great!",
	"Let’s go!",
	"Off your feet!",
	"Seek them out.",
	"I’ve got your trail.",
	"Found one!",
	"I’ll handle this.",
	"Who’s next?",
	"I’m back",
	"Miss me?",
	"I’m right here.",
	"Looking for me?",
	"World divided!",
	"You are divided!",
	"No one walks away.",
	"You are powerless!",
	"I need a reset.",
	"System failure.",
	"Emergency reset required.",
	"Requesting manual reset.",
	"Critical damage.",
	"Shutting down.",
	"Back online.",
	"Core systems restored.",
	"Now, where was I?",
	"Thank you.",
	"Resuming your termination.",
	"They are so dead!",
	"You want to play? Let’s play.",
	"Ooh, I like it.",
	"Oh I’m enjoying this!",
	"Beautiful.",
	"I love this gun!",
	"This is too fun!",
	"Here we go!",
	"Hoy! I’m pissed!",
	"Die!",
	"Dead!",
	"Zapped!",
	"Nightmare, take them!",
	"Face your fear!",
	"I’m done with you.",
	"Inevitable.",
	"Contract complete.",
	"Dream no more.",
	"Let’s turn the tide.",
	"I suggest you move."
	
}

local function table_length(data)
    if type(data) ~= 'table' then
        return 0													
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local function on_event(event)
    local lp = entity_list.get_local_player()
    local kill_cmd = 'say ' .. killsays[math.random(table_length(killsays))] --randomly selecting a killsay
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    engine.execute_cmd(kill_cmd) --executing the killsay command
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death")