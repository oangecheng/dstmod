local _G=GLOBAL

_G.STRINGS.AIP={}


Assets={
Asset("ATLAS","images/inventoryimages/popcorngun.xml"),
Asset("ATLAS","images/inventoryimages/incinerator.xml"),
Asset("ATLAS","images/inventoryimages/dark_observer.xml"),
Asset("ATLAS","images/inventoryimages/aip_fish_sword.xml"),


Asset("ATLAS","images/inventoryimages/aip_dou_tech.xml"),
Asset("ANIM","anim/aip_ui_doujiang_chest.zip"),
Asset("ATLAS","images/inventoryimages/aip_doujiang_slot_bg.xml"),
Asset("ATLAS","images/inventoryimages/aip_doujiang_slot_ash_bg.xml"),
Asset("ATLAS","images/inventoryimages/aip_doujiang_slot_electricity_bg.xml"),
Asset("ATLAS","images/inventoryimages/aip_doujiang_slot_fire_bg.xml"),
Asset("ATLAS","images/inventoryimages/aip_doujiang_slot_plant_bg.xml"),
Asset("ATLAS","images/inventoryimages/aip_doujiang_slot_water_bg.xml"),
Asset("ATLAS","images/inventoryimages/aip_doujiang_slot_wind_bg.xml"),


Asset("ATLAS","images/inventoryimages/aip_totem_tech.xml"),


Asset( "ANIM","anim/aip_player_drive.zip"),
}


PrefabFiles={

"aip_vest",
"aip_projectile",


"aip_wheat",
"aip_sunflower",
"aip_veggies",
"foods",
"aip_nectar_maker",
"aip_nectar",
"aip_leaf_note",
"aip_xinyue_hoe",
"aip_xinyue_gridplacer",
"aip_22_fish",


"aip_blood_package",
"aip_plaster",
"aip_igloo",
"aip_dragon",
"aip_dragon_tail",
"aip_dragon_footprint",
"aip_krampus_plus",


"popcorngun",
"aip_fish_sword",
"aip_beehave",
"aip_oar_woodead",
"aip_dou_scepter_projectile",
"aip_heal_fx",
"aip_sanity_fx",
"aip_dou_inscription",
"aip_dou_inscription_package",
"aip_dou_element_guard",
"aip_aura",
"aip_buffer_fx",


"aip_dou_opal",
"aip_dou_tooth",
"aip_dou_scepter",


"incinerator",
"aip_woodener",
"aip_glass_chest",


"aip_dou_totem",
"aip_fly_totem",
"aip_score_ball",
"aip_mini_doujiang",
"aip_mud_crab",
"aip_cookiecutter_king",
"aip_map",
"aip_olden_tea",
"aip_shell_stone",
"aip_suwu",
"aip_suwu_mound",
"aip_breadfruit_tree",
"aip_rubik_fire",
"aip_rubik",
"aip_legion",
"aip_rubik_ghost",
"aip_rubik_heart",
"aip_wizard_hat",
"aip_nightmare_package",
"aip_aura_track",
"aip_eye_box",


"aip_track_tool",
"aip_glass_orbit",
"aip_glass_minecar",
"aip_shadow_transfer",


"aip_orbit",
"aip_mine_car",


"aip_dress",
"aip_armor_gambler",


"aip_chesspiece",


"dark_observer",
"dark_observer_vest",
"aip_shadow_package",
"aip_shadow_chest",
"aip_shadow_wrapper",
"aip_xiyou_card",
"aip_xiyou_cards",
"aip_xiyou_card_package",
}

local language=GetModConfigData("language")
local dev_mode=GetModConfigData("dev_mode")=="enabled"
local open_beta=GetModConfigData("open_beta")=="open"


modimport("scripts/aipUtils.lua")



local AIP_DOU_SCEPTER=AddRecipeTab(
"AIP_DOU_SCEPTER",
100,
"images/inventoryimages/aip_dou_tech.xml",
"aip_dou_tech.tex",
nil,
true
)

local AIP_DOU_TOTEM=AddRecipeTab(
"AIP_DOU_TOTEM",
100,
"images/inventoryimages/aip_totem_tech.xml",
"aip_totem_tech.tex",
nil,
true
)


local TECH_SCEPTER_LANG={
english="Mysterious",
chinese="神秘魔法",
}

local TECH_TOTEM_LANG={
english="IOT",
chinese="联结",
}

_G.STRINGS.TABS.AIP_DOU_SCEPTER=TECH_SCEPTER_LANG[language]
_G.STRINGS.TABS.AIP_DOU_TOTEM=TECH_TOTEM_LANG[language]


modimport("scripts/techHooker.lua")



local inscriptions=require("utils/aip_scepter_util").inscriptions
for name,info in pairs(inscriptions) do
AddRecipe(
name,info.recipes,AIP_DOU_SCEPTER,_G.TECH.AIP_DOU_SCEPTER,
nil,nil,true,nil,nil,
"images/inventoryimages/"..name..".xml",name..".tex"
)
end


AddRecipe(
"aip_shadow_transfer",
{ Ingredient("moonglass",2),Ingredient("moonrocknugget",2),Ingredient("aip_22_fish",1,"images/inventoryimages/aip_22_fish.xml") },
AIP_DOU_TOTEM,_G.TECH.AIP_DOU_TOTEM,
nil,nil,true,nil,nil,
"images/inventoryimages/aip_shadow_transfer.xml",
"aip_shadow_transfer.tex"
)


AddRecipe(
"aip_track_tool",
{ Ingredient("moonglass",6),Ingredient("moonrocknugget",3),Ingredient("transistor",1) },
AIP_DOU_TOTEM,_G.TECH.AIP_DOU_TOTEM,
nil,nil,true,nil,nil,
"images/inventoryimages/aip_track_tool.xml",
"aip_track_tool.tex"
)


AddRecipe(
"aip_glass_minecar",
{ Ingredient("moonglass",5),Ingredient("goldnugget",4) },
AIP_DOU_TOTEM,_G.TECH.AIP_DOU_TOTEM,
nil,nil,true,nil,nil,
"images/inventoryimages/aip_glass_minecar.xml",
"aip_glass_minecar.tex"
)


modimport("scripts/componentsHooker.lua")


AddMinimapAtlas("minimap/dark_observer_vest.xml")
AddMinimapAtlas("minimap/aip_dou_totem.xml")
AddMinimapAtlas("minimap/aip_cookiecutter_king.xml")
AddMinimapAtlas("minimap/aip_fly_totem.xml")


modimport("scripts/containersWrapper.lua")
modimport("scripts/writeablesWrapper.lua")
modimport("scripts/itemTileWrapper.lua")
modimport("scripts/hudWrapper.lua")
modimport("scripts/shadowPackageAction.lua")
modimport("scripts/widgetHooker.lua")
modimport("scripts/recpiesHooker.lua")
modimport("scripts/flyWrapper.lua")
modimport("scripts/houseWrapper.lua")
modimport("scripts/sgHooker.lua")


if dev_mode then
modimport("scripts/dev.lua")
end


if GetModConfigData("additional_orbit")=="open" then
modimport("scripts/mineCarAction.lua")
end


modimport("scripts/prefabsHooker.lua")


AddPrefabPostInit("world",function(inst)
if _G.TheNet:GetIsServer() or _G.TheNet:IsDedicated() then
inst:AddComponent("world_common_store")
end
end)


modimport("scripts/hooks/aip_drive_hook")
modimport("scripts/hooks/aip_transfer_hook")

function PlayerPrefabPostInit(inst)
if not inst.components.aipc_player_client then
inst:AddComponent("aipc_player_client")
end

















if not _G.TheWorld.ismastersim then
return
end

if not inst.components.aipc_timer then
inst:AddComponent("aipc_timer")
end
end

AddPlayerPostInit(PlayerPrefabPostInit)








































































