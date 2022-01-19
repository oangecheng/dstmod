--[[
{
	name,--配方名，一般情况下和需要合成的道具同名
	ingredients,--配方，这边为了区分不同难度的配方，做了嵌套{{正常难度},{简易难度}}，只填一个视为不做难度区分
	tab,--合成栏
	level,--解锁科技
	placer,--建筑类科技放置时显示的贴图、占位等/也可以配List用于添加更多额外参数，比如不可分解{no_deconstruction = true}
	min_spacing,--最小间距，不填默认为3.2
	nounlock,--不解锁配方，只能在满足科技条件的情况下制作
	numtogive,--一次性制作的数量，不填默认为1
	builder_tag,--制作者需要拥有的标签
	atlas,--需要用到的图集文件(.xml)，不填默认用images/name.xml
	image,--物品贴图(.tex)，不填默认用name.tex
	testfn,--尝试放下物品时的函数，可用于判断坐标点是否符合预期
	product,--实际合成道具，不填默认取name
	needHidden,--简易模式隐藏
	noatlas,--不需要图集文件
	noimage,--不需要贴图
}
--]]
local Recipes = {
	--------------------------------------------------------------------
	------------------------------原生配方------------------------------
	--------------------------------------------------------------------
	
	------------------------------植物人------------------------------
	--活木
    {
        name = "livinglog",
        ingredients = {
			{
				Ingredient(CHARACTER_INGREDIENT.HEALTH, 20),
			},
        },
        tab = CUSTOM_RECIPETABS.NATURE,
        level = TECH.NONE,
		builder_tag = "livinglogbuilder",
		noatlas = true,
		noimage = true,
    },
	------------------------------非原生气球------------------------------
	--[[
	--沉默气球
	{
	    name = "medal_balloon",
	    ingredients = {
			{
				Ingredient("balloons_empty", 0), Ingredient(CHARACTER_INGREDIENT.SANITY, 5),
			},
	    },
	    tab = CUSTOM_RECIPETABS.BALLOONOMANCY,
	    level = TECH.NONE,
		builder_tag = "balloonomancer",
		placer={dropitem = true, buildingstate = "makeballoon"},--制作后直接掉落；使用吹气球动作
	},
	--暗影气球
	{
	    name = "shadow_balloon",
	    ingredients = {
			{
				Ingredient("balloons_empty", 0), Ingredient(CHARACTER_INGREDIENT.SANITY, 5),
			},
	    },
	    tab = CUSTOM_RECIPETABS.BALLOONOMANCY,
	    level = TECH.NONE,
		builder_tag = "balloonomancer",
		placer={dropitem = true, buildingstate = "makeballoon"},--制作后直接掉落；使用吹气球动作
	},
	]]
	
	--------------------------------------------------------------------
	------------------------------新增配方------------------------------
	--------------------------------------------------------------------
	--勋章盒
    {
        name = "medal_box",
        ingredients = {
			{
				Ingredient("purplegem", 1),Ingredient("driftwood_log", 4),Ingredient("turf_carpetfloor", 2),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		image = "medal_box1.tex"
    },
	--调料盒
    {
        name = "spices_box",
        ingredients = {
			{
				Ingredient("trinket_17", 1),Ingredient("boards", 8),
			},
			{
				Ingredient("boards", 8),
			},
        },
        tab = RECIPETABS.FARM,
        level = TECH.CARTOGRAPHY_TWO,
		builder_tag = "seasoningchef",
    },
	------------------------------大厨勋章------------------------------
    --烹调勋章
    {
        name = "cook_certificate",
        ingredients = {
            {
            	Ingredient("cookbook", 1),
				Ingredient("toil_money", 6,"images/toil_money.xml"),
            },
    		--简易配方
			{
				Ingredient("cookbook", 1),
				Ingredient("toil_money", 3,"images/toil_money.xml"),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--黑曜石锅
	{
	    name = "medal_cookpot",
	    ingredients = {
	        {
				Ingredient("medal_obsidian", 6,"images/medal_obsidian.xml"),
				Ingredient("charcoal", 6),
			},
	    },
	    tab = RECIPETABS.FARM,
        level = TECH.LOST,
		placer = "medal_cookpot_placer",
		min_spacing = 2,
	},
	------------------------------专属调料------------------------------
	--果冻粉
    {
        name = "spice_jelly",
        ingredients = {
            {
				Ingredient("medal_fishbones", 3,"images/medal_fishbones.xml"),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--荧光粉
    {
        name = "spice_phosphor",
        ingredients = {
            {
				Ingredient("moonbutterflywings", 2),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	--月树花粉
    {
        name = "spice_moontree_blossom",
        ingredients = {
            {
				Ingredient("moon_tree_blossom", 3),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		-- numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--仙人掌花粉
    {
        name = "spice_cactus_flower",
        ingredients = {
            {
				Ingredient("cactus_flower", 3),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--血糖
    {
        name = "spice_blood_sugar",
        ingredients = {
            {
				Ingredient("mosquitosack", 3),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--灵魂佐料
    {
        name = "spice_soul",
        ingredients = {
            {
				Ingredient("wortox_soul", 1),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	--土豆淀粉
    {
        name = "spice_potato_starch",
        ingredients = {
            {
				Ingredient("potato", 3),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 2,
		builder_tag = "seasoningchef",
    },
	--秘制酱料
    {
        name = "spice_poop",
        ingredients = {
            {
				Ingredient("compostwrap", 2),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 5,
		builder_tag = "seasoningchef",
    },
	--叶肉酱
    {
        name = "spice_plantmeat",
        ingredients = {
            {
				Ingredient("plantmeat", 1),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 3,
		builder_tag = "seasoningchef",
    },
	--曼德拉果酱
    {
        name = "spice_mandrake_jam",
        ingredients = {
            {
				Ingredient("mandrakeberry", 3,"images/mandrakeberry.xml"),
			},
        },
        tab = RECIPETABS.FOODPROCESSING,
        level = TECH.FOODPROCESSING_ONE,
        nounlock = true,
		numtogive = 1,
		builder_tag = "seasoningchef",
    },
	------------------------------智慧勋章------------------------------
	--蒙昧勋章
	{
	    name = "wisdom_test_certificate",
	    ingredients = {
	        {
				Ingredient("toil_money", 4,"images/toil_money.xml"),
			},
			{
				Ingredient("toil_money", 2,"images/toil_money.xml"),
			},
	    },
	    tab = RECIPETABS.CARTOGRAPHY,
	    level = TECH.CARTOGRAPHY_TWO,
	    nounlock = true,
	},
	--不朽精华
    {
        name = "immortal_essence",
        ingredients = {
            {
				Ingredient("spoiled_food", 20), Ingredient("saltrock", 3),
			},
			{
				Ingredient("spoiled_food", 10),
			},
        },
        tab = RECIPETABS.REFINE,
        level = TECH.SCIENCE_TWO,
        -- nounlock = true,
    },
	--血汗钱
    {
        name = "toil_money",
        ingredients = {
            {
				Ingredient("goldnugget", 2),Ingredient(CHARACTER_INGREDIENT.HEALTH, 25),
			},
        },
        tab = RECIPETABS.REFINE,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--血汗钱
    {
        name = "toil_money_copy",
		product = "toil_money",
        ingredients = {
            {
				Ingredient("goldnugget", 2),Ingredient("spidergland", 4),
			},
        },
        tab = RECIPETABS.REFINE,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--新华字典
	{
        name = "xinhua_dictionary",
        ingredients = {
            {
				Ingredient("toil_money", 10,"images/toil_money.xml"),
			},
			{
				Ingredient("toil_money", 5,"images/toil_money.xml"),
			},
        },
		tab = CUSTOM_RECIPETABS.BOOKS,
        -- tab = RECIPETABS.REFINE,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------巧手勋章------------------------------
	--巧手考验勋章
	{
        name = "handy_test_certificate",
        ingredients = {
            {
				Ingredient("toil_money", 6,"images/toil_money.xml"),
			},
			{
				Ingredient("toil_money", 3,"images/toil_money.xml"),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--催雨弹
	{
	    name = "medal_rain_bomb",
	    ingredients = {
	        {
				Ingredient("miniflare", 1),Ingredient("saltrock", 1),Ingredient("gunpowder", 1),
			},
	    },
		tab = CUSTOM_RECIPETABS.ENGINEERING,
	    level = TECH.SCIENCE_TWO,
		builder_tag="has_handy_medal",
	},
	--放晴弹
	{
	    name = "medal_clear_up_bomb",
	    ingredients = {
	        {
				Ingredient("miniflare", 1),Ingredient("lightbulb", 1),Ingredient("gunpowder", 1),
			},
	    },
		tab = CUSTOM_RECIPETABS.ENGINEERING,
	    level = TECH.SCIENCE_TWO,
		builder_tag="has_handy_medal",
	},
	--手摇深井泵改造装置
	{
        name = "medal_waterpump_item",
        ingredients = {
            {
				Ingredient("cane", 1),Ingredient("gears", 2),Ingredient("transistor", 2),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.SCIENCE_TWO,
		builder_tag = "has_handy_medal",
    },
	--手摇深井泵(用来砸和分解)
	{
        name = "medal_waterpump",
        ingredients = {
            {
				Ingredient("cane", 1),Ingredient("gears", 2),Ingredient("transistor", 2),Ingredient("boards", 2),Ingredient("oceanfish_small_9_inv", 1)
			},
        },
        level = TECH.LOST,
		nounlock = true,
		-- placer = "medal_waterpump_placer",
		-- min_spacing = 1.5,
    },
	--藏宝图
	{
	    name = "medal_treasure_map",
	    ingredients = {
	        {
				Ingredient("medal_treasure_map_scraps1", 1,"images/medal_treasure_map_scraps1.xml"),
				Ingredient("medal_treasure_map_scraps2", 1,"images/medal_treasure_map_scraps2.xml"),
				Ingredient("medal_treasure_map_scraps3", 1,"images/medal_treasure_map_scraps3.xml"),
				Ingredient("sewing_tape", 1),
			},
	    },
	    tab = RECIPETABS.REFINE,
	    level = TECH.SCIENCE_TWO,
		-- builder_tag = "has_handy_medal",
	},
	--宝藏探测仪
	{
	    name = "medal_resonator_item",
	    ingredients = {
	        {
				Ingredient("compass", 1),Ingredient("gears", 1),Ingredient("transistor", 1),
			},
	    },
	    tab = CUSTOM_RECIPETABS.ENGINEERING,
	    level = TECH.SCIENCE_TWO,
		builder_tag = "has_handy_medal",
	},
	--缪斯雕像1
	{
        name = "medal_statue_marble_muse1",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_muse1_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--缪斯雕像2
	{
        name = "medal_statue_marble_muse2",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_muse2_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--瓷瓶雕像
	{
        name = "medal_statue_marble_urn",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_urn_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--士卒雕像
	{
        name = "medal_statue_marble_pawn",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_pawn_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--丘比特雕像
	{
        name = "medal_statue_marble_harp",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_harp_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--格罗姆雕像
	{
        name = "medal_statue_marble_glommer",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_glommer_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--老麦雕像
	{
        name = "medal_statue_marble_maxwell",
        ingredients = {
            {
				Ingredient("marble", 5),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_maxwell_placer",
		builder_tag="has_handy_medal",
		min_spacing = 2.5,
    },
	--鸽子雕像
	{
        name = "medal_statue_marble_gugugu",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_gugugu_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--咸鱼雕像
	{
        name = "medal_statue_marble_saltfish",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_saltfish_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--猫猫雕像
	{
        name = "medal_statue_marble_stupidcat",
        ingredients = {
            {
				Ingredient("marble", 3),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_stupidcat_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	--大黑蛋雕像
	{
        name = "medal_statue_marble_blackegg",
        ingredients = {
            {
				Ingredient("marble", 3),Ingredient("charcoal", 2),
			},
        },
        tab = CUSTOM_RECIPETABS.ENGINEERING,
        level = TECH.NONE,
		placer = "medal_statue_marble_blackegg_placer",
		builder_tag="has_handy_medal",
		min_spacing = 1.5,
    },
	------------------------------伐木勋章------------------------------
	--初级伐木勋章
	{
        name = "smallchop_certificate",
        ingredients = {
            {
            	Ingredient("log", 20),
			},
			{
				Ingredient("log", 10),
            },
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------矿工勋章------------------------------
	--初级矿工勋章
	{
        name = "smallminer_certificate",
        ingredients = {
            {
            	Ingredient("flint", 8),Ingredient("rocks", 8),Ingredient("nitre", 4),
			},
			{
				Ingredient("flint", 4),Ingredient("rocks", 4),Ingredient("nitre", 2),
            },
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------丰收勋章------------------------------
	--月光铲
	{
        name = "medal_moonglass_shovel",
        ingredients = {
			{
				Ingredient("livinglog", 1),Ingredient("moonglass", 3),Ingredient("kelp", 2),
			},
        },
        tab = RECIPETABS.CELESTIAL,
        level = TECH.CELESTIAL_THREE,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--月光锤
	{
        name = "medal_moonglass_hammer",
        ingredients = {
			{
				Ingredient("livinglog", 1),Ingredient("moonglass", 3),Ingredient("kelp", 2),
			},
        },
        tab = RECIPETABS.CELESTIAL,
        level = TECH.CELESTIAL_THREE,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--月光网
	{
        name = "medal_moonglass_bugnet",
        ingredients = {
			{
				Ingredient("silk", 2),Ingredient("moonglass", 3),Ingredient("kelp", 2),	
			},
        },
        tab = RECIPETABS.CELESTIAL,
        level = TECH.CELESTIAL_THREE,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--月光药水
	{
        name = "medal_moonglass_potion",
        ingredients = {
			{	
				Ingredient("moonbutterflywings", 1),Ingredient("moonglass", 3),Ingredient("moon_tree_blossom", 2),
			},
        },
        tab = RECIPETABS.CELESTIAL,
        level = TECH.CELESTIAL_THREE,
		numtogive = 2,
		image = "halloweenpotion_moon.tex",
		noatlas = true,
        nounlock = true,
		builder_tag = "has_transplant_medal",
    },
	--活木树苗
	{
        name = "medaldug_livingtree_root",
        ingredients = {
			{
				Ingredient("livinglog", 1), Ingredient(CHARACTER_INGREDIENT.HEALTH, 20),
			},
			{
				Ingredient("livinglog", 1), Ingredient(CHARACTER_INGREDIENT.HEALTH, 10),
			},
        },
        tab = CUSTOM_RECIPETABS.NATURE,
        level = TECH.MAGIC_THREE,
		builder_tag = "plantkin",
    },
	------------------------------新增书籍------------------------------
	--无字天书
	{
        name = "closed_book",
        ingredients = {
            {
				Ingredient("papyrus", 2),
			},
        },
		tab = CUSTOM_RECIPETABS.BOOKS,
        -- tab = RECIPETABS.REFINE,
        level = TECH.CARTOGRAPHY_TWO,
    },
	--不朽之谜
		{
		name = "immortal_book",
		ingredients = {
			{
				Ingredient("closed_book", 1,"images/closed_book.xml"),
				Ingredient("waxpaper", 1),
				Ingredient("immortal_essence", 3,"images/immortal_essence.xml"),
			},
		},
		tab = CUSTOM_RECIPETABS.BOOKS,
		-- tab = RECIPETABS.REFINE,
		level = TECH.NONE,
		builder_tag = "is_bee_king",
	},
    
	--陷阱重置册
	{
        name = "trapreset_book",
        ingredients = {
            {
				Ingredient("papyrus", 2),Ingredient("sewing_tape", 4),
			},
        },
		tab = CUSTOM_RECIPETABS.BOOKS,
        -- tab = RECIPETABS.REFINE,
        level = TECH.NONE,
		builder_tag = "wisdombuilder",
    },
	------------------------------正义勋章------------------------------
	--逮捕勋章
	{
        name = "arrest_certificate",
        ingredients = {
            {
				Ingredient("killerbee", 20),
			},
			{
				Ingredient("killerbee", 10),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	--怪物精华
    {
        name = "medal_monster_essence",
        ingredients = {
            {
				Ingredient("durian", 2), Ingredient("charcoal", 3), Ingredient("monstermeat", 4),
			},
			{
				Ingredient("durian", 1), Ingredient("charcoal", 2), Ingredient("monstermeat", 2),
			},
        },
        tab = RECIPETABS.REFINE,
        level = TECH.LOST,
    },
	------------------------------钓鱼勋章------------------------------
	--钓鱼勋章
	{
        name = "smallfishing_certificate",
        ingredients = {
            {
            	Ingredient("toil_money", 4,"images/toil_money.xml"),
            },
            {
            	Ingredient("toil_money", 2,"images/toil_money.xml"),
            },
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------其他勋章------------------------------
	--友善勋章
	{
        name = "friendly_certificate",
        ingredients = {
            {
				Ingredient("toil_money", 6,"images/toil_money.xml"),
			},
			{
				Ingredient("toil_money", 3,"images/toil_money.xml"),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "monster",
    },
	--女武神的检验
	{
        name = "valkyrie_examine_certificate",
        ingredients = {
            {
				Ingredient("toil_money", 6,"images/toil_money.xml"),
			},
			{
				Ingredient("toil_money", 3,"images/toil_money.xml"),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
    },
	------------------------------其他道具------------------------------
	--熊皮宝箱
	{
        name = "bearger_chest",
        ingredients = {
            {
				Ingredient("bearger_fur", 1), Ingredient("boards", 5),Ingredient("bundlewrap", 8),
				Ingredient("immortal_essence", 6,"images/immortal_essence.xml"),
			},
			{
				Ingredient("bearger_fur", 1), Ingredient("boards", 3),Ingredient("bundlewrap", 4),
				Ingredient("immortal_essence", 3,"images/immortal_essence.xml"),
			},
        },
        tab = RECIPETABS.TOWN,
        level = TECH.LOST,
		-- placer = "bearger_chest_placer",
		placer={placer = "bearger_chest_placer", no_deconstruction = true},--禁止分解
		min_spacing = 1.5,
    },
	--童心箱
	{
	    name = "medal_childishness_chest",
	    ingredients = {
	        {
				Ingredient("boards", 5), Ingredient("rope", 1),Ingredient("trinket_1", 1),
			},
	    },
	    tab = RECIPETABS.TOWN,
	    level = TECH.NONE,
		placer = "medal_childishness_chest_placer",
		builder_tag = "has_childishness",
		min_spacing = 1.5,
	},
	--食人花手杖
	{
        name = "lureplant_rod",
        ingredients = {
            {
				Ingredient("lureplantbulb", 1), Ingredient("nightmarefuel", 5),Ingredient("livinglog", 2),
			},
			{
				Ingredient("lureplantbulb", 1), Ingredient("nightmarefuel", 3),Ingredient("livinglog", 1),
			},
        },
        tab = RECIPETABS.MAGIC,
        level = TECH.MAGIC_THREE,
		builder_tag = "has_plant_medal",
    },
	--大理石斧
	{
        name = "marbleaxe",
        ingredients = {
            {
				Ingredient("marble", 3), Ingredient("twigs", 2), Ingredient("goldnugget", 2),
			},
        },
        tab = RECIPETABS.TOOLS,
        level = TECH.SCIENCE_TWO,
    },
	--大理石镐
	{
        name = "marblepickaxe",
        ingredients = {
            {
				Ingredient("marble", 3), Ingredient("twigs", 2), Ingredient("goldnugget", 2),
			},
        },
        tab = RECIPETABS.TOOLS,
        level = TECH.SCIENCE_TWO,
    },
	--玻璃钓竿
	{
        name = "medal_fishingrod",
        ingredients = {
            {
				Ingredient("moonglass", 4),Ingredient("silk", 5),Ingredient("kelp", 2),	
			},
        },
        tab = RECIPETABS.SURVIVAL,
        level = TECH.SCIENCE_TWO,
		-- tab = RECIPETABS.CELESTIAL,
		-- level = TECH.CELESTIAL_THREE,
		-- nounlock = true,
		-- builder_tag = "has_transplant_medal",
    },
	--不朽宝石
	{
        name = "immortal_gem",
        ingredients = {
            {
				Ingredient("immortal_fruit", 5,"images/immortal_fruit.xml"), 
				Ingredient("opalpreciousgem", 1),
			},
        },
        tab = RECIPETABS.REFINE,
        level = TECH.LOST,
		placer={no_deconstruction = true},--禁止分解
    },
	--时空宝石
	{
        name = "medal_space_gem",
        ingredients = {
            {
				Ingredient("immortal_fruit", 5,"images/immortal_fruit.xml"),
				Ingredient("medal_time_slider", 10,"images/medal_time_slider.xml"),
				Ingredient("purplegem", 1),
			},
        },
        tab = RECIPETABS.REFINE,
        level = TECH.LOST,
		placer={no_deconstruction = true},--禁止分解
    },
	--蝙蝠陷阱
	{
        name = "trap_bat",
        ingredients = {
            {
				Ingredient("goldnugget", 2),Ingredient("stinger", 1),Ingredient("silk", 1),
			},
        },
        tab = RECIPETABS.WAR,
        level = TECH.LOST,
    },
	--羊角帽
	{
        name = "medal_goathat",
        ingredients = {
			{
				Ingredient("lightninggoathorn", 2),Ingredient("beefalowool", 8),Ingredient("transistor", 5),
			},
			{
				Ingredient("lightninggoathorn", 1),Ingredient("beefalowool", 4),Ingredient("transistor", 2),
			},
        },
        tab = RECIPETABS.DRESS,
        level = TECH.LOST,
    },
	--淘气铃铛
	{
        name = "medal_naughtybell",
        ingredients = {
			{
				Ingredient("glommerwings", 1),Ingredient("glommerflower", 1),Ingredient("glommerfuel", 2),
			},
        },
        tab = RECIPETABS.MAGIC,
        level = TECH.MAGIC_THREE,
		builder_tag = "naughtymedal",
		placer={no_deconstruction = true},--禁止分解
    },
	--黑曜石火坑
	{
        name = "medal_firepit_obsidian",
        ingredients = {
			{
				Ingredient("medal_obsidian", 8,"images/medal_obsidian.xml"),
				Ingredient("charcoal", 6),Ingredient("cutgrass", 6),
			},
			{
				Ingredient("medal_obsidian", 4,"images/medal_obsidian.xml"),
				Ingredient("charcoal", 3),Ingredient("cutgrass", 3),
			},
        },
        tab = RECIPETABS.LIGHT,
        level = TECH.LOST,
		placer = "medal_firepit_obsidian_placer",
		min_spacing = 2,
    },
	--蓝曜石火坑
	{
        name = "medal_coldfirepit_obsidian",
        ingredients = {
			{
				Ingredient("medal_blue_obsidian", 8,"images/medal_blue_obsidian.xml"),
				Ingredient("nitre", 6),Ingredient("transistor", 3),
			},
			{
				Ingredient("medal_blue_obsidian", 4,"images/medal_blue_obsidian.xml"),
				Ingredient("nitre", 3),Ingredient("transistor", 2),
			},
        },
        tab = RECIPETABS.LIGHT,
        level = TECH.LOST,
		placer = "medal_coldfirepit_obsidian_placer",
		min_spacing = 2,
    },
	--船上钓鱼池
	{
        name = "medal_seapond",
        ingredients = {
            {
				Ingredient("boards", 4), Ingredient("rope", 4),Ingredient("chum", 1),
			},
			{
				Ingredient("boards", 4), Ingredient("rope", 4),Ingredient("barnacle", 4),
			},
        },
        tab = RECIPETABS.SEAFARING,
        level = TECH.LOST,
		placer={placer = "medal_seapond_placer", no_deconstruction = true},--禁止分解
		min_spacing = 3,
		testfn=function(pt)
		   return TheWorld.Map:GetPlatformAtPoint(pt.x, 0, pt.z,  -3) ~= nil
		end,
    },
	--触手尖刺
	{
        name = "tentaclespike",
        ingredients = {
			{
				Ingredient("houndstooth", 3),Ingredient("livinglog", 1),
			},
			{
				Ingredient("houndstooth", 2),Ingredient("log", 2),
			},
        },
        tab = RECIPETABS.WAR,
        level = TECH.MAGIC_THREE,
		builder_tag = "tentaclemedal",
		noatlas = true,
		noimage = true,
    },
	--活性触手尖刺
	{
        name = "medal_tentaclespike",
        ingredients = {
			{
				Ingredient("houndstooth", 4),Ingredient("tentaclespike", 1),
			},
			{
				Ingredient("houndstooth", 2),Ingredient("tentaclespike", 1),
			},
        },
        tab = RECIPETABS.WAR,
        level = TECH.MAGIC_THREE,
		builder_tag = "tentaclemedal",
    },
	--树根宝箱
	{
        name = "medal_livingroot_chest",
        ingredients = {
            {
				Ingredient("livinglog", 6), Ingredient("nightmarefuel", 6),
			},
			{
				Ingredient("livinglog", 3), Ingredient("nightmarefuel", 3),
			},
        },
        tab = RECIPETABS.TOWN,
        level = TECH.MAGIC_THREE,
		placer = "medal_livingroot_chest_placer",
		min_spacing = 1.5,
    },
	--空瓶子
	{
        name = "messagebottleempty",
        ingredients = {
			{
				Ingredient("moonglass", 4),
			},
			{
				Ingredient("moonglass", 2),
			},
        },
        tab = RECIPETABS.REFINE,
        level = TECH.NONE,
		builder_tag = "has_bathfire_medal",
		noatlas = true,
		noimage = true,
    },
	--高效耕地机
	{
        name = "medal_farm_plow_item",
        ingredients = {
            {
				Ingredient("farm_plow_item", 1),Ingredient("golden_farm_hoe", 2),Ingredient("tillweed", 2),
			},
			{
				Ingredient("farm_plow_item", 1),Ingredient("golden_farm_hoe", 2),Ingredient("boards", 3),
			},
        },
        tab = RECIPETABS.FARM, 
        level = TECH.SCIENCE_TWO,
    },
	--黑曜石甲
	{
        name = "armor_medal_obsidian",
        ingredients = {
            {
				Ingredient("medal_obsidian", 3,"images/medal_obsidian.xml"),
				Ingredient("sewing_tape", 1),
			},
        },
        tab = RECIPETABS.WAR,
        level = TECH.LOST,
    },
	--蓝曜石甲
	{
        name = "armor_blue_crystal",
        ingredients = {
            {
				Ingredient("medal_blue_obsidian", 3,"images/medal_blue_obsidian.xml"),
				Ingredient("sewing_tape", 1),
			},
        },
        tab = RECIPETABS.WAR,
        level = TECH.LOST,
    },
	--蓝曜石制冰机
	{
        name = "medal_ice_machine",
        ingredients = {
			{
				Ingredient("medal_blue_obsidian", 4,"images/medal_blue_obsidian.xml"),
				Ingredient("gears", 1),Ingredient("transistor", 1),Ingredient("trinket_6", 1),
			},
        },
        tab = RECIPETABS.FARM,
        level = TECH.LOST,
		placer = "medal_ice_machine_placer",
		min_spacing = 1.5,
    },
	--育王蜂箱
	{
        name = "medal_beebox",
        ingredients = {
			{
				Ingredient("medal_withered_heart", 1,"images/medal_withered_heart.xml"),
				Ingredient("beeswax", 3),Ingredient("driftwood_log", 6),
			},
        },
        tab = RECIPETABS.FARM,
        level = TECH.NONE,
		builder_tag = "is_bee_king",
		placer = "medal_beebox_placer",
		-- min_spacing = 1.5,
    },
	------------------------------专属弹药------------------------------
	--方尖弹
    {
        name = "medalslingshotammo_sanityrock",
        ingredients = {
            {
				Ingredient("sanityrock_fragment", 1,"images/sanityrock_fragment.xml"),
			},
        },
        tab = CUSTOM_RECIPETABS.SLINGSHOTAMMO,
        level = TECH.NONE,
        nounlock = true,
		numtogive = 10,
		builder_tag = "senior_childishness",
		placer={no_deconstruction = true},--禁止分解
    },
	--沙刺弹
	{
	    name = "medalslingshotammo_sandspike",
	    ingredients = {
	        {
				Ingredient("townportaltalisman", 2),
			},
	    },
	    tab = CUSTOM_RECIPETABS.SLINGSHOTAMMO,
	    level = TECH.NONE,
	    nounlock = true,
		numtogive = 5,
		builder_tag = "senior_childishness",
		placer={no_deconstruction = true},--禁止分解
	},
	--落水弹
	{
	    name = "medalslingshotammo_water",
	    ingredients = {
	        {
				Ingredient("mosquitosack", 2),Ingredient("ice", 2),
			},
	    },
	    tab = CUSTOM_RECIPETABS.SLINGSHOTAMMO,
	    level = TECH.NONE,
	    nounlock = true,
		numtogive = 5,
		builder_tag = "senior_childishness",
		placer={no_deconstruction = true},--禁止分解
	},
	--痰蛋弹
	{
	    name = "medalslingshotammo_taunt",
	    ingredients = {
	        {
				Ingredient("phlegm", 1),Ingredient("rottenegg", 2),
			},
	    },
	    tab = CUSTOM_RECIPETABS.SLINGSHOTAMMO,
	    level = TECH.NONE,
	    nounlock = true,
		numtogive = 5,
		builder_tag = "senior_childishness",
		placer={no_deconstruction = true},--禁止分解
	},
	--尖刺弹
	{
	    name = "medalslingshotammo_spines",
	    ingredients = {
	        {
				Ingredient("waterplant_bomb", 1),Ingredient("stinger", 10),
			},
	    },
	    tab = CUSTOM_RECIPETABS.SLINGSHOTAMMO,
	    level = TECH.NONE,
	    nounlock = true,
		numtogive = 10,
		builder_tag = "senior_childishness",
		placer={no_deconstruction = true},--禁止分解
	},
	--弹药盒
	{
	    name = "medal_ammo_box",
	    ingredients = {
	        {
				Ingredient("pigskin", 2),Ingredient("driftwood_log", 12),Ingredient("rope", 1),
			},
	    },
	    tab = CUSTOM_RECIPETABS.SLINGSHOTAMMO,
	    level = TECH.NONE,
	    nounlock = true,
		builder_tag = "senior_childishness",
	},
	------------------------------传承勋章------------------------------
	--羽绒服
	{
        name = "down_filled_coat",
        ingredients = {
            {
				Ingredient("goose_feather", 20),Ingredient("tentaclespots", 2),Ingredient("sewing_kit", 1),
			},
			{
				Ingredient("goose_feather", 10),Ingredient("tentaclespots", 1),Ingredient("sewing_kit", 1),
			},
        },
        tab = RECIPETABS.DRESS,
        level = TECH.SCIENCE_TWO,
		builder_tag = "traditionalbearer1",
    },
	--蓝晶帽
	{
        name = "hat_blue_crystal",
        ingredients = {
            {
				Ingredient("medal_blue_obsidian", 12,"images/medal_blue_obsidian.xml"),
				Ingredient("sewing_tape", 6),
			},
			{
				Ingredient("medal_blue_obsidian", 6,"images/medal_blue_obsidian.xml"),
				Ingredient("sewing_tape", 3),
			},
        },
        tab = RECIPETABS.DRESS,
        level = TECH.SCIENCE_TWO,
		builder_tag = "traditionalbearer1",
    },
	--复眼勋章
	{
        name = "ommateum_certificate",
        ingredients = {
            {
				Ingredient("blank_certificate", 1,"images/blank_certificate.xml"),
				Ingredient("deerclops_eyeball", 1),Ingredient("yellowmooneye", 1),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer2",
    },
	--速度勋章
	{
        name = "speed_certificate",
        ingredients = {
            {
				Ingredient("blank_certificate", 1,"images/blank_certificate.xml"),
				Ingredient("walrus_tusk", 1),Ingredient("townportaltalisman", 10),
			},
			{
				Ingredient("blank_certificate", 1,"images/blank_certificate.xml"),
				Ingredient("walrus_tusk", 1),Ingredient("townportaltalisman", 5),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer2",
    },
	--空间勋章
	{
        name = "space_certificate",
        ingredients = {
            {
				Ingredient("speed_certificate", 1,"images/speed_certificate.xml"),
				Ingredient("medal_time_slider", 10,"images/medal_time_slider.xml"),
				Ingredient("townportaltalisman", 10),
			},
			{
				Ingredient("speed_certificate", 1,"images/speed_certificate.xml"),
				Ingredient("medal_time_slider", 5,"images/medal_time_slider.xml"),
				Ingredient("townportaltalisman", 5),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer3",
		placer={no_deconstruction = true},--禁止分解
    },
	--融合勋章(用来分解)
	{
        name = "multivariate_certificate",
        ingredients = {
            {
				Ingredient("blank_certificate", 2,"images/blank_certificate.xml"),
			},
        },
        -- tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.LOST,
        nounlock = true,
    },
	--中级融合勋章(用来分解)
	{
        name = "medium_multivariate_certificate",
        ingredients = {
            {
				Ingredient("blank_certificate", 4,"images/blank_certificate.xml"),
			},
        },
        -- tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.LOST,
        nounlock = true,
    },
	--高级融合勋章(用来分解)
	{
        name = "large_multivariate_certificate",
        ingredients = {
            {
				Ingredient("blank_certificate", 8,"images/blank_certificate.xml"),
			},
        },
        -- tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.LOST,
        nounlock = true,
    },
	--智能陷阱制作手册
	{
        name = "autotrap_book",
        ingredients = {
            {
				Ingredient("trapreset_book", 1,"images/trapreset_book.xml"),
				Ingredient("gears", 3),Ingredient("sewing_tape", 4),
			},
        },
		tab = CUSTOM_RECIPETABS.BOOKS,
        level = TECH.NONE,
		builder_tag = "traditionalbearer3",
    },
	--方尖锏
	{
        name = "sanityrock_mace",
        ingredients = {
            {
				Ingredient("sanityrock_fragment", 9,"images/sanityrock_fragment.xml"),
				Ingredient("moonglass", 5),Ingredient("nightmarefuel", 3),
			},
        },
        tab = RECIPETABS.MAGIC,
        level = TECH.MAGIC_THREE,
		builder_tag = "traditionalbearer3",
		placer={no_deconstruction = true},--禁止分解
    },
	--踏水勋章
	{
        name = "treadwater_certificate",
        ingredients = {
            {
				Ingredient("blank_certificate", 1,"images/blank_certificate.xml"),
				Ingredient("malbatross_feathered_weave", 4),Ingredient("cookiecuttershell", 8),--Ingredient("malbatross_beak", 1),
			},
			{
				Ingredient("blank_certificate", 1,"images/blank_certificate.xml"),
				Ingredient("malbatross_feather", 6),Ingredient("cookiecuttershell", 4),
			},
        },
        tab = RECIPETABS.CARTOGRAPHY,
        level = TECH.CARTOGRAPHY_TWO,
        nounlock = true,
		builder_tag = "traditionalbearer3",
    },
}

return {
	Recipes = Recipes,
}