--seworldstatus和goldstaff里有计算材料价格之和的公式，如果物品在本列表中有价格，则以本列表的价格为优先
selist_food =
{
	{name = "kabobs", price = 36},--肉串
	{name = "meatballs", price = 54},--肉丸
	{name = "bonestew", price = 100},--肉汤
	{name = "meat_dried", price = 60},--肉干
	{name = "turkeydinner", price = 90},--火鸡正餐
	{name = "baconeggs", price = 125},--鸡蛋火腿
	{name = "perogies", price = 114},--饺子
	{name = "hotchili", price = 85},--辣椒酱
	{name = "guacamole", price = 85},--鼬鼠沙拉
	{name = "unagi", price = 76},--鳗鱼寿司
	{name = "frogglebunwich", price = 64},--青蛙三明治
	{name = "fishtacos", price = 76},--玉米鱼饼
	{name = "fishsticks", price = 112},--鱼条
	{name = "honeynuggets", price = 92},--甜蜜金砖
	{name = "honeyham", price = 142},--蜜汁火腿
	{name = "monsterlasagna", price = 71},--怪兽千层饼
	{name = "powcake", price = 36},--芝士蛋糕
	{name = "butterflymuffin", price = 54},--蝴蝶松饼
	{name = "fruitmedley", price = 64},--水果拼盘
	{name = "ratatouille", price = 58},--蔬菜杂烩
	{name = "jammypreserves", price = 72},--果酱蜜饯
	{name = "trailmix", price = 64},--水果杂烩
	{name = "flowersalad", price = 96},--花瓣沙拉
	{name = "taffy", price = 48},--太妃糖
	{name = "icecream", price = 228},--冰淇淋
	{name = "waffles", price = 256},--华夫饼
	{name = "pumpkincookie", price = 76},--南瓜饼
	{name = "stuffedeggplant", price = 82},--香酥茄盒
	{name = "watermelonicle", price = 63},--西瓜冰
	{name = "dragonpie", price = 124},--火龙果派
	{name = "pepperpopper", price = 58, atlas = 2},--爆炒填馅辣椒
	{name = "mashedpotatoes", price = 120, atlas = 1},--奶油土豆泥
	{name = "potatotornado", price = 68, atlas = 2},--花式回旋块茎
	{name = "salsa", price = 99, atlas = 2},--生鲜萨尔萨酱
	{name = "vegstinger", price = 75, atlas = 2},--蔬菜鸡尾酒
	{name = "asparagussoup", price = 66, atlas = 1},--芦笋汤

	{name = "surfnturf", price = 148, atlas = 2},--海鲜牛排
	{name = "seafoodgumbo", price = 138, atlas = 2},--海鲜浓汤
	{name = "californiaroll", price = 107, atlas = 1},--加州卷
	{name = "ceviche", price = 135, atlas = 1},--酸橘汁腌鱼
	{name = "lobsterdinner", price = 374, atlas = 1},--龙虾正餐
	{name = "lobsterbisque", price = 144, atlas = 1},--龙虾汤
	{name = "barnaclestuffedfishhead", price = 87, atlas = 1},--酿鱼头
	{name = "barnaclinguine", price = 96, atlas = 1},--藤壶中细面
	{name = "barnaclepita", price = 48, atlas = 1},--藤壶皮塔饼
	{name = "barnaclesushi", price = 75, atlas = 1},--藤壶握寿司
	{name = "sweettea", price = 46, atlas = 2},--舒缓茶
	{name = "koalefig_trunk", price = 334, atlas = 1},--无花果酿树干
	{name = "figkabab", price = 79, atlas = 1},--无花果烤串
	{name = "figatoni", price = 97, atlas = 1},--无花果意面
	{name = "frognewton", price = 51, atlas = 1},--无花果蛙腿三明治

	{name = "meatysalad", price = 108, atlas = 1},--牛肉绿叶菜
	{name = "leafymeatsouffle", price = 123, atlas = 1},--果冻沙拉
	{name = "leafymeatburger", price = 158, atlas = 1},--素食堡
	{name = "leafloaf", price = 117, atlas = 1},--叶肉糕
	{name = "bananapop", price = 66, atlas = 1},--香蕉冻
	{name = "mandrakesoup", price = 450},--曼德拉草汤
	{name = "bonesoup", price = 171, atlas = 1},--骨头汤
	{name = "freshfruitcrepes", price = 351, atlas = 1},--鲜果可丽饼
	{name = "moqueca", price = 160, atlas = 1},--海鲜杂烩
	{name = "monstertartare", price = 132, atlas = 1},--怪物达达
	{name = "voltgoatjelly", price = 450, atlas = 2},--伏特羊角冻
	{name = "glowberrymousse", price = 204, atlas = 1},--发光浆果慕斯
	{name = "potatosouffle", price = 148, atlas = 2},--蓬松土豆蛋奶酥
	{name = "frogfishbowl", price = 135, atlas = 1},--蓝带鱼排
	{name = "gazpacho", price = 96, atlas = 1},--芦笋冷汤
	{name = "dragonchilisalad", price = 212, atlas = 1},--辣龙椒沙拉
	{name = "nightmarepie", price = 255, atlas = 1},--恐怖国王饼
	{name = "smallmeat", price = 18},--小肉
	{name = "meat", price = 30},--大肉
	{name = "monstermeat", price = 27},--怪兽肉
	{name = "drumstick", price = 18},--鸡腿
	{name = "bird_egg", price = 12},--鸡蛋
	{name = "fishmeat_small", price = 20, atlas = 1},--小鱼块
	{name = "fishmeat", price = 33, atlas = 1},--大鱼块
	{name = "kelp", price = 10, atlas = 1},--海带
	{name = "barnacle", price = 14, atlas = 1},--藤壶
	{name = "fig", price = 11, atlas = 1},--无花果
	{name = "wobster_sheller_land", price = 80, atlas = 2},--龙虾
	{name = "eel", price = 60},--鳗鱼
	{name = "froglegs", price = 14},--青蛙腿
	{name = "plantmeat", price = 33},--食人花肉
	{name = "batwing", price = 62},--蝙蝠翅膀
	{name = "batnose", price = 43, atlas = 1},--裸露鼻孔
	{name = "trunk_summer", price = 125},--红色象鼻
	{name = "trunk_winter", price = 200},--蓝色象鼻
	{name = "berries", price = 3},--浆果
	{name = "berries_juicy", price = 6},--蜜汁浆果
	{name = "rock_avocado_fruit_ripe", price = 8, atlas = 2},--成熟石果
	{name = "cutlichen", price = 4},--苔藓
	{name = "ice", price = 6},--冰
	{name = "red_cap", price = 8},--红蘑菇
	{name = "green_cap", price = 12},--绿蘑菇
	{name = "blue_cap", price = 16},--蓝蘑菇
	{name = "moon_cap", price = 24, atlas = 1},--月亮蘑菇
	{name = "cactus_meat", price = 19},--仙人掌
	{name = "cactus_flower", price = 30},--仙人掌花
	{name = "cave_banana", price = 16},--香蕉
	{name = "butterflywings", price = 8},--蝴蝶翅膀
	{name = "moonbutterflywings", price = 20, atlas = 1},--月蛾翅膀
	{name = "moon_tree_blossom", price = 10, atlas = 1},--月树花
	{name = "honey", price = 8},--蜂蜜
	{name = "petals", price = 2},--花瓣
	{name = "petals_evil", price = 8},--噩梦花瓣
	{name = "carrot", price = 12},--胡萝卜
	{name = "corn", price = 18},--玉米
	{name = "durian", price = 24},--榴莲
	{name = "pomegranate", price = 21},--石榴
	{name = "eggplant", price = 28},--茄子
	{name = "pumpkin", price = 35},--南瓜
	{name = "watermelon", price = 30},--西瓜
	{name = "dragonfruit", price = 75},--火龙果
	{name = "asparagus", price = 18, atlas = 1},--芦笋
	{name = "onion", price = 33, atlas = 2},--洋葱
	{name = "potato", price = 28, atlas = 2},--土豆
	{name = "tomato", price = 24, atlas = 2},--番茄
	{name = "garlic", price = 21, atlas = 1},--大蒜
	{name = "pepper", price = 15, atlas = 2},--辣椒
	{name = "forgetmelots", price = 7, atlas = 1},--必忘我
	{name = "tillweed", price = 2, atlas = 2},--犁地草
	{name = "firenettles", price = 4, atlas = 1},--火荨麻叶
}

selist_cloth = 
{
	{name = "sewing_kit", price = nil},--缝补机
	{name = "strawhat", price = nil},--草帽
	{name = "flowerhat", price = nil},--花环
	{name = "grass_umbrella", price = nil},--花伞
	{name = "umbrella", price = nil},--雨伞
	{name = "minifan", price = nil},--风车
	{name = "beefalohat", price = nil},--牛角帽
	{name = "catcoonhat", price = nil},--猫帽
	{name = "earmuffshat", price = nil},--兔毛耳罩
	{name = "hawaiianshirt", price = nil},--花纹衬衫
	{name = "icehat", price = nil},--冰块
	{name = "raincoat", price = nil},--雨衣
	{name = "rainhat", price = nil},--雨帽
	{name = "reflectivevest", price = nil},--夏季背心
	{name = "trunkvest_summer", price = nil},--夏日背心
	{name = "trunkvest_winter", price = nil},--寒冬背心
	{name = "watermelonhat", price = nil},--西瓜帽
	{name = "kelphat", price = nil, atlas = 1},--海花冠
	{name = "winterhat", price = nil},--冬帽

	{name = "torch", price = nil},--火把
	{name = "redlantern", price = 124},--灯笼
	{name = "lantern", price = nil},--提灯
	{name = "minerhat", price = nil},--矿工帽
	{name = "pumpkin_lantern", price = nil},--南瓜灯
	{name = "molehat", price = nil},--地鼠帽

	{name = "beehat", price = nil},--养蜂帽
	{name = "featherhat", price = nil},--羽毛帽
	{name = "bushhat", price = nil},--浆果帽
	{name = "tophat", price = nil},--高礼帽
	{name = "spiderhat", price = 325},--女王帽
	{name = "goggleshat", price = nil},--时尚眼镜
	{name = "sweatervest", price = nil},--小巧背心
	{name = "onemanband", price = nil},--独奏乐器
	{name = "compass", price = nil},--指南针
	{name = "waterballoon", price = nil},--水球
	{name = "amulet", price = nil},--红护符
	{name = "blueamulet", price = nil},--蓝护符
	{name = "purpleamulet", price = nil},--紫护符

	{name = "heatrock", price = nil},--暖石
	{name = "bedroll_straw", price = nil},--稻草卷
	{name = "bedroll_furry", price = nil},--毛皮铺盖
	{name = "bernie_inactive", price = nil},--小熊
	{name = "giftwrap", price = nil},--彩纸
	{name = "bundlewrap", price = nil},--空包裹
	{name = "featherpencil", price = nil},--羽毛笔
	{name = "healingsalve", price = 36},--药膏
	{name = "tillweedsalve", price = nil, atlas = 2},--犁地草膏
	{name = "bandage", price = nil},--蜂蜜药膏
	{name = "lifeinjector", price = nil},--针筒
	{name = "reskin_tool", price = nil, atlas = 2},--清洁扫把

	{name = "backpack", price = nil},--背包
	{name = "piggyback", price = nil},--小猪包
	{name = "seedpouch", price = nil, atlas = 2},--种子袋
	{name = "winter_ornament_light1", price = 150},--圣诞灯红
	{name = "winter_ornament_light2", price = 150},--圣诞灯绿
	{name = "winter_ornament_light3", price = 150},--圣诞灯蓝
	{name = "winter_ornament_light4", price = 150},--圣诞灯白
}

selist_smithing = 
{
	{name = "armorgrass", price = nil},--草甲
	{name = "armorwood", price = nil},--木甲
	{name = "spear", price = nil},--长矛
	{name = "spear_wathgrithr", price = 124},--战斗长矛
	{name = "wathgrithrhat", price = 132},--战斗头盔
	{name = "hambat", price = nil},--火腿棒
	{name = "footballhat", price = nil},--猪皮头盔
	{name = "cookiecutterhat", price = nil, atlas = 1},--饼干切割机帽子
	{name = "tentaclespike", price = 115},--触手棒
	{name = "batbat", price = nil},--蝙蝠棒
	{name = "nightsword", price = nil},--影刀
	{name = "armor_sanity", price = nil},--影甲
	{name = "armormarble", price = nil},--大理石甲
	{name = "whip", price = nil},--猫尾鞭
	{name = "boomerang", price = nil},--飞镖
	{name = "blowdart_pipe", price = nil},--吹箭
	{name = "blowdart_fire", price = nil},--燃烧吹箭
	{name = "blowdart_sleep", price = nil},--麻醉吹箭
	{name = "blowdart_yellow", price = nil},--电磁吹箭
	{name = "firestaff", price = nil},--红魔杖
	{name = "icestaff", price = nil},--蓝魔杖
	{name = "telestaff", price = nil},--紫魔杖

	{name = "gunpowder", price = nil},--炸药
	{name = "trap_teeth", price = nil},--狗牙陷阱
	{name = "beemine", price = nil},--蜜蜂地雷
	{name = "waterplant_bomb", price = 29, atlas = 2},--种壳

	{name = "axe", price = nil},--斧头
	{name = "shovel", price = nil},--铲子
	{name = "pickaxe", price = nil},--矿锄
	{name = "goldenaxe", price = nil},--金斧头
	{name = "goldenshovel", price = nil},--金铲子
	{name = "goldenpickaxe", price = nil},--金矿锄
	{name = "hammer", price = nil},--锤子
	{name = "pitchfork", price = nil},--草叉
	{name = "razor", price = nil},--剃须刀
	{name = "bugnet", price = nil},--捕虫网
	{name = "birdtrap", price = nil},--捕鸟器
	{name = "beef_bell", price = nil, atlas = 1},--皮弗娄牛铃
	{name = "saddle_basic", price = nil},--鞍
	{name = "saddlehorn", price = nil},--取鞍器
	{name = "fishingrod", price = nil},--鱼竿

	{name = "farm_hoe", price = nil, atlas = 1},--园艺锄
	{name = "golden_farm_hoe", price = nil, atlas = 1},--黄金园艺锄
	{name = "wateringcan", price = nil, atlas = 2},--浇水壶
	{name = "farm_plow_item", price = nil, atlas = 1},--耕地机
	{name = "soil_amender", price = 80, atlas = 2},--催长剂起子
	{name = "plantregistryhat", price = nil, atlas = 2},--耕作先驱帽
	{name = "treegrowthsolution", price = nil, atlas = 2},--树果酱

	{name = "pocket_scale", price = nil, atlas = 2},--弹簧秤
	{name = "oceanfishingrod", price = nil, atlas = 2},--海钓竿
	{name = "oceanfishingbobber_ball", price = nil, atlas = 1},--木球浮标
	{name = "oceanfishingbobber_oval", price = nil, atlas = 2},--硬物浮标
	{name = "oceanfishinglure_spoon_red", price = nil, atlas = 2},--日出匙型假饵
	{name = "oceanfishinglure_spoon_green", price = nil, atlas = 2},--黄昏匙型假饵
	{name = "oceanfishinglure_spoon_blue", price = nil, atlas = 2},--夜间匙型假饵
	{name = "oceanfishinglure_spinner_red", price = nil, atlas = 2},--日出旋转亮片
	{name = "oceanfishinglure_spinner_green", price = nil, atlas = 2},--黄昏旋转亮片
	{name = "oceanfishinglure_spinner_blue", price = nil, atlas = 2},--夜间旋转亮片

	{name = "boat_item", price = nil, atlas = 1},--船套装
	{name = "boatpatch", price = nil, atlas = 1},--船补丁
	{name = "oar", price = nil, atlas = 1},--浆
	{name = "oar_driftwood", price = nil, atlas = 1},--浮木浆
	{name = "anchor_item", price = nil, atlas = 1},--锚套装
	{name = "mast_item", price = nil, atlas = 1},--桅杆套装
	{name = "steeringwheel_item", price = nil, atlas = 2},--方向舵套装
	{name = "mastupgrade_lamp_item", price = nil, atlas = 1},--甲板照明灯
	{name = "mastupgrade_lightningrod_item", price = nil, atlas = 1},--避雷导线

	{name = "turf_grass", price = nil},--长草地皮
	{name = "turf_forest", price = nil},--森林地皮
	{name = "turf_savanna", price = nil},--草地地皮
	{name = "turf_deciduous", price = nil},--季节地皮
	{name = "turf_rocky", price = nil},--岩石地皮
	{name = "turf_carpetfloor", price = nil},--地毯地板
	{name = "turf_checkerfloor", price = nil},--方格地板
	{name = "turf_woodfloor", price = nil},--木质地板
	{name = "turf_road", price = nil},--卵石路
	{name = "turf_pebblebeach", price = 40, atlas = 2},--岩石海滩地皮
	{name = "turf_shellbeach", price = nil, atlas = 2},--贝壳海滩地皮
	{name = "turf_meteor", price = 87, atlas = 2},--月球环形山地皮
	{name = "turf_archive", price = 114, atlas = 2},--远古石刻

	{name = "fence_item", price = nil},--栅栏
	{name = "fence_gate_item", price = nil},--木门
	{name = "wall_hay_item", price = nil},--草墙
	{name = "wall_wood_item", price = nil},--木墙
	{name = "wall_stone_item", price = nil},--石墙
	{name = "wall_moonrock_item", price = nil},--月石墙
}

selist_resource = 
{
	{name = "cutgrass", price = 5},--草
	{name = "twigs", price = 6},--树枝
	{name = "log", price = 10},--木头
	{name = "charcoal", price = 6},--木炭
	{name = "driftwood_log", price = 34, atlas = 1},--浮木桩
	{name = "cutreeds", price = 8},--芦苇
	{name = "rocks", price = 8},--石头
	{name = "flint", price = 6},--燧石
	{name = "nitre", price = 12},--硝石
	{name = "goldnugget", price = 14},--金块
	{name = "saltrock", price = 22, atlas = 2},--盐晶
	{name = "rock_avocado_fruit", price = 18, atlas = 2},--石果
	{name = "marble", price = 34},--大理石
	{name = "moonrocknugget", price = 34},--月石
	{name = "dug_berrybush", price = 27},--浆果丛
	{name = "dug_berrybush2", price = 34},--热带浆果丛
	{name = "dug_berrybush_juicy", price = 40},--蜜汁浆果丛
	{name = "dug_grass", price = 20},--草丛
	{name = "dug_sapling", price = 17},--树枝丛
	{name = "dug_marsh_bush", price = 21},--尖刺丛
	{name = "pinecone", price = 5},--常青树种子
	{name = "acorn", price = 6},--桦树种子
	{name = "twiggy_nut", price = 6},--多枝树种
	{name = "lureplantbulb", price = 180},--食人花
	{name = "livingtree_root", price = 100, atlas = 1},--完全正常的树根
	{name = "rock_avocado_fruit_sprout", price = 85, atlas = 2},--发芽的石果
	{name = "bullkelp_root", price = 51, atlas = 1},--公牛海带茎
	{name = "waterplant_planter", price = 68, atlas = 2},--海芽插穗
	{name = "dug_trap_starfish", price = 188, atlas = 1},--海星陷阱
	{name = "seeds", price = 6},--种子
	{name = "foliage", price = 6},--蕨叶
	{name = "succulent_picked", price = 10},--肉质植物
	{name = "lightbulb", price = 12},--荧光果
	{name = "wormlight_lesser", price = 24},--小发光浆果
	{name = "wormlight", price = 68},--发光浆果
	{name = "fireflies", price = 84},--萤火虫
	{name = "lightflier", price = 101, atlas = 1},--球状光虫
	{name = "redgem", price = 100},--红宝石
	{name = "bluegem", price = 100},--蓝宝石
	{name = "purplegem", price = 200},--紫宝石
	{name = "livinglog", price = 90},--活木
	{name = "nightmarefuel", price = 32},--噩梦燃料
	{name = "spidergland", price = 16},--蜘蛛腺体
	{name = "silk", price = 20},--蜘蛛网
	{name = "spidereggsack", price = 140},--蜘蛛巢
	{name = "honeycomb", price = 120},--蜂巢
	{name = "coontail", price = 100},--猫尾
	{name = "boneshard", price = 20},--骨片
	{name = "houndstooth", price = 38},--狗牙
	{name = "stinger", price = 18},--蜂刺
	{name = "cookiecuttershell", price = 52, atlas = 1},--饼干切割机壳
	{name = "messagebottleempty", price = 38, atlas = 1},--空瓶子
	{name = "horn", price = 180},--牛角
	{name = "beefalowool", price = 21},--牛毛
	{name = "pigskin", price = 48},--猪皮
	{name = "manrabbit_tail", price = 53},--兔毛
	{name = "feather_crow", price = 16},--黑鸟毛
	{name = "feather_robin", price = 18},--红鸟毛
	{name = "feather_robin_winter", price = 22},--蓝鸟毛
	{name = "feather_canary", price = 36},--金鸟毛
	{name = "beardhair", price = 20},--胡须
	{name = "tentaclespots", price = 74},--触手皮
	{name = "mosquitosack", price = 32},--血袋
	{name = "rottenegg", price = 10},--臭鸡蛋
	{name = "spoiled_food", price = 6},--腐烂食物
	{name = "poop", price = 12},--屎
	{name = "guano", price = 10},--鸟屎
	{name = "phlegm", price = 100},--鼻涕
	{name = "glommerfuel", price = 38},--格罗姆粘液
	{name = "slurtleslime", price = 30},--含糊虫粘液
	{name = "slurtle_shellpieces", price = 30, atlas = 2},--壳碎片
	{name = "spore_medium", price = 55},--红色孢子
	{name = "spore_small", price = 55},--绿色孢子
	{name = "spore_tall", price = 55},--蓝色孢子
	{name = "tallbirdegg", price = 130},--高鸟蛋
	{name = "butterfly", price = 16},--蝴蝶
	{name = "bee", price = 22},--蜜蜂
	{name = "rabbit", price = 24},--兔子
	{name = "mole", price = 36},--地鼠
	{name = "carrat", price = 42, atlas = 1},--胡萝卜鼠
	{name = "crow", price = 22},--黑鸟
	{name = "robin", price = 33},--红鸟
	{name = "robin_winter", price = 44},--蓝鸟
	{name = "puffin", price = 48, atlas = 2},--海鹦鹉
	{name = "canary", price = 55},--金丝雀
	{name = "canary_poisoned", price = 125},--中毒金丝雀
	{name = "oceanfish_small_8_inv", price = 150, atlas = 2},--炽热太阳鱼
	{name = "oceanfish_medium_8_inv", price = 150, atlas = 2},--冰鲷鱼
	{name = "oceanfish_small_9_inv", price = 90, atlas = 2},--口水鱼
}

selist_precious = 
{
	{name = "blueprint", price = 250},--蓝图

	{name = "goatmilk", price = 1200},--电羊奶
	{name = "butter", price = 1600},--蝴蝶黄油
	{name = "royal_jelly", price = 1500},--蜂王浆
	{name = "jellybean", price = 600},--糖豆

	{name = "mandrake", price = 2500},--曼德拉草
	{name = "bearger_fur", price = 2800},--熊皮
	{name = "deerclops_eyeball", price = 3600},--眼球
	{name = "dragon_scales", price = 600},--龙鳞
	{name = "goose_feather", price = 200},--鹅毛
	{name = "deer_antler3", price = 250},--鹿角钥匙
	{name = "klaussackkey", price = 1800},--真钥匙
	{name = "fossil_piece", price = 600},--化石碎片
	{name = "gears", price = 400},--齿轮
	{name = "greengem", price = 1400},--绿宝石
	{name = "orangegem", price = 1100},--橙宝石
	{name = "yellowgem", price = 1100},--黄宝石
	{name = "lavae_egg", price = 600},--熔岩虫卵
	{name = "lightninggoathorn", price = 1200},--电羊角
	{name = "minotaurhorn", price = 2500},--犀牛角
	{name = "shroom_skin", price = 1600},--蛤蟆皮
	{name = "atrium_key", price = 1200},--远古钥匙
	{name = "shadowheart", price = 1600},--暗影之心
	{name = "slurper_pelt", price = 450},--辍食者皮
	{name = "thulecite", price = 200},--铥矿
	{name = "steelwool", price = 800},--刚羊毛
	{name = "walrus_tusk", price = 1000},--海象牙
	{name = "walrushat", price = 2400},--海象帽

	{name = "armorruins", price = 2100},--铥矿甲
	{name = "armorslurper", price = 3500},--饥饿腰带
	{name = "eyeturret_item", price = 9999},--眼球塔
	{name = "greenstaff", price = 4500},--绿法杖
	{name = "orangestaff", price = 4800},--橙法杖
	{name = "yellowstaff", price = 3700},--黄法杖
	{name = "nightstick", price = 1900},--晨星
	{name = "panflute", price = 2500},--排箫
	{name = "ruins_bat", price = 1800},--铥矿棒
	{name = "ruinshat", price = 1400},--铥矿头盔
	{name = "slurtlehat", price = 1200},--蜗牛帽
	{name = "armorsnurtleshell", price = 1800},--蜗牛壳
	{name = "staff_tornado", price = 5200},--旋风

	{name = "cane", price = 1000},--步行手杖
	{name = "featherfan", price = 1500},--鹅毛扇
	{name = "icepack", price = 6000},--冰背包
	{name = "opalstaff", price = 7400},--呼月法杖
	{name = "saddle_race", price = 1200},--蝴蝶鞍
	{name = "saddle_war", price = 4800},--战斗鞍
	{name = "armordragonfly", price = 1400},--龙鳞衣
	{name = "beargervest", price = 4600},--熊皮大衣
	{name = "eyebrellahat", price = 5600},--眼球伞
	{name = "greenamulet", price = 2200},--绿护符
	{name = "orangeamulet", price = 1700},--橙护符
	{name = "yellowamulet", price = 1700},--黄护符
	{name = "hivehat", price = 2000},--蜂王冠
	{name = "krampus_sack", price = 9999},--小偷包
	{name = "armorskeleton", price = 4000},--骨甲
	{name = "skeletonhat", price = 3200},--骨盔
	{name = "deserthat", price = 300},--风镜
	{name = "thurible", price = 2400},--暗影香炉
	{name = "townportaltalisman", price = 300},--沙之石
	{name = "sleepbomb", price = 800},--催眠袋
	{name = "red_mushroomhat", price = 120},--红菇帽
	{name = "green_mushroomhat", price = 120},--绿菇帽
	{name = "blue_mushroomhat", price = 120},--蓝菇帽
	{name = "trinket_15", price = 270},--白主教
	{name = "trinket_16", price = 270},--黑主教
	{name = "trinket_28", price = 270},--白战车
	{name = "trinket_29", price = 270},--黑战车
	{name = "trinket_30", price = 270},--白骑士
	{name = "trinket_31", price = 270},--黑骑士

	{name = "moonrockseed", price = 2000, atlas = 1},--天体宝球
	{name = "messagebottle", price = 250, atlas = 1},--瓶中信
	{name = "trident", price = 3000, atlas = 2},--刺耳三叉戟
	{name = "moonbutterfly", price = 300, atlas = 1},--月蛾
	{name = "moonglass", price = 200, atlas = 1},--月亮碎片
	{name = "malbatross_feather", price = 800, atlas = 1},--邪天翁羽毛
	{name = "malbatross_beak", price = 1000, atlas = 1},--邪天翁喙
	{name = "gnarwail_horn", price = 650, atlas = 1},--一角鲸的角

	{name = "carnival_gametoken", price = 64, atlas = 1},--鸦年华代币
	{name = "carnival_prizebooth_kit", price = 625, atlas = 1},--奖品摊位套装
	{name = "carnivalgame_feedchicks_kit", price = 625, atlas = 1},--鸟鸟吃虫虫套装
	{name = "carnivalgame_herding_kit", price = 625, atlas = 1},--追蛋套装
	{name = "carnivalgame_memory_kit", price = 625, atlas = 1},--篮中蛋套装

	{name = "spider_healer", price = 520, atlas = 2},--护士蜘蛛
}

selist_special = 
{
	{name = "goldstaff", price = 1000},--点金法杖
	{name = "luckamulet", price = 1500},--幸运项链
	{name = "stealer", price = 7000},--勤奋的探索者
	{name = "vipcard", price = 9999},--vip贵宾卡
}

--特殊蓝图
selist_blueprint = 
{
	{name = "mushroom_light_blueprint", price = 2000},--萤菇灯
	{name = "mushroom_light2_blueprint", price = 2000},--炽菇灯
	{name = "bundlewrap_blueprint", price = 2000},--空包裹
	{name = "sleepbomb_blueprint", price = 2000},--睡球
	{name = "endtable_blueprint", price = 2000},--茶几
	{name = "dragonflyfurnace_blueprint", price = 2000},--龙鳞熔炉
	{name = "townportal_blueprint", price = 2000},--沙传送阵
	{name = "goggleshat_blueprint", price = 2000},--时尚眼镜
	{name = "deserthat_blueprint", price = 2000},--风镜
	{name = "red_mushroomhat_blueprint", price = 2000},--红菇帽
	{name = "green_mushroomhat_blueprint", price = 2000},--绿菇帽
	{name = "blue_mushroomhat_blueprint", price = 2000},--蓝菇帽
}