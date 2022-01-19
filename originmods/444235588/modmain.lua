PrefabFiles = {
	"deluxe_firepit",
	"deluxe_firepit_fire",
	"endo_firepit",
	"endo_firepit_fire",
	"ice_star",
	"ice_star_flame",
	"heat_star",
	"heat_star_flame",
}

Assets = 
{
	Asset("ATLAS", "images/inventoryimages/deluxe_firepit.xml"),
	Asset( "IMAGE", "minimap/deluxe_firepit.tex" ),
	Asset( "ATLAS", "minimap/deluxe_firepit.xml" ),	

	Asset("ATLAS", "images/inventoryimages/endo_firepit.xml"),
	Asset( "IMAGE", "minimap/endo_firepit.tex" ),
	Asset( "ATLAS", "minimap/endo_firepit.xml" ),	

	Asset("ATLAS", "images/inventoryimages/ice_star.xml"),
	Asset( "IMAGE", "minimap/ice_star.tex" ),
	Asset( "ATLAS", "minimap/ice_star.xml" ),	

	Asset("ATLAS", "images/inventoryimages/heat_star.xml"),
	Asset( "IMAGE", "minimap/heat_star.tex" ),
	Asset( "ATLAS", "minimap/heat_star.xml" ),	
}
	AddMinimapAtlas("minimap/deluxe_firepit.xml")
	AddMinimapAtlas("minimap/endo_firepit.xml")
	AddMinimapAtlas("minimap/ice_star.xml")
	AddMinimapAtlas("minimap/heat_star.xml")

	STRINGS = GLOBAL.STRINGS
	RECIPETABS = GLOBAL.RECIPETABS
	Recipe = GLOBAL.Recipe
	Ingredient = GLOBAL.Ingredient
	TECH = GLOBAL.TECH


---------------------------------------------------
--  Heaters
---------------------------------------------------
--DELUXE FIREPIT

	-- Deluxe Firepit dialog
		GLOBAL.STRINGS.NAMES.DELUXE_FIREPIT = "Deluxe Firepit"
		STRINGS.RECIPE_DESC.DELUXE_FIREPIT = "Wow, now that is fancy... and efficient!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Somehow still pleasing even when its extinguished.",
					EMBERS = "Just barely enough to work with.",
					LOW = "Ideal for a barbeque.",
					NORMAL = "Now if only I had four walls and a roof...",
					HIGH = "Yeesh, you could get third degree burns from looking at it.",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "I NEED TO REBOOT IT!",
					EMBERS = "IT'S ALMOST OUT!",
					LOW = "SUFFICIENT",
					NORMAL = "IT IS IDEAL FOR WINTER TIME",
					HIGH = "WARNING: HEAT EXCEEDING SPECIFIED LIMITS",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Is all kaput!",
					EMBERS = "Is almost kaput!",
					LOW = "Is perfect for cooking and dark time.",
					NORMAL = "Very Mighty fire.",
					HIGH = "Fire is too mighty! Flames stay back!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Ah, boring...",
					EMBERS = "The fire's as bored as I am.",
					LOW = "This is adequate.",
					NORMAL = "The flames are looking good... but bigger is better!",
					HIGH = "HAHAHAHAHAHAHA! Perfection!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "At least it still looks nice.",
					EMBERS = "I should probably fan the flames.",
					LOW = "This will serve my purposes nicely.",
					NORMAL = "Perfect... for winter!!",
					HIGH = "This level of overkill is best suited for pyro-maniacs!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Fiddle sticks.",
					EMBERS = "Anything but my books...",
					LOW = "Now this is a textbook campfire.",
					NORMAL = "This should keep even a snow man warm.",
					HIGH = "I think I made it TOO good!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Cold and blackened, like my heart.",
					EMBERS = "Only the smallest embers cling to the charred wood.",
					LOW = "A small flame will have to do.",
					NORMAL = "I can live with it.",
					HIGH = "Any hotter and It'd be like standing in Hell!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "Lucy, looks like we need more logs.",
					EMBERS = "It doesn't look very warm any more Lucy...",
					LOW = "We can get still some warmth if we huddle around it.",
					NORMAL = "Now this is more like the fireplace I had back home.",
					HIGH = "Lucy, stay back from the flames... they look dangerous!",
				}				

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DELUXE_FIREPIT  =
					{
						OUT = "Oofën ägäïn!",
						EMBERS = "Ëvën thë mëät is offëndëd by this wëäk firë!",
						LOW = "This is Okäy.",
						NORMAL = "Odin himsëlf woüld bë proüd of this firë!",
						HIGH = "Ëvën the grëät and mighty Odin woüld bë scärëd of this firë!!",
					}


			GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.DELUXE_FIREPIT  =
					{
						OUT = "All gone!",
						EMBERS = "Sparks and cinders.",
						LOW = "We can tolerate this.",
						NORMAL = "Now this is just what we needed.",
						HIGH = "We think it wise to stay back.",
					}
			GLOBAL.STRINGS.CHARACTERS.WARLY.DESCRIBE.DELUXE_FIREPIT  =
				{
					EMBERS = "That fire's almost out!",
					GENERIC = "To warm my fingers and roast sausages.",
					HIGH = "Maximum heat!",
					LOW = "It's getting low.",
					NORMAL = "Parfait.",
					OUT = "I like when it's warm and toasty.",
				}
		
		    GLOBAL.STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.DELUXE_FIREPIT  =
				{
					EMBERS = "Dying",
					HIGH = "Too high!",
					LOW = "Stay back",
					NORMAL = "Not too close",
					OUT = "Whew. No fire",
				}
				GLOBAL.STRINGS.CHARACTERS.WINONA.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "I oughta fire it back up.",
					EMBERS = "It's almost gone cold.",
					LOW = "It's close to out.",
					NORMAL = "Nicely roaring.",
					HIGH = "Even a flame that big has got nothin on a tin smelter.",
				}

                GLOBAL.STRINGS.CHARACTERS.WORTOX.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "And out it goes.",
					EMBERS = "Soon to be ashes to the wind.",
					LOW = "Such tiny flames! They burn so weak!",
					NORMAL = "A flame like that makes our camp feel homely.",
					HIGH = "Such great flames! Hyuyu!",
				}
				
--				GLOBAL.STRINGS.CHARACTERS.WALTER.DESCRIBE.DELUXE_FIREPIT  =
--				{
--					EMBERS = "",
--					HIGH = "",
--					LOW = "",
--					NORMAL = "",
--					OUT = "",
--				}
--				
				GLOBAL.STRINGS.CHARACTERS.WURT.DESCRIBE.DELUXE_FIREPIT  =
				{
					OUT = "It out.",
					EMBERS = "Fancy fire dying.",
					LOW = "Fancy fire getting small.",
					NORMAL = "Fancy cozy fire, flurp.",
					HIGH = "Time for story-tell around fancy fire, florp!",
   			    }
				
				

	-- Deluxe Firepit config opions
		GLOBAL.deluxeFirepitBurnRate = GetModConfigData("deluxeFirepitBurnRate")
		GLOBAL.deluxeFirepitDropLoot = GetModConfigData("dropLoot")
		
local RecipeIngredients = {
    Ingredient("log", 6), 
    Ingredient("goldnugget", 3), 
    Ingredient("cutstone", 14)
}

if GetModConfigData("recipeCost") == "cheap" then
    RecipeIngredients = {
        Ingredient("log", 3), 
        Ingredient("goldnugget", 1), 
        Ingredient("cutstone", 5)
		}
elseif GetModConfigData("recipeCost") == "expensive" then
    RecipeIngredients = {
        Ingredient("log", 9), 
        Ingredient("goldnugget", 6), 
        Ingredient("cutstone", 20)
		}
end


AddRecipe("deluxe_firepit", RecipeIngredients, 
				RECIPETABS.LIGHT, TECH.SCIENCE_TWO, 
				"deluxe_firepit_placer",
				nil,	nil, 	nil, 	nil,       "images/inventoryimages/deluxe_firepit.xml" , "deluxe_firepit.tex" )	
	--

--ENDO FIREPIT (renamed to Blue Firepit for DST) 

	-- ENDO Firepit dialog
		GLOBAL.STRINGS.NAMES.ENDO_FIREPIT = "Deluxe Endothermic Fire"
		STRINGS.RECIPE_DESC.ENDO_FIREPIT = "Amazing! Both COLD and Efficient!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "This will be perfect for the summer!",
					EMBERS = "Only a little light left, and I'm starting to warm up already.",
					LOW = "Just enough cooling... maybe more would be better!",
					NORMAL = "The blue flame is so entoxicating...",
					HIGH = "Stand back - you could get hypothermia from that flame!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "I NEED TO REBOOT IT!",
					EMBERS = "IT'S ALMOST OUT! TEMPERATURE RISING!",
					LOW = "SUFFICIENTLY COOLING",
					NORMAL = "IT IS IDEAL FOR SUMMER TIME",
					HIGH = "WARNING: FREEZING IMMINENT!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Is all kaput!",
					EMBERS = "Is almost kaput!",
					LOW = "Is cooling me just enough...",
					NORMAL = "Mighty blue flame!!",
					HIGH = "Fire is too mighty! This level of cooling is unnatural.",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Cold??!! Fires should ONLY be hot!",
					EMBERS = "A pathetic cold blue flame...",
					LOW = "This is adequate.",
					NORMAL = "The blue flames are looking good... and cooling me nicely.",
					HIGH = "HAHAHAHAHAHAHA! Perfection! Maybe fires can be COLD...",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "At least it still looks nice.",
					EMBERS = "I should probably add more fuel",
					LOW = "This will serve my purposes nicely.",
					NORMAL = "Perfect... for the summer time!!",
					HIGH = "Even I should probably stand back from that flame!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Cold fires aren't in any of my books, I wonder how it works...",
					EMBERS = "A stable, if not small state.",
					LOW = "This cooling fire is perfect for my needs.",
					NORMAL = "This fire is amazing, I need to update my journal.",
					HIGH = "I think I made it TOO good!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "It doesn't look very impressive...",
					EMBERS = "Cold and blue - just like my soul.",
					LOW = "This will do for now.",
					NORMAL = "Any protection from that sun is a blessing.",
					HIGH = "Its colder than my heart!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "Lucy, we need to fuel this fire.",
					EMBERS = "Hey Lucy, look how small that flame has got...",
					LOW = "We are at least protected from the suns constant heat.",
					NORMAL = "This level of cooling is just right for both of us...",
					HIGH = "Lucy, stay back from the flames... they could freeze your soul!",
				}


			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ENDO_FIREPIT  =
					{
						OUT = "Oofën ägäïn!.",
						EMBERS = "Ëvën thë mëät is offëndëd by this wëäk firë!",
						LOW = "This is Okäy.",
						NORMAL = "Thor himsëlf woüld bë proüd of this firë!",
						HIGH = "Ëvën the grëät and mighty Thor woüld bë scärëd of this firë!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.ENDO_FIREPIT  =
					{
						OUT = "All gone!",
						EMBERS = "Small, blue and little cooling.",
						LOW = "We can tolerate this.",
						NORMAL = "Now this is just what we needed.",
						HIGH = "We think it wise to stay back.",
					}
					
			GLOBAL.STRINGS.CHARACTERS.WARLY.DESCRIBE.ENDO_FIREPIT  =
				{
					EMBERS = "I should stoke the fire.",
					GENERIC = "Fire that cools?",
					HIGH = "The flames climb higher!",
					LOW = "It's getting low.",
					NORMAL = "I should like to sit by you for a moment.",
					OUT = "I will have to light you again.",
				}
			GLOBAL.STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.ENDO_FIREPIT  =
				{
					EMBERS ="Almost gone",
					HIGH ="Pretty",
					LOW = "Getting warmer",
					NORMAL = "Cooling",
					OUT ="Needs food",
				}
				
		    GLOBAL.STRINGS.CHARACTERS.WINONA.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "I oughta fire it back up.",
					EMBERS = "It's almost gone cold.",
					LOW = "It's not gonna last much longer.",
					NORMAL = "It's doin' alright.",
					HIGH = "Not quite frozen steel, but still pretty cold!",
				}

            GLOBAL.STRINGS.CHARACTERS.WORTOX.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "And out it goes.",
					EMBERS = "Soon to be ashes to the wind.",
					LOW = "With flames so small, no cold to cool us all!",
					NORMAL = "A brrrrrisk flame this one be!",
					HIGH = "Burrrrrrning Brrrrrrightly this fire is! Brrrrrr!",
				}
				
--			GLOBAL.STRINGS.CHARACTERS.WALTER.DESCRIBE.ENDO_FIREPIT  =
--				{
--					EMBERS = "",
--					HIGH = "",
--					LOW = "",
--					NORMAL = "",
--					OUT = "",
--				}
--				
			GLOBAL.STRINGS.CHARACTERS.WURT.DESCRIBE.ENDO_FIREPIT  =
				{
					OUT = "It out.",
					EMBERS = "Fancy cold fire dying.",
					LOW = "Fancy cold fire getting small.",
					NORMAL = "Fancy chilly fire?",
					HIGH = "Time for story-tell around fancy chilly fire, florp!",

				}


	-- Endo Firepit config opions
		GLOBAL.deluxeEndoFirepitBurnRate = GetModConfigData("deluxeEndoFirepitBurnRate")
		GLOBAL.endoDropLoot = GetModConfigData("endoDropLoot")
	--

	-- Endo firepit Recipe

		-- standard cost
		
local RecipeIngredients = {
    Ingredient("cutstone", 14), 
    Ingredient("transistor", 2), 
    Ingredient("nitre", 4)
}

if GetModConfigData("recipeCost") == "cheap" then
    RecipeIngredients = {
        Ingredient("cutstone", 5), 
        Ingredient("transistor", 1), 
        Ingredient("nitre", 2)
		}
elseif GetModConfigData("recipeCost") == "expensive" then
    RecipeIngredients = {
        Ingredient("cutstone", 20), 
        Ingredient("transistor", 4), 
        Ingredient("nitre", 9)
		}
end


AddRecipe("endo_firepit", RecipeIngredients, 
				RECIPETABS.LIGHT, TECH.SCIENCE_TWO, 
				"endo_firepit_placer",
				nil,	nil, 	nil, 	nil,        "images/inventoryimages/endo_firepit.xml" , "endo_firepit.tex" )	
		



--HEAT STAR

	-- Heat Star dialog
		GLOBAL.STRINGS.NAMES.HEAT_STAR = "Star of Anchiale"
		STRINGS.RECIPE_DESC.HEAT_STAR = "Create your very own Sun!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEAT_STAR  =
				{
					OUT = "It looks amazing, now how do I activate it again?",
					EMBERS = "I still can't believe its a star! Quick, better feed it some more.",
					LOW = "Looks pretty small now.",
					NORMAL = "I think its safe...",
					HIGH = "Its like the Sun.... only RIGHT next to me... WOW IT'S HOT!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.HEAT_STAR  =
				{
					OUT = "SYSTEM ERROR 243: STAR OF ANCHIALE - NO DATA;",
					EMBERS = "CRITICAL ERROR: QUANTUM FLUX CANNOT BE NEGATIVE: UNABLE TO COMPUTE!",
					LOW = "CAUTION: INVERTED ATOMIC WAVES COULD BE UNSTABLE",
					NORMAL = "CAUTION: STABLILTY OF GRAVITY WELL UNKNOWN",
					HIGH = "WARNING: EXCEEDING SPECIFIED LIMITS",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HEAT_STAR  =
				{
					OUT = "??!!!?!??",
					EMBERS = "He demands too much!",
					LOW = "Small and feeble star - pffft!!",
					NORMAL = "Incredible!!",
					HIGH = "How can anything be more impressive than my mighty physique!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.HEAT_STAR  =
				{
					OUT = "I can't wait to activate its glory!",
					EMBERS = "This star looks pathetic!",
					LOW = "What a lovely sight, but I know it can be bigger!",
					NORMAL = "This is the best thing ever!!",
					HIGH = "I think I'm in love!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Beautifully detailed in every respect.",
					EMBERS = "This won't do at all!!",
					LOW = "This will serve my purposes nicely.",
					NORMAL = "Simply amazing!",
					HIGH = "I should really take a few steps back, that heat is phenominal!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HEAT_STAR  =
				{
					OUT = "The 'Star of Anchiale' is not in any of my books?",
					EMBERS = "This is barely a Star at all...",
					LOW = "Someone should document this phenomenon",
					NORMAL = "Amazing and scary, at least it is keeping me warm.",
					HIGH = "This contradicts all of the Laws of Physics!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.HEAT_STAR  =
				{
					OUT = "The engraving on the base reads 'The Spirit of Anchiale will never be cold'",
					EMBERS = "No, don't go spirit!!",
					LOW = "Abigail has a companion, but I need to refuel it to keep it alive.",
					NORMAL = "Another spirit to keep me and Abigail warm and secure.",
					HIGH = "I must have done something to enrage this spirit. Stop you're scaring me!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Lucy, This doesn't look safe...",
					EMBERS = "It doesn't look very powerful any more Lucy...",
					LOW = "A minuature star, well Lucy I have now seen everything!",
					NORMAL = "Hey Lucy, I wonder how it hovers like that?",
					HIGH = "Lucy, stay back... It looks like its going to explode!",
				}

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HEAT_STAR  =
					{
						OUT = "Oofën ägäïn!",
						EMBERS = "Ëvën thë mëät is offëndëd by yoür wëäknëss!",
						LOW = "Cäll yoürsëlf ä Star? I'vë sëën mätchës strongër thän yoü!!",
						NORMAL = "Odin himsëlf woüld bë proüd of yoür powër spirit.",
						HIGH = "Mighty Spirit - You'rë powër is grëätër thän I ëvër imaginëd!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.HEAT_STAR  =
					{
						OUT = "The glowy, burny thing comes out of here...",
						EMBERS = "We need to make it more glowy and burny!",
						LOW = "We've seen this much brighter, more fuel is required!!",
						NORMAL = "Now this is just what we needed - a big burny sun in our base camp.",
						HIGH = "We hope it can't get any bigger!!",
					}
				GLOBAL.STRINGS.CHARACTERS.WARLY.DESCRIBE.HEAT_STAR  =
				{
					EMBERS = "That star's almost out!",
					GENERIC = "To warm my fingers and roast sausages.",
					HIGH = "Maximum heat!",
					LOW = "It's getting low.",
					NORMAL = "Parfait.",
					OUT = "I like when it's warm and toasty.",
				}
			GLOBAL.STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.HEAT_STAR  =
				{
					OUT = "Light ball gone",
					EMBERS = "No! Don't go light ball!",
					LOW = "Light ball get weak",
					NORMAL = "Light ball?",
					HIGH = "Light ball too big!",
				}
			GLOBAL.STRINGS.CHARACTERS.WINONA.DESCRIBE.HEAT_STAR  =
				{
					OUT = "It still looks neat enough even when it's out.",
					EMBERS = "It's soon to expire.",
					LOW = "No time to waste gazing at a star.",
					NORMAL = "As hot as a tin smelter in July that.",
					HIGH = "Yeesh! That puts a tin smelter to shame!",
				}

            GLOBAL.STRINGS.CHARACTERS.WORTOX.DESCRIBE.HEAT_STAR  =
				{
					OUT = "And out it goes.",
					EMBERS = "Nothing more then a wee little fireball now.",
					LOW = "Much more bearable for my wee impish eyes.",
					NORMAL = "My poor imp eyes hurt at its sight!",
					HIGH = "I see the flame dimension!",
				}
				
--			GLOBAL.STRINGS.CHARACTERS.WALTER.DESCRIBE.HEAT_STAR  =
--				{
--					EMBERS = "",
--					HIGH = "",
--					LOW = "",
--					NORMAL = "",
--					OUT = "",
--				}
--				
			GLOBAL.STRINGS.CHARACTERS.WURT.DESCRIBE.HEAT_STAR  =
				{
					EMBERS = "Hot ball fading!",
					HIGH = "Too hot! Flurp!",
					LOW = "Hot ball getting small.",
					NORMAL = "A hot ball?",
					OUT = "Hot ball looks fancy even out, flurp.",
				}

	-- Heat Star config opions
		GLOBAL.heatStarBurnRate = GetModConfigData("heatStarBurnRate")
		GLOBAL.heatStarDropLoot = GetModConfigData("heatStarDropLoot")
		GLOBAL.heatStar_starsSpawnHounds = GetModConfigData("starsSpawnHounds")
		
local RecipeIngredients = {
    Ingredient("transistor", 2), 
    Ingredient("cutstone", 30), 
    Ingredient("redgem", 1)
}

if GetModConfigData("recipeCost") == "cheap" then
    RecipeIngredients = {
        Ingredient("transistor", 1), 
        Ingredient("cutstone", 5), 
        Ingredient("redgem", 1)
		}
elseif GetModConfigData("recipeCost") == "expensive" then
    RecipeIngredients = {
        Ingredient("transistor", 5), 
        Ingredient("cutstone", 40), 
        Ingredient("redgem", 2)
		}
end


AddRecipe("heat_star", RecipeIngredients, 
				RECIPETABS.LIGHT, TECH.SCIENCE_TWO, 
				"heat_star_placer",
				nil,	nil, 	nil, 	nil,       "images/inventoryimages/heat_star.xml" , "heat_star.tex" )

--
---------------------------------------------------


---------------------------------------------------
--  Coolers (Only available in RoG DLC)
---------------------------------------------------

--ICE STAR

--	if (GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)) then 

	-- Ice Star dialog
		GLOBAL.STRINGS.NAMES.ICE_STAR = "Star of Boreas"
		STRINGS.RECIPE_DESC.ICE_STAR = "Create an Star made of ICE!!"
	 
		
		GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICE_STAR  =
				{
					OUT = "It looks cold, now how do I activate it again?",
					EMBERS = "I still can't believe its an Ice star!  I wonder what happens when it goes out?!",
					LOW = "Looks pretty small now, can't believe its still so COLD!",
					NORMAL = "Thank you Giant Star... This level of cooling is perfect!",
					HIGH = "A massive ball of ice.. This truly cannot be safe! IT'S SOOO COLD!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WX78.DESCRIBE.ICE_STAR  =
				{
					OUT = "SYSTEM ERROR 243: STAR OF BOREAS - NO DATA;",
					EMBERS = "CRITICAL ERROR: QUANTUM NEGATIVITY : UNABLE TO COMPUTE!",
					LOW = "CAUTION: INVERTED ATOMIC WAVES COULD BE UNSTABLE",
					NORMAL = "COOLING AT ACCEPTABLE LEVELS",
					HIGH = "WARNING: EXCEEDING QUANTUM LIMITS",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ICE_STAR  =
				{
					OUT = "??!!!?!??",
					EMBERS = "She demands too much!",
					LOW = "I would be better off fanning myself with a toothpick!!",
					NORMAL = "Just what I needed on a hot Summers day!!",
					HIGH = "How can anything be more impressive than my mighty physique!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WILLOW.DESCRIBE.ICE_STAR  =
				{
					OUT = "This is an abomination!! Flames should always BE HOT!!",
					EMBERS = "This star looks pathetic! and blue, YUK!",
					LOW = "I hate the stars blue flames, it's not natural!",
					NORMAL = "Pffft... What's the point of a cold star anyway?!!",
					HIGH = "Now you're just showing off!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ICE_STAR  =
				{
					OUT = "Beautifully detailed in every respect",
					EMBERS = "This won't do at all!!",
					LOW = "This will serve my purposes nicely.",
					NORMAL = "Simply amazing!  That takes the heat away nicely",
					HIGH = "I should really take a few steps back, that could freeze another World?!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ICE_STAR  =
				{
					OUT = "The 'Star of Boreas' is not in any of my books?",
					EMBERS = "This is barely a Star at all...",
					LOW = "Someone should document this phenomenon.",
					NORMAL = "How can this thing be cooling me down so nicely??",
					HIGH = "This contradicts all of the Laws of Physics!  On so many levels!!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WENDY.DESCRIBE.ICE_STAR  =
				{
					OUT = "The engraving on the base reads 'The Spirit of Boreas will freeze your bones'",
					EMBERS = "No, don't go spirit!!",
					LOW = "Abigail has a companion, but I need to refuel it to keep it alive.",
					NORMAL = "I feel very chilled!",
					HIGH = "I must have done something to enrage this spirit. Stop... you're scaring me!",
				}

		 GLOBAL.STRINGS.CHARACTERS.WOODIE.DESCRIBE.ICE_STAR  =
				{
					OUT = "Lucy, I don't trust it...",
					EMBERS = "It doesn't look very powerful any more Lucy...",
					LOW = "A minuature star, well Lucy I have now seen everything!",
					NORMAL = "Hey Lucy, I wonder how it hovers like that?",
					HIGH = "Lucy, get back... It looks like its going to implode!",
				}

			GLOBAL.STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ICE_STAR  =
					{
						OUT = "Oofën ägäïn!",
						EMBERS = "Ëvën thë mëät is offëndëd by yoür wëäknëss!",
						LOW = "Cäll yoürsëlf än ice Star? I'vë bëën in säünäs coldër thän yoü!!",
						NORMAL = "I süpposë this mäkës Sümmër bärëäblë",
						HIGH = "Mighty Spirit - You'rë powër is grëätër thän I ëvër imaginëd!!",
					}


			 GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.ICE_STAR  =
					{
						OUT = "The freezy, bluey thing comes out of here...",
						EMBERS = "We need to make it more freezy!",
						LOW = "We've seen this much brighter, its barely cooling us down at all!",
						NORMAL = "This is just what we needed after being out in the heat all day.",
						HIGH = "It's like Winter... IN SUMMER!!!",
					}
					
			GLOBAL.STRINGS.CHARACTERS.WARLY.DESCRIBE.ICE_STAR  =
				{
					EMBERS = "I should fuel that star.",
					GENERIC = "An icy star?",
					HIGH = "The star grows larger!",
					LOW = "It's getting low.",
					NORMAL = "I should like to sit by you for a moment.",
					OUT = "I will have to light you again.",
				}
				
			GLOBAL.STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.ICE_STAR  =
				{
					OUT = "Chilly Light ball gone",
					EMBERS = "Chilly light ball almost gone",
					LOW = "Chilly Light Ball get weak",
					NORMAL = "Chilly Light Ball?",
					HIGH = "Light Ball too cold!",
				}
				
			GLOBAL.STRINGS.CHARACTERS.WINONA.DESCRIBE.ICE_STAR  =
				{
					OUT = "Still looks pretty nifty when its out.",
					EMBERS = "It's soon to expire.",
					LOW = "A pretty sight that, it wont last long though.",
					NORMAL = "As cold as frozen steel!",
					HIGH = "It would freeze a storeroom of steel in seconds.",
				}

            GLOBAL.STRINGS.CHARACTERS.WORTOX.DESCRIBE.ICE_STAR  =
				{
					OUT = "And out it goes.",
					EMBERS = "Soon to be cold air.",
					LOW = "It gives a low chilly chill chill.",
					NORMAL = "So cold, so cold! So very uncomforting!",
					HIGH = "I see the frost dimension!",
				}

--			GLOBAL.STRINGS.CHARACTERS.WALTER.DESCRIBE.ICE_STAR  =
--				{
--					EMBERS = "",
--					HIGH = "",
--					LOW = "",
--					NORMAL = "",
--					OUT = "",
--				}
--				
			GLOBAL.STRINGS.CHARACTERS.WURT.DESCRIBE.ICE_STAR  =
				{
					EMBERS = "Cold ball fading!",
					HIGH = "Too cold! Flurp!",
					LOW = "Cold ball getting small.",
					NORMAL = "A cold ball?",
					OUT = "Cold ball looks fancy even out, flurp.",
				}

	-- Ice Star config opions
		GLOBAL.iceStarBurnRate = GetModConfigData("iceStarBurnRate")
		GLOBAL.iceStarDropLoot = GetModConfigData("iceStarDropLoot")
		GLOBAL.iceStar_starsSpawnHounds = GetModConfigData("starsSpawnHounds")
		
local RecipeIngredients = {
    Ingredient("transistor", 2), 
    Ingredient("cutstone", 30), 
    Ingredient("bluegem", 1)
}

if GetModConfigData("recipeCost") == "cheap" then
    RecipeIngredients = {
        Ingredient("transistor", 1), 
        Ingredient("cutstone", 5), 
        Ingredient("bluegem", 1)
		}
elseif GetModConfigData("recipeCost") == "expensive" then
    RecipeIngredients = {
        Ingredient("transistor", 5), 
        Ingredient("cutstone", 40), 
        Ingredient("bluegem", 2)
		}
end


AddRecipe("ice_star", RecipeIngredients, 
				RECIPETABS.LIGHT, TECH.SCIENCE_TWO, 
				"ice_star_placer",
				nil,	nil, 	nil, 	nil,       "images/inventoryimages/ice_star.xml" , "ice_star.tex" )
				