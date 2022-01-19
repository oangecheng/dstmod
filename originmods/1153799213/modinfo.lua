name = "Craftable Material"

description = [[可以用很多常见的材料来制作稀有的物品。
Can craft some rare materials by common materials.

目前存在的问题：启用配方会导致替换掉原本的配方，启用制作铥矿石，则会替换掉原本通过远古科技6个碎片合成一个完整铥矿的配方。活木也是一样，启用活木会导致沃姆伍德（虫木）不能在他独特的制造栏里做活木了。
Current problem: If you enable thulecites and livinglogs recipes, it will replace the original recipe, enable thulecite in the refine tabs, then you cannot find the original thulecite recipe in the ancient tab.So did the Living Log, it will cause Wormwood cannot craft living log by his own ability.]]

author = "Sotar"

version = "1.12"


forumthread = ""

api_version = 10

api_version_dst = 10

priority = 0

dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
hamlet_compatible = false
shipwrecked_compatible = false

client_only_mod = false
all_clients_require_mod = true

server_filter_tags =
{
	"Material",
}

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = 
{
	{
		name = "language",
		label = "语言(Language)",
		hover = "物品描述的语言。(Language of recipes description in game.)",
		options =
		{
			{description = "English", data = "0", hover = "English recipe description."},
			{description = "中文", data = "1", hover = "中文配方说明。"},
		},
		default = "0",
	},
	{
		name = "redgem",
		label = "红宝石(Red Gem)",
		hover = "是否开启制作红宝石的配方？(Can craft red gem or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作红宝石。(Can craft red gems in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作红宝石。(Cannot craft red gems in game.)"},
		},
		default = "0",
	},
	{
		name = "bluegem",
		label = "蓝宝石(Blue Gem)",
		hover = "是否开启制作蓝宝石的配方？(Can craft blue gem or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作蓝宝石。(Can craft blue gems in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作蓝宝石。(Cannot craft blue gems in game.)"},
		},
		default = "0",
	},
	{
		name = "gear",
		label = "齿轮(Gear)",
		hover = "是否开启制作齿轮的配方？(Can craft gears or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作齿轮。(Can craft gears in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作齿轮。(Cannot craft gears in game.)"},
		},
		default = "0",
	},	
	{
		name = "pigskin",
		label = "猪皮(Pig Skin)",
		hover = "是否开启制作猪皮的配方？(Can craft pig skin or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作猪皮。(Can craft pig skin in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作猪皮。(Cannot craft pig skin in game.)"},
		},
		default = "0",
	},	
	{
		name = "saltrock",
		label = "海盐(Salt)",
		hover = "是否开启制作海盐的配方？(Can craft salt or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作海盐。(Can craft salt in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作海盐。(Cannot craft salt in game.)"},
		},
		default = "0",
	},
	{
		name = "barnacle",
		label = "藤壶(Barnacles)",
		hover = "是否开启制作藤壶的配方？(Can craft barnacles or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作藤壶。(Can craft barnacles in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作藤壶。(Cannot craft barnacles in game.)"},
		},
		default = "0",
	},
	{
		name = "moonrock",
		label = "月石(Moon Rock)",
		hover = "是否开启制作月石的配方？(Can craft moonrocks or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作月石。(Can craft moonrocks in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作月石。(Cannot craft moonrocks in game.)"},
		},
		default = "0",
	},
	{
		name = "livinglog",
		label = "活木(Living Log)",
		hover = "是否令所有人都可以制作活木？会导致虫木角色无法通过特殊能力制作活木。(Everyone can craft livinglogs and Wormwood cannot craft it by his own ability tab.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "所有角色可以在游戏内制作活木。(Everyone can craft livinglogs in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "只有虫木可以制作活木。(Only Wormwood can craft livinglogs.)"},
		},
		default = "1",
	},
	{
		name = "marble",
		label = "大理石(Marble)",
		hover = "是否开启制作大理石的配方？(Can craft marbles or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作大理石。(Can craft marbles in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作大理石。(Cannot craft marbles in game.)"},
		},
		default = "0",
	},
	{
		name = "gold",
		label = "黄金(Gold)",
		hover = "是否开启制作黄金的配方？(Can craft gold or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作黄金。(Can craft gold in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作黄金。(Cannot craft gold in game.)"},
		},
		default = "1",
	},
	{
		name = "thulecite",
		label = "铥矿石(Thulecite)",
		hover = "是否使用新的制作铥矿石的配方？会导致原本的配方被覆盖。(Can craft thulecites or not. Will replace the original recipe.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以以更常见的物品制作铥矿石。(A new recipe will replace the original recipe.)"},
			{description = "关闭(Disable)", data = "1", hover = "只能使用原始配方合成铥矿。(Can craft thulecites by the original recipe.)"},
		},
		default = "1",
	},
	{
		name = "yellowgem",
		label = "黄宝石(Yellow Gem)",
		hover = "是否开启制作黄宝石的配方？(Can craft yellow gem or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作黄宝石。(Can craft yellow gems in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作黄宝石。(Cannot craft yellow gems in game.)"},
		},
		default = "0",
	},
	{
		name = "orangegem",
		label = "橙宝石(Orange Gem)",
		hover = "是否开启制作橙宝石的配方？(Can craft orange gem or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作橙宝石。(Can craft orange gems in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作橙宝石。(Cannot craft orange gems in game.)"},
		},
		default = "0",
	},
	{
		name = "greengem",
		label = "绿宝石(Green Gem)",
		hover = "是否开启制作绿宝石的配方？(Can craft green gem or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作绿宝石。(Can craft green gems in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作绿宝石。(Cannot craft green gems in game.)"},
		},
		default = "0",
	},
	{
		name = "butter",
		label = "蝴蝶黄油(Butter)",
		hover = "是否开启制作蝴蝶黄油的配方？(Can craft butter or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作蝴蝶黄油。(Can craft butter in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作蝴蝶黄油。(Cannot craft butter in game.)"},
		},
		default = "0",
	},
	{
		name = "tusk",
		label = "海象牙(Walrus Tusk)",
		hover = "是否开启制作海象牙的配方？(Can craft walrus tusks or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作海象牙。(Can craft walrus tusks in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作海象牙。(Cannot craft walrus tusks in game.)"},
		},
		default = "0",
	},
	{
		name = "beargerfur",
		label = "熊皮(Bearger Fur)",
		hover = "是否开启制作熊皮的配方？(Can craft bearger fur or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作熊皮。(Can craft bearger fur in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作熊皮。(Cannot craft bearger fur in game.)"},
		},
		default = "1",
	},
	{
		name = "goosefeather",
		label = "鹿鹅羽毛(Goose Feather)",
		hover = "是否开启制作鹿鹅羽毛的配方？(Can craft goose feather or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作鹿鹅羽毛。(Can craft goose feather in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作鹿鹅羽毛。(Cannot craft goose feather in game.)"},
		},
		default = "1",
	},
	{
		name = "goathorn",
		label = "电羊角(Volt Goat Horn)",
		hover = "是否开启制作电羊角的配方？(Can craft goat horn or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作电羊角。(Can craft goat horn in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作电羊角。(Cannot craft goat horn in game.)"},
		},
		default = "0",
	},
	{
		name = "steelwool",
		label = "钢羊毛(Steel Wool)",
		hover = "是否开启制作钢丝绒的配方？(Can craft steelwools or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作钢丝绒。(Can craft steelwools in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作钢丝绒。(Cannot craft steelwools in game.)"},
		},
		default = "0",
	},
	{
		name = "lightbulb",
		label = "荧光果(Light Bulb)",
		hover = "是否开启制作荧光果的配方？(Can craft lightbulbs or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作荧光果。(Can craft lightbulbs in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作荧光果。(Cannot craft lightbulbs in game.)"},
		},
		default = "0",
	},
	{
		name = "manrabbittail",
		label = "兔毛(Bunny Tail)",
		hover = "是否开启制作兔毛的配方？(Can craft bunny tails or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作兔毛。(Can craft bunny tails in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作兔毛。(Cannot craft bunny tails in game.)"},
		},
		default = "0",
	},
	{
		name = "batwing",
		label = "蝙蝠翅膀(Bat Wing)",
		hover = "是否开启制作蝙蝠翅膀的配方？选择其主要材料。(Can craft batwings or not. And choose the main material of it.)",
		options =
		{
			{description = "触手皮(Tentacle)", data = "0", hover = "需要触手皮作为主要合成材料。(The Tentacle Spots will be the main material.)"},
			{description = "蜘蛛网(Silks)", data = "1", hover = "主要材料为蛛网和猪皮。(The main material will be the Silks and the Pig Skins.)"},
			{description = "关闭(Disable)", data = "2", hover = "不能制作蝙蝠翅膀。(Cannot craft batwing in game.)"},
		},
		default = "0",
	},
	{
		name = "fireflies",
		label = "萤火虫(Fireflies)",
		hover = "是否开启制作萤火虫的配方？(Can craft fireflies or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作萤火虫。(Can craft fireflies in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作萤火虫。(Cannot craft fireflies in game.)"},
		},
		default = "0",
	},
	{
		name = "minotaurhorn",
		label = "远古守护者的角(Guardian's Horn)",
		hover = "是否开启制作远古犀牛角的配方？选择其主要材料。(Can craft guardian's horn or not. And choose the main material of it.)",
		options =
		{
			{description = "牛角(Beefalo Horns)", data = "0", hover = "需要牛角作为主要合成材料。(The Beefalo Horns will be the main material.)"},
			{description = "海象牙(Tusks)", data = "1", hover = "主要材料为海象牙。(The main material will be Walrus Tusks.)"},
			{description = "关闭(Disable)", data = "2", hover = "不能制作远古守护者的角。(Cannot craft guardian's horn in game.)"},
		},
		default = "0",
	},
	{
		name = "opalpreciousgem",
		label = "彩虹宝石(Iridescent Gem)",
		hover = "是否开启制作彩虹宝石的配方？(Can craft iridescent gem or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作彩虹宝石。(Can craft iridescent gems in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作彩虹宝石。(Cannot craft iridescent gems in game.)"},
		},
		default = "0",
	},
	{
		name = "horn",
		label = "牛角(Beefalo Horn)",
		hover = "是否开启制作牛角的配方？(Can craft beefalo horn or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作牛角。(Can craft beefalo horn in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作牛角。(Cannot craft beefalo horn in game.)"},
		},
		default = "0",
	},
	{
		name = "mole",
		label = "鼹鼠(Mole)",
		hover = "是否开启制作鼹鼠的配方？(Can craft mole or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作鼹鼠。(Can craft mole in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作鼹鼠。(Cannot craft mole in game.)"},
		},
		default = "0",
	},
	{
		name = "lureplantbulb",
		label = "食人花种子(Fleshy Bulb)",
		hover = "是否开启制作食人花种子的配方？(Can craft fleshy bulb or not.)",
		options =
		{
			{description = "开启(Enable)", data = "0", hover = "可以制作食人花种子。(Can craft fleshy bulb in game.)"},
			{description = "关闭(Disable)", data = "1", hover = "不能制作食人花种子。(Cannot craft fleshy bulb in game.)"},
		},
		default = "1",
	},
}