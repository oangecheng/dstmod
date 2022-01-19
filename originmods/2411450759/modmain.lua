PrefabFiles = {
	"amelia",
    "amelia_none",
    "bubba",
    "amelia_watch",
    "watson_concoction",
    "amelia_magnifying_glass",
    "amelia_hidden",
    "ameliabuffs",
    "concoction_fx",
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

    Asset( "IMAGE", "images/inventoryimages/bubba_tab.tex" ),
    Asset( "ATLAS", "images/inventoryimages/bubba_tab.xml" ),

    Asset( "ANIM", "anim/amebuff.zip" ),
}

AddMinimapAtlas("images/map_icons/amelia.xml")

modimport("scripts/util/amelia_settings.lua")
modimport("scripts/util/amelia_recipes.lua")
modimport("scripts/amelia_states.lua")
modimport("scripts/util/amelia_fx.lua")
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

-- Event Emitter
local function PushGroundpoundEvent(inst)
	inst:PushEvent("amelia_groundpound") 
end

AddModRPCHandler("amelia", "GroundPoundAction", PushGroundpoundEvent)

local AMELIA_GROUNDPOUND = GLOBAL.Action()
AMELIA_GROUNDPOUND.str = "GroundPoundAction"
AMELIA_GROUNDPOUND.id = "AMELIA_GROUNDPOUND"
AMELIA_GROUNDPOUND.fn = function(act)
	PushGroundpoundEvent(act.target)
	return true
end 
AddAction(AMELIA_GROUNDPOUND)

local function OnGroundPound(inst)
	SendModRPCToServer(MOD_RPC["amelia"]["GroundPoundAction"], inst)
end

-- BLACK RED
local MOLE_COLOURCUBES =
{
    day = "images/colour_cubes/mole_vision_on_cc.tex",
    dusk = "images/colour_cubes/mole_vision_on_cc.tex",
    night = "images/colour_cubes/mole_vision_on_cc.tex",
    full_moon = "images/colour_cubes/mole_vision_on_cc.tex",
}
-- BLUE
local RUINS_COLORCUBES =
{
    day = "images/colour_cubes/ruins_dark_cc.tex",
    dusk = "images/colour_cubes/ruins_dim_cc.tex",
    night = "images/colour_cubes/ruins_light_cc.tex",
    full_moon = "images/colour_cubes/ruins_dim_cc.tex",
}
-- Purple
local PURPLE_COLORCUBES =
{
    day = "images/colour_cubes/purple_moon_cc.tex",
    dusk = "images/colour_cubes/purple_moon_cc.tex",
    night = "images/colour_cubes/purple_moon_cc.tex",
    full_moon = "images/colour_cubes/purple_moon_cc.tex",
}
-- Kinda white
local GHOSTVISION_COLOURCUBES =
{
    day = "images/colour_cubes/ghost_cc.tex",
    dusk = "images/colour_cubes/ghost_cc.tex",
    night = "images/colour_cubes/ghost_cc.tex",
    full_moon = "images/colour_cubes/ghost_cc.tex",
}
-- Green
local SINKHOLE_COLORCUBES =
{
    day = "images/colour_cubes/sinkhole_cc.tex",
    dusk = "images/colour_cubes/sinkhole_cc.tex",
    night = "images/colour_cubes/sinkhole_cc.tex",
    full_moon = "images/colour_cubes/sinkhole_cc.tex",
}

local Visions = {
    MOLE_COLOURCUBES,
    RUINS_COLORCUBES,
    PURPLE_COLORCUBES,
    GHOSTVISION_COLOURCUBES,
    SINKHOLE_COLORCUBES
}

local function OnColourCubesEffect(inst)
    
    local Vision
    if inst:HasTag("poison_debuff") then
        Vision = SINKHOLE_COLORCUBES
    elseif inst:HasTag("mind_split_debuff") then
        Vision = GHOSTVISION_COLOURCUBES
    elseif inst:HasTag("conc_sweat_debuff") then
        Vision = RUINS_COLORCUBES
    elseif inst:HasTag("stomachache_debuff") then
        Vision = MOLE_COLOURCUBES
    elseif inst:HasTag("drowsy_debuff") then
        Vision = PURPLE_COLORCUBES
    end

    if inst.components.playervision ~= nil 
    and not inst.components.playervision:GetCCTable() 
    and inst:HasTag("under_conc_effect") 
    and Vision then
        inst.components.playervision:ForceGoggleVision(true)
        inst.components.playervision:SetCustomCCTable(Vision)
        inst.currentvision = Vision
    elseif inst.components.playervision ~= nil and 
    inst.currentvision == inst.components.playervision:GetCCTable() 
    and inst:HasTag("remove_cc") and not inst:HasTag("under_conc_effect")
    and not Vision then
        inst.components.playervision:ForceGoggleVision(false)
        inst.components.playervision:SetCustomCCTable(nil)
        inst:RemoveTag("remove_cc")
    end
end

-- Adds things to the player after initialization
AddPlayerPostInit(function(inst)
	if inst.prefab == "amelia" then
        if not GLOBAL.TheWorld.ismastersim then
            inst:ListenForEvent("GroundPoundAction", OnGroundPound)
        end
        inst:AddComponent("ameliahistory")
    end
    if inst:HasTag("player") and not GLOBAL.TheWorld.ismastersim and TUNING.WATSON_CONCOCTION_FILTER then
        inst:DoPeriodicTask(0.1, OnColourCubesEffect)
    end
end)


AddModCharacter("amelia", "FEMALE", skin_modes)
