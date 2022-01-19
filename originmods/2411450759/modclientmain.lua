PrefabFiles = {
	"amelia",
    "amelia_none",
    "bubba",
    "amelia_watch",
    "watson_concoction",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/amelia.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/amelia.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/amelia.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/amelia.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/amelia_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/amelia_silho.xml" ),

    Asset( "IMAGE", "bigportraits/amelia.tex" ),
    Asset( "ATLAS", "bigportraits/amelia.xml" ),

    Asset( "IMAGE", "bigportraits/amelia_none.tex" ),
    Asset( "ATLAS", "bigportraits/amelia_none.xml" ),

    Asset( "IMAGE", "bigportraits/amelia_shadow.tex" ),
    Asset( "ATLAS", "bigportraits/amelia_shadow.xml" ),
	
	Asset( "IMAGE", "images/map_icons/amelia.tex" ),
	Asset( "ATLAS", "images/map_icons/amelia.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_amelia.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_amelia.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_amelia.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_amelia.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_amelia.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_amelia.xml" ),
	
	Asset( "IMAGE", "images/names_amelia.tex" ),
    Asset( "ATLAS", "images/names_amelia.xml" ),
	
	Asset( "IMAGE", "images/names_gold_amelia.tex" ),
    Asset( "ATLAS", "images/names_gold_amelia.xml" ),

}

AddMinimapAtlas("images/map_icons/amelia.xml")

modimport("scripts/util/amelia_settings.lua")
modimport("scripts/util/amelia_skins.lua")


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



AddModCharacter("amelia", "FEMALE", skin_modes)
