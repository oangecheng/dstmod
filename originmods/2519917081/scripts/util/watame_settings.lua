--localized variables
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local TUNING = GLOBAL.TUNING

-- The character select screen lines
STRINGS.CHARACTER_TITLES.watame = "The Bard Sheep"
STRINGS.CHARACTER_NAMES.watame = "Tsunomaki Watame"
STRINGS.CHARACTER_DESCRIPTIONS.watame = [[
    󰀧 Watame night fever
    󰀉 Respawn every 8 seconds
    󰀞 Growing wools
    ]]
-- STRINGS.CHARACTER_SURVIVABILITY.watame = "わため程度"
STRINGS.CHARACTER_SURVIVABILITY.watame = "Lamb"

-- Basic stats
TUNING.WATAME_HEALTH = GetModConfigData("watame_health")
TUNING.WATAME_HUNGER = GetModConfigData("watame_hunger")
TUNING.WATAME_SANITY = GetModConfigData("watame_sanity")
TUNING.WATAME_HUNGER_RATE = GetModConfigData("watame_hunger_rate")
TUNING.WATAME_MS = GetModConfigData("watame_speed")
TUNING.WATAME_DPS = GetModConfigData("watame_dmg")

TUNING.WATAME_VOICE = GetModConfigData("watame_voice")

-- Perk stats
-- Watame's Auto-Respawn
TUNING.WATAME_AUTO_RESPAWN_DELAY = GetModConfigData("watame_auto_respawn_delay")
TUNING.WATAME_AUTO_RESPAWN_FREQUENCY = GetModConfigData("watame_auto_respawn_frequency")
TUNING.ENABLE_WATAME_AUTO_RESPAWN = GetModConfigData("enable_watame_auto_respawn")

-- Watame Shogun Helm
TUNING.WATAME_SHOGUN_RECIPE = 0
TUNING.WATAME_SHOGUN_ATK_BUFF = GetModConfigData("watame_shogun_atk_buff")
TUNING.WATAME_SHOGUN_DURABILITY = GetModConfigData("watame_shogun_durability") 
TUNING.WATAME_SHOGUN_ABSORPTION = GetModConfigData("watame_shogun_absoption")
TUNING.WATAME_SHOGUN_COLD_INSULATION = GetModConfigData("watame_shogun_cold_insulation")

-- Watame Katana
TUNING.WATAME_KATANA_RECIPE = 0
TUNING.WATAME_KATANA_ATK_DAMAGE = GetModConfigData("watame_katana_atk_damage")
TUNING.WATAME_KATANA_CRIT_MULTI = GetModConfigData("watame_katana_crit_multi1")
TUNING.WATAME_KATANA_CRIT_CHANCE = GetModConfigData("watame_katana_crit_chance1")
TUNING.ENABLE_WATAME_KATANA_CRIT_SHOGUN_SET = GetModConfigData("enable_watame_katana_crit_shogun_set")
TUNING.WATAME_KATANA_USAGE = GetModConfigData("watame_katana_usage")

-- Others
TUNING.WATAME_IMMUNE_TO_COLD = GetModConfigData("watame_immune_to_cold")
TUNING.WATAME_VOICE = GetModConfigData("watame_voice")
TUNING.WATAME_HIDDEN = GetModConfigData("watame_clothes")
TUNING.WATAME_GOD_MODE = GetModConfigData("watame_god_mode")

-- Ids
TUNING.MODNAME = modname

-- Language settings
TUNING.WATAME_LANGUAGE = GetModConfigData("watame_language")

if TUNING.WATAME_LANGUAGE == "AUTO" then
    if tostring(GLOBAL.LanguageTranslator.defaultlang) == "ja" or GLOBAL.Profile:GetLanguageID() == 20 then
        TUNING.WATAME_LANGUAGE = "JP"
    elseif GLOBAL.Profile:GetLanguageID() == 21 or GLOBAL.Profile:GetLanguageID() == 22 or GLOBAL.Profile:GetLanguageID() == 23 then
        TUNING.WATAME_LANGUAGE = "CN"
    else
        TUNING.WATAME_LANGUAGE = "EN"
    end
end

-- Custom speech strings
STRINGS.CHARACTERS.WATAME = require "lang/speech_watame_jp"

-- The character's and prefabs' names as appears in-game 
STRINGS.NAMES.WATAME = "角巻わため"
STRINGS.CHARACTER_QUOTES.watame = "\"わためは悪くないよね？\""

STRINGS.SKIN_NAMES.watame_none = "角巻わため"
STRINGS.SKIN_DESCRIPTIONS.watame_none = "吟遊詩羊 (ZeroRyuk ver.)"

STRINGS.SKIN_NAMES.watame_shadow = "角巻わため"
STRINGS.SKIN_QUOTES.watame_shadow = "\"わためは悪くないよね？\""
STRINGS.SKIN_DESCRIPTIONS.watame_shadow = "吟遊詩羊 (Staly ver.)"

--Items' names and descriptions
STRINGS.NAMES.WATAME_SHOGUN = "わため将軍カブト"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATAME_SHOGUN = "何か羊の匂いがする。" 
STRINGS.CHARACTERS.WATAME.DESCRIBE.WATAME_SHOGUN = "角ドリルしたろうか？"
STRINGS.RECIPE_DESC.WATAME_SHOGUN = "角ドリル作ってあげろうか？"

STRINGS.NAMES.WATAME_KATANA = "わための刀剣"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATAME_KATANA = "格好いいな！" 
STRINGS.CHARACTERS.WATAME.DESCRIBE.WATAME_KATANA = "斬るユー！"
STRINGS.RECIPE_DESC.WATAME_KATANA = "時にクリティカルヒットをする刀剣"

if TUNING.WATAME_LANGUAGE == "EN" then
    -- Custom speech strings
    STRINGS.CHARACTERS.WATAME = require "lang/speech_watame"

    -- The character's and prefabs' names as appears in-game 
    STRINGS.NAMES.WATAME = "Tsunomaki Watame"
    STRINGS.CHARACTER_QUOTES.watame = "\"Watame did nothing wrong.\""

    STRINGS.SKIN_NAMES.watame_none = "Tsunomaki Watame"
    STRINGS.SKIN_DESCRIPTIONS.watame_none = "Bard Sheep (ZeroRyuk ver.)"

    STRINGS.SKIN_NAMES.watame_shadow = "Tsunomaki Watame"
    STRINGS.SKIN_QUOTES.watame_shadow = "\"Watame did nothing wrong.\""
    STRINGS.SKIN_DESCRIPTIONS.watame_shadow = "Bard Sheep (Staly ver.)"

    STRINGS.SKIN_NAMES.watame_victorian = "Tsunomaki Watame"
    STRINGS.SKIN_QUOTES.watame_victorian = "\"Watame Night Fever!\""
    STRINGS.SKIN_DESCRIPTIONS.watame_victorian = "Party Sheep"

    --Items' names and descriptions
    STRINGS.NAMES.WATAME_SHOGUN = "Watame Shogun Helm"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATAME_SHOGUN = "This smells like a sheep." 
    STRINGS.CHARACTERS.WATAME.DESCRIBE.WATAME_SHOGUN = "You wanna eat my horn drill?"
    STRINGS.RECIPE_DESC.WATAME_SHOGUN = "Get your own horn drill"

    STRINGS.NAMES.WATAME_KATANA = "Watame's Katana"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATAME_KATANA = "This looks so cool!" 
    STRINGS.CHARACTERS.WATAME.DESCRIBE.WATAME_KATANA = "KILL YOU!"
    STRINGS.RECIPE_DESC.WATAME_KATANA = "Critical hit by chance"

elseif TUNING.WATAME_LANGUAGE == "CN" then  -- TODO: Watiing for CN translation
    -- Custom speech strings
    STRINGS.CHARACTERS.WATAME = require "lang/speech_watame_cn"
    
    -- The character's and prefabs' names as appears in-game 
    STRINGS.NAMES.WATAME = "角卷綿芽"
    STRINGS.CHARACTER_QUOTES.watame = "\"這不是綿芽的錯對吧？\""

    STRINGS.SKIN_NAMES.watame_none = "角卷綿芽"
    STRINGS.SKIN_DESCRIPTIONS.watame_none = "吟遊詩羊 (ZeroRyuk ver.)"

    STRINGS.SKIN_NAMES.watame_shadow = "角卷綿芽"
    STRINGS.SKIN_QUOTES.watame_shadow = "\"這不是綿芽的錯對吧？\""
    STRINGS.SKIN_DESCRIPTIONS.watame_shadow = "吟遊詩羊 (Staly ver.)"

    --Items' names and descriptions
    STRINGS.NAMES.WATAME_SHOGUN = "綿芽的將軍頭盔"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATAME_SHOGUN = "聞起來有股羊騷味。" 
    STRINGS.CHARACTERS.WATAME.DESCRIBE.WATAME_SHOGUN = "想嘗嘗我羊角的威力嗎？"
    STRINGS.RECIPE_DESC.WATAME_SHOGUN = "屬於你自己的羊角鑽頭。"

    STRINGS.NAMES.WATAME_KATANA = "綿芽的武士刀"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.WATAME_KATANA = "看起來很酷！" 
    STRINGS.CHARACTERS.WATAME.DESCRIBE.WATAME_KATANA = "把你砍飛！"
    STRINGS.RECIPE_DESC.WATAME_KATANA = "機率性爆擊的優良武器。"
end

-- Custom starting inventory
TUNING.WATAME_STARTING_ITEMS = GetModConfigData("watame_starting")

if TUNING.WATAME_STARTING_ITEMS == 1 then
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WATAME = {
    }
elseif TUNING.WATAME_STARTING_ITEMS == 2 then
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WATAME = {
        "watame_katana",
        "watame_shogun",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["watame_katana"] = 
    {
        atlas = "images/inventoryimages/watame_katana.xml",
        image = "watame_katana.tex",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["watame_shogun"] = 
    {
        atlas = "images/inventoryimages/watame_shogun.xml",
        image = "watame_shogun.tex",
    }
else
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WATAME = {
        "watame_katana",
    }
    TUNING.STARTING_ITEM_IMAGE_OVERRIDE["watame_katana"] = 
    {
        atlas = "images/inventoryimages/watame_katana.xml",
        image = "watame_katana.tex",
    }
end

