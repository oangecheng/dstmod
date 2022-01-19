local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("watame_none",
{
	base_prefab = "watame",
	build_name_override = "watame",
	type = "base",
	rarity = "Character",
	rarity_modifier = "CharacterModifier",
	skins = {
		normal_skin = "watame",
		ghost_skin = "ghost_watame_build",
		wnf_skin = "watame_victorian"
	},
	assets = {
		Asset( "ANIM", "anim/watame.zip" ),
		Asset( "ANIM", "anim/ghost_watame_build.zip" ),
		Asset( "ANIM", "anim/watame_victorian.zip" ),
	},
	skin_tags = { "BASE", "watame", },
--	has_leg_boot = true,
	skip_item_gen = true,
	skip_giftable_gen = true,
}))
table.insert(prefabs, CreatePrefabSkin("watame_shadow",
{
	base_prefab = "watame",
	build_name_override = "watame_shadow",
	type = "base",
	rarity = "Distinguished",
	rarity_modifier = "Woven",
	skip_item_gen = true,
	skip_giftable_gen = true,
	skin_tags = { "BASE", "watame", },
	skins = {
		normal_skin = "watame_shadow",
		ghost_skin = "ghost_watame_build",
		wnf_skin = "watame_shadow"
	},

	assets = {
		Asset( "ANIM", "anim/watame_shadow.zip" ),
		Asset( "ANIM", "anim/ghost_watame_build.zip" ),
	},

}))
table.insert(prefabs, CreatePrefabSkin("watame_victorian",
{
	base_prefab = "watame",
	build_name_override = "watame_victorian",
	type = "base",
	rarity = "Distinguished",
	rarity_modifier = "Woven",
	skip_item_gen = true,
	skip_giftable_gen = true,
	skin_tags = { "BASE", "watame",},
	skins = {
		normal_skin = "watame_victorian",
		ghost_skin = "ghost_watame_build",
		wnf_skin = "watame_victorian",
	},

	assets = {
		Asset( "ANIM", "anim/watame_victorian.zip" ),
		Asset( "ANIM", "anim/ghost_watame_build.zip" ),
	},
}))
-- table.insert(prefabs, CreatePrefabSkin("watame_survivor",
-- {
-- 	base_prefab = "watame",
-- 	build_name_override = "watame_survivor",
-- 	type = "base",
-- 	rarity = "Distinguished",
-- 	rarity_modifier = "Woven",
-- 	skip_item_gen = true,
-- 	skip_giftable_gen = true,
-- 	skin_tags = { "BASE", "watame", },
-- 	skins = {
-- 		normal_skin = "watame_survivor",
-- 		ghost_skin = "ghost_watame_build",
-- 	},

-- 	assets = {
-- 		Asset( "ANIM", "anim/watame_survivor.zip" ),
-- 		Asset( "ANIM", "anim/ghost_watame_build.zip" ),
-- 	},

-- }))
--
return unpack(prefabs)