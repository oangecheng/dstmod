PrefabFiles = {
	"watame",
	"watame_none",
	"harp",
    "watame_discofloor",
    "watame_shogun",
    "watame_katana"
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/watame.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/watame.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/watame.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/watame.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/watame_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/watame_silho.xml" ),

    Asset( "IMAGE", "bigportraits/watame.tex" ),
    Asset( "ATLAS", "bigportraits/watame.xml" ),

    Asset( "IMAGE", "bigportraits/watame_none.tex" ),
    Asset( "ATLAS", "bigportraits/watame_none.xml" ),
    
    Asset( "IMAGE", "bigportraits/watame_shadow.tex" ),
    Asset( "ATLAS", "bigportraits/watame_shadow.xml" ),
	
	Asset( "IMAGE", "images/map_icons/watame.tex" ),
	Asset( "ATLAS", "images/map_icons/watame.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_watame.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_watame.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_watame.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_watame.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_watame.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_watame.xml" ),
	
	Asset( "IMAGE", "images/names_watame.tex" ),
    Asset( "ATLAS", "images/names_watame.xml" ),
	
	Asset( "IMAGE", "images/names_gold_watame.tex" ),
    Asset( "ATLAS", "images/names_gold_watame.xml" ),
	
	--額外添加
	
	Asset( "ATLAS", "images/hud/watametab.xml" ),
	Asset( "IMAGE", "images/hud/watametab.tex" ),


    Asset( "SOUNDPACKAGE", "sound/watame_sounds.fev" ),
    Asset( "SOUND", "sound/watame_sounds.fsb" ),
}

AddMinimapAtlas("images/map_icons/watame.xml")

modimport("scripts/util/watame_settings.lua")
modimport("scripts/util/watame_recipes.lua")
modimport("scripts/util/watame_skins.lua")
modimport("scripts/stategraphs/watame_states.lua")
modimport("scripts/util/watame_eat_grass.lua")


local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

--
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local TUNING = GLOBAL.TUNING

-- The character select screen lines
-- STRINGS.CHARACTER_DESCRIPTIONS.watame = "*戦う苦手\n*寒さに強い\n*綺麗のハープ持っている" -- TODO: These is not written on description, but all excepts harp will be implement on her design


-- The character's name as appears in-game 
STRINGS.NAMES.WATAME = "Watame"
STRINGS.SKIN_NAMES.watame_none = "Watame"

---新增裝備：白羽豎琴

STRINGS.NAMES.HARP = "白羽のハープ"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HARP = "綺麗のハープだね"
STRINGS.RECIPE_DESC.HARP = "心を癒すの楽器。"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}


AddPrefabPostInit("watermelonhat", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return inst end
	local _onequipfn = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function (inst, owner)
		_onequipfn(inst, owner)
		if owner:HasTag("watame") then
			inst.components.equippable.dapperness = TUNING.DAPPERNESS_HUGE
		else
			inst.components.equippable.dapperness = -TUNING.DAPPERNESS_SMALL
		end
	end
end)

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("watame", "FEMALE", skin_modes)

