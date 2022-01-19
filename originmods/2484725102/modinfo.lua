name = "Upgradeable Chest"
description = "upgrade your chest with boards.\n\nLarger content, same space occupation.\n\n\n\n\nWoddie and Lucy rate this 5 stars."
author = "CC"
version = "9.10"

api_version = 10

dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "upgradablechest.xml"
icon = "upgradablechest.tex"

server_filter_tags = {"upgradable chest"}

forumthread = ""

configuration_options =
{
	{
		name = "MAX_LV",
		label = "Max upgrade",
		options =
			{
				{description = "up to 5x5", data = 5, hover = "able to upgrade 1 times"},
				{description = "up to 7x7", data = 7, hover = "able to upgrade 2 times"},
				{description = "up to 9x9", data = 9, hover = "able to upgrade 3 times"},
				{description = "up to 11x11", data = 11, hover = "able to upgrade 4 times"},
				{description = "up to 13x13", data = 13, hover = "able to upgrade 5 times"},
				{description = "infinite", data = 63, hover = "to test the limits and break through? challenge accepted!"},
			},
		default = 9,
	},
	{
		name = "",
		label = "Upgradeable Containers:",
		options = {{description = "", data = 0}},
		default = 0,
	},
	{
		name = "C_TREASURECHEST",
		label = "Chest",
		options =	{
						{description = "no", data = false},
						{description = "yes", data = true, hover = "1 boards in each outermost slots"},
					},
		default = true,
	},
	{
		name = "C_ICEBOX",
		label = "Ice Box",
		options =	{
						{description = "no", data = false},
						{description = "yes", data = true, hover = "1 gears in each top-most slots, 1 cut stone in each other outermost slots"},
					},
		default = true,
	},
	{
		name = "C_SALTBOX",
		label = "Salt Box",
		options =	{
						{description = "no", data = false},
						{description = "yes", data = true, hover = "1 salt crystal in each outermost slots, and 1 blue gem in the center-most slot"},
					},
		default = true,
	},
	{
		name = "C_DRAGONFLYCHEST",
		label = "Dragonfly Chest",
		options =	{
						{description = "no", data = false},
						{description = "yes", data = true, hover = "1 boards in each outermost slots"},
					},
		default = true,
	},
	{
		name = "C_FISH_BOX",
		label = "Fish Box",
		options =	{
						{description = "no", data = false},
						{description = "yes", data = true, hover = "1 rope in each outermost slots"},
					},
		default = true,
	},
	{
		name = "",
		label = "Widget UI Setting:",
		options = {{description = "", data = 0}},
		default = 0,
	},
	{
		name = "SHOWGUIDE",
		label = "Shows Guide",
		hover = "Show you the upgrade requirement\nWon't show for Column/Row Upgrade\(expensive mode\)",
		options =	{
						{description = "never", data = false},
						{description = "always", data = true},
						{description = "auto", data = 3, hover = "Turn the guide off after you upgrade the chest once."},
					},
		default = 3,
		client = true,
	},
	{
		name = "UI_WIDGETPOS",
		label = "Widget Position",
		options =	{
						{description = "upside", data = false, hover = "unchange, above the character"},
						{description = "leftside", data = true, hover = "next to the character"},
					},
		default = true,
		client = true,
	},
	{
		name = "DRAGGABLE",
		label = "Draggable Widget",
		options =	{
						{description = "disable", data = false},
						{description = "3x3", data = 3, hover = "show 3x3 slots"},
						{description = "4x4", data = 4, hover = "show 4x4 slots"},
						{description = "5x5\(suggest\)", data = 5, hover = "show 5x5 slots"},
						{description = "6x6", data = 6, hover = "show 6x6 slots"},
						{description = "7x7", data = 7, hover = "show 7x7 slots"},
					},
		default = false,
		client = true,
	},
	{
		name = "UI_ICEBOX",
		label = "Ice Box Leftward",
		hover = "shift the ui of ice box leftward so that it won't block your cooker",
		options = 	{
						{description = "no", data = false},
						{description = "yes", data = true},
					},
		default = false,
		client = true,
	},
	{
		name = "DROPALL",
		label = "\"Drop All\" Button",
		hover = "a button allow you dropping the entire content to the ground",
		options = 	{
						{description = "no", data = false},
						{description = "yes", data = true},
					},
		default = false,
		client = true,
	},
	{
		name = "UI_BGIMAGE",
		label = "Hide Background Image",
		options = 	{
						{description = "no", data = false},
						{description = "yes", data = true},
					},
		default = false,
		client = true,
	},
	{
		name = "",
		label = "Other Functions:",
		options = {{description = "", data = 0}},
		default = 0,
	},
--[[	{--I will make this option work when I stop update the mod, now is forced on
		name = "MODCOMPAT",
		label = "Mod Compat",
		hover = "Allow the mod to compat with more mods. I won't fix any bug that happens after the option is on",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = false,
	},]]
	{
		name = "UPG_MODE",
		label = "Upgrade Mode",
		hover = "Testing function\nChange the upgrading mode",
		options = {
			{description = "normal mode", data = 1, hover = "put upgrade items on the outermost slots"},
			{description = "expensive mode", data = 2, hover = "put upgrade items to the right or to the bottom for upgrade"},
			{description = "complex mode", data = 3, hover = "both of the modes"},
		},
		default = 1,
	},
	{
		name = "PAGEABLE",
		label = "Pageable Upgrade",
		hover = "Testing feature\nMake the Chest Pageable",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true, hover = "After the chest is in max level, put the upgrade items to all the slots in 1st page"},
		},
		default = false,
	},
	{
		name = "CHANGESIZE",
		label = "Change Size",
		hover = "Change the chest size scale to its level",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = false,
	},
	{
		name = "SCALE_FACTOR",
		label = "Size Factor",
		hover = "The scale for upgraded chest\(in radius\)\nActivate only if \"Change Size\" option on.",
		options = {
			{description = "2", data = 1, hover = "Size of 6x6 chest is 2 times to the 3x3"},
			{description = "1.5", data = 2, hover = "Size of 6x6 chest is 1.5 times to the 3x3"},
			{description = "1.33", data = 3, hover = "Size of 6x6 chest is 1.33 times to the 3x3"},
			{description = "1.25", data = 4, hover = "Size of 6x6 chest is 1.25 times to the 3x3"},
			{description = "1.2", data = 5},
			{description = "1.16", data = 6},
			{description = "1.1", data = 10}
		},
		default = 3,
	},
	{
		name = "DEGRADABLE",
		label = "Downgrade-able",
		hover = "Enable downgrading the chest\nPut a hammer in the empty container",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = true,
	},
	{
		name = "INSIGHT",
		label = "Insight",
		hover = "Mod: Insight will shows the detailed info for chest level",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = true,
		--client = true,
	},
	{
		name = "RETURNITEM",
		label = "Deconstruct Return Items",
		hover = "Testing function\nReturn items when decontrution",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = false,
	},
	{
		name = "",
		label = "DEBUG:",
		options = {{description = "", data = 0}},
		default = 0,
	},
	{
		name = "DEBUG_MAXLV",
		label = "Max Level",
		hover = "Containers are in max lv once builded",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = false,
	},
	{
		name = "DEBUG_IIC",
		label = "Item in Container",
		hover = "Put upgrade material and hammer into container once builded",
		options = {
			{description = "no", data = false},
			{description = "yes", data = true},
		},
		default = false,
	},
}

if locale == "zh" or locale == "zht" then

	configuration_options = {
		{
			name = "MAX_LV",
			label = "等级上限",
			options =
				{
					{description = "直到5x5", data = 5, hover = "可以升级 1 次"},
					{description = "直到7x7", data = 7, hover = "可以升级 2 次"},
					{description = "直到9x9", data = 9, hover = "可以升级 3 次"},
					{description = "直到11x11", data = 11, hover = "可以升级 4 次"},
					{description = "直到13x13", data = 13, hover = "可以升级 5 次"},
					{description = "无限", data = 63, hover = "想挑战上限？接受挑战"},
				},
			default = 9,
		},
		{
			name = "",
			label = "可升级的容器:",
			options = {{description = "", data = 0}},
			default = 0,
		},
		{
			name = "C_TREASURECHEST",
			label = "箱子",
			options =	{
							{description = "否", data = false},
							{description = "是", data = true, hover = "1 木板到每一个最外层储存格"},
						},
			default = true,
		},
		{
			name = "C_ICEBOX",
			label = "冰箱",
			options =	{
							{description = "否", data = false},
							{description = "是", data = true, hover = " 1 齿轮到每一个最上层储存格，1 石砖到其他最外层储存格"},
						},
			default = true,
		},
		{
			name = "C_SALTBOX",
			label = "盐盒",
			options =	{
							{description = "否", data = false},
							{description = "是", data = true, hover = "1 盐晶到每一个最外层储存格，1 蓝宝石到最中间储存格"},
						},
			default = true,
		},
		{
			name = "C_DRAGONFLYCHEST",
			label = "龙鳞宝箱",
			options =	{
							{description = "否", data = false},
							{description = "是", data = true, hover = "1 木板到每一个最外层储存格"},
						},
			default = true,
		},
		{
			name = "C_FISH_BOX",
			label = "锡鱼罐",
			options =	{
							{description = "否", data = false},
							{description = "是", data = true, hover = "1 绳子到每一个最外层储存格"},
						},
			default = true,
		},
		{
			name = "",
			label = "UI设置:",
			options = {{description = "", data = 0}},
			default = 0,
		},
		{
			name = "SHOWGUIDE",
			label = "显示升级需求",
			hover = "为你显示升级所需物品\n不会显示 行/列升级（混合模式） 的需求",
			options =	{
							{description = "永不", data = false},
							{description = "一直", data = true},
							{description = "自动", data = 3, hover = "当你进行一次升级后，永久关闭显示"},
						},
			default = 3,
			client = true,
		},
		{
			name = "UI_WIDGETPOS",
			label = "位置",
			options =	{
							{description = "上面", data = false, hover = "原版的位置, 人物上方"},
							{description = "左面", data = true, hover = "在人物左边"},
						},
			default = true,
			client = true,
		},
		{
			name = "DRAGGABLE",
			label = "可拖动UI",
			options =	{
							{description = "关闭", data = false},
							{description = "3x3", data = 3, hover = "显示3x3的数量"},
							{description = "4x4", data = 4, hover = "显示4x4的数量"},
							{description = "5x5\(建议\)", data = 5, hover = "显示5x5的数量"},
							{description = "6x6", data = 6, hover = "显示6x6的数量"},
							{description = "7x7", data = 7, hover = "显示7x7的数量"},
						},
			default = false,
			client = true,
		},
		{
			name = "UI_ICEBOX",
			label = "冰箱UI左移",
			hover = "UI左移使UI不会遮挡烹饪锅",
			options = 	{
							{description = "否", data = false},
							{description = "是", data = true},
						},
			default = false,
			client = true,
		},
		{
			name = "DROPALL",
			label = "\"清空\"按钮",
			hover = "一个能把箱子里所有物品扔到地上的按钮",
			options = 	{
							{description = "否", data = false},
							{description = "是", data = true},
						},
			default = false,
			client = true,
		},
		{
			name = "UI_BGIMAGE",
			label = "隐藏UI背景",
			options = 	{
							{description = "否", data = false},
							{description = "是", data = true},
						},
			default = false,
			client = true,
		},
		{
			name = "",
			label = "其他功能:",
			options = {{description = "", data = 0}},
			default = 0,
		},
	--[[	{
			name = "MODCOMPAT",
			label = "模组兼容",
			hover = "让本模组可兼容更多模组，开启以后出bug概不负责",
			options = {
				{description = "否", data = false},
				{description = "是", data = true},
			},
			default = true,
		},]]
		{
			name = "UPG_MODE",
			label = "升级模式",
			hover = "测试中\n变更升级模式",
			options = {
				{description = "普通模式", data = 1, hover = "升级材料放最外圈储存格"},
				{description = "复杂模式", data = 2, hover = "升级材料放最右列 / 最下行储存格以进行横向 / 纵向升级"},
				{description = "混合模式", data = 3, hover = "我全都要"},
			},
			default = 1,
		},
		{
			name = "PAGEABLE",
			label = "翻页升级",
			hover = "测试中\n让箱子可翻页的升级",
			options = {
				{description = "否", data = false},
				{description = "是", data = true, hover = "满级以后，把升级材料放满第 1 页"},
			},
			default = false,
		},
		{
			name = "CHANGESIZE",
			label = "改变大小",
			hover = "测试中\n根据箱子等级改变箱子大小",
			options = {
				{description = "no", data = false},
				{description = "yes", data = true},
			},
			default = false,
		},
		{
			name = "SCALE_FACTOR",
			label = "大小比例",
			hover = "改变箱子大小的比例\n只在\"改变大小\"选项开启时有效",
			options = {
				{description = "2", data = 1, hover = "1:2, ie. 6x6箱子2倍大(半径)"},
				{description = "1.5", data = 2},
				{description = "1.33", data = 3, hover = "1:1.33, ie. 6x6箱子1.33倍大(半径)"},
				{description = "1.25", data = 4},
				{description = "1.2", data = 5, hover = "1:1.2, ie. 6x6箱子1.2倍大(半径)"},
				{description = "1.16", data = 6},
				{description = "1.1", data = 10, hover = "1:1.1, ie. 6x6箱子1.1倍大(半径)"}
			},
			default = 3,
		},
		{
			name = "DEGRADABLE",
			label = "可降级",
			hover = "箱子可降级\n放一个锤子进空箱子",
			options = {
				{description = "no", data = false},
				{description = "yes", data = true},
			},
			default = true,
		},
		{
			name = "INSIGHT",
			label = "Insight资讯",
			hover = "模组: Insight 会为你显示更多资讯",
			options = {
				{description = "no", data = false},
				{description = "yes", data = true},
			},
			default = true,
			--client = true,
		},
		{
			name = "RETURNITEM",
			label = "拆除返还材料",
			hover = "测试中\n拆除时返还升级材料",
			options = {
				{description = "否", data = false},
				{description = "是", data = true, hover = "锤子返一半，法杖返所有（并不）"},
			},
			default = false,
		},
		{
			name = "",
			label = "除错模式:",
			options = {{description = "", data = 0}},
			default = 0,
		},
		{
			name = "DEBUG_MAXLV",
			label = "满级",
			hover = "容器在建造的时候就已经满级",
			options = {
				{description = "否", data = false},
				{description = "是", data = true},
			},
			default = false,
		},
		{
			name = "DEBUG_IIC",
			label = "自带升级材料",
			hover = "容器在建造时自带升级材料和锤子",
			options = {
				{description = "no", data = false},
				{description = "yes", data = true},
			},
			default = false,
		},
	}
end

if locale == "zh" or locale == "zht" then
	description = description.."\n\n\nUI设置是客户端设置, 前往 主菜单->模组->服务器模组 更改"
else
	description = description.."\n\n\nThe UI Settings are client configs, change setting from\nmain menu->Mod->Server Mods"
end