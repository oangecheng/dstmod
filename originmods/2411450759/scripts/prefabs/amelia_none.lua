return CreatePrefabSkin("amelia_none",
{
	base_prefab = "amelia",
	build_name_override = "amelia",
	type = "base",
	rarity = "Character", 
	skip_item_gen = true,
	skip_giftable_gen = true,
	skin_tags = { "BASE", "amelia", "character"},
	assets = {
		Asset( "ANIM", "anim/amelia.zip" ),
		Asset( "ANIM", "anim/ghost_amelia_build.zip" ),
	},
	skins = {
		normal_skin = "amelia",
		ghost_skin = "ghost_amelia_build",
	}
	, 
}),
CreatePrefabSkin("amelia_shadow",
{
	base_prefab = "amelia",
	build_name_override = "amelia_shadow",
	type = "base",
	rarity = "event",
	skip_item_gen = true,
	skip_giftable_gen = true,
	skin_tags = { "BASE", "amelia", "shadow"},
	assets = {
		Asset( "ANIM", "anim/amelia_shadow.zip" ),
		Asset( "ANIM", "anim/ghost_amelia_build.zip" ),
	},
	skins = {
		normal_skin = "amelia_shadow",
		ghost_skin = "ghost_amelia_build",
	},
})