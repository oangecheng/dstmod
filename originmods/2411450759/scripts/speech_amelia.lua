--[[
	--- This is Wilson's speech file for Don't Starve Together ---
	Write your character's lines here.
	If you want to use another speech file as a base, or use a more up-to-date version, get them from data\databundles\scripts.zip\scripts\
	
	If you want to use quotation marks in a quote, put a \ before it.
	Example:
	"Like \"this\"."
]]
return {
	ACTIONFAIL =
	{
        REPAIR =
        {
            WRONGPIECE = "Something's wrong with this!",
        },
        BUILD =
        {
            MOUNTED = "I need to get down to the ground first!",
            HASPET = "I already have Bubba and Mikki.",
        },
		SHAVE =
		{
			AWAKEBEEFALO = "Better do that while they are sleeping.",
			GENERIC = "I can't shave that!",
			NOBITS = "There isn't even any stubble left!",
--fallback to speech_wilson.lua             REFUSE = "only_used_by_woodie",
		},
		STORE =
		{
			GENERIC = "It's already full.",
			NOTALLOWED = "I can't put that in here!",
			INUSE = "I will wait for my turn.",
            NOTMASTERCHEF = "I'm detective and doctor, not a chef.",
		},
        CONSTRUCT =
        {
            INUSE = "Someone beat me to it.",
            NOTALLOWED = "It won't fit in there.",
            EMPTY = "I need something to build with.",
            MISMATCH = "I think I select a wrong plans.",
        },
		RUMMAGE =
		{	
			GENERIC = "I can't do that.",
			INUSE = "Hurry up and lets me use it!",
            NOTMASTERCHEF = "I'm detective and doctor, not a chef.",
		},
		UNLOCK =
        {
--fallback to speech_wilson.lua         	WRONGKEY = "I can't do that.",
        },
		USEKLAUSSACKKEY =
        {
        	WRONGKEY = "Why this key is not working?!",
        	KLAUS = "I'm a little preoccupied!!",
			QUAGMIRE_WRONGKEY = "Where can I find the correct key?!",
        },
		ACTIVATE = 
		{
			LOCKED_GATE = "The gate is locked.",
		},
        COOK =
        {
            GENERIC = "My hands are full now, I can't cook.",
            INUSE = "Let's me cook first!",
            TOOFAR = "I'm way too FAR from that!",
        },
        START_CARRAT_RACE =
        {
            NO_RACERS = "Where can I get some Carrats?",
        },
        
        --warly specific action
		DISMANTLE =
		{
			COOKING = "Let's wait until it finishs cooking.",
			INUSE = "We need to move it NOW!",
			NOTEMPTY = "We need to cook something!",
        },
        FISH_OCEAN =
		{
			TOODEEP = "I need to use the better kind of rod!",
		},
        OCEAN_FISHING_POND =
		{
			WRONGGEAR = "This might be overdoing it a bit.",
		},
        --wickerbottom specific action
--fallback to speech_wilson.lua         READ =
--fallback to speech_wilson.lua         {
--fallback to speech_wilson.lua             GENERIC = "only_used_by_wickerbottom",
--fallback to speech_wilson.lua             NOBIRDS = "only_used_by_wickerbottom"
--fallback to speech_wilson.lua         },

        GIVE =
        {
            GENERIC = "Why don't you just ACCEPT it?",
            DEAD = "Well, I'll take it then.",
            SLEEPING = "Maybe I will come later when they woke up.",
            BUSY = "Can you quit doing that for a sec?",
            ABIGAILHEART = "I don't think I could use a heart on her.",
            GHOSTHEART = "Seems like it rejecting my offer.",
            NOTGEM = "This won't fit there!",
            WRONGGEM = "I need a different kind of gem!",
            NOTSTAFF = "It's not gonna fit here.",
            MUSHROOMFARM_NEEDSSHROOM = "Where did I store my mushroom again?",
            MUSHROOMFARM_NEEDSLOG = "We need to find more living log!",
            MUSHROOMFARM_NOMOONALLOWED = "Better plant it outside moon island.",
            SLOTFULL = "We already put something there.",
            FOODFULL = "It's refusing food from me.",
            NOTDISH = "It won't want to eat that.",
            DUPLICATE = "We already know that one.",
            NOTSCULPTABLE = "I can't make it a sculpture.",
--fallback to speech_wilson.lua             NOTATRIUMKEY = "It's not quite the right shape.",
            CANTSHADOWREVIVE = "It won't resurrect.",
            WRONGSHADOWFORM = "It's not put together right.",
            NOMOON = "I need to see the moon for that to work.",
			PIGKINGGAME_MESSY = "I'm too lazy to clean these.",
			PIGKINGGAME_DANGER = "It's too dangerous for that right now.",
			PIGKINGGAME_TOOLATE = "It's too late now.",
        },
        GIVETOPLAYER =
        {
            FULL = "Free up your slot please.",
            DEAD = "Well, I'll take it then.",
            SLEEPING = "Too unconscious to care.",
            BUSY = "Can you quit doing that for a sec?",
        },
        GIVEALLTOPLAYER =
        {
            FULL = "Free up your slot please.",
            DEAD = "Well, I'll take it then.",
            SLEEPING = "Maybe I will come later when they woke up.",
            BUSY = "I'll try again in a second.",
        },
        WRITE =
        {
            GENERIC = "No need to rewrite that.",
            INUSE = "Come on! I need to write something!",
        },
        DRAW =
        {
            NOIMAGE = "I need some model to draw this!",
        },
        CHANGEIN =
        {
            GENERIC = "My outfit is fine as it is.",
            BURNING = "Put out the fire NOW!",
            INUSE = "Just pick one already!",
        },
        ATTUNE =
        {
            NOHEALTH = "I'm too sick to use it.",
        },
        MOUNT =
        {
            TARGETINCOMBAT = "Just calm down already and lets me ride!",
            INUSE = "Hey! That saddle is MINE!",
        },
        SADDLE =
        {
            TARGETINCOMBAT = "It won't let me do that while it's angry.",
        },
        TEACH =
        {
            --Recipes/Teacher
            KNOWN = "I already know that, you know?",
            CANTLEARN = "This is too complicated even for me.",

            --MapRecorder/MapExplorer
            WRONGWORLD = "This map was made for somewhere else.",
        },
        WRAPBUNDLE =
        {
            EMPTY = "I need an item to wrap.",
        },
        PICKUP =
        {
			RESTRICTION = "Maybe it is unusable to me.",
			INUSE = "Let's me use that first!",
        },
        SLAUGHTER =
        {
            TOOFAR = "DAMMIT! It got away!",
        },
        REPLATE =
        {
            MISMATCH = "Seems like it's wrong type of dish.", 
            SAMEDISH = "It's already on the same dish!", 
        },
        SAIL =
        {
        	REPAIR = "It's FINE! No need to repair.",
        },
        ROW_FAIL =
        {
            BAD_TIMING0 = "I HATE THIS!",
            BAD_TIMING1 = "This is HARD!",
            BAD_TIMING2 = "It not my FAULT!",
        },
        LOWER_SAIL_FAIL =
        {
            "WHY SAILING IS SO HARD IN THIS GAME!",
            "I... hate... THIS!",
            "This game mechanic.. SUCK!",
        },
        BATHBOMB =
        {
            GLASSED = "I can't, the surface is glassed over.",
            ALREADY_BOMBED = "That would be a waste of a bath bomb.",
        },
        GIVE_TACKLESKETCH =
		{
			DUPLICATE = "It's the same sketch as existing one!",
		},
		COMPARE_WEIGHABLE =
		{
			TOO_SMALL = "It's too small..",
		},
        BEGIN_QUEST =
        {
            ONEGHOST = "Oh yeah! Time for some ghost busting!",
        },
		TELLSTORY = 
		{
			GENERIC = "only_used_by_walter",
--fallback to speech_wilson.lua 			NOT_NIGHT = "only_used_by_walter",
--fallback to speech_wilson.lua 			NO_FIRE = "only_used_by_walter",
		},
        SING_FAIL =
        {
--fallback to speech_wilson.lua             SAMESONG = "only_used_by_wathgrithr",
        },
	},
	ACTIONFAIL_GENERIC = "That's not possible.",
	ANNOUNCE_BOAT_LEAK = "Oh shoot! The boat starts to leak!",
	ANNOUNCE_BOAT_SINK = "We are going to drown!",
	ANNOUNCE_DIG_DISEASE_WARNING = "Now we get rid of the disease.",
	ANNOUNCE_PICK_DISEASE_WARNING = "Yike! I should have not touching that.",
	ANNOUNCE_ADVENTUREFAIL = "Why that's not working?!",
    ANNOUNCE_MOUNT_LOWHEALTH = "This beast gonna die if we don't do SOMETHING!",

    --waxwell and wickerbottom specific strings
    ANNOUNCE_TOOMANYBIRDS = "only_used_by_waxwell_and_wicker",
    ANNOUNCE_WAYTOOMANYBIRDS = "only_used_by_waxwell_and_wicker",

    --wolfgang specific
    ANNOUNCE_NORMALTOMIGHTY = "only_used_by_wolfang",
    ANNOUNCE_NORMALTOWIMPY = "only_used_by_wolfang",
    ANNOUNCE_WIMPYTONORMAL = "only_used_by_wolfang",
    ANNOUNCE_MIGHTYTONORMAL = "only_used_by_wolfang",

	ANNOUNCE_BEES = "BEEEEEEEEEEEEES!!!!",
	ANNOUNCE_BOOMERANG = "This weapon SUCK!",
	ANNOUNCE_CHARLIE = "I need to craft a torch!",
	ANNOUNCE_CHARLIE_ATTACK = "Oh SHOOT! That thing hit me!",
	ANNOUNCE_CHARLIE_MISSED = "only_used_by_winona", --winona specific 
	ANNOUNCE_COLD = "It's chilling!",
	ANNOUNCE_HOT = "I need some ice right now!",
	ANNOUNCE_CRAFTING_FAIL = "Some ingredients are missing!",
	ANNOUNCE_DEERCLOPS = "Big bad guy is coming!",
	ANNOUNCE_CAVEIN = "Oh no! We are stucked!",
	ANNOUNCE_ANTLION_SINKHOLE = 
	{
		"The ground is shaking?!",
		"An earthquake?!",
		"Something is underground!",
	},
	ANNOUNCE_ANTLION_TRIBUTE =
	{
        "Will this satisfied him?",
        "It better be something GOOD!",
        "GIMME GIMME!",
	},
	ANNOUNCE_SACREDCHEST_YES = "That was EAAASYYYYY!",
	ANNOUNCE_SACREDCHEST_NO = "I HATE YOU!",
    ANNOUNCE_DUSK = "It's getting dark. We gonna head back soon.",
    
    --wx-78 specific
    ANNOUNCE_CHARGE = "only_used_by_wx78",
	ANNOUNCE_DISCHARGE = "only_used_by_wx78",

	ANNOUNCE_EAT =
	{
		GENERIC = "Ah nom nom nom!",
		PAINFUL = "I don't feel so good.",
		SPOILED = "Eww! That was terrible!",
		STALE = "Better dispose this.",
		INVALID = "I can't eat that!",
        YUCKY = "It's DISGUSTING!",
        
        --Warly specific ANNOUNCE_EAT strings
		COOKED = "only_used_by_warly",
		DRIED = "only_used_by_warly",
        PREPARED = "only_used_by_warly",
        RAW = "only_used_by_warly",
		SAME_OLD_1 = "only_used_by_warly",
		SAME_OLD_2 = "only_used_by_warly",
		SAME_OLD_3 = "only_used_by_warly",
		SAME_OLD_4 = "only_used_by_warly",
        SAME_OLD_5 = "only_used_by_warly",
		TASTY = "only_used_by_warly",
    },
    
    ANNOUNCE_ENCUMBERED =
    {
        "Huff... Pant...",
        "I'm stucked!",
        "This suck...",
        "I hate this so much...",
        "I'm so DONE with this!",
        "Why this happens to me?",
        "Arghh...!",
        "If only I could use my full power...",
        "Not worse than what happened to me, but still..",
    },
    ANNOUNCE_ATRIUM_DESTABILIZING = 
    {
		"Tt's time to leave, guys!",
		"We are on our own now!",
		"RUNNNNN!",
	},
    ANNOUNCE_RUINS_RESET = "It seems those monsters are coming back",
    ANNOUNCE_SNARED = "HELP! I'm stucked!!",
    ANNOUNCE_REPELLED = "You can't touch me!",
	ANNOUNCE_ENTER_DARK = "Find the light source!",
	ANNOUNCE_ENTER_LIGHT = "We're safe now!",
	ANNOUNCE_FREEDOM = "I'm FREE!!",
	ANNOUNCE_HIGHRESEARCH = "Still too EASY for me!",
	ANNOUNCE_HOUNDS = "I heard a wolf sound.",
	ANNOUNCE_WORMS = "Wait, What was that?",
	ANNOUNCE_HUNGRY = "I need to find things to EAT!",
	ANNOUNCE_HUNT_BEAST_NEARBY = "The beast should be close by. Follow the track!",
	ANNOUNCE_HUNT_LOST_TRAIL = "WE LOST IT!",
	ANNOUNCE_HUNT_LOST_TRAIL_SPRING = "I CAN'T see footprints clearly in this wet dirt!",
	-- ANNOUNCE_INV_FULL = "Are you free, Bubba? My inventory is full!",
    ANNOUNCE_INV_FULL = 
    {
        "Are you free, Bubba? My inventory is full!",
        "There is never enough space for all these items.",
        "Too many things I want to KEEP!",
    },
	ANNOUNCE_KNOCKEDOUT = "Ouch, I need to get up now..",
	ANNOUNCE_LOWRESEARCH = "WAYYYYYY too easy!",
	ANNOUNCE_MOSQUITOS = "I HATE mosquitos!",
    ANNOUNCE_NOWARDROBEONFIRE = "I can't change while it's on fire!",
    ANNOUNCE_NODANGERGIFT = "I can't open presents with monsters about!",
    ANNOUNCE_NOMOUNTEDGIFT = "I should get off my beefalo first.",
	ANNOUNCE_NODANGERSLEEP = "It's not SAFE to sleep here!",
	ANNOUNCE_NODAYSLEEP = "It's too bright to sleep.",
	ANNOUNCE_NODAYSLEEP_CAVE = "I'm not that tired.",
	ANNOUNCE_NOHUNGERSLEEP = "How can I sleep with this growling stomach?!",
	ANNOUNCE_NOSLEEPONFIRE = "Stay a bit further from fire, will ya?.",
	ANNOUNCE_NODANGERSIESTA = "It's not a time for siesta right now!",
	ANNOUNCE_NONIGHTSIESTA = "Better sleep in the bed than siestas at night.",
	ANNOUNCE_NONIGHTSIESTA_CAVE = "How anyone could just chilling down here?",
	ANNOUNCE_NOHUNGERSIESTA = "Better find something to eat first.",
	ANNOUNCE_NODANGERAFK = "Lets get rid of these mobs first before leaving!",
	ANNOUNCE_NO_TRAP = "Well, that was EZ.",
	ANNOUNCE_PECKED = "Stop pecking ME!",
	ANNOUNCE_QUAKE = "That doesn't sound good.",
	ANNOUNCE_RESEARCH = "It always good to try something new.",
	ANNOUNCE_SHELTER = "It's nice and dry under the tree.",
	ANNOUNCE_THORNS = "Ouch!",
	ANNOUNCE_BURNT = "IT'S BURN!",
	ANNOUNCE_TORCH_OUT = "Hurry! Craft a new torch!",
	ANNOUNCE_THURIBLE_OUT = "The thurible has burnt out.",
	ANNOUNCE_FAN_OUT = "My fan is blown away!",
    ANNOUNCE_COMPASS_OUT = "This compass is useless now.",
	ANNOUNCE_TRAP_WENT_OFF = "Oops.",
	ANNOUNCE_UNIMPLEMENTED = "I don't think it's ready yet...",
	ANNOUNCE_WORMHOLE = "That was not like any time travelling I known.",
	ANNOUNCE_TOWNPORTALTELEPORT = "Could this be another method of time travelling?.",
	ANNOUNCE_CANFIX = "\nI definitely know how to fix this!",
	ANNOUNCE_ACCOMPLISHMENT = "Getting things done feel good, isn't it?",
	ANNOUNCE_ACCOMPLISHMENT_DONE = "Another sucesssful mission!",	
	ANNOUNCE_INSUFFICIENTFERTILIZER = "We need more fertilizers!",
	ANNOUNCE_TOOL_SLIP = "It slipped out of my HAND!",
	ANNOUNCE_LIGHTNING_DAMAGE_AVOIDED = "Good thing I build that rod beforehand.",
	ANNOUNCE_TOADESCAPING = "The toad is getting away.",
	ANNOUNCE_TOADESCAPED = "The toad is gone.",


	ANNOUNCE_DAMP = "I feel uncomfortable.",
	ANNOUNCE_WET = "My clothes getting wet.",
	ANNOUNCE_WETTER = "I need to dry myself quick!",
	ANNOUNCE_SOAKED = "I'm so DONE with all these wetness!",

	ANNOUNCE_WASHED_ASHORE = "I have seen much worse.",

    ANNOUNCE_DESPAWN = "I can see the light!",
	ANNOUNCE_BECOMEGHOST = "oOooOooo!!",
	ANNOUNCE_GHOSTDRAIN = "My humanity is about to start slipping away...",
	ANNOUNCE_PETRIFED_TREES = "Did I just hear trees screaming?",
	ANNOUNCE_KLAUS_ENRAGE = "There's no way to beat it now!!",
	ANNOUNCE_KLAUS_UNCHAINED = "Its chains came off!",
	ANNOUNCE_KLAUS_CALLFORHELP = "It called for help!",

	ANNOUNCE_MOONALTAR_MINE =
	{
		GLASS_MED = "There it is! A Moonaltar's part.",
		GLASS_LOW = "Almost there, keep digging.",
		GLASS_REVEAL = "Got it!",
		IDOL_MED = "There it is! A Moonaltar's part.",
		IDOL_LOW = "Almost there, keep digging.",
		IDOL_REVEAL = "Got it!",
		SEED_MED = "There it is! A Moonaltar's part.",
		SEED_LOW = "Almost there, keep digging.",
		SEED_REVEAL = "Got it!",
	},

    --hallowed nights
    ANNOUNCE_SPOOKED = "Oooh! Spooky.",
	ANNOUNCE_BRAVERY_POTION = "I feel calm after I drank that.",
	ANNOUNCE_MOONPOTION_FAILED = "Did I missed something?",

    --winter's feast
	ANNOUNCE_EATING_NOT_FEASTING = "It's not hurt sharing I guess.",
    ANNOUNCE_WINTERS_FEAST_BUFF = "That was a satisfied meal.",
    ANNOUNCE_IS_FEASTING = "YUM YMU YUM!",
    ANNOUNCE_WINTERS_FEAST_BUFF_OVER = "Maybe I will get another.",
    
    --lavaarena event
    ANNOUNCE_REVIVING_CORPSE = "You want a help?",
    ANNOUNCE_REVIVED_OTHER_CORPSE = "It' done!",
    ANNOUNCE_REVIVED_FROM_CORPSE = "Aw, thank you!",

    ANNOUNCE_FLARE_SEEN = "What are they trying to tell me?",
    ANNOUNCE_OCEAN_SILHOUETTE_INCOMING = "Oh shoot! Sea monsters!",

    --willow specific
	ANNOUNCE_LIGHTFIRE =
	{
		"only_used_by_willow",
    },

    --winona specific
--fallback to speech_wilson.lua     ANNOUNCE_HUNGRY_SLOWBUILD = 
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua 	    "only_used_by_winona",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_HUNGRY_FASTBUILD = 
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua 	    "only_used_by_winona",
--fallback to speech_wilson.lua     },

    --wormwood specific
--fallback to speech_wilson.lua     ANNOUNCE_KILLEDPLANT = 
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_GROWPLANT = 
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_BLOOMING = 
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wormwood",
--fallback to speech_wilson.lua     },

    --wortox specfic
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_EMPTY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_FEW =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_MANY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua     ANNOUNCE_SOUL_OVERLOAD =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "only_used_by_wortox",
--fallback to speech_wilson.lua     },

    --walter specfic
--fallback to speech_wilson.lua 	ANNOUNCE_SLINGHSOT_OUT_OF_AMMO =
--fallback to speech_wilson.lua 	{
--fallback to speech_wilson.lua 		"only_used_by_walter",
--fallback to speech_wilson.lua 		"only_used_by_walter",
--fallback to speech_wilson.lua 	},
--fallback to speech_wilson.lua 	ANNOUNCE_STORYTELLING_ABORT_FIREWENTOUT =
--fallback to speech_wilson.lua 	{
--fallback to speech_wilson.lua         "only_used_by_walter",
--fallback to speech_wilson.lua 	},
--fallback to speech_wilson.lua 	ANNOUNCE_STORYTELLING_ABORT_NOT_NIGHT =
--fallback to speech_wilson.lua 	{
--fallback to speech_wilson.lua         "only_used_by_walter",
--fallback to speech_wilson.lua 	},

    --quagmire event
    QUAGMIRE_ANNOUNCE_NOTRECIPE = "Those ingredients didn't make ANYTHING!",
    QUAGMIRE_ANNOUNCE_MEALBURNT = "I left it on too long.",
    QUAGMIRE_ANNOUNCE_LOSE = "I have a bad feeling about this.",
    QUAGMIRE_ANNOUNCE_WIN = "Time to go!",

    --fallback to speech_wilson.lua     ANNOUNCE_ROYALTY =
--fallback to speech_wilson.lua     {
--fallback to speech_wilson.lua         "Your majesty.",
--fallback to speech_wilson.lua         "Your highness.",
--fallback to speech_wilson.lua         "My liege!",
--fallback to speech_wilson.lua     },

    ANNOUNCE_ATTACH_BUFF_ELECTRICATTACK    = "I will make you feel the shock.",
    ANNOUNCE_ATTACH_BUFF_ATTACK            = "Fight me!",
    ANNOUNCE_ATTACH_BUFF_PLAYERABSORPTION  = "I can tank them with this!",
    ANNOUNCE_ATTACH_BUFF_WORKEFFECTIVENESS = "Let's get some work done!",
    ANNOUNCE_ATTACH_BUFF_MOISTUREIMMUNITY  = "I can run around in rain, no problem!",
    ANNOUNCE_ATTACH_BUFF_SLEEPRESISTANCE   = "Now I can pound you all night!",
    
    ANNOUNCE_DETACH_BUFF_ELECTRICATTACK    = "Aww, no more sparking?",
    ANNOUNCE_DETACH_BUFF_ATTACK            = "Why do I feel tired than before..",
    ANNOUNCE_DETACH_BUFF_PLAYERABSORPTION  = "Let's be more careful now.",
    ANNOUNCE_DETACH_BUFF_WORKEFFECTIVENESS = "...time to cut some slack.",
    ANNOUNCE_DETACH_BUFF_MOISTUREIMMUNITY  = "The dry effect is over.",
    ANNOUNCE_DETACH_BUFF_SLEEPRESISTANCE   = "I need some tea..",

	ANNOUNCE_OCEANFISHING_LINESNAP = "The line is too WEAK for fishing!",
	ANNOUNCE_OCEANFISHING_LINETOOLOOSE = "Reel it in NOW!",
	ANNOUNCE_OCEANFISHING_GOTAWAY = "I'M QUIT! Who need to fish anyway?",
	ANNOUNCE_OCEANFISHING_BADCAST = "Next time, I think I can do it correctly.",
	ANNOUNCE_OCEANFISHING_IDLE_QUOTE = 
	{
		"WHY THIS IS TAKING TOO LONG?",
		"...I'm sleeping.",
		"The fish don't want to take the bait for some REASON!",
		"...maybe I should try to use a bomb instead.",
	},

	ANNOUNCE_WEIGHT = "Weight: {weight}",
	ANNOUNCE_WEIGHT_HEAVY  = "Weight: {weight}\nI got a BIG one!",

	-- these are just for testing for now, no need to write real strings yet
	ANNOUNCE_WINCH_CLAW_MISS = "Aw, come on! I was close enough!",
	ANNOUNCE_WINCH_CLAW_NO_ITEM = "Looks like I caught a whole lot of nothing.",
   --Wurt announce strings
--fallback to speech_wilson.lua     ANNOUNCE_KINGCREATED = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_KINGDESTROYED = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_THRONE = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_HOUSE = "only_used_by_wurt",
--fallback to speech_wilson.lua     ANNOUNCE_CANTBUILDHERE_WATCHTOWER = "only_used_by_wurt",
ANNOUNCE_READ_BOOK = 
{
--fallback to speech_wilson.lua         BOOK_SLEEP = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_BIRDS = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_TENTACLES =  "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_BRIMSTONE = "only_used_by_wurt",
--fallback to speech_wilson.lua         BOOK_GARDENING = "only_used_by_wurt",
},
ANNOUNCE_WEAK_RAT = "That thing's looking kinda rough.",

ANNOUNCE_CARRAT_START_RACE = "Alright, let's win that prize!",

ANNOUNCE_CARRAT_ERROR_WRONG_WAY = {
    "You dumb Carrat, you're going the wrong way!",
    "Hey! The finish line's THAT way!",
},
ANNOUNCE_CARRAT_ERROR_FELL_ASLEEP = "Hey! WAKE UP!!",    
ANNOUNCE_CARRAT_ERROR_WALKING = "Um, can we maybe go a bit faster?!",    
ANNOUNCE_CARRAT_ERROR_STUNNED = "Not so good with the reflexes, huh?",

ANNOUNCE_GHOST_QUEST = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_GHOST_HINT = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_GHOST_TOY_NEAR = {
--fallback to speech_wilson.lua         "only_used_by_wendy",
--fallback to speech_wilson.lua     },
--fallback to speech_wilson.lua 	ANNOUNCE_SISTURN_FULL = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_ABIGAIL_DEATH = "only_used_by_wendy",
--fallback to speech_wilson.lua     ANNOUNCE_ABIGAIL_RETRIEVE = "only_used_by_wendy",
--fallback to speech_wilson.lua 	ANNOUNCE_ABIGAIL_LOW_HEALTH = "only_used_by_wendy",
ANNOUNCE_ABIGAIL_SUMMON = 
{
--fallback to speech_wilson.lua 		LEVEL1 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL2 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL3 = "only_used_by_wendy",
},

ANNOUNCE_GHOSTLYBOND_LEVELUP = 
{
--fallback to speech_wilson.lua 		LEVEL2 = "only_used_by_wendy",
--fallback to speech_wilson.lua 		LEVEL3 = "only_used_by_wendy",
},

--fallback to speech_wilson.lua     ANNOUNCE_NOINSPIRATION = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_TAUNT_BUFF = "only_used_by_wathgrithr",
--fallback to speech_wilson.lua     ANNOUNCE_BATTLESONG_INSTANT_PANIC_BUFF = "only_used_by_wathgrithr",

ANNOUNCE_ARCHIVE_NEW_KNOWLEDGE = "Interesting...",
ANNOUNCE_ARCHIVE_OLD_KNOWLEDGE = "Nothing new to me.",
ANNOUNCE_ARCHIVE_NO_POWER = "Well that was exciting.",
	BATTLECRY =
	{
		GENERIC = "I'll KILL you!",
		PIG = "Come here, pig!",
		PREY = "Get wrecked!",
		SPIDER = "You wanna fight me?!",
		SPIDER_WARRIOR = "Time to show my skill.",
		DEER = "Let's hunt!",
        TALLBIRD = "It's groundpound time! Heh Heh heh.",
	},
	COMBAT_QUIT =
	{
		GENERIC = "I'm just a bit underleveled.",
		PIG = "Nah, who's care about those pigs.",
		PREY = "I'll comeback for you later.",
		SPIDER = "I'll just leave them alone.",
		SPIDER_WARRIOR = "I hate that weird spider.",
	},
	DESCRIBE =
	{
		MULTIPLAYER_PORTAL = "A respawn point.",
        MULTIPLAYER_PORTAL_MOONROCK = "A respawn point... on the moon.",
        MOONROCKIDOL = "Why do people worship this?",
        CONSTRUCTION_PLANS = "New stuff!",

        ANTLION =
        {
            GENERIC = "You want these junks I have?",
            VERYHAPPY = "We are friends now!",
            UNHAPPY = "Why you mad, bro?",
        },
        ANTLIONTRINKET = "Is there any use for this?",
        SANDSPIKE = "That was dangerous!",
        SANDBLOCK = "How did they solidfy?",
        GLASSSPIKE = "That could pierce you to dead.",
        GLASSBLOCK = "I can see my reflection on it.",
        ABIGAIL_FLOWER =
        {
            GENERIC ="A beautiful flower.",
            LEVEL1 = "Hmm?, it changing color.",
			LEVEL2 = "I dunno, it starts to look creepy.",
			LEVEL3 = "Ok, now I'm sure it is haunted.",

			-- deprecated
            -- LONG = "It hurts my soul to look at that thing.",
            -- MEDIUM = "It's giving me the creeps.",
            -- SOON = "Something is up with that flower!",
            -- HAUNTED_POCKET = "I don't think I should hang on to this.",
            -- HAUNTED_GROUND = "I'd die to find out what it does.",
        },

        BALLOONS_EMPTY = "A rubber?",
        BALLOON = "Are those useful for anything but decoration?",

        BERNIE_INACTIVE =
        {
            BROKEN = "Oh the teddy is torn apart.",
            GENERIC = "A teddy bear?",
        },

        BERNIE_ACTIVE = "A doll walking by itself. That's kinda cool.",
        BERNIE_BIG = "Now it looks terrifying.",

        BOOK_BIRDS = "Kiara might love this one.",
        BOOK_TENTACLES = "Probably similiar to the book Ina has.",
        BOOK_GARDENING = "This could have some practical knowledge.",
        BOOK_SLEEP = "Any book could induce sleep by the way.",
        BOOK_BRIMSTONE = "What kind of doomsday novel is this?",

        PLAYER =
        {
            GENERIC = "How's ya doing, %s!",
            ATTACKER = "You wanna fight, %s?",
            MURDERER = "I'll crush you!",
            REVIVER = "%s, friend of ghosts.",
            GHOST = "I could craft a heart for you.",
            FIRESTARTER = "Why did you set those flames, %s.",
        },
        GURA = {
            GENERIC = "Hey, Gura!",
            ATTACKER = "Are you challenging me, Gura?",
            MURDERER = "Come'on Gura! Let's settle the score.",
            REVIVER = "Seems like you still remember me after all...",
            GHOST = "Look like you can't live without me, Gura.",
            FIRESTARTER = "Wait what!? Why did you burn that?",
        },

        -- WILSON =
        -- {
        --     GENERIC = "Hi there %s! and don't touch my watch.",
        --     ATTACKER = "You start to become a nuisance.",
        --     MURDERER = "I will turn you into a history, %s!",
        --     REVIVER = "Nice science you got there, %s.",
        --     GHOST = "Uh, you need a hand?",
        --     FIRESTARTER = "What kind of experiment you are trying to do again?",
        -- },
        -- WOLFGANG =
        -- {
        --     GENERIC = "It's good to see you, %s!",
        --     ATTACKER = "Woah, take it easy big man!",
        --     MURDERER = "Your attack won't land on me!",
        --     REVIVER = "You are a big man with big heart.",
        --     GHOST = "Physical abilities won't always save you.",
        --     FIRESTARTER = "Put that torch down, big man.",
        -- },
        -- WAXWELL =
        -- {
        --     GENERIC = "Good day, mysterious man.",
        --     ATTACKER = "I knew you are fishy, %s.",
        --     MURDERER = "I'll show you Logic and Reason... those're my fists!",
        --     REVIVER = "%s is using his powers for good.",
        --     GHOST = "Don't look at me like that, %s! I'm working on it!",
        --     FIRESTARTER = "%s's just asking to get roasted.",
        -- },
        -- WX78 =
        -- {
        --     GENERIC = "Good day to you, %s!",
        --     ATTACKER = "I think we need to tweak your primary directive, %s...",
        --     MURDERER = "%s! You've violated the first law!",
        --     REVIVER = "I guess %s got that empathy module up and running.",
        --     GHOST = "I always thought %s could use a heart. Now I'm certain!",
        --     FIRESTARTER = "You look like you're gonna melt, %s. What happened?",
        -- },
        -- WILLOW =
        -- {
        --     GENERIC = "Good day to you, %s!",
        --     ATTACKER = "%s is holding that lighter pretty tightly...",
        --     MURDERER = "Murderer! Arsonist!",
        --     REVIVER = "%s, friend of ghosts.",
        --     GHOST = "I bet you're just burning for a heart, %s.",
        --     FIRESTARTER = "Again?",
        -- },
        -- WENDY =
        -- {
        --     GENERIC = "Greetings, %s!",
        --     ATTACKER = "%s doesn't have any sharp objects, does she?",
        --     MURDERER = "Murderer!",
        --     REVIVER = "%s treats ghosts like family.",
        --     GHOST = "I'm seeing double! I'd better concoct a heart for %s.",
        --     FIRESTARTER = "I know you set those flames, %s.",
        -- },
        -- WOODIE =
        -- {
        --     GENERIC = "Greetings, %s!",
        --     ATTACKER = "%s has been a bit of a sap lately...",
        --     MURDERER = "Murderer! Bring me an axe and let's get in the swing of things!",
        --     REVIVER = "%s saved everyone's backbacon.",
        --     GHOST = "Does \"universal\" coverage include the void, %s?",
        --     BEAVER = "%s's gone on a wood chucking rampage!",
        --     BEAVERGHOST = "Will you bea-very mad if I don't revive you, %s?",
        --     MOOSE = "Gad-zooks, that's a moose!",
        --     MOOSEGHOST = "That moose'nt be very comfortable.",
        --     GOOSE = "Take a gander at that!",
        --     GOOSEGHOST = "Be more careful, you silly goose!",
        --     FIRESTARTER = "Don't burn yourself out, %s.",
        -- },
        -- WICKERBOTTOM =
        -- {
        --     GENERIC = "Good day, %s!",
        --     ATTACKER = "I think %s's planning to throw the book at me.",
        --     MURDERER = "Here comes my peer review!",
        --     REVIVER = "I have deep respect for %s's practical theorems.",
        --     GHOST = "This doesn't seem very scientific, does it, %s?",
        --     FIRESTARTER = "I'm sure you had a very clever reason for that fire.",
        -- },
        -- WES =
        -- {
        --     GENERIC = "Greetings, %s!",
        --     ATTACKER = "%s is silent, but deadly...",
        --     MURDERER = "Mime this!",
        --     REVIVER = "%s thinks outside the invisible box.",
        --     GHOST = "How do you say \"I'll get a revival device\" in mime?",
        --     FIRESTARTER = "Wait, don't tell me. You lit a fire.",
        -- },
        -- WEBBER =
        -- {
        --     GENERIC = "Good day, %s!",
        --     ATTACKER = "I'm gonna roll up a papyrus newspaper, just in case.",
        --     MURDERER = "Murderer! I'll squash you, %s!",
        --     REVIVER = "%s is playing well with others.",
        --     GHOST = "%s is really buggin' me for a heart.",
        --     FIRESTARTER = "We need to have a group meeting about fire safety.",
        -- },
        -- WATHGRITHR =
        -- {
        --     GENERIC = "Good day, %s!",
        --     ATTACKER = "I'd like to avoid a punch from %s, if possible.",
        --     MURDERER = "%s's gone berserk!",
        --     REVIVER = "%s has full command of spirits.",
        --     GHOST = "Nice try. You're not escaping to Valhalla yet, %s.",
        --     FIRESTARTER = "%s is really heating things up today.",
        -- },
        -- WINONA =
        -- {
        --     GENERIC = "Good day to you, %s!",
        --     ATTACKER = "%s is a safety hazard.",
        --     MURDERER = "It ends here, %s!",
        --     REVIVER = "You're pretty handy to have around, %s.",
        --     GHOST = "Looks like someone threw a wrench into your plans.",
        --     FIRESTARTER = "Things are burning up at the factory.",
        -- },
        -- WORTOX =
        -- {
        --     GENERIC = "Greetings to you, %s!",
        --     ATTACKER = "I knew %s couldn't be trusted!",
        --     MURDERER = "Time to grab the imp by the horns!",
        --     REVIVER = "Thanks for lending a helping claw, %s.",
        --     GHOST = "I reject the reality of ghosts and imps.",
        --     FIRESTARTER = "%s is becoming a survival liability.",
        -- },
        -- WORMWOOD =
        -- {
        --     GENERIC = "Greetings, %s!",
        --     ATTACKER = "%s seems pricklier than usual today.",
        --     MURDERER = ", %s!",
        --     REVIVER = "Thanks for coming to help, %s.",
        --     GHOST = "You need some help, lil guy?",
        --     FIRESTARTER = "I thought you hated fire, %s.",
        -- },
        -- WARLY =
        -- {
        --     GENERIC = "Greetings, %s!",
        --     ATTACKER = "Well, this is a recipe for disaster.",
        --     MURDERER = "I hope you don't have any half-baked plans to murder me!",
        --     REVIVER = "Always rely on %s to cook up a plan.",
        --     GHOST = "Maybe he was cooking with ghost peppers.",
        --     FIRESTARTER = "He's gonna flambé the place right down!",
        -- },

        -- WURT =
        -- {
        --     GENERIC = "Good day, %s!",
        --     ATTACKER = "%s is looking especially monstrous today...",
        --     MURDERER = "You're just another murderous merm!",
        --     REVIVER = "Why thank you, %s!",
        --     GHOST = "%s is looking greener around the gills than usual.",
        --     FIRESTARTER = "Didn't anyone teach you not to play with fire?!",
        -- },

        -- WALTER =
        -- {
        --     GENERIC = "Hi %s!",
        --     ATTACKER = "That goody-goody finally snapped!",
        --     MURDERER = "Hey %s, let's talk about this...",
        --     REVIVER = "Alright, I'm sorry for calling you a goody-goody.",
        --     GHOST = "I think he's actually having fun.",
        --     FIRESTARTER = "Who \"doesn't know fire safety\" NOW, %s?",
        -- },

--fallback to speech_wilson.lua         MIGRATION_PORTAL =
--fallback to speech_wilson.lua         {
--fallback to speech_wilson.lua             GENERIC = "If I had any friends, this could take me to them.",
--fallback to speech_wilson.lua             OPEN = "If I step through, will I still be me?",
--fallback to speech_wilson.lua             FULL = "It seems to be popular over there.",
--fallback to speech_wilson.lua         },
        GLOMMER = 
        {
            GENERIC = "It looks cute... I guess?",
            SLEEPING = "It looks really cute while sleeping.",
        },
        GLOMMERFLOWER =
        {
            GENERIC = "Look like that flower in amazon.",
            DEAD = "So the Glommer's life was connecting to this flower.",
        },
        GLOMMERWINGS = "A rare insect wings.",
        GLOMMERFUEL = "I don't wanna touch that.",
        BELL = "I should try ringing this at someone house, heh heh.",
        STATUEGLOMMER =
        {
            GENERIC = "Just wait for full moon, you will see.",
            EMPTY = "The flower should still grow there.",
        },

        LAVA_POND_ROCK = "Just some very hot rocks.",

		WEBBERSKULL = "Better bury it, cuz it's UGLY!",
		WORMLIGHT = "What kind of chemical make it glows I wonder?",
		WORMLIGHT_LESSER = "Still usable as a light source.",
		WORM =
		{
		    PLANT = "I would suspect any glow plant if I were you.",
		    DIRT = "That looks different from moleworm's.",
		    WORM = "I knew it! The depth worm!",
		},
        WORMLIGHT_PLANT = "I would suspect any glow plant if I were you.",
		MOLE =
		{
			HELD = "You are at my mercy now!",
			UNDERGROUND = "Try bait them with some minerals.",
			ABOVEGROUND = "Just whack that mole with a hammer.",
		},
		MOLEHILL = "A home for those moleworm.",
		MOLEHAT = "Practical, but it hurts my eyes.",

		EEL = "So slippery, it's hard to grab.",  
		EEL_COOKED = "This should taste good with some salty sauce!",
		UNAGI = "Almost like what I ate in sushi restarant.",
		EYETURRET = "Are we tower defense now?", 
		EYETURRET_ITEM = "Maybe I could abuse this.",
		MINOTAURHORN = "That's really a big horn.", 
		MINOTAURCHEST = "This is the oldest kind of gacha I ever know.",
		THULECITE_PIECES = "We can combine these into Thulecite somewhere.", 
		POND_ALGAE = "Just some plant we could not use.",
		GREENSTAFF = "We could abuse rare equipment with this!",
		GIFT = "A loot box!!",
        GIFTWRAP = "Let's wrap thing up!",
		POTTEDFERN = "I could make a greenhouse with this.",
        SUCCULENT_POTTED = "A plant in a pot.",
		SUCCULENT_PLANT = "We could only found this in summer.",
		SUCCULENT_PICKED = "Try plant these in a pot.",
		SENTRYWARD = "It's as same as a security camera!",
        TOWNPORTAL =
        {
			GENERIC = "This could make traveling much faster.",
			ACTIVE = "I hope the one on the other side do their job.",
		},
        TOWNPORTALTALISMAN = 
        {
			GENERIC = "We can craft teleporter thingy with this!",
			ACTIVE = "Much convenience than walking.",
		},
        WETPAPER = "Paper won't look the same even if you dry it.",
        WETPOUCH = "This SUCK! Everything inside already wet.", 
        MOONROCK_PIECES = "How's this thing pertified?",
        MOONBASE =
        {
            GENERIC = "A hint. Try putting something related to star in there.",
            BROKEN = "We need to repair it with a similiar material!",
            STAFFED = "Everyone, get in positions!",
            WRONGSTAFF = "Seems like it's not the correct one.",
            MOONSTAFF = "It starts getting chill around here.",
        },
        MOONDIAL = 
        {
			GENERIC = "I never saw a moondial using water.",
			NIGHT_NEW = "It's a new moon already.",
			NIGHT_WAX = "The moon is waxing.",
			NIGHT_FULL = "It's a full moon.",
			NIGHT_WANE = "The moon is waning.",
			CAVE = "This is useless down here.",
--fallback to speech_wilson.lua 			WEREBEAVER = "only_used_by_woodie", --woodie specific
        },
		THULECITE = "Which era is this come from again?",
		ARMORRUINS = "I could feel the history just by wearing it.",
		ARMORSKELETON = "I'm now INVINCIBLE! Hahaha.",
		SKELETONHAT = "This is good helmet, with a little price to pay.",
		RUINS_BAT = "I think I saw this somewhere in old southern America.",
		RUINSHAT = "An ancient artifact with a futuristic function.",
		NIGHTMARE_TIMEPIECE =
		{
            CALM = "Nothing happens.. yet.",
            WARN = "I could feel a disturbance via this.",
            WAXING = "The nightmare is COMING!",
            STEADY = "It seems to be staying steady.",
            WANING = "Feels like it's receding.",
            DAWN = "The nightmare is almost gone!",
            NOMAGIC = "No reaction at all.",
		},
		BISHOP_NIGHTMARE = "It's falling apart!",
		ROOK_NIGHTMARE = "Terrifying!",
		KNIGHT_NIGHTMARE = "It's a knightmare!",
		MINOTAUR = "That thing doesn't look happy.",
		SPIDER_DROPPER = "Just don't look up.",
		NIGHTMARELIGHT = "I wonder what function this served.",
		NIGHTSTICK = "It's electric!",
		GREENGEM = "It's green and gemmy.",
		MULTITOOL_AXE_PICKAXE = "It's brilliant!",
		ORANGESTAFF = "This beats walking.",
		YELLOWAMULET = "Warm to the touch.",
		GREENAMULET = "No base should be without one!",
		SLURPERPELT = "Doesn't look all that much different dead.",	

		SLURPER = "Another specie of SUCKER!",
		SLURPER_PELT = "Stay dead, you sucker!",
		ARMORSLURPER = "Weird. This make me full instead of hungry.",
		ORANGEAMULET = "This is useful, but I have enough of this hallucination.",
		YELLOWSTAFF = "How's that make a little star appears I wonder.",
		YELLOWGEM = "The same color as mine!",
		ORANGEGEM = "The sharp corner make it hards to carry around.",
        OPALSTAFF = "I can summon a beautiful polar light with this.",
        OPALPRECIOUSGEM = "This gem seems special.",
        TELEBASE = 
		{
			VALID = "It's ready to go.",
			GEMS = "It needs more purple gems.",
		},
		GEMSOCKET = 
		{
			VALID = "Looks ready.",
			GEMS = "It needs a gem.",
		},
		STAFFLIGHT = "This is warm and comfortable..",
        STAFFCOLDLIGHT = "The is pretty and cool!",

        ANCIENT_ALTAR = "An ancient and mysterious structure.",

        ANCIENT_ALTAR_BROKEN = "This seems to be broken.",

        ANCIENT_STATUE = "It seems to throb out of tune with the world.",

        LICHEN = "That's look gross!",
		CUTLICHEN = "Better use this as a rot.",

		CAVE_BANANA = "I need potassium to balance out sometime.",
		CAVE_BANANA_COOKED = "Look tasty!",
		CAVE_BANANA_TREE = "How can it grows without light I wonder.",
		ROCKY = "They look UGLY!.",
		
		COMPASS =
		{
			GENERIC="Which way am I facing?",
			N = "North.",
			S = "South.",
			E = "East.",
			W = "West.",
			NE = "Northeast.",
			SE = "Southeast.",
			NW = "Northwest.",
			SW = "Southwest.",
		},

        HOUNDSTOOTH = "...I don't feel comfortable with this.",
        ARMORSNURTLESHELL = "It sticks to your back when you wear it.",
        BAT = "This monster's a SUCKER! Literally!",
        BATBAT = "Cool! I can gain health by slapping someone with this.",
        BATWING = "Haha! You SUCK!",
        BATWING_COOKED = "At least it's not coming back.",
        BATCAVE = "I have enough of these.",
        BEDROLL_FURRY = "It's so warm and comfy.",
        BUNNYMAN = "Isn't bunny suppose to look cute?",
        FLOWER_CAVE = "That looks lovely.",
        GUANO = "Stinky!",
        LANTERN = "A must for explorer!",
        LIGHTBULB = "A biological light.",
        MANRABBIT_TAIL = "Let's make a comfy bed with this.",
        MUSHROOMHAT = "Are you sure it won't grow on my head?",
        MUSHROOM_LIGHT2 =
        {
            ON = "Nice color.",
            OFF = "Look like shrooms than another version.",
            BURNT = "Such a waste.",
        },
        MUSHROOM_LIGHT =
        {
            ON = "I can't explain why it light up.",
            OFF = "A shroom for the room.",
            BURNT = "There it goes.",
        },
        SLEEPBOMB = "The second best way to knockdown people, hehehe.",
        MUSHROOMBOMB = "Watch out for the mushroom cloud!",
        SHROOM_SKIN = "I refuse touching that!",
        TOADSTOOL_CAP =
        {
            EMPTY = "Just a hole in the ground.",
            INGROUND = "I see something weird there.",
            GENERIC = "A toadstool, huh?",
        },
        TOADSTOOL =
        {
            GENERIC = "This guy looks soooo UGLY! Let's KILL it!",
            RAGE = "STOP GETTING MAD!",
        },
        MUSHROOMSPROUT =
        {
            GENERIC = "The mushrooms are multiplying!",
            BURNT = "That's right! Burn it down.",
        },
        MUSHTREE_TALL =
        {
            GENERIC = "Gross. This tree is sick all over.",
            BLOOM = "Ack! It stinks!",
        },
        MUSHTREE_MEDIUM =
        {
            GENERIC = "Gross. It smells like leprechaun butt.",
            BLOOM = "It's spreading junk everywhere.",
        },
        MUSHTREE_SMALL =
        {
            GENERIC = "Gross. It's all mushroomy.",
            BLOOM = "Ew, I don't want to get too close.",
        },
        MUSHTREE_TALL_WEBBED = "The spiders thought this one was important.",
        SPORE_TALL =
        {
            GENERIC = "It's just drifting around.",
            HELD = "I'll keep a little light in my pocket.",
        },
        SPORE_MEDIUM =
        {
            GENERIC = "Hasn't a care in the world.",
            HELD = "I'll keep a little light in my pocket.",
        },
        SPORE_SMALL =
        {
            GENERIC = "That's a sight for spore eyes.",
            HELD = "I'll keep a little light in my pocket.",
        },
        RABBITHOUSE =
        {
            GENERIC = "Where did they find a carrot this BIG?",
            BURNT = "Now you sleep on the floor, bunnies.",
        },
        SLURTLE = "Ew. Just ew.",
        SLURTLE_SHELLPIECES = "A puzzle with no solution.",
        SLURTLEHAT = "That would mess up my hair.",
        SLURTLEHOLE = "A den of \"ew\".",
        SLURTLESLIME = "If it wasn't useful, I wouldn't touch it.",
        SNURTLE = "He's less gross, but still gross.",
        SPIDER_HIDER = "STOP BOTHERING ME!",
        SPIDER_SPITTER = "I HATE spiders!",
        SPIDERHOLE = "It's encrusted with old webbing.",
        SPIDERHOLE_ROCK = "It's encrusted with old webbing.",
        STALAGMITE = "Just another SPIKEY rock.",
        STALAGMITE_TALL = "Oh look! Another rock. How's exciting!",

        TURF_CARPETFLOOR = "It's surprisingly scratchy.",
        TURF_CHECKERFLOOR = "These are pretty snazzy.",
        TURF_DIRT = "A chunk of ground.",
        TURF_FOREST = "A chunk of ground.",
        TURF_GRASS = "A chunk of ground.",
        TURF_MARSH = "A chunk of ground.",
        TURF_METEOR = "A chunk of moon ground.",
        TURF_PEBBLEBEACH = "A chunk of beach.",
        TURF_ROAD = "Hastily cobbled stones.",
        TURF_ROCKY = "A chunk of ground.",
        TURF_SAVANNA = "A chunk of ground.",
        TURF_WOODFLOOR = "These are floorboards.",

		TURF_CAVE="Yet another ground type.",
		TURF_FUNGUS="Yet another ground type.",
        TURF_FUNGUS_MOON = "Yet another ground type.",
		TURF_ARCHIVE = "Yet another ground type.",
		TURF_SINKHOLE="Yet another ground type.",
		TURF_UNDERROCK="Yet another ground type.",
		TURF_MUD="Yet another ground type.",

		TURF_DECIDUOUS = "Yet another ground type.",
		TURF_SANDY = "Yet another ground type.",
		TURF_BADLANDS = "Yet another ground type.",
		TURF_DESERTDIRT = "A chunk of ground.",
		TURF_FUNGUS_GREEN = "A chunk of ground.",
		TURF_FUNGUS_RED = "A chunk of ground.",
		TURF_DRAGONFLY = "Fireproof ground is always good to have.",

		POWCAKE = "This thing last 10,000 times longer than ur mom.",
        CAVE_ENTRANCE = "An entrance to the next level.",
        CAVE_ENTRANCE_RUINS = "Better be prepared.",
       
       	CAVE_ENTRANCE_OPEN = 
        {
            GENERIC = "Let's try open it up.",
            OPEN = "A new adventure await.",
            FULL = "I'll have to wait until someone leaves to enter.",
        },
        CAVE_EXIT = 
        {
            GENERIC = "I guess I will continue exploring for a while.",
            OPEN = "I need some fresh air!",
            FULL = "The surface is too crowded!",
        },

		MAXWELLPHONOGRAPH = "Is that dapper daddy's BGM?",
		BOOMERANG = "I wish I can get a hand on a gun instead.",
		PIGGUARD = "Are these guys taking bath at all?",
		ABIGAIL = "Awww, what a cute ghost.",
		ADVENTURE_PORTAL = "I'm not sure I want to fall for that a second time.",
		AMULET = "An extra life.",
		ANIMAL_TRACK = "The large prey is nearby!",
		ARMORGRASS = "It feels itchy, I HATE it!",
		ARMORMARBLE = "I hate to slow down myself.",
		ARMORWOOD = "The best kind of armor I could get now.",
		ARMOR_SANITY = "This make me look wayyy too EDGY!",
		ASH =
		{
			GENERIC = "Now it turned into a dust.",
			REMAINS_GLOMMERFLOWER = "The flower was consumed by fire in the teleportation!",
			REMAINS_EYE_BONE = "The eyebone was consumed by fire in the teleportation!",
			REMAINS_THINGIE = "There could be an explanation for that.",
		},
		AXE = "A trusty axe.",
		BABYBEEFALO = 
		{
			GENERIC = "Awwww. So cute!",
		    SLEEPING = "Sweet dreams, smelly.",
        },
        BUNDLE = "Our supplies are in there!",
        BUNDLEWRAP = "Wrapping things up should make them easier to carry.",
		BACKPACK = "I can hoard more items!",
		BACONEGGS = "Bacon is TASTY!",
		BANDAGE = "Seems sterile enough.",
		BASALT = "That's too strong to break through!",
		BEARDHAIR = "It's only gross when they're not your own.",
		BEARGER = "That bear is sooooo BIG!",
		BEARGERVEST = "Welcome to the hibernation station!",
		ICEPACK = "Feel like carrying a whole refrigerator on my back.",
		BEARGER_FUR = "A mat of thick fur.",
		BEDROLL_STRAW = "How is that different from sleeping on the grass?",
		BEEQUEEN = "You can't escape my groundpound even in the air!",
		BEEQUEENHIVE = 
		{
			GENERIC = "It's too sticky to walk on.",
			GROWING = "Was that there before?",
		},
        BEEQUEENHIVEGROWN = "How did it get so big?!",
        BEEGUARD = "It's guarding the queen.",
        HIVEHAT = "I don't feel like my usual self when I wear it.",
        MINISIGN =
        {
            GENERIC = "I could draw better than that!",
            UNDRAWN = "We should draw something on there.",
        },
        MINISIGN_ITEM = "It's not much use like this. We should place it.",
		BEE =
		{
			GENERIC = "Their buzzing sound is annoying.",
			HELD = "Better store it somewhere or just end it",
		},
		BEEBOX =
		{
			READY = "It's full of honey.",
			FULLHONEY = "It's full of honey.",
			GENERIC = "Put these annoying bugs into use.",
			NOHONEY = "It's empty.",
			SOMEHONEY = "Need to wait a bit.",
			BURNT = "How did it get burned?!!",
		},
		MUSHROOM_FARM =
		{
			STUFFED = "That's a lot of mushrooms!",
			LOTS = "The mushrooms have really taken to the log.",
			SOME = "It should keep growing now.",
			EMPTY = "It could use a spore. Or a mushroom transplant.",
			ROTTEN = "The log is dead. We should replace it with a live one.",
			BURNT = "Well, it's done for.",
			SNOWCOVERED = "I don't think it can grow in this cold.",
		},
		BEEFALO =
		{
			FOLLOWER = "Oh, he's following me!",
			GENERIC = "Careful not to aggro them.",
			NAKED = "I'm so sooooorry, but I NEED these wools.",
			SLEEPING = "Shhhh, they are sleeping.",
            --Domesticated states:
            DOMESTICATED = "This one looks tamed than the others.",
            ORNERY = "It looks so pissed off.",
            RIDER = "This fellow appears quite ridable.",
            PUDGY = "I might fed him too much.",
		},

		BEEFALOHAT = "That's a case of hat-hair waiting to happen.",
		BEEFALOWOOL = "It smells like beefalo tears.",
		BEEHAT = "Protects your skin, but squashes your meticulous coiffure.",
        BEESWAX = "Beeswax is a good preservative.",
		BEEHIVE = "It's buzzing with activity.",
		BEEMINE = "It buzzes when shaken.",
		BEEMINE_MAXWELL = "Bottled mosquito rage!",
		BERRIES = "I gonna need a lot of these to fill my stomach.",
		BERRIES_COOKED = "Still not that filling to me.",
        BERRIES_JUICY = "Much more tasty, but they won't last long.",
        BERRIES_JUICY_COOKED = "Better eat them early!",
		BERRYBUSH =
		{
			BARREN = "I think it needs to be fertilized.",
			WITHERED = "Nothing will grow in this heat.",
			GENERIC = "Better than nothing, I guess.",
			PICKED = "Let's do something else while waiting.",
			DISEASED = "It looks pretty sick.",
			DISEASING = "Err, something's not right.",
			BURNING = "What a WASTE!",
		},
		BERRYBUSH_JUICY =
		{
			BARREN = "It won't make any berries in this state.",
			WITHERED = "Would be nice if I can have them in summer.",
			GENERIC = "Better leave them there until I want to eat.",
			PICKED = "Come'on! I NEED MORE!",
			DISEASED = "It looks pretty sick.",
			DISEASING = "Err, something's not right.",
			BURNING = "What a WASTE!",
		},
		BIGFOOT = "That is one biiig foot.",
		BIRDCAGE =
		{
			GENERIC = "I know how to take care a pet.",
			OCCUPIED = "Whatever, just don't take my eggs.",
			SLEEPING = "Grr, it won't take food at this time.",
			HUNGRY = "It's time to feed.",
			STARVING = "I almost forgot to feed it.",
			DEAD = "Oh shoot, I forgot to feed it!",
			SKELETON = "Time to clean the cage...",
		},
		BIRDTRAP = "This will trap them for some GOOD stuffs!",
		CAVE_BANANA_BURNT = "Not my fault!",
		BIRD_EGG = "Just an egg.",
		BIRD_EGG_COOKED = "Nice for breakfast!",
		BISHOP = "Back off, preacherman!",
		BLOWDART_FIRE = "I can burn something, unnoticed.",
		BLOWDART_SLEEP = "Hehehe, they won't know what hit them.",
		BLOWDART_PIPE = "Is this the best ranged weapon you can get?",
		BLOWDART_YELLOW = "It has shocking accuracy.",
		BLUEAMULET = "Cool as ice!",
		BLUEGEM = "It sparkles with cold energy.",
		BLUEPRINT = 
		{ 
            COMMON = "Interesting...",
            RARE = "Very interesting.",
        },
        SKETCH = "A picture of a sculpture. We'll need somewhere to make it.",
		BLUE_CAP = "This is the most nutritious form of mushroom.",
		BLUE_CAP_COOKED = "This helps reduce some stress when eaten.",
		BLUE_MUSHROOM =
		{
			GENERIC = "Pick them while you can.",
			INGROUND = "Wrong time of the day for picking.",
			PICKED = "Mushroom won't grow back until the rain.",
		},
		BOARDS = "These boards are as flat as.. ah, nothing.",
		BONESHARD = "Some spooky bones.",
		BONESTEW = "I can't eat the bone through...",
		BUGNET = "The only method to catch those bugs.",
		BUSHHAT = "I can ambush someone with this, hehehe.",
		BUTTER = "A butter? Lucky!",
		BUTTERFLY =
		{
			GENERIC = "Oh, I flying flower.",
			HELD = "Now I have you!",
		},
		BUTTERFLYMUFFIN = "Putting butterfly into something turned it into a muffin.",
		BUTTERFLYWINGS = "Without these, it's just a butter.",
		BUZZARD = "Get away from my food!",

		SHADOWDIGGER = "Oh good. Now there's more of him.",

		CACTUS = 
		{
			GENERIC = "The taste might worth the pain.",
			PICKED = "I'll come back later.",
		},
		CACTUS_MEAT_COOKED = "Grilled fruit of the desert.",
		CACTUS_MEAT = "Make sure there are no spine left.",
		CACTUS_FLOWER = "A pretty flower from a prickly plant.",

		COLDFIRE =
		{
			EMBERS = "That fire needs more fuel or it's going to go out.",
			GENERIC = "This look nice in the darkness.",
			HIGH = "Too much fuel!",
			LOW = "The fire's getting a bit low.",
			NORMAL = "Nice and comfy.",
			OUT = "Well, that's over.",
		},
		CAMPFIRE =
		{
			EMBERS = "That fire needs more fuel or it's going to go out.",
			GENERIC = "This look nice in the darkness.",
			HIGH = "Too much fuel!",
			LOW = "The fire's getting a bit low.",
			NORMAL = "Nice and comfy.",
			OUT = "Well, that's over.",
		},
		CANE = "I can zoom faster with this!",
		CATCOON = "A playful little thing.",
		CATCOONDEN = 
		{
			GENERIC = "It's a den in a stump.",
			EMPTY = "Its owner ran out of lives.",
		},
		CATCOONHAT = "Ears hat!",
		COONTAIL = "I think it's still swishing.",
		CARROT = "Yuck. This vegetable came out of the dirt.",
		CARROT_COOKED = "Mushy.",
		CARROT_PLANTED = "The earth is making plantbabies.",
		CARROT_SEEDS = "It's a carrot seed.",
		CARTOGRAPHYDESK =
		{
			GENERIC = "Now I can share info with everyone.",
			BURNING = "So much for that.",
			BURNT = "Nothing but ash now.",
		},
		WATERMELON_SEEDS = "It's a melon seed.",
		CAVE_FERN = "It's a fern.",
		CHARCOAL = "It's small, dark, and smells like burnt wood.",
        CHESSPIECE_PAWN = "I can relate.",
        CHESSPIECE_ROOK =
        {
            GENERIC = "It's even heavier than it looks.",
            STRUGGLE = "The chess pieces are moving themselves!",
        },
        CHESSPIECE_KNIGHT =
        {
            GENERIC = "It's a horse, of course.",
            STRUGGLE = "The chess pieces are moving themselves!",
        },
        CHESSPIECE_BISHOP =
        {
            GENERIC = "It's a stone bishop.",
            STRUGGLE = "The chess pieces are moving themselves!",
        },
        CHESSPIECE_MUSE = "Hmm... Looks familiar.",
        CHESSPIECE_FORMAL = "Doesn't seem very \"kingly\" to me.",
        CHESSPIECE_HORNUCOPIA = "Makes my stomach rumble just looking at it.",
        CHESSPIECE_PIPE = "That was never really my thing.",
        CHESSPIECE_DEERCLOPS = "It feels like its eye follows you.",
        CHESSPIECE_BEARGER = "It was a lot bigger up close.",
        CHESSPIECE_MOOSEGOOSE =
        {
            "Eurgh. It's so lifelike.",
        },
        CHESSPIECE_DRAGONFLY = "I think... I think I understand art.",
		CHESSPIECE_MINOTAUR = "Remind me of that big bad beast.",
        CHESSPIECE_BUTTERFLY = "Pertifued flying flower.",
        CHESSPIECE_ANCHOR = "I think we can just use them as anchor like this.",
        CHESSPIECE_MOON = "I guess it's nice.",
        CHESSPIECE_CARRAT = "Now all I can think of is roasted carrots.",
        CHESSPIECE_MALBATROSS = "She was a pretty tough old bird.",
        CHESSPIECE_CRABKING = "Was the treasure worth it?",
        CHESSPIECE_TOADSTOOL = "What are you looking at?",
        CHESSPIECE_STALKER = "Not so tough now, are you?",
        CHESSPIECE_KLAUS = "Haha, you can't get me now.",
        CHESSPIECE_BEEQUEEN = "Took the sting out of her stinger.",
        CHESSPIECE_ANTLION = "Can't shake anything up like that.",
        CHESSJUNK1 = "Dead windup horsey.",
        CHESSJUNK2 = "Dead windup priest.",
        CHESSJUNK3 = "Dead windup castle.",
		CHESTER = "He's so fuzzy!",		
        CHESTER_EYEBONE =
		{
			GENERIC = "It's looking at me.",
			WAITING = "It went to sleep.",
		},
		COOKEDMANDRAKE = "Poor little guy.",
		COOKEDMEAT = "A properly grilled meat is nice.",
		COOKEDMONSTERMEAT = "Still too DISGUSTING to eat!",
		COOKEDSMALLMEAT = "Nothing sate my appretite than a piece of meat.",
		COOKPOT =
		{
			COOKING_LONG = "This is going to take a while.",
			COOKING_SHORT = "It's almost done!",
			DONE = "The meal is ready!",
			EMPTY = "Just put something edible in it.",
			BURNT = "The pot got wasted.",
		},
		CORN = "Lets cook some popcorn with this!",
		CORN_COOKED = "Grilled corn is good too!",
		CORN_SEEDS = "It's a corn seed.",
        CANARY =
		{
			GENERIC = "Some sort of bird.",
			HELD = "I'm not squishing you, am I?",
		},
        CANARY_POISONED = "It's probably fine.",

		CRITTERLAB = "Oh? Something hiding in here!",   
        CRITTER_GLOMLING = "Look much CUTE than the adult!",
        CRITTER_DRAGONLING = "I dunno, its eyes are too big.",
		CRITTER_LAMB = "So this is what Watamate look like.",
        CRITTER_PUPPY = "Try to get alongs with Bubba, ok?",
        CRITTER_KITTEN = "Why this is called kitty, when it is a raccoon?",
        CRITTER_PERDLING = "Is this some kind of chick?",
		CRITTER_LUNARMOTHLING = "Are you a bird or butterfly?",

		CROW =
		{
			GENERIC = "Creepy!",
			HELD = "He's not very happy in there.",
		},
		CUTGRASS = "Haha, KUSA!",
		CUTREEDS = "An advanced tier kusa.",
		CUTSTONE = "This look really smooth and clean.",
		DEADLYFEAST = "A most potent dish.",
		DEER =
		{
			GENERIC = "It always runs away from me. I HATE IT!",
			ANTLER = "Don't think that horn makes you special, deer.",
		},
        DEER_ANTLER = "Was that supposed to come off?",
        DEER_GEMMED = "Gimme that GEM!",
		DEERCLOPS = "It's enormous!!",
		DEERCLOPS_EYEBALL = "This is really GROSS!",
		EYEBRELLAHAT =	"Why do this thing needs an eye in the first place?",
		DEPLETED_GRASS =
		{
			GENERIC = "Regrows faster, you lazy grass!",
		},
        GOGGLESHAT = "This might protects my eyes from sand or something.",
        DESERTHAT = "Quality eye protection.",
		-- DEVTOOL = "It smells of bacon!",
		-- DEVTOOL_NODEV = "I'm not strong enough to wield it.",
		DIRTPILE = "Who just leaves dirt lying around?",
        DIVININGROD =
		{
			COLD = "It's making some kind of noise.",
			GENERIC = "It's full of electrical junk.",
			HOT = "Gah! Enough with the beeping!",
			WARM = "This thing is getting noisier.",
			WARMER = "Must be close!",
		},
		DIVININGRODBASE =
		{
			GENERIC = "Not sure what this does. Doesn't seem like it's fiery things.",
			READY = "Just needs to be unlocked with a key. Not fire, unfortunately.",
			UNLOCKED = "It's whirring now!",
		},
		DIVININGRODSTART = "I'll make something out of it.",
		DRAGONFLY = "It's filled with fire!",
		ARMORDRAGONFLY = "A high grade fireproof armor!",
		DRAGON_SCALES = "Oooooooh! It's shiny!",
		DRAGONFLYCHEST = "Keep things safe from those fiery dogs and dragons.",
		DRAGONFLYFURNACE = 
		{
			HAMMERED = "Is that usable?",
			GENERIC = "Let's try turn it back on.", --no gems
			NORMAL = "Try put another gem in there.", --one gem
			HIGH = "This is getting too hot.", --two gems
		},
        
        HUTCH = "Some weird walking fish FOLLOWING ME!",
        HUTCH_FISHBOWL =
        {
            GENERIC = "I like to watch fish in the container.",
            WAITING = "You good, fish?",
        },
		LAVASPIT = 
		{
			HOT = "A hot drool!",
			COOL = "Cool drool, literally.",
		},
		LAVA_POND = "I don't want to get near that, It's too HOT!",
		LAVAE = "That's kind look cute.",
		LAVAE_COCOON = "Is it turning to that flying creature?",
		LAVAE_PET = 
		{
			STARVING = "I can see her ribs!",
			HUNGRY = "What does she eat again?",
			CONTENT = "Look like she is happy!",
			GENERIC = "Cute little fiery bug.",
		},
		LAVAE_EGG = 
		{
			GENERIC = "I think a fire is trying to escape.",
		},
		LAVAE_EGG_CRACKED =
		{
			COLD = "It has a chill.",
			COMFY = "That egg looks happy.",
		},
		LAVAE_TOOTH = "I hope she's not a biter.",

		DRAGONFRUIT = "This is health kind of fruit!",
		DRAGONFRUIT_COOKED = "Why do anyone want to eat a hot fruit?",
		DRAGONFRUIT_SEEDS = "Some seeds.",
		DRAGONPIE = "This is delicious!",
		DRUMSTICK = "Bang on the drum all day!",
		DRUMSTICK_COOKED = "Hmm... Satisfy hunger, or bang on the drum?",
		DUG_BERRYBUSH = "What's the matter, got no dirt?",
		DUG_BERRYBUSH_JUICY = "What's the matter, got no dirt?",
		DUG_GRASS = "What's the matter, got no dirt?",
		DUG_MARSH_BUSH = "What's the matter, got no dirt?",
		DUG_SAPLING = "What's the matter, got no dirt?",
		DURIAN = "Ew, stinky!",
		DURIAN_COOKED = "Yuck, it smells just as bad cooked!",
		DURIAN_SEEDS = "Some seeds.",
		EARMUFFSHAT = "Smells like rabbit butt.",
		EGGPLANT = "Definitely not a bird.",
		EGGPLANT_COOKED = "Grilled eggplant is nice too.",
		EGGPLANT_SEEDS = "Some seeds.",
		
		ENDTABLE = 
		{
			BURNT = "Oh, now I know those hands weren't here.",
			GENERIC = "We could decorate this with flowers.",
			EMPTY = "I'm still not sure if monsterhand is still there, nor I want to check it.",
			WILTED = "Those need replacing.",
			FRESHLIGHT = "At least we won't be in the dark.",
			OLDLIGHT = "We're gonna be in the dark soon.", -- will be wilted soon, light radius will be very small at this point
		},
		DECIDUOUSTREE = 
		{
			BURNING = "Just don't let fire spread to the base!",
			BURNT = "Some charcoal would be handy.",
			CHOPPED = "Let's stockpile some more woods..",
			POISON = "Keep your eyes on those tentacles.",
			GENERIC = "These trees look beautiful in autumn.",
		},
		ACORN = "Hey there, tree seed.",
        ACORN_SAPLING = "You'll be a real tree soon.",
		ACORN_COOKED = "Looks like you won't become a tree after all.",
		BIRCHNUTDRAKE = "You CREEPY little S**T!",
		EVERGREEN =
		{
			BURNING = "Just don't let fire spread to the base!",
			BURNT = "Some charcoal would be handy.",
			CHOPPED = "Let's stockpile some more woods..",
			GENERIC = "Looks like a nice tree to chop down.",
		},
		EVERGREEN_SPARSE =
		{
			BURNING = "Just don't let fire spread to the base!",
			BURNT = "Some charcoal would be handy.",
			CHOPPED = "Let's stockpile some more woods..",
			GENERIC = "Looks like a nice tree to chop down.",
		},
		TWIGGYTREE = 
		{
			BURNING = "Just don't let fire spread to the base!",
			BURNT = "Some charcoal would be handy.",
			CHOPPED = "Let's stockpile some more woods..",
			GENERIC = "How are you supposed to get the sticks from up there??",			
			DISEASED = "Burn the sick!",
		},
		TWIGGY_NUT_SAPLING = "Grow faster!",
        TWIGGY_OLD = "Let's chop it down to clear the space.",
		TWIGGY_NUT = "How about we make twig farm?",
		EYEPLANT = "They are multiplying!",
		INSPECTSELF = "Detective Amelia Watson at your service!",
		FARMPLOT =
		{
			GENERIC = "Sigh. It's a pile of dirt.",
			GROWING = "Hurry up, dirtpile. Feed me!",
			NEEDSFERTILIZER = "Stupid thing needs poop.",
			BURNT = "All those works are gone in the fire.",
		},
		FEATHERHAT = "Look like a phoenix feather!",                       
		FEATHER_CROW = "Black bird feather.",
		FEATHER_ROBIN = "Redbird feather.",
		FEATHER_ROBIN_WINTER = "Snowbird feather.",
		FEATHER_CANARY = "Canary feather.",
		FEATHERPENCIL = "Do people still writing with this?",
        COOKBOOK = "I don't need this. I can memorize all recipes!",
		FEM_PUPPET = "She looks scared half to death.",
		FIREFLIES =
		{
			GENERIC = "I wish they didn't run away!",
			HELD = "They're like little fires in my pocket!",
		},
		FIREHOUND = "STAY AWAY FROM MY BASE!",
		FIREPIT =
		{
			EMBERS = "Uh oh. It's almost gone!",
			GENERIC = "We are safe from darkness for now.",
			HIGH = "This might getting too dangerous.",
			LOW = "We might want to add some fuel soon.",
			NORMAL = "Warm and cozy.",
			OUT = "Put some fuel in it!",
		},
		COLDFIREPIT =
		{
			EMBERS = "Uh oh. It's almost gone!",
			GENERIC = "We are safe from darkness for now.",
			HIGH = "This might getting too dangerous.",
			LOW = "We might want to add some fuel soon.",
			NORMAL = "Warm and cozy.",
			OUT = "Put some fuel in it!",
		},
		FIRESTAFF = "Now I can use some magic!",
		FIRESUPPRESSOR = 
		{	
			ON = "Nice job putting out the fires.", 
			OFF = "No fire for now.",
			LOWFUEL = "Almost out.",
		},

		FISH = "Slippery fishy!",
		FISHINGROD = "Fishing for the answer with a hook, line and sinker.",
		FISHSTICKS = "What you see is what you get. Sticks of fish.",
		FISHTACOS = "Convenient taco-grip.",
		FISH_COOKED = "The smell are much better than raw.",
		FLINT = "This unusual rock can breaks so many things.",
		FLOWER = 
		{
            GENERIC = "These flowers are more useful than just being pretty.",
            ROSE = "Watch out for the thorns.",
        },
        FLOWER_WITHERED = "Looks like good kindling.",
		FLOWERHAT = "A halo of flowers. Too bad it's not a burning halo of flowers.",
		FLOWER_EVIL = "Ugh, that smells terrible.",
		FOLIAGE = "Fuel for the fire.",
		FOOTBALLHAT = "Sports are hard.",
        FOSSIL_PIECE = "Some prehistoric spooky bones!",
        FOSSIL_STALKER =
        {
			GENERIC = "We need to find more pieces.",
			FUNNY = "Look like we are doing it wrong.",
			COMPLETE = "Andddd it's done.",
        },
        STALKER = "I brought you back so I could beat you up!",
        STALKER_ATRIUM = "It's just bones and shadow.",
        STALKER_MINION = "Yuck, it's barely even alive.",
        THURIBLE = "It smells like burnt hair!",
        ATRIUM_OVERGROWTH = "I never saw this language before.",
		FROG =
		{
			DEAD = "Wrecked.",
			GENERIC = "Better use trap for this.",
			SLEEPING = "Weird snoring.",
		},
		FROGGLEBUNWICH = "At least the leg is hidden inside the bun now.",
		FROGLEGS = "Don't make me eat that thing.",
		FROGLEGS_COOKED = "I still don't want to eat that...",
		FRUITMEDLEY = "Yum, fruit!",
		FURTUFT = "Black and white and fuzzy all over!", 
		GEARS = "We can make some interesting machines with this!",
		GHOST = "You can't kill what's already dead.",
		GOLDENAXE = "A luxury tool for chopping tree.",
		GOLDENPICKAXE = "A luxury tool for breaking rocks and finding diamonds.",
		GOLDENPITCHFORK = "A luxury tool for farming and witch hunting.",
		GOLDENSHOVEL = "A luxury tool for digging and hiding evidences.",
		GOLDNUGGET = "What should we spend it on??",
		GRASS =
		{
			BARREN = "It needs poop.",
			WITHERED = "Make me feel even hotter by just looking at it.",
			BURNING = "That's burning fast!",
			GENERIC = "KUSA!",
			PICKED = "Regrow faster, will ya?",
			DISEASED = "It looks pretty sick.",
			DISEASING = "Err, something's not right.",
		},
		GRASSGEKKO = 
		{
			GENERIC = "Ew.",	
			DISEASED = "Dead ew!",
		},
		GREEN_CAP = "We better cook this one on fire.",
		GREEN_CAP_COOKED = "It has some mind soothing properties.",
		GREEN_MUSHROOM =
		{
			GENERIC = "Pick them while you can.",
			INGROUND = "Wrong time of the day for picking.",
			PICKED = "Mushroom won't grow back until the rain.",
		},
		GUNPOWDER = "Let's blow thing up with this, hehehe!",         
		HAMBAT = "Using food as a weapon? That's weird.",
		HAMMER = "A tool for pounding thing!",
		HEALINGSALVE = "Good for heal the wound.",
		HEATROCK =
		{
			FROZEN = "Frozen solid.",
			COLD = "It's stone cold.",
			GENERIC = "I could manipulate its temperature.",
			WARM = "Still warm enough to use.",
			HOT = "It's glowing!",
		},
		HOME = "Someone must live here.",
		HOMESIGN =
		{
			GENERIC = "Good for taking memo.",
            UNWRITTEN = "Let's write something useful.",
			BURNT = "What was written here, again?",
		},
		ARROWSIGN_POST =
		{
			GENERIC = "Good for taking memo.",
            UNWRITTEN = "Let's write something useful.",
			BURNT = "What was written here, again?",
		},
		ARROWSIGN_PANEL =
		{
			GENERIC = "Good for taking memo.",
            UNWRITTEN = "Let's write something useful.",
			BURNT = "What was written here, again?",
		},
		HONEY = "Sweet and delicious!",
		HONEYCOMB = "It's waxy.",
		HONEYHAM = "Ham and honey go well together.",
		HONEYNUGGETS = "Honey-covered pieces of meat.",
		HORN = "I can hear those hairy beasts inside.",
		HOUND = "You dare approaching me?!",
		HOUNDCORPSE =
		{
			GENERIC = "So smelly.",
			BURNING = "This guy even stink while burning.",
			REVIVING = "Nope, I'm out.",
		},
		HOUNDBONE = "Bonk them for the bones.",
		HOUNDMOUND = "They are living with their food waste.",
		ICEBOX = "A good long term investment.",
		ICEHAT = "I don't think my neck could handles its weight.",
		ICEHOUND = "Don't let it touch you.",
		INSANITYROCK =
		{
			ACTIVE = "Am I seeing things?",
			INACTIVE = "Doesn't look flammable. How boring.",
		},
		JAMMYPRESERVES = "But.. there is no bread TO EAT WITH!",

		KABOBS = "I'm long for some BBQ!",
		KILLERBEE =
		{
			GENERIC = "I like the cut of that bee's jib.",
			HELD = "Buzz!",
		},
		KNIGHT = "It looks stupid with a tiny pair of legs.",
		KOALEFANT_SUMMER = "Oh look, a walking lump of meat!",
		KOALEFANT_WINTER = "Oh look, a walking lump of cold meat!",
		KRAMPUS = "DON'T TOUCH MY ITEMS!",
		KRAMPUS_SACK = "This bad boy holds a tons!",
		LEIF = "He is too ANGRY to get chopped down!",
		LEIF_SPARSE = "Looks twice as creepy as another one.",
		LIGHTER  = "Whose lighter is this?",
		LIGHTNING_ROD =
		{
			CHARGED = "This is too bright for my eyes!",
			GENERIC = "Keep stupid lightning away!",
		},
		LIGHTNINGGOAT =
		{
			GENERIC = "Bouncy goat.",
			CHARGED = "You're crazy!",
		},
		LIGHTNINGGOATHORN = "I heard lightning when I held it to my ear.",
		GOATMILK = "It's fuzzy with electricity. Yuck.",
		LITTLE_WALRUS = "He looks tasty.",
		LIVINGLOG = "It looks upset.",
		LOG =
		{
			BURNING = "That's not how you make a campfire!",
			GENERIC = "This is must for camping.",
		},
		LUCY = "I talking axe? That's weird.",
		LUREPLANT = "I bet a quick fire would take care of this.",
		LUREPLANTBULB = "Gross! It's so meaty!",
		MALE_PUPPET = "He looks scared half to death.",

		MANDRAKE_ACTIVE = "This guy is noisy!",
		MANDRAKE_PLANTED = "Those plants are really rare.",
		MANDRAKE = "Careful not to cook it on fire.",

        MANDRAKESOUP = "Well, he won't be waking up again.",
        MANDRAKE_COOKED = "The only good mandrake is the one that SHUT UP!",
        MAPSCROLL = "A blank map. Doesn't seem very useful.",
        MARBLE = "I should decorate my base with this.",
        MARBLEBEAN = "I traded the old family cow for it.",
        MARBLEBEAN_SAPLING = "It looks carved.",
        MARBLESHRUB = "Makes sense to me.",
        MARBLEPILLAR = "I think I could use that.",
        MARBLETREE = "I don't think an axe will cut it.",
        MARSH_BUSH =
        {
			BURNT = "One less thorn patch to worry about.",
            BURNING = "That's burning fast!",
            GENERIC = "It looks thorny.",
            PICKED = "Ouch.",
        },
        BURNT_MARSH_BUSH = "It's all burnt up.",
        MARSH_PLANT = "It's a plant, why did you even ask?",
        MARSH_TREE =
        {
            BURNING = "Spikes and fire!",
            BURNT = "Now it's burnt and spiky.",
            CHOPPED = "Not so spiky now!",
            GENERIC = "Those spikes look sharp!",
        },
        MAXWELL = "I HATE that guy.",
        MAXWELLHEAD = "I can see into his pores.",
        MAXWELLLIGHT = "I wonder how they work.",
        MAXWELLLOCK = "Looks almost like a key hole.",
        MAXWELLTHRONE = "That doesn't look very comfortable.",
        MEAT = "It's a bit gamey, but it'll do.",
        MEATBALLS = "It's just a big wad of meat.",
        MEATRACK =
        {
            DONE = "The meat is dried.",
            DRYING = "Meat takes a while to dry.",
            DRYINGINRAIN = "Just dry already!",
            GENERIC = "I should dry some meats.",
            BURNT = "The rack got dried.",
            DONE_NOTMEAT = "It's dried and ready to eat.",
            DRYING_NOTMEAT = "This takes a while to dry.",
            DRYINGINRAIN_NOTMEAT = "Just dry already!",
        },
        MEAT_DRIED = "A bit of salt would be great on this.",
        MERM = "I dunno guys, that thing looks fishy.. and STINK!",
        MERMHEAD =
        {
            GENERIC = "The stinkiest thing I'll smell all day.",
            BURNT = "Burnt merm flesh somehow smells even worse.",
        },
        MERMHOUSE =
        {
            GENERIC = "Who would live here?",
            BURNT = "Nothing to live in, now.",
        },
        MINERHAT = "This could also be handy in Minecraft!",
        MONKEY = "I hate this annoying little s**t!",
        MONKEYBARREL = "Let's pound this down to the ground.",
        MONSTERLASAGNA = "Noodles, meat and clumps of hair. Nasty.",
        FLOWERSALAD = "You called a bowl of cactus, salad?",
        ICECREAM = "A tasty dessert to keep me sane.",
        WATERMELONICLE = "This might be too cold for me.",
        TRAILMIX = "Risu senpai might love this one.",
        HOTCHILI = "Now that's my kind of heat!",
        GUACAMOLE = "Holy moley, that's tasty!",
        MONSTERMEAT = "Let's throw this in pot and make something more edible.",
        MONSTERMEAT_DRIED = "This is still too gross to eat!",
        MOOSE = "What in the world...",
        MOOSE_NESTING_GROUND = "Ugh, it smells like bird butts!",
        MOOSEEGG = "It's huuuuge!",
        MOSSLING = "Its feathers are frazzled.",
        FEATHERFAN = "My arms are tired from having to fan myself.",
        MINIFAN = "No fun, making me exercise to stay cool!",
        GOOSE_FEATHER = "So snuggly!",
        STAFF_TORNADO = "Oh yeah! Tornado spell.",
        MOSQUITO =
        {
            GENERIC = "Let's kill this sucker.",
            HELD = "I just want to crush it already!",
        },
        MOSQUITOSACK = "Ew, a sack of blood.",
        MOUND =
        {
            DUG = "He probably deserved it.",
            GENERIC = "I bet there's all sorts of good stuff down there!",
        },
        NIGHTLIGHT = "It gives off a spooky light.",
        NIGHTMAREFUEL = "A usable ingredient for my gadget.",
        NIGHTSWORD = "This is so edgy in several meanings.",
        NITRE = "This could be handy later.",
        ONEMANBAND = "We should add a beefalo bell.",
        OASISLAKE =
		{
			GENERIC = "Is that a mirage?",
			EMPTY = "It's dry as a bone.",
		},
        PANDORASCHEST = "It may contain something fantastic! Or horrible.",
        PANFLUTE = "To serenade the animals.",
        PAPYRUS = "Some sheets of paper.",
        WAXPAPER = "Some sheets of wax paper.",
        PENGUIN = "Must be breeding season.",
        PERD = "Stupid bird! Stay away from those berries!",
        PEROGIES = "These turned out pretty good.",
        PETALS = "Pick some petals for brain juice!",
        PETALS_EVIL = "I'm not sure I want to hold those.",
        PHLEGM = "Disgusting...",
        PICKAXE = "Iconic, isn't it?",
        PIGGYBACK = "Even more space for items.",
        PIGHEAD =
        {
            GENERIC = "Free pigskin!",
            BURNT = "Crispy.",
        },
        PIGHOUSE =
        {
            FULL = "He's doing pig things in there.",
            GENERIC = "Are these pigs smart enough to build a house?",
            LIGHTSOUT = "You can't hide from ME!",
            BURNT = "Should have hammer it down instead.",
        },
        PIGKING = "This guy is way too FAT!",
        PIGMAN =
        {
            DEAD = "2EZ.",
            FOLLOWER = "You're my slave now.",
            GENERIC = "They kind of creep me out.",
            GUARD = "This one looks a bit tougher.",
            WEREPIG = "More like a weird pig.",
        },
        PIGSKIN = "It still has the tail on it.",
        PIGTENT = "Smells like bacon.",
        PIGTORCH = "Sure looks cozy.",
        PINECONE = "I could make a tree farm with these.",
        PINECONE_SAPLING = "It'll be a tree soon!",
        LUMPY_SAPLING = "How did this tree even reproduce?",
        PITCHFORK = "Now I just need an angry mob to join.",
        PLANTMEAT = "That doesn't look very appealing.",
        PLANTMEAT_COOKED = "At least it's warm now.",
        PLANT_NORMAL =
        {
            GENERIC = "Leafy!",
            GROWING = "Guh! It's growing so slowly!",
            READY = "Mmmm. Ready to harvest.",
            WITHERED = "The heat killed it.",
        },
        POMEGRANATE = "It looks disgusting inside.",
        POMEGRANATE_COOKED = "Crunchy.",
        POMEGRANATE_SEEDS = "It's a pomegranate seeds.",
        POND = "I can't see the bottom!",
        POOP = "Eww!",
        FERTILIZER = "That is definitely a bucket full of poop.",
        PUMPKIN = "It's as big as my head!",
        PUMPKINCOOKIE = "That's a pretty gourd cookie!",
        PUMPKIN_COOKED = "How did it not turn into a pie?",
        PUMPKIN_LANTERN = "Spooky!",
        PUMPKIN_SEEDS = "It's a pumpkin seed.",
        PURPLEAMULET = "It's whispering to me.",
        PURPLEGEM = "This one is a rarier kind of gem.",
        RABBIT =
        {
            GENERIC = "Ooh, they look cute!",
            HELD = "I can kill it with my barehand.",
        },
        RABBITHOLE =
        {
            GENERIC = "Just put a trap nearby for an easy food source.",
            SPRING = "No rabbit for the season.",
        },
        RAINOMETER =
        {
            GENERIC = "It measures cloudiness.",
            BURNT = "The measuring parts went up in a cloud of smoke.",
        },
        RAINCOAT = "Good for not getting a cold inside the rain.",
        RAINHAT = "Keep my hair in good shape inside the rain.",
        RATATOUILLE = "A true vegetarian dish.",
        RAZOR = "Let's shave someone bald with this!",
        REDGEM = "It sparkles with inner warmth.",
        RED_CAP = "Better use this as an ingredient.",
        RED_CAP_COOKED = "It's not too late to throw this in crockpot.",
        RED_MUSHROOM =
        {
            GENERIC = "Pick them while you can.",
			INGROUND = "Wrong time of the day for picking.",
			PICKED = "Mushroom won't grow back until the rain.",
        },
        REEDS =
        {
            BURNING = "That's really burning!",
            GENERIC = "It's a clump of reeds.",
            PICKED = "Just comeback again when we need it.",
        },
        RELIC = "Ancient household goods.",
        RUINS_RUBBLE = "This can be fixed.",
        RUBBLE = "Just bits and pieces of rock.",
        RESEARCHLAB =
        {
            GENERIC = "I don't mind a little science as long as it's not too nerdy.",
            BURNT = "Don't worry, that's EZ to replace.",
        },
        RESEARCHLAB2 =
        {
            GENERIC = "Leave it to me! I am experienced in chemistry.",
            BURNT = "Nothing unusual about chemicals being flammable.",
        },
        RESEARCHLAB3 =
        {
            GENERIC = "This is out of my expertises.",
            BURNT = "That was crazy, isn't it?",
        },
        RESEARCHLAB4 =
        {
            GENERIC = "What kind of pun is this, Ina?",
            BURNT = "I'm not a magician, so it's not my fault.",
        },
        RESURRECTIONSTATUE =
        {
            GENERIC = "You respawn on that thing? Sounds creepy.",
            BURNT = "At least give me back those meats!",
        },
        RESURRECTIONSTONE = "I will just call this a save point.",
        ROBIN =
        {
            GENERIC = "Does that mean winter is gone?",
            HELD = "He likes my pocket.",
        },
        ROBIN_WINTER =
        {
            GENERIC = "Life in the frozen wastes.",
            HELD = "It's so soft.",
        },
        ROBOT_PUPPET = "They're trapped!",
        ROCK_LIGHT =
        {
            GENERIC = "A crusted over lava pit.",
            OUT = "Looks fragile.",
            LOW = "The lava's crusting over.",
            NORMAL = "Nice and comfy.",
        },
        CAVEIN_BOULDER =
        {
            GENERIC = "I think I can lift this one.",
            RAISED = "It's out of reach.",
        },
        ROCK = "It wouldn't fit in my pocket.",
        PETRIFIED_TREE = "It looks scared stiff.",
        ROCK_PETRIFIED_TREE = "It looks scared stiff.",
        ROCK_PETRIFIED_TREE_OLD = "It looks scared stiff.",
        ROCK_ICE =
        {
            GENERIC = "Ice to meet you.",
            MELTED = "Won't be useful until it freezes again.",
        },
        ROCK_ICE_MELTED = "Won't be useful until it freezes again.",
        ICE = "Ice to meet you.",
        ROCKS = "We could make stuff with these.",
        ROOK = "Storm the castle!",
        ROPE = "Some short lengths of rope.",
        ROTTENEGG = "Ew! It stinks!",
        ROYAL_JELLY = "It infuses the eater with the power of science!",
        JELLYBEAN = "One part jelly, one part bean.",
        SADDLE_BASIC = "That'll allow the mounting of some smelly animal.",
        SADDLE_RACE = "This saddle really flies!",
        SADDLE_WAR = "The only problem is the saddle sores.",
        SADDLEHORN = "This could take a saddle off.",
        SALTLICK = "I heard some animals need an extra sodium to survive.",
        BRUSH = "Sometime I brush up Bubba with this'.",
		SANITYROCK =
		{
			ACTIVE = "That's a CRAZY looking rock!",
			INACTIVE = "Where did the rest of it go?",
		},
		SAPLING =
		{
			BURNING = "Don't lets the fire spread",
			WITHERED = "It's useless in this hot weather.",
			GENERIC = "A little trees are so cute!",
			PICKED = "Regrow faster, will ya?",
			DISEASED = "It looks pretty sick.",
			DISEASING = "Err, something's not right.",
		},
   		SCARECROW = 
   		{
			GENERIC = "I'm still amazed how this thing could tricks birds.",
			BURNING = "Woah, he's burning.",
			BURNT = "Byeee, Mr. Scarecrow.",
   		},
   		SCULPTINGTABLE=
   		{
			EMPTY = "We can make stone sculptures with this.",
			BLOCK = "Ready for sculpting.",
			SCULPTURE = "A masterpiece!",
			BURNT = "Burnt right down.",
   		},
        SCULPTURE_KNIGHTHEAD = "Where's the rest of it?",
		SCULPTURE_KNIGHTBODY = 
		{
			COVERED = "It's an odd marble statue.",
			UNCOVERED = "I guess he cracked under the pressure.",
			FINISHED = "At least it's back in one piece now.",
			READY = "Something's moving inside.",
		},
        SCULPTURE_BISHOPHEAD = "Is that a head?",
		SCULPTURE_BISHOPBODY = 
		{
			COVERED = "It looks old, but it feels new.",
			UNCOVERED = "There's a big piece missing.",
			FINISHED = "Now what?",
			READY = "Something's moving inside.",
		},
        SCULPTURE_ROOKNOSE = "Where did this come from?",
		SCULPTURE_ROOKBODY = 
		{
			COVERED = "It's some sort of marble statue.",
			UNCOVERED = "It's not in the best shape.",
			FINISHED = "All patched up.",
			READY = "Something's moving inside.",
		},
        GARGOYLE_HOUND = "I don't like how it's looking at me.",
        GARGOYLE_WEREPIG = "It looks very lifelike.",
		SEEDS = "I wonder what kind of plant it came from.",
		SEEDS_COOKED = "To think that this might have been a rare seed..",
		SEWING_KIT = "Repair all those rare equipemnts!",
		SEWING_TAPE = "Good for shut someone mouth when they're too loud.",
		SHOVEL = "A treassure hunting tool.",
		SILK = "This has a fine and smooth touch.",
		SKELETON = "We could smash this for some bones.",
		SCORCHED_SKELETON = "Spooky.",
		SKULLCHEST = "I'm not sure if I want to open it.",
		SMALLBIRD =
		{
			GENERIC = "That's a rather small bird.",
			HUNGRY = "It looks hungry.",
			STARVING = "It must be starving.",
			SLEEPING = "It's barely making a peep.",
		},
		SMALLMEAT = "A tiny chunk of dead animal.",
		SMALLMEAT_DRIED = "A little jerky.",
		SPAT = "What a crusty looking animal.",
		SPEAR = "That's one pointy stick.",
		SPEAR_WATHGRITHR = "Do roleplaying prop usable in real combat?",
		WATHGRITHRHAT = "Look sturdy than those stage prop I saw.",
		SPIDER =
		{
			DEAD = "Ewwww!",
			GENERIC = "I HATE spiders.",
			SLEEPING = "Now wrecks it before it wakes UP!",
		},
		SPIDERDEN = "I might get stucked if I touch that.",
		SPIDEREGGSACK = "How about burns them while we can?",
		SPIDERGLAND = "This has some medical properties.",
		SPIDERHAT = "Nice for halloween, isn't it?",
		SPIDERQUEEN = "Oh shoot! That spider is so large!",
		SPIDER_WARRIOR =
		{
			DEAD = "Get banned, you cheater!",
			GENERIC = "It can jump? THAT'S CHEATING!",
			SLEEPING = "I need some stronger weapon to smack it...",
		},
		SPOILED_FOOD = "I won't put risk on myself eating that.",
        STAGEHAND =
        {
			AWAKE = "That super CREEPY!",
			HIDING = "I sense something weird under the desk.",
        },
        STATUE_MARBLE = 
        {
            GENERIC = "It's a fancy marble statue.",
            TYPE1 = "Don't lose your head now!",
            TYPE2 = "Statuesque.",
            TYPE3 = "I wonder who the artist is.", --bird bath type statue
        },
		STATUEHARP = "What happened to the head?",
		STATUEMAXWELL = "He's a lot shorter in person.",
		STEELWOOL = "Scratchy metal fibers.",
		STINGER = "I could make concoction with this!",
		STRAWHAT = "I'm farmer now.",
		STUFFEDEGGPLANT = "It's really stuffing!",
		SWEATERVEST = "Some good fashion never hurt.",
		REFLECTIVEVEST = "To think that we could reflect heat with a cloth.",
		HAWAIIANSHIRT = "I'm a tourist now!",
		TAFFY = "This might be too sweet for me.",
		TALLBIRD = "Are you a mom? Groundpound time it is!",
		TALLBIRDEGG = "Will it hatch?",
		TALLBIRDEGG_COOKED = "Delicious and nutritious.",
		TALLBIRDEGG_CRACKED =
		{
			COLD = "Is it shivering or am I?",
			GENERIC = "Looks like it's hatching!",
			HOT = "Are eggs supposed to sweat?",
			LONG = "I have a feeling this is going to take a while...",
			SHORT = "It should hatch any time now.",
		},
		TALLBIRDNEST =
		{
			GENERIC = "That's quite an egg!",
			PICKED = "The nest is empty.",
		},
		TEENBIRD =
		{
			GENERIC = "Not a very tall bird.",
			HUNGRY = "You need some food and quick, huh?",
			STARVING = "It has a dangerous look in its eye.",
			SLEEPING = "It's getting some shut-eye",
		},
        -- ! These are DS story mode exclusive
		-- TELEPORTATO_BASE =
		-- {
		-- 	ACTIVE = "Is this device really allows me to teleport?",
		-- 	GENERIC = "This appears to be a nexus to another world!",
		-- 	LOCKED = "There's still something missing.",
		-- 	PARTIAL = "Soon, the invention will be complete!",
		-- },
		-- TELEPORTATO_BOX = "It kinda warm.",
		-- TELEPORTATO_CRANK = "Tough enough to handle the most intense experiments.",
		-- TELEPORTATO_POTATO = "This metal potato contains great and fearful power...",
		-- TELEPORTATO_RING = "A ring that could focus dimensional energies.",
		TELESTAFF = "Kinda useless if I don't know where it will take me to.",
		TENT = 
		{
			GENERIC = "I get sort of crazy when I don't sleep.",
			BURNT = "Nothing left to sleep in.",
		},
		SIESTAHUT = 
		{
			GENERIC = "A nice place for an afternoon rest, safely out of the heat.",
			BURNT = "It won't provide much shade now.",
		},
		TENTACLE = "I will passed on that.",
		TENTACLESPIKE = "As if it was not dangerous enough.",
		TENTACLESPOTS = "Gonna look out for a spot like that one.",
		TENTACLE_PILLAR = "That tentacle is WAYYYYYY too BIG!.",
        TENTACLE_PILLAR_HOLE = "I don't want to face that creep, but the loot is tempting...",
		TENTACLE_PILLAR_ARM = "DON'T TOUCH ME!",
		TENTACLE_GARDEN = "I'm so DONE with this!",
		TOPHAT = "What a classy hat.",
		TORCH = "We need this to fend off the shadow.",
		TRANSISTOR = "It's whirring with electricity.",
		TRAP = "Useful for catch the weakling.",
		TRAP_TEETH = "What a nasty surprise.",
		TRAP_TEETH_MAXWELL = "I'll want to avoid stepping on that!",
		TREASURECHEST = 
		{
			GENERIC = "It's a tickle trunk!",
			BURNT = "That trunk was truncated.",
		},
		TREASURECHEST_TRAP = "A TRESSURE!",
		SACRED_CHEST = 
		{
			GENERIC = "I hear whispers. It wants something.",
			LOCKED = "It's passing its judgment.",
		},
		TREECLUMP = "It's almost like someone is trying to prevent me from going somewhere.",
		
		TRINKET_1 = "Did you burned this, Kiara?", --Melted Marbles
		TRINKET_2 = "Calli like to play this, isn't she?", --Fake Kazoo
		TRINKET_3 = "The knot is stuck. Forever.", --Gord's Knot
		TRINKET_4 = "Go back to the lawn where you belong.", --Gnome
		TRINKET_5 = "This reminds me my brother's toy.", --Toy Rocketship
		TRINKET_6 = "Can we use this with something at the base?.", --Frazzled Wires
		TRINKET_7 = "I'm too busy for a minigame.", --Ball and Cup
		TRINKET_8 = "Why a thing from bathtub ends up here?", --Rubber Bung
		TRINKET_9 = "I might keep this to fix my clothes.", --Mismatched Buttons
		TRINKET_10 = "Why I want to keep someone else dentures?", --Dentures
		TRINKET_11 = "In other words, a useless robot.", --Lying Robot
		TRINKET_12 = "Some HENTAI stuffs.", --Dessicated Tentacle
		TRINKET_13 = "Go back to the lawn where you belong.", --Gnomette
		TRINKET_14 = "I need a usable teacup, not this junk.", --Leaky Teacup
		TRINKET_15 = "Maybe I could play chess with Kiara if I gather enough of these.", --Pawn
		TRINKET_16 = "Maybe I could play chess with Kiara if I gather enough of these.", --Pawn
		TRINKET_17 = "Another solid junk.", --Bent Spork
		TRINKET_18 = "I wonder what it's hiding?", --Trojan Horse
		TRINKET_19 = "It doesn't spin very well.", --Unbalanced Top
		TRINKET_20 = "I don't think it is hygiene enough to use.", --Backscratcher
		TRINKET_21 = "This egg beater is all bent out of shape.", --Egg Beater
		TRINKET_22 = "Why this is needed when we already have ropes.", --Frayed Yarn
		TRINKET_23 = "I can put my shoes on without help, thanks.", --Shoehorn
		TRINKET_24 = "Nice cat-shaped decoration.", --Lucky Cat Jar
		TRINKET_25 = "STINK!", --Air Unfreshener
		TRINKET_26 = "Edible food container, huh?", --Potato Cup
		TRINKET_27 = "If you unwound it you could poke someone from really far away.", --Coat Hanger
		TRINKET_28 = "Maybe I could play chess with Kiara if I gather enough of these..", --Rook
        TRINKET_29 = "Maybe I could play chess with Kiara if I gather enough of these..", --Rook
        TRINKET_30 = "Maybe I could play chess with Kiara if I gather enough of these.", --Knight
        TRINKET_31 = "Maybe I could play chess with Kiara if I gather enough of these.", --Knight
        TRINKET_32 = "I know someone who'd have a ball with this!", --Cubic Zirconia Ball
        TRINKET_33 = "I hope this doesn't attract spiders.", --Spider Ring
        TRINKET_34 = "For what?", --Monkey Paw
        TRINKET_35 = "Useful as a container at least.", --Empty Elixir
        TRINKET_36 = "Pfft, they're not even sharp.", --Faux fangs
        TRINKET_37 = "Looks like firewood to me.", --Broken Stake
        TRINKET_38 = "It makes stuff look small no matter which way I turn it.", -- Binoculars Griftlands trinket
        TRINKET_39 = "Who needs just one glove?", -- Lone Glove Griftlands trinket
        TRINKET_40 = "Snails are gross!", -- Snail Scale Griftlands trinket
        TRINKET_41 = "Ooo, it's warm.", -- Goop Canister Hot Lava trinket
        TRINKET_42 = "It's full of someone's childhood memories.", -- Toy Cobra Hot Lava trinket
        TRINKET_43= "It's not very good at jumping.", -- Crocodile Toy Hot Lava trinket
        TRINKET_44 = "It's some sort of plant specimen.", -- Broken Terrarium ONI trinket
        TRINKET_45 = "It's picking up frequencies from another world.", -- Odd Radio ONI trinket
        TRINKET_46 = "If only there is a power..", -- Hairdryer ONI trinket
        
        HALLOWEENCANDY_1 = "The cavities are probably worth it, right?",
        HALLOWEENCANDY_2 = "What kind of corruption grew these?",
        HALLOWEENCANDY_3 = "It's... corn.",
        HALLOWEENCANDY_4 = "They wriggle on the way down.",
        HALLOWEENCANDY_5 = "My teeth are going to have something to say about this tomorrow.",
        HALLOWEENCANDY_6 = "I... don't think I'll be eating those.",
        HALLOWEENCANDY_7 = "Everyone'll be raisin' a fuss over these.",
        HALLOWEENCANDY_8 = "Only a sucker wouldn't love this.",
        HALLOWEENCANDY_9 = "Sticks to your teeth.",
        HALLOWEENCANDY_10 = "Only a sucker wouldn't love this.",
        HALLOWEENCANDY_11 = "Much better tasting than the real thing.",
        HALLOWEENCANDY_12 = "Did that candy just move?", --ONI meal lice candy
        HALLOWEENCANDY_13 = "Oh, my poor jaw.", --Griftlands themed candy
        HALLOWEENCANDY_14 = "I don't do well with spice.", --Hot Lava pepper candy
        CANDYBAG = "It's some sort of delicious pocket dimension for sugary treats.",

		HALLOWEEN_ORNAMENT_1 = "A spectornament I could hang in a tree.",
		HALLOWEEN_ORNAMENT_2 = "Completely batty decoration.",
		HALLOWEEN_ORNAMENT_3 = "This wood look good hanging somewhere.", 
		HALLOWEEN_ORNAMENT_4 = "Almost i-tentacle to the real ones.",
		HALLOWEEN_ORNAMENT_5 = "Eight-armed adornment.",
		HALLOWEEN_ORNAMENT_6 = "Everyone's raven about tree decorations these days.", 

		HALLOWEENPOTION_DRINKS_WEAK = "I was hoping for something bigger.",
		HALLOWEENPOTION_DRINKS_POTENT = "A potent potion.",
        HALLOWEENPOTION_BRAVERY = "Full of grit.",
		HALLOWEENPOTION_MOON = "Infused with transforming such-and-such.",
		HALLOWEENPOTION_FIRE_FX = "Crystallized inferno.", 
		MADSCIENCE_LAB = "How long I didn't see a chemistry tool in such a perfect condition.",
		LIVINGTREE_ROOT = "Something's in there! I'll have to root it out.", 
		LIVINGTREE_SAPLING = "It'll grow up big and horrifying.",

        DRAGONHEADHAT = "So who gets to be the head?",
        DRAGONBODYHAT = "I'm middling on this middle piece.",
        DRAGONTAILHAT = "Someone has to bring up the rear.",
        PERDSHRINE =
        {
            GENERIC = "I feel like it wants something.",
            EMPTY = "I've got to plant something there.",
            BURNT = "That won't do at all.",
        },
        REDLANTERN = "This lantern feels more special than the others.",
        LUCKY_GOLDNUGGET = "What a lucky find!",
        FIRECRACKERS = "Something for pranking your friends.",
        PERDFAN = "It's inordinately large.",
        REDPOUCH = "Is there something inside?",
        WARGSHRINE = 
        {
            GENERIC = "I should make something fun.",
            EMPTY = "I need to put a torch in it.",
            BURNING = "I should make something fun.", --for willow to override
            BURNT = "It burned down.",
        },
        CLAYWARG = 
        {
        	GENERIC = "A terror cotta monster!",
        	STATUE = "Did it just move?",
        },
        CLAYHOUND = 
        {
        	GENERIC = "It's been unleashed!",
        	STATUE = "It looks so real.",
        },
        HOUNDWHISTLE = "This'd stop a dog in its tracks.",
        CHESSPIECE_CLAYHOUND = "That thing's the leashed of my worries.",
        CHESSPIECE_CLAYWARG = "And I didn't even get eaten!",

		PIGSHRINE =
		{
            GENERIC = "More stuff to make.",
            EMPTY = "It's hungry for meat.",
            BURNT = "Burnt out.",
		},
		PIG_TOKEN = "This looks important.",
		PIG_COIN = "This'll pay off in a fight.",
		YOTP_FOOD1 = "A feast fit for me.",
		YOTP_FOOD2 = "A meal only a beast would love.",
		YOTP_FOOD3 = "Nothing fancy.",

		PIGELITE1 = "What are you looking at?", --BLUE
		PIGELITE2 = "He's got gold fever!", --RED
		PIGELITE3 = "Here's mud in your eye!", --WHITE
		PIGELITE4 = "Wouldn't you rather hit someone else?", --GREEN

		PIGELITEFIGHTER1 = "What are you looking at?", --BLUE
		PIGELITEFIGHTER2 = "He's got gold fever!", --RED
		PIGELITEFIGHTER3 = "Here's mud in your eye!", --WHITE
		PIGELITEFIGHTER4 = "Wouldn't you rather hit someone else?", --GREEN

		BISHOP_CHARGE_HIT = "Ow!",
		TRUNKVEST_SUMMER = "Wilderness casual.",
		TRUNKVEST_WINTER = "Winter survival gear.",
		TRUNK_COOKED = "I find it weird to even try to eat this...",
		TRUNK_SUMMER = "A light breezy trunk.",
		TRUNK_WINTER = "A thick, hairy trunk.",
		TUMBLEWEED = "This is like a loot box from nature!",
		TURKEYDINNER = "This roasted smell make me hungry.",
		TWIGS = "I'm surprised that I could make a tool with these.",
		UMBRELLA = "It helps me not getting soak in the rain.",
		GRASS_UMBRELLA = "I guess this is better than nothing.",
		UNIMPLEMENTED = "It doesn't look finished! It could be dangerous.",
		WAFFLES = "Such a rare treat in the wilderness.",
		WALL_HAY = 
		{	
			GENERIC = "Hmmmm. I guess that'll have to do.",
			BURNT = "That won't do at all.",
		},
		WALL_HAY_ITEM = "Does this even protect us from danger?",
		WALL_STONE = "That's a nice wall.",
		WALL_STONE_ITEM = "They make me feel so safe.",
		WALL_RUINS = "An ancient piece of wall.",
		WALL_RUINS_ITEM = "A solid piece of history.",
		WALL_WOOD = 
		{
			GENERIC = "Pointy!",
			BURNT = "Burnt!",
		},
		WALL_WOOD_ITEM = "Pickets!",
		WALL_MOONROCK = "Spacey and smooth!",
		WALL_MOONROCK_ITEM = "Very light, but surprisingly tough.",
		FENCE = "It's just a wood fence.",
        FENCE_ITEM = "All we need to build a nice, sturdy fence.",
        FENCE_GATE = "Don't forget to close it.",
        FENCE_GATE_ITEM = "All we need to build a nice, sturdy gate.",
		WALRUS = "I didn't know walruses are aggressive.",
		WALRUSHAT = "This is such a classy hat.",
		WALRUS_CAMP =
		{
			EMPTY = "Let's sabotage them with traps before winter.",
			GENERIC = "Can I steal his house?",
		},
		WALRUS_TUSK = "I'm sure I'll find a use for it eventually.",
		WARDROBE = 
		{
			GENERIC = "It holds dark, forbidden secrets...",
            BURNING = "That's burning fast!",
			BURNT = "It's out of style now.",
		},
		WARG = "That huge wolf is SCARY!",
		WASPHIVE = "I think those bees are mad.",
		WATERBALLOON = "Good for stop the fire from spreading.",
		WATERMELON = "Sweet and refeshing.",
		WATERMELON_COOKED = "Again, why anyone want to eat a warm fruit.",
		WATERMELONHAT = "IT WILL MAKE MY HAIR STICKY!",
		WAXWELLJOURNAL = "Edgy book.",
		WETGOOP = "I will KILL anyone who made me eat this!",
        WHIP = "Nothing like loud noises to help keep the peace.",
		WINTERHAT = "It'll be good for when winter comes.",
		WINTEROMETER = 
		{
			GENERIC = "Do we really need to make it this big?",
			BURNT = "I hope it doesn't release toxin in the air.",
		},

        WINTER_TREE =
        {
            BURNT = "That puts a damper on the festivities.",
            BURNING = "That was a mistake, I think.",
            CANDECORATE = "Happy Winter's Feast!",
            YOUNG = "It's almost Winter's Feast!",
        },
		WINTER_TREESTAND = 
		{
			GENERIC = "I need a pine cone for that.",
            BURNT = "That puts a damper on the festivities.",
		},
        WINTER_ORNAMENT = "This make me want to decorate our base for the season.",
        WINTER_ORNAMENTLIGHT = "A tree's not complete without some electricity.",
        WINTER_ORNAMENTBOSS = "This one is especially impressive.",
		WINTER_ORNAMENTFORGE = "I should hang this one over a fire.",
		WINTER_ORNAMENTGORGE = "For some reason it makes me hungry.",

        WINTER_FOOD1 = "I will rip its arms and legs off one by one.", --gingerbread cookie
        WINTER_FOOD2 = "Too sweet for my taste.", --sugar cookie
        WINTER_FOOD3 = "Better use this to bonk someone than eating it.", --candy cane
        WINTER_FOOD4 = "Uh, why eternal? It used tons of preservatives?", --fruitcake
        WINTER_FOOD5 = "The look and taste go well together.", --yule log cake
        WINTER_FOOD6 = "Soft and crunchy in one!", --plum pudding
        WINTER_FOOD7 = "This might mess up my teeth.", --apple cider
        WINTER_FOOD8 = "Any hot drink is fine in winter.", --hot cocoa
        WINTER_FOOD9 = "It's just an egg, but it tastes so good.", --eggnog

        KLAUS = "I hate its look.",
        KLAUS_SACK = "We should definitely open that.",
		KLAUSSACKKEY = "It's really fancy for a deer antler.",
		WORMHOLE =
		{
			GENERIC = "That looks UGLY!",
			OPEN = "I don't wanna imagine what is inside there.",
		},
		WORMHOLE_LIMITED = "Guh, that thing looks worse off than usual.",
		ACCOMPLISHMENT_SHRINE = "Sometime it's feel good to working toward the completion.",        
		LIVINGTREE = "Is it peeping me?",
		ICESTAFF = "If only I could freeze thing and shatter it for one hit kill.",
		REVIVER = "Here, get a life!",
		SHADOWHEART = "Ugh, why it still beating?!",
        ATRIUM_RUBBLE = 
        {
			LINE_1 = "It depicts the people in certain era, suffering from disaster.",
			LINE_2 = "I can't read this tablet. It's too old.",
			LINE_3 = "Some shadow creatures taking over the citye.",
			LINE_4 = "The people start to transform into some horrendous creatures.",
			LINE_5 = "I think I saw a similiar future metropolis in a certain timeline.",
		},
        ATRIUM_STATUE = "It's super creepy!.",
        ATRIUM_LIGHT = 
        {
			ON = "A truly unsettling light.",
			OFF = "Something must power it.",
		},
        ATRIUM_GATE =
        {
			ON = "Back in working order.",
			OFF = "The essential components are still intact.",
			CHARGING = "It's gaining power.",
			DESTABILIZING = "The gateway is destabilizing.",
			COOLDOWN = "It needs time to recover. Me too.",
        },
        ATRIUM_KEY = "There is power emanating from it.",
		LIFEINJECTOR = "A scientific breakthrough! The cure!",
		SKELETON_PLAYER =
		{
			MALE = "%s probably died when messing with %s.",
			FEMALE = "%s probably died when messing with %s.",
			ROBOT = "%s probably wrecked when messing with %s.",
			DEFAULT = "%s probably died when messing with %s.",
		},
		HUMANMEAT = "...can I trade this for some gold instead?",
		HUMANMEAT_COOKED = "I can't believe you make me cook it...",
		HUMANMEAT_DRIED = "I still could not forget where it comes from.",
		ROCK_MOON = "That rock came from the moon.",
		MOONROCKNUGGET = "That rock came from the moon.",
		MOONROCKCRATER = "I should try stick something shiny in it.",
		MOONROCKSEED = "I hope other tech stations are portable like this.",

        REDMOONEYE = "It can see and be seen for miles!",
        PURPLEMOONEYE = "Makes a good marker, but I wish it'd stop looking at me.",
        GREENMOONEYE = "That'll keep a watchful eye on the place.",
        ORANGEMOONEYE = "No one could get lost with that thing looking out for them.",
        YELLOWMOONEYE = "That ought to show everyone the way.",
        BLUEMOONEYE = "It's always smart to keep an eye out.",

        --Arena Event
        LAVAARENA_BOARLORD = "That's the guy in charge here.",
        BOARRIOR = "You sure are big!",
        BOARON = "I can take him!",
        PEGHOOK = "That spit is corrosive!",
        TRAILS = "He's got a strong arm on him.",
        TURTILLUS = "Its shell is so spiky!",
        SNAPPER = "This one's got bite.",
		RHINODRILL = "He's got a nose for this kind of work.",
		BEETLETAUR = "I can smell him from here!",

        LAVAARENA_PORTAL = 
        {
            ON = "I'll just be going now.",
            GENERIC = "That's how we got here. Hopefully how we get back, too.",
        },
        LAVAARENA_KEYHOLE = "It needs a key.",
		LAVAARENA_KEYHOLE_FULL = "That should do it.",
        LAVAARENA_BATTLESTANDARD = "Everyone, break the Battle Standard!",
        LAVAARENA_SPAWNER = "This is where those enemies are coming from.",

        HEALINGSTAFF = "I don't mind doing support role occasionally.",
        FIREBALLSTAFF = "It calls a meteor from above.",
        HAMMER_MJOLNIR = "It's a heavy hammer for pounding things.",
        SPEAR_GUNGNIR = "I could do a quick charge with that.",
        BLOWDART_LAVA = "Still no gun for me to use.",
        BLOWDART_LAVA2 = "The better fire dart.",
        LAVAARENA_LUCY = "A throwing axe?",
        WEBBER_SPIDER_MINION = "Summon a creepy minions.",
        BOOK_FOSSIL = "This'll keep those monsters held for a little while.",
		LAVAARENA_BERNIE = "He might make a good distraction for us.",
		SPEAR_LANCE = "It gets to the point.",
		BOOK_ELEMENTAL = "I can't make out the text.",
		LAVAARENA_ELEMENTAL = "It's a rock monster!",

   		LAVAARENA_ARMORLIGHT = "Light, but not very durable.",
		LAVAARENA_ARMORLIGHTSPEED = "Lightweight and designed for mobility.",
		LAVAARENA_ARMORMEDIUM = "It offers a decent amount of protection.",
		LAVAARENA_ARMORMEDIUMDAMAGER = "That could help me hit a little harder.",
		LAVAARENA_ARMORMEDIUMRECHARGER = "I'd have energy for a few more stunts wearing that.",
		LAVAARENA_ARMORHEAVY = "That's as good as it gets.",
		LAVAARENA_ARMOREXTRAHEAVY = "This armor has been petrified for maximum protection.",

		LAVAARENA_FEATHERCROWNHAT = "Those fluffy feathers make me want to run!",
        LAVAARENA_HEALINGFLOWERHAT = "The blossom interacts well with healing magic.",
        LAVAARENA_LIGHTDAMAGERHAT = "My strikes would hurt a little more wearing that.",
        LAVAARENA_STRONGDAMAGERHAT = "It looks like it packs a wallop.",
        LAVAARENA_TIARAFLOWERPETALSHAT = "Looks like it amplifies healing expertise.",
        LAVAARENA_EYECIRCLETHAT = "It has a gaze full of science.",
        LAVAARENA_RECHARGERHAT = "Those crystals will quickened my abilities.",
        LAVAARENA_HEALINGGARLANDHAT = "This garland will restore a bit of my vitality.",
        LAVAARENA_CROWNDAMAGERHAT = "That could cause some major destruction.",

		LAVAARENA_ARMOR_HP = "That should keep me safe.",

		LAVAARENA_FIREBOMB = "It smells like brimstone.",
		LAVAARENA_HEAVYBLADE = "A sharp looking instrument.",

        --Quagmire
        QUAGMIRE_ALTAR = 
        {
        	GENERIC = "We'd better start cooking some offerings.",
        	FULL = "It's in the process of digestinating.",
    	},
		QUAGMIRE_ALTAR_STATUE1 = "It's an old statue.",
		QUAGMIRE_PARK_FOUNTAIN = "Been a long time since it was hooked up to water.",
		
        QUAGMIRE_HOE = "It's a farming instrument.",
        
        QUAGMIRE_TURNIP = "It's a raw turnip.",
        QUAGMIRE_TURNIP_COOKED = "Cooking is science in practice.",
        QUAGMIRE_TURNIP_SEEDS = "A handful of odd seeds.",
        
        QUAGMIRE_GARLIC = "The number one breath enhancer.",
        QUAGMIRE_GARLIC_COOKED = "Perfectly browned.",
        QUAGMIRE_GARLIC_SEEDS = "A handful of odd seeds.",
        
        QUAGMIRE_ONION = "This reminds me of a certain vegetable senpai.",
        QUAGMIRE_ONION_COOKED = "A successful chemical reaction.",
        QUAGMIRE_ONION_SEEDS = "A handful of odd seeds.",
        
        QUAGMIRE_POTATO = "The apples of the earth.",
        QUAGMIRE_POTATO_COOKED = "A nicely cooked potato.",
        QUAGMIRE_POTATO_SEEDS = "A handful of odd seeds.",
        
        QUAGMIRE_TOMATO = "It's red because it's full of science.",
        QUAGMIRE_TOMATO_COOKED = "Cooking's easy if you understand chemistry.",
        QUAGMIRE_TOMATO_SEEDS = "A handful of odd seeds.",
        
        QUAGMIRE_FLOUR = "Ready for baking.",
        QUAGMIRE_WHEAT = "It looks a bit grainy.",
        QUAGMIRE_WHEAT_SEEDS = "A handful of odd seeds.",
        --NOTE: raw/cooked carrot uses regular carrot strings
        QUAGMIRE_CARROT_SEEDS = "A handful of odd seeds.",
        
        QUAGMIRE_ROTTEN_CROP = "I don't think the altar will want that.",
        
		QUAGMIRE_SALMON = "A healthy kind of fish.",
		QUAGMIRE_SALMON_COOKED = "Ready for the dinner table.",
		QUAGMIRE_CRABMEAT = "No imitations here.",
		QUAGMIRE_CRABMEAT_COOKED = "I can put a meal together in a pinch.",
        -- QUAGMIRE_POT = "This one holds more ingredients.",
        -- QUAGMIRE_POT_SMALL = "Let's get cooking!",
        -- QUAGMIRE_POT_HANGER_ITEM = "For suspension-based cookery.",
		QUAGMIRE_SUGARWOODTREE = 
		{
			GENERIC = "It's full of delicious, delicious sap.",
			STUMP = "Where'd the tree go? I'm stumped.",
			TAPPED_EMPTY = "Here sappy, sappy, sap.",
			TAPPED_READY = "Sweet golden sap.",
			TAPPED_BUGS = "That's how you get ants.",
			WOUNDED = "It looks ill.",
		},
		QUAGMIRE_SPOTSPICE_SHRUB = 
		{
			GENERIC = "It reminds me of those tentacle monsters.",
			PICKED = "I can't get anymore out of that shrub.",
		},
		QUAGMIRE_SPOTSPICE_SPRIG = "I could grind it up to make a spice.",
		QUAGMIRE_SPOTSPICE_GROUND = "Flavorful.",
		QUAGMIRE_SAPBUCKET = "We can use it to gather sap from the trees.",
		QUAGMIRE_SAP = "It tastes sweet.",
		QUAGMIRE_SALT_RACK =
		{
			READY = "Salt has gathered on the rope.",
			GENERIC = "Science takes time.",
		},
		
		QUAGMIRE_POND_SALT = "A little salty spring.",
		QUAGMIRE_SALT_RACK_ITEM = "For harvesting salt from the pond.",

		QUAGMIRE_SAFE = 
		{
			GENERIC = "It's a safe. For keeping things safe.",
			LOCKED = "It won't open without the key.",
		},

		QUAGMIRE_KEY = "Safe bet this'll come in handy.",
		QUAGMIRE_KEY_PARK = "I'll park it in my pocket until I get to the park.",
        QUAGMIRE_PORTAL_KEY = "This looks science-y.",

		
		QUAGMIRE_MUSHROOMSTUMP =
		{
			GENERIC = "Are those mushrooms? I'm stumped.",
			PICKED = "I don't think it's growing back.",
		},
		QUAGMIRE_MUSHROOMS = "These are edible mushrooms.",
        QUAGMIRE_MEALINGSTONE = "The daily grind.",
		QUAGMIRE_PEBBLECRAB = "That rock's alive!",

		
		QUAGMIRE_RUBBLE_CARRIAGE = "On the road to nowhere.",
        QUAGMIRE_RUBBLE_CLOCK = "Someone beat the clock. Literally.",
        QUAGMIRE_RUBBLE_CATHEDRAL = "Preyed upon.",
        QUAGMIRE_RUBBLE_PUBDOOR = "No longer a-door-able.",
        QUAGMIRE_RUBBLE_ROOF = "Someone hit the roof.",
        QUAGMIRE_RUBBLE_CLOCKTOWER = "That clock's been punched.",
        QUAGMIRE_RUBBLE_BIKE = "Must have mis-spoke.",
        QUAGMIRE_RUBBLE_HOUSE =
        {
            "No one's here.",
            "Something destroyed this town.",
            "I wonder who they angered.",
        },
        QUAGMIRE_RUBBLE_CHIMNEY = "Something put a damper on that chimney.",
        QUAGMIRE_RUBBLE_CHIMNEY2 = "Something put a damper on that chimney.",
        QUAGMIRE_MERMHOUSE = "What an ugly little house.",
        QUAGMIRE_SWAMPIG_HOUSE = "It's seen better days.",
        QUAGMIRE_SWAMPIG_HOUSE_RUBBLE = "Some pig's house was ruined.",
        QUAGMIRE_SWAMPIGELDER =
        {
            GENERIC = "I guess you're in charge around here?",
            SLEEPING = "It's sleeping, for now.",
        },
        QUAGMIRE_SWAMPIG = "It's a super hairy pig.",
        
        QUAGMIRE_PORTAL = "Another dead end.",
        QUAGMIRE_SALTROCK = "A different taste of salt.",
        QUAGMIRE_SALT = "It's full of salt.",
        --food--
        QUAGMIRE_FOOD_BURNT = "That one was an experiment.",
        QUAGMIRE_FOOD =
        {
        	GENERIC = "I should offer it on the Altar of Gnaw.",
            MISMATCH = "That's not what it wants.",
            MATCH = "Science says this will appease the sky God.",
            MATCH_BUT_SNACK = "It's more of a light snack, really.",
        },
        
        QUAGMIRE_FERN = "Probably chock full of vitamins.",
        QUAGMIRE_FOLIAGE_COOKED = "We cooked the foliage.",
        QUAGMIRE_COIN1 = "I'd like more than a penny for my thoughts.",
        QUAGMIRE_COIN2 = "A decent amount of coin.",
        QUAGMIRE_COIN3 = "Seems valuable.",
        QUAGMIRE_COIN4 = "We can use these to reopen the Gateway.",
        QUAGMIRE_GOATMILK = "Good if you don't think about where it came from.",
        QUAGMIRE_SYRUP = "Adds sweetness to the mixture.",
        QUAGMIRE_SAP_SPOILED = "Might as well toss it on the fire.",
        QUAGMIRE_SEEDPACKET = "Sow what?",
        
        QUAGMIRE_POT = "This pot holds more ingredients.",
        QUAGMIRE_POT_SMALL = "Let's get cooking!",
        QUAGMIRE_POT_SYRUP = "I need to sweeten this pot.",
        QUAGMIRE_POT_HANGER = "It has hang-ups.",
        QUAGMIRE_POT_HANGER_ITEM = "For suspension-based cookery.",
        QUAGMIRE_GRILL = "Now all I need is a backyard to put it in.",
        QUAGMIRE_GRILL_ITEM = "I'll have to grill someone about this.",
        QUAGMIRE_GRILL_SMALL = "Barbecurious.",
        QUAGMIRE_GRILL_SMALL_ITEM = "For grilling small meats.",
        QUAGMIRE_OVEN = "It needs ingredients to make the science work.",
        QUAGMIRE_OVEN_ITEM = "For burning things.",
        QUAGMIRE_CASSEROLEDISH = "A dish for all seasonings.",
        QUAGMIRE_CASSEROLEDISH_SMALL = "For making minuscule motleys.",
        QUAGMIRE_PLATE_SILVER = "A silver plated plate.",
        QUAGMIRE_BOWL_SILVER = "A bright bowl.",
        QUAGMIRE_CRATE = "Kitchen stuff.",
        
        QUAGMIRE_MERM_CART1 = "Any thing in there?", --sammy's wagon
        QUAGMIRE_MERM_CART2 = "I could use some stuff.", --pipton's cart
        QUAGMIRE_PARK_ANGEL = "Take that, creature!",
        QUAGMIRE_PARK_ANGEL2 = "So lifelike.",
        QUAGMIRE_PARK_URN = "Ashes to ashes.",
        QUAGMIRE_PARK_OBELISK = "A monumental monument.",
        QUAGMIRE_PARK_GATE =
        {
            GENERIC = "Turns out a key was the key to getting in.",
            LOCKED = "Locked tight.",
        },
        QUAGMIRE_PARKSPIKE = "A pointy boi.",
        QUAGMIRE_CRABTRAP = "A crabby trap.",
        QUAGMIRE_TRADER_MERM = "Maybe they'd be willing to trade.",
        QUAGMIRE_TRADER_MERM2 = "Maybe they'd be willing to trade.",
        
        QUAGMIRE_GOATMUM = "Reminds me of my old nanny.",
        QUAGMIRE_GOATKID = "This goat's much smaller.",
        QUAGMIRE_PIGEON =
        {
            DEAD = "They're dead.",
            GENERIC = "He's just winging it.",
            SLEEPING = "It's sleeping, for now.",
        },
        QUAGMIRE_LAMP_POST = "Huh. Reminds me of home.",

        QUAGMIRE_BEEFALO = "It should have died by now.",
        QUAGMIRE_SLAUGHTERTOOL = "Laboratory tools for surgical butchery.",

        QUAGMIRE_SAPLING = "I can't get anything else out of that.",
        QUAGMIRE_BERRYBUSH = "Those berries are all gone.",

        QUAGMIRE_ALTAR_STATUE2 = "What are you looking at?",
        QUAGMIRE_ALTAR_QUEEN = "A monumental monument.",
        QUAGMIRE_ALTAR_BOLLARD = "As far as posts go, this one is adequate.",
        QUAGMIRE_ALTAR_IVY = "Kind of clingy.",

        QUAGMIRE_LAMP_SHORT = "Enlightening.",

        --v2 Winona
        WINONA_CATAPULT = 
        {
        	GENERIC = "An interesting turret Winona made.",
        	OFF = "It needs some electricity.",
        	BURNING = "It's on fire!",
        	BURNT = "Better keep it safe next time.",
        },
        WINONA_SPOTLIGHT = 
        {
        	GENERIC = "I appreciate the light, but it might be too bright!",
        	OFF = "It needs some electricity.",
        	BURNING = "It's on fire!",
        	BURNT = "Better keep it safe next time.",
        },
        WINONA_BATTERY_LOW = 
        {
        	GENERIC = "I think I understand how this works.",
        	LOWPOWER = "It's getting low on power.",
        	OFF = "I could get it working, if Winona's busy.",
        	BURNING = "It's on fire!",
        	BURNT = "Better keep it safe next time.",
        },
        WINONA_BATTERY_HIGH = 
        {
        	GENERIC = "Somehow this use gems as energy.",
        	LOWPOWER = "It'll turn off soon.",
        	OFF = "Maybe I should only turn it on when necessary.",
        	BURNING = "It's on fire!",
        	BURNT = "Better keep it safe next time.",
        },

        --Wormwood
        COMPOSTWRAP = "There's no way I'm going to use that on myself.",
        ARMOR_BRAMBLE = "The best offense is a good defense.",
        TRAP_BRAMBLE = "It'd really poke whoever stepped on it.",

        BOATFRAGMENT03 = "Not much left of it.",
        BOATFRAGMENT04 = "Not much left of it.",
        BOATFRAGMENT05 = "Not much left of it.",
		BOAT_LEAK = "I should patch that up before we sink.",
        MAST = "A mast!",
        SEASTACK = "It's a rock.",
        FISHINGNET = "Much better than conventional fishing.",
        ANTCHOVIES = "Yeesh. Can I toss it back?",
        STEERINGWHEEL = "I'm a pirate now!",
        ANCHOR = "Keep the boat stays in a place.",
        BOATPATCH = "Just in case of disaster.",
        DRIFTWOOD_TREE = 
        {
            BURNING = "That driftwood's burning!",
            BURNT = "Doesn't look very useful anymore.",
            CHOPPED = "There might still be something worth digging up.",
            GENERIC = "A dead tree that washed up on shore.",
        },

        DRIFTWOOD_LOG = "It floats on water.",

        MOON_TREE = 
        {
            BURNING = "The tree is burning!",
            BURNT = "The tree burned down.",
            CHOPPED = "That was a pretty thick tree.",
            GENERIC = "I didn't know trees grew on the moon.",
        },
		MOON_TREE_BLOSSOM = "It fell from the moon tree.",

        MOONBUTTERFLY = 
        {
        	GENERIC = "Oh, it's a moon butterfly.",
        	HELD = "I've got you now.",
        },
		MOONBUTTERFLYWINGS = "We're really winging it now.",
        MOONBUTTERFLY_SAPLING = "A moth turned into a tree? Lunacy!",
        ROCK_AVOCADO_FRUIT = "I'd shatter my teeth on that.",
        ROCK_AVOCADO_FRUIT_RIPE = "Uncooked stone fruit is the pits.",
        ROCK_AVOCADO_FRUIT_RIPE_COOKED = "It's actually soft enough to eat now.",
        ROCK_AVOCADO_FRUIT_SPROUT = "It's growing.",
        ROCK_AVOCADO_BUSH = 
        {
        	BARREN = "Its fruit growing days are over.",
			WITHERED = "It's pretty hot out.",
			GENERIC = "It's a bush... from the moon!",
			PICKED = "It'll take awhile to grow more fruit.",
			DISEASED = "It looks pretty sick.",
            DISEASING = "Err, something's not right.",
			BURNING = "It's burning!",
		},
        DEAD_SEA_BONES = "That's what they get for coming up on land.",
        HOTSPRING = 
        {
        	GENERIC = "What?! We cannot get in hot spring?",
        	BOMBED = "Something is.. HAPPENING!",
        	GLASS = "How could it turns in to glass?! I dunno.",
			EMPTY = "I think it will fill up again after awhile.",
        },
        MOONGLASS = "It's very sharp.",
        MOONGLASS_ROCK = "I can practically see my reflection in it.",
        BATHBOMB = "I wonder if I could use this in a bath.",
        TRAP_STARFISH =
        {
            GENERIC = "Aw, what a cute little starfish!",
            CLOSED = "It tried to chomp me!",
        },
        DUG_TRAP_STARFISH = "It's not fooling anyone now.",
        SPIDER_MOON = 
        {
        	GENERIC = "Oh good. The moon mutated it.",
        	SLEEPING = "Thank science, it stopped moving.",
        	DEAD = "Is it really dead?",
        },
        MOONSPIDERDEN = "That's not a normal spider den.",
		FRUITDRAGON =
		{
			GENERIC = "It's cute, but it's not ripe yet.",
			RIPE = "I think it's ripe now.",
			SLEEPING = "It's snoozing.",
		},
        PUFFIN =
        {
            GENERIC = "I've never seen a live puffin before!",
            HELD = "Catching one ain't puffin to brag about.",
            SLEEPING = "Peacefully huffin' and puffin'.",
        },

		MOONGLASSAXE = "I've made it extra effective.",
		GLASSCUTTER = "I'm not really cut out for fighting.",

        ICEBERG =
        {
            GENERIC = "Let's steer clear of that.",
            MELTED = "It's completely melted.",
        },
        ICEBERG_MELTED = "It's completely melted.",

        MINIFLARE = "I can light it to let everyone know I'm here.",

		MOON_FISSURE = 
		{
			GENERIC = "My brain pulses with peace and terror.", 
			NOLIGHT = "The cracks in this place are starting to show.",
		},
        MOON_ALTAR =
        {
            MOON_ALTAR_WIP = "It wants to be finished.",
            GENERIC = "Hm? What did you say?",
        },

        MOON_ALTAR_IDOL = "I feel compelled to carry it somewhere.",
        MOON_ALTAR_GLASS = "It doesn't want to be on the ground.",
        MOON_ALTAR_SEED = "It wants me to give it a home.",

        MOON_ALTAR_ROCK_IDOL = "There's something trapped inside.",
        MOON_ALTAR_ROCK_GLASS = "There's something trapped inside.",
        MOON_ALTAR_ROCK_SEED = "There's something trapped inside.",

        SEAFARING_PROTOTYPER =
        {
            GENERIC = "I think tanks are in order.",
            BURNT = "Not so hard to make it again.",
        },
        BOAT_ITEM = "Sailing helps me relax sometime.",
        STEERINGWHEEL_ITEM = "That's going to be the steering wheel.",
        ANCHOR_ITEM = "Now I can build an anchor.",
        MAST_ITEM = "Now I can build a mast.",
        MUTATEDHOUND = 
        {
        	DEAD = "Now I can breathe easy.",
        	GENERIC = "Runnnnnn!",
        	SLEEPING = "I have a very strong desire to run.",
        },

        MUTATED_PENGUIN = 
        {
			DEAD = "That's the end of that.",
			GENERIC = "Oh shoot! Run!",
			SLEEPING = "Thank goodness. It's sleeping.",
		},
        CARRAT = 
        {
        	DEAD = "Now it looks like a carrot.",
        	GENERIC = "This thing make me feel uneasy.",
        	HELD = "You're soooo ugly up close.",
        	SLEEPING = "Still creepy.",
        },

		BULLKELP_PLANT = 
        {
            GENERIC = "I better gather it, just in case.",
            PICKED = "I might come back later.",
        },
		BULLKELP_ROOT = "I can plant it in deep water.",
        KELPHAT = "Sometimes you have to feel worse to feel better.",
		KELP = "It gets my pockets all wet and gross.",
		KELP_COOKED = "It's closer to a liquid than a solid.",
		KELP_DRIED = "Just right amount of saltiness.",

		GESTALT = "It make me see hallucination.",

		COOKIECUTTER = "I don't like the way it's looking at my boat...",
		COOKIECUTTERSHELL = "A shell of its former self.",
		COOKIECUTTERHAT = "At least my hair will stay dry.",
		SALTSTACK =
		{
			GENERIC = "I feel uneasy just by looking at these.",
			MINED_OUT = "It's all mined!",
			GROWING = "I guess it just grows like that.",
		},
		SALTROCK = "I swear these are not mine!",
		SALTBOX = "Won't the food getting too salty?",

        MALBATROSS = "A fowl beast indeed!",
        MALBATROSS_FEATHER = "Plucked from a fine feathered fiend.",
        MALBATROSS_BEAK = "Smells fishy.",
        MAST_MALBATROSS_ITEM = "It's lighter than it looks.",
        MAST_MALBATROSS = "Spread my wings and sail away!",
		MALBATROSS_FEATHERED_WEAVE = "I'm making a quill-t!",

        WALKINGPLANK = "Maybe I should trick Gura to walk on this, without floatie.",
        OAR = "Manual ship acceleration.",
		OAR_DRIFTWOOD = "Manual ship acceleration.",

		----------------------- ROT STRINGS GO ABOVE HERE ------------------

        --Wortox
        WORTOX_SOUL = "only_used_by_wortox", --only wortox can inspect souls

        PORTABLECOOKPOT_ITEM =
        {
            GENERIC = "Now we're cookin'!",
            DONE = "Now we're done cookin'!",

			COOKING_LONG = "That meal is going to take a while.",
			COOKING_SHORT = "It'll be ready in no-time!",
			EMPTY = "I bet there's nothing in there.",
        },
        
        PORTABLEBLENDER_ITEM = "It mixes all the food.",
        PORTABLESPICER_ITEM =
        {
            GENERIC = "This will spice things up.",
            DONE = "Should make things a little tastier.",
        },
        SPICEPACK = "How does it keep foods fresh?",
        SPICE_GARLIC = "A powerfully potent powder.",
        SPICE_SUGAR = "Sweet! It's sweet!",
        SPICE_CHILI = "A flagon of fiery fluid.",
        SPICE_SALT = "Still too much sodium for me.",
        MONSTERTARTARE = "There's got to be something else to eat around here.",
        FRESHFRUITCREPES = "Sugary fruit! Part of a balanced breakfast.",
        FROGFISHBOWL = "Is that just... frogs stuffed inside a fish?",
        POTATOTORNADO = "Potato, infused with a tornado!",
        DRAGONCHILISALAD = "I hope I can handle the spice level.",
        GLOWBERRYMOUSSE = "Is it really safe to eat?",
        VOLTGOATJELLY = "It's shockingly delicious.",
        NIGHTMAREPIE = "A spooky food.",
        BONESOUP = "I can't fill my stomach with liquid and bone, you know?",
        MASHEDPOTATOES = "Would be perfect if we have some gravy.",
        POTATOSOUFFLE = "I forgot what good food tasted like.",
        MOQUECA = "He's such a talented chef.",
        GAZPACHO = "Are you calling this cooking?",
        ASPARAGUSSOUP = "Smells like it tastes.",
        VEGSTINGER = "Can you use the celery as a straw?",
        BANANAPOP = "It freezes my brain, but delicious.",
        CEVICHE = "Can I get a bigger bowl? This one looks a little shrimpy.",
        SALSA = "So... hot...!",
        PEPPERPOPPER = "What a mouthful!",

        TURNIP = "It's a raw turnip.",
        TURNIP_COOKED = "Cooking is science in practice.",
        TURNIP_SEEDS = "A handful of odd seeds.",
        
        GARLIC = "Better use this for cooking.",
        GARLIC_COOKED = "It makes my breath smelly!.",
        GARLIC_SEEDS = "A handful of odd seeds.",
        
        ONION = "This reminds me of a certain vegetable senpai.",
        ONION_COOKED = "Crunchy onion.",
        ONION_SEEDS = "A handful of odd seeds.",
        
        POTATO = "I should try making fried potatoes.",
        POTATO_COOKED = "A nicely cooked potato.",
        POTATO_SEEDS = "A handful of odd seeds.",
        
        TOMATO = "It's full of vitamin.",
        TOMATO_COOKED = "Why would anyone cook tomato on fire?",
        TOMATO_SEEDS = "A handful of odd seeds.",

        ASPARAGUS = "Another healthy vegetable.", 
        ASPARAGUS_COOKED = "It's good for health!",
        ASPARAGUS_SEEDS = "It's asparagus seeds.",

        PEPPER = "Nice and spicy.",
        PEPPER_COOKED = "It was already hot to begin with.",
        PEPPER_SEEDS = "A handful of seeds.",

        WEREITEM_BEAVER = "Some Woodie's belonging.",
        WEREITEM_GOOSE = "Some Woodie's belonging.",
        WEREITEM_MOOSE = "Some Woodie's belonging.",

        MERMHAT = "Made for infiltration.",
        MERMTHRONE =
        {
            GENERIC = "They have similiar social structure to humans.",
            BURNT = "I don't really care.",
        },        
        MERMTHRONE_CONSTRUCTION =
        {
            GENERIC = "Just what is she planning?",
            BURNT = "I suppose we'll never know what it was for now.",
        },        
        MERMHOUSE_CRAFTED = 
        {
            GENERIC = "Look a bit better than regular one.",
            BURNT = "Ugh, the smell!",
        },

        MERMWATCHTOWER_REGULAR = "They seem happy to have found a king.",
        MERMWATCHTOWER_NOKING = "A royal guard with no Royal to guard.",
        MERMKING = "That trident reminds me of Gura.",
        MERMGUARD = "These guys looking at me with suspicious eyes.",
        MERM_PRINCE = "They operate on a first-come, first-sovereigned basis.",

    },

    DESCRIBE_GENERIC = "It's SOMETHING!",
    DESCRIBE_TOODARK = "Quick! Craft some torch!",
    DESCRIBE_SMOLDERING = "Put down a fire while it's still small!",
    EAT_FOOD =
    {
        TALLBIRDEGG_CRACKED = "Mmm. Beaky.",
    },
}
