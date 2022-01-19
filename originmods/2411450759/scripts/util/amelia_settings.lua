--localized variables
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.amelia = "Time Traveling Detective"
STRINGS.CHARACTER_NAMES.amelia = "Amelia Watson"
STRINGS.CHARACTER_DESCRIPTIONS.amelia = [[
󰀏 Is a time traveller
󰀙 Has special ground pounding move
󰀃 Bubba is here with her
    ]]
STRINGS.CHARACTER_QUOTES.amelia = "*HIC*"
STRINGS.CHARACTER_SURVIVABILITY.amelia = "Almost died many times"

-- Your character's stats
TUNING.AMELIA_HEALTH = GetModConfigData("amelia_health")
TUNING.AMELIA_HUNGER = GetModConfigData("amelia_hunger")
TUNING.AMELIA_SANITY = GetModConfigData("amelia_sanity")
TUNING.AMELIA_HUNGER_RATE = GetModConfigData("amelia_hunger_rate")

TUNING.AMELIA_MS = GetModConfigData("amelia_speed")
TUNING.AMELIA_DPS = GetModConfigData("amelia_dmg")

-- Time Leap
TUNING.AMELIA_WATCH_RECIPE = GetModConfigData("amelia_watch_recipe")
TUNING.AMELIA_WATCH_TIMELEAP_SECS = GetModConfigData("amelia_watch_timeleap_secs")
TUNING.AMELIA_WATCH_MAX_USES = GetModConfigData("amelia_watch_max_uses")
-- TUNING.AMELIA_WATCH_SANITY_COST = GetModConfigData("amelia_watch_sanity_cost")

-- Watson Concoction
TUNING.WATSON_CONCOCTION_RECIPE = GetModConfigData("watson_concoction_recipe")
TUNING.WATSON_CONCOCTION_DURATION = GetModConfigData("watson_concoction_duration")
TUNING.WATSON_CONCOCTION_FILTER = GetModConfigData("watson_concoction_filter")

-- Watson Concoction - Buffs
TUNING.WATSON_CONCOCTION_ATTACK_MULTIPLIER = GetModConfigData("watson_concoction_attack_multiplier")
TUNING.WATSON_CONCOCTION_ABSORPTION_MODIFIER = GetModConfigData("watson_concoction_absorption_modifier")
TUNING.WATSON_CONCOCTION_MS_BUFF = GetModConfigData("watson_concoction_movespeed_buff")
TUNING.WATSON_CONCOCTION_HEALTH_REGEN_AMOUNT = GetModConfigData("watson_concoction_health_regen_amount")
TUNING.WATSON_CONCOCTION_SANITY_REGEN_AMOUNT = GetModConfigData("watson_concoction_sanity_regen_amount")

-- Watson Concoction - Side Effects
TUNING.WATSON_CONCOCTION_TOTAL_POISON_DPS = GetModConfigData("watson_concoction_total_poison_dps")
TUNING.WATSON_CONCOCTION_HEADACHE_SANITY_DAMAGE = GetModConfigData("watson_concoction_headache_sanity_damage")
TUNING.WATSON_CONCOCTION_SWEAT_MOISTURE_PER_SEC = GetModConfigData("watson_concoction_sweat_moisture_per_sec")
TUNING.WATSON_CONCOCTION_STOMACHACHE_HUNGER_DAMAGE = GetModConfigData("watson_concoction_stomachache_hunger_damage")
TUNING.WATSON_CONCOCTION_STOMACHACHE_ON_EAT_DAMAGE = GetModConfigData("watson_concoction_stomachache_on_eat_damage")
TUNING.WATSON_CONCOCTION_DROWSINESS_ENABLE = GetModConfigData("watson_concoction_drowsiness_enable")

-- Magnifying glass

TUNING.AMELIA_MAGNIFYING_GLASS_DUR = GetModConfigData("amelia_magnifying_glass_dur")


-- Groundpound
TUNING.AMELIA_GROUNDPOUND_KEY = GetModConfigData("amelia_groundpound_key")
TUNING.AMELIA_GROUNDPOUND_DMG_MULTI = GetModConfigData("amelia_groundpound_dmg_multi")
TUNING.AMELIA_GROUNDPOUND_RADIUS = GetModConfigData("amelia_groundpound_radius")
TUNING.AMELIA_GROUNDPOUND_HUNGER_COST = GetModConfigData("amelia_groundpound_hunger_cost")
TUNING.AMELIA_GROUNDPOUND_DESTROY_STRUCTURE_ENABLED = GetModConfigData("amelia_groundpound_destroy_structure_enabled")

-- Bubba
TUNING.BUBBA_DIG_ENABLED = GetModConfigData("bubba_dig_enabled")
TUNING.BUBBA_DIG_CHANCE = GetModConfigData("bubba_dig_chance")
TUNING.BUBBA_DIG_CHECK_CD = GetModConfigData("bubba_dig_cooldown")

-- Toxic gamer
TUNING.AMELIA_SALT_DROPRATE_ATTACKED = GetModConfigData("amelia_salt_droprate_attacked")
TUNING.AMELIA_SANITY_PENALTY_ON_SALT = GetModConfigData("amelia_sanity_penalty_on_salt")
TUNING.AMELIA_TOXIC_GAMER_LINES_ENABLED = GetModConfigData("amelia_toxic_gamer_lines_enabled")


-- Voice
TUNING.AMELIA_VOICE = GetModConfigData("amelia_voice")
-- Cosmetics
TUNING.AMELIA_HIDDEN = GetModConfigData("amelia_clothes")

-- Ids
TUNING.AMELIA_MODNAME = modname

-- The character's and prefabs' names as appears in-game 
STRINGS.NAMES.AMELIA = "Amelia Watson"
STRINGS.SKIN_NAMES.amelia_none = "Amelia Watson"
STRINGS.SKIN_DESCRIPTIONS.amelia_none = "With Hat and Coat"

STRINGS.SKIN_NAMES.amelia_shadow = "Amelia Watson"
STRINGS.SKIN_QUOTES.amelia_shadow = "\"Nothing beats a Ground Pound!\""
STRINGS.SKIN_DESCRIPTIONS.amelia_shadow = "No Hat and Coat"

GLOBAL.STRINGS.ACTIONS.CASTSPELL.TIMELEAP = "Time leap"

-- Custom speech strings
STRINGS.CHARACTERS.AMELIA= require "speech_amelia"

--Items' names and descriptions
STRINGS.NAMES.AMELIA_WATCH = "Time Traveller's Watch"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMELIA_WATCH = "A luxury pocket watch."
STRINGS.CHARACTERS.AMELIA.DESCRIBE.AMELIA_WATCH = "Time for some nostalgia trip."
STRINGS.RECIPE_DESC.AMELIA_WATCH = "When I was a kid..."

STRINGS.NAMES.WATSON_CONCOCTION = "Watson Concoction"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATSON_CONCOCTION = "That looks suspicious."
STRINGS.CHARACTERS.AMELIA.DESCRIBE.WATSON_CONCOCTION = "This might hurt a little bit."
STRINGS.RECIPE_DESC.WATSON_CONCOCTION = "Make you see things."

STRINGS.NAMES.AMELIA_MAGNIFYING_GLASS = "Amelia's Magnifying glass"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AMELIA_MAGNIFYING_GLASS = "It's Ame's magnifying glass!"
STRINGS.CHARACTERS.AMELIA.DESCRIBE.AMELIA_MAGNIFYING_GLASS = "I'm here to investigate!"
STRINGS.RECIPE_DESC.AMELIA_MAGNIFYING_GLASS = "Time to investigate!"
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_AMELIA_MAGNIFYING_GLASS = "The glass broke!"

--Mob names
STRINGS.NAMES.BUBBA = "Bubba"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BUBBA = "It's Amelia's pet."
STRINGS.CHARACTERS.AMELIA.DESCRIBE.BUBBA = "I'm glad you are here with me, Bubba."


-- Custom starting inventory
TUNING.AMELIA_STARTING_ITEMS = GetModConfigData("amelia_starting")
if TUNING.AMELIA_STARTING_ITEMS == 1 then
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.AMELIA = {
        "amelia_watch",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["amelia_watch"] = 
    {
        atlas = "images/inventoryimages/amelia_watch_icon.xml",
        image = "amelia_watch_icon.tex",
    }
elseif TUNING.AMELIA_STARTING_ITEMS == 2 then
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.AMELIA = {
        "amelia_watch",
        "watson_concoction",
        "watson_concoction",
        "watson_concoction",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["amelia_watch"] = 
    {
        atlas = "images/inventoryimages/amelia_watch_icon.xml",
        image = "amelia_watch_icon.tex",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["watson_concoction"] = 
    {
        atlas = "images/inventoryimages/watson_concoction.xml",
        image = "watson_concoction.tex",
    }
else
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.AMELIA = {
    }
end

