local isCh = locale == "zh" or locale == "zhr"--是否为中文
name = isCh and "能力勋章" or "Functional Medal"
description = isCh and "当前版本1.5.0.8\n加入了勋章系统，大家可以通过制图桌去制作各种勋章啦~\n详细的mod介绍可以去www.guanziheng.com查看哦~\n遇到问题可以先查阅介绍页的常见问题，如果问题还是不能解决，欢迎加群反馈~\n群号:967226714" or "Addition of the Medal System, you can use the cartographer's desk to make various medals."
author = "恒子、|白日(画师)|BCI(动画)"

version = "1.5.0.8"--整体.大章节.小章节.修Bug

api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = true
restart_required = false
all_clients_require_mod = true
icon = "modicon.tex"
icon_atlas = "modicon.xml"
server_filter_tags = {"medal","能力勋章"}

forumthread = "https://www.guanziheng.com"
priority = -9999--优先级调高

configuration_options = isCh and
{
	{
		name = "language_switch",
		label = "选择语言",
		hover = "选择你的常用语言",
		options =
		{
			{description = "中文", data = "ch", hover = "中文"},
			{description = "English", data = "eng", hover = "English"},
		},
		default = "ch",
	},
	{
		name = "difficulty_switch",
		label = "难度选择",
		hover = "选择道具的制作成本",
		options =
		{
			{description = "简易", data = true, hover = "低成本"},
			{description = "默认", data = false, hover = "默认成本"},
		},
		default = false,
	},
	{
		name = "medalequipslots_switch",
		label = "勋章栏",
		hover = "额外独立出来的勋章栏，方便装备勋章",
		options =
		{
			{description = "开启", data = true, hover = "开启勋章栏"},
			{description = "关闭", data = false, hover = "关闭勋章栏"},
		},
		default = true,
	},
	{
		name = "medal_inv_switch",
		label = "勋章栏自动贴边",
		hover = "融合勋章栏是否自动贴边，贴边显示更舒适，如果开了45格等不能正常兼容的Mod可关闭该选项",
		options =
		{
			{description = "开启", data = true, hover = "自动贴边"},
			{description = "关闭", data = false, hover = "不自动贴边"},
		},
		default = true,
	},
	{
		name = "containerdrag_switch",
		label = "容器拖拽",
		hover = "开启后可拖动勋章栏、勋章盒等UI",
		options =
		{
			{description = "关闭", data = false, hover = "关闭容器拖拽"},
			{description = "开启(F1)", data = "KEY_F1", hover = "默认按住F1拖动"},
			{description = "F2", data = "KEY_F2", hover = "按住F2拖动"},
			{description = "F3", data = "KEY_F3", hover = "按住F3拖动"},
			{description = "F4", data = "KEY_F4", hover = "按住F4拖动"},
			{description = "F5", data = "KEY_F5", hover = "按住F5拖动"},
			{description = "F6", data = "KEY_F6", hover = "按住F6拖动"},
			{description = "F7", data = "KEY_F7", hover = "按住F7拖动"},
			{description = "F8", data = "KEY_F8", hover = "按住F8拖动"},
			{description = "F9", data = "KEY_F9", hover = "按住F9拖动"},
		},
		default = "KEY_F1",
	},
	{
		name = "all_containerdrag_switch",
		label = "所有容器可拖拽",
		hover = "开启后允许玩家拖拽所有容器(必须开启容器拖拽功能才生效)",
		options =
		{
			{description = "关闭", data = false, hover = "不允许拖拽所有容器，容器拖拽只对勋章自带容器有效"},
			{description = "开启", data = true, hover = "游戏内所有容器均可拖拽"},
		},
		default = true,
	},
	{
		name = "medalpage_switch",
		label = "勋章介绍页",
		hover = "勋章介绍页图标",
		options =
		{
			{description = "显示", data = true, hover = "显示介绍页图标"},
			{description = "隐藏", data = false, hover = "隐藏介绍页图标"},
		},
		default = true,
	},
	{
		name = "medal_info_switch",
		label = "显示更多信息",
		hover = "显示钓鱼池鱼的数量、预览融合勋章内勋章",
		options =
		{
			{description = "开启", data = true, hover = "显示更多信息"},
			{description = "关闭", data = false, hover = "屏蔽更多信息"},
		},
		default = true,
	},
	{
		name = "show_medal_fx",
		label = "特效",
		hover = "可选择是否开启吞噬法杖、读功能性书籍等地方会播放的特效，怕卡可关闭",
		options =
		{
			{description = "开启", data = true, hover = "开启特效"},
			{description = "关闭", data = false, hover = "关闭特效"},
		},
		default = true,
	},
	{
		name = "medal_new_crafttabs_switch",
		label = "多列制作栏",
		hover = "可选择是否开启多列制作栏，开启后额外的制作栏将会以多列的形式呈现",
		options =
		{
			{description = "关闭", data = false, hover = "单列显示"},
			{description = "开启", data = true, hover = "多列显示"},
		},
		default = true,
	},
	{
		name = "medal_tips_switch",
		label = "飘字提示",
		hover = "可选择是否开启弹幕提示，开启时部分勋章消耗耐久时会飘字提示",
		options =
		{
			{description = "关闭", data = false, hover = "关闭飘字提示"},
			{description = "开启", data = true, hover = "开启飘字提示"},
		},
		default = true,
	},
	{
		name = "transplant_switch",
		label = "移植功能",
		hover = "若不想开启移植功能或者已经开启其他同类型mod，可选择关闭",
		options =
		{
			{description = "开启", data = true, hover = "开启移植功能"},
			{description = "关闭", data = false, hover = "关闭移植功能"},
		},
		default = true,
	},
	{
		name = "medal_goodmid_resources_multiple",
		label = "高级风滚草资源",
		hover = "和花样风滚草联动，可在风滚草内加入移植作物等高级资源",
		options =
		{
			{description = "关闭", data = 0, hover = "关闭该资源"},
			{description = "开启", data = 1, hover = "加入该资源"},
			{description = "×2", data = 2, hover = "两倍掉落率"},
			{description = "×5", data = 5, hover = "五倍掉落率"},
			{description = "×10", data = 10, hover = "十倍掉落率"},
			{description = "×20", data = 20, hover = "二十倍掉落率"},
			{description = "×50", data = 50, hover = "五十倍掉落率"},
			{description = "×100", data = 100, hover = "一百倍掉落率"},
		},
		default = 1,
	},
	{
		name = "medal_goodmax_resources_multiple",
		label = "稀有风滚草资源",
		hover = "和花样风滚草联动，可在风滚草内加入勋章等稀有资源",
		options =
		{
			{description = "关闭", data = 0, hover = "关闭该资源"},
			{description = "开启", data = 1, hover = "加入该资源"},
			{description = "×2", data = 2, hover = "两倍掉落率"},
			{description = "×5", data = 5, hover = "五倍掉落率"},
			{description = "×10", data = 10, hover = "十倍掉落率"},
			{description = "×20", data = 20, hover = "二十倍掉落率"},
			{description = "×50", data = 50, hover = "五十倍掉落率"},
			{description = "×100", data = 100, hover = "一百倍掉落率"},
		},
		default = 0,
	},
	{
		name = "medal_tech_lock",
		label = "基础科技依赖",
		hover = "关闭后制作一些勋章的内容不再需要科学1~3本和魔法1~2本才能解锁\n主要为了玩无科技蓝图模式的玩家增加的设置，普通玩家无视即可。",
		options =
		{
			{description = "开启", data = false, hover = "制作本模组内容仍然需要科学本和魔法本来解锁"},
			{description = "关闭", data = true, hover = "制作本模组内容不再需要科学本和魔法本来解锁"},
		},
		default = false,
	}
} or
{
	{--选择语言
		name = "language_switch",
		label = "Language",
		hover = "Choose your common language",
		options =
		{
			{description = "中文", data = "ch", hover = "中文"},
			{description = "English", data = "eng", hover = "English"},
		},
		default = "eng",
	},
	{--难度选择
		name = "difficulty_switch",
		label = "Selection Level",
		hover = "Production cost of choosing props.",
		options =
		{
			{description = "Easy", data = true, hover = "Low cost"},
			{description = "Default", data = false, hover = "Default cost"},
		},
		default = false,
	},
	{--勋章栏
		name = "medalequipslots_switch",
		label = "Medal Equip Slots",
		hover = "Extra independent Medal Equip Slots.",
		options =
		{
			{description = "Open", data = true, hover = "Open Medal Equip Slots"},
			{description = "Closed", data = false, hover = "Closed Medal Equip Slots"},
		},
		default = true,
	},
	{--勋章栏自动贴边
		name = "medal_inv_switch",
		label = "Automatic Trimming of Medal Equip Slots",
		hover = "If the Medal Equip Slots cannot be displayed normally, you can choose to turn it off for compatibility",
		options =
		{
			{description = "Open", data = true, hover = "Open"},
			{description = "Closed", data = false, hover = "Closed"},
		},
		default = true,
	},
	{--容器拖拽
		name = "containerdrag_switch",
		label = "Drag Container",
		hover = "Drag container function switch and hotkey settings.",
		options =
		{
			{description = "Closed", data = false, hover = "Closed Drag Container"},
			{description = "Open(F1)", data = "KEY_F1", hover = "Press and hold F1 drag by default"},
			{description = "F2", data = "KEY_F2", hover = "Press and hold F2 drag"},
			{description = "F3", data = "KEY_F3", hover = "Press and hold F3 drag"},
			{description = "F4", data = "KEY_F4", hover = "Press and hold F4 drag"},
			{description = "F5", data = "KEY_F5", hover = "Press and hold F5 drag"},
			{description = "F6", data = "KEY_F6", hover = "Press and hold F6 drag"},
			{description = "F7", data = "KEY_F7", hover = "Press and hold F7 drag"},
			{description = "F8", data = "KEY_F8", hover = "Press and hold F8 drag"},
			{description = "F9", data = "KEY_F9", hover = "Press and hold F9 drag"},
		},
		default = "KEY_F1",
	},
	{--所有容器可拖拽
		name = "all_containerdrag_switch",
		label = "Drag All Container",
		hover = "Drag all container function switch and hotkey settings.",
		options =
		{
			{description = "Closed", data = false, hover = "Just drag medal container"},
			{description = "Open", data = true, hover = "Drag all container"},
		},
		default = true,
	},
	{--勋章介绍页
		name = "medalpage_switch",
		label = "Mod Wiki Page",
		hover = "Mod Wiki Page icon.",
		options =
		{
			{description = "Show", data = true, hover = "Show Wiki page icon"},
			{description = "Hide", data = false, hover = "Hide Wiki page icon"},
		},
		default = true,
	},
	{--显示更多信息
		name = "medal_info_switch",
		label = "Show more info",
		hover = "Displays the number of fish in the fishing pool",
		options =
		{
			{description = "Open", data = true, hover = "Show more info"},
			{description = "Close", data = false, hover = "Close more info"},
		},
		default = true,
	},
	{--显示特效
		name = "show_medal_fx",
		label = "Show FX",
		hover = "You can choose to show or hide FX",
		options =
		{
			{description = "Open", data = true, hover = "Show"},
			{description = "Close", data = false, hover = "Hide"},
		},
		default = true,
	},
	{--多列制作栏
		name = "medal_new_crafttabs_switch",
		label = "Multi Column Craft Tabs",
		hover = "After opening, the additional craft tabs will be presented in the form of multiple columns",
		options =
		{
			{description = "Close", data = false, hover = "Single column display"},
			{description = "Open", data = true, hover = "Multi column display"},
		},
		default = true,
	},
	{
		name = "medal_tips_switch",
		label = "Floating Tips",
		hover = "After opening,When some medals consume durability, they will be prompted with floating words",
		options =
		{
			{description = "Close", data = false, hover = "Close"},
			{description = "Open", data = true, hover = "Open"},
		},
		default = true,
	},
	{--移植功能
		name = "transplant_switch",
		label = "Transplant Function",
		hover = "If you have another transplant Mod,you can closed this button.",
		options =
		{
			{description = "Open", data = true, hover = "Open"},
			{description = "Closed", data = false, hover = "Closed"},
		},
		default = true,
	},
	{--高级风滚草资源
		name = "medal_goodmid_resources_multiple",
		label = "Advanced Tumbleweed Resources",
		hover = "Advanced resources such as transplanting crops can be added to the Tumbleweed",
		options =
		{
			{description = "Close", data = 0, hover = "Close the resource"},
			{description = "Open", data = 1, hover = "Join the resource"},
			{description = "×2", data = 2, hover = "2 times probability"},
			{description = "×5", data = 5, hover = "5 times probability"},
			{description = "×10", data = 10, hover = "10 times probability"},
			{description = "×20", data = 20, hover = "20 times probability"},
			{description = "×50", data = 50, hover = "50 times probability"},
			{description = "×100", data = 100, hover = "100 times probability"},
		},
		default = 1,
	},
	{--稀有风滚草资源
		name = "medal_goodmax_resources_multiple",
		label = "Rare Tumbleweed Resources",
		hover = "Rare resources such as Medal can be added to the Tumbleweed",
		options =
		{
			{description = "Close", data = 0, hover = "Close the resource"},
			{description = "Open", data = 1, hover = "Join the resource"},
			{description = "×2", data = 2, hover = "2 times probability"},
			{description = "×5", data = 5, hover = "5 times probability"},
			{description = "×10", data = 10, hover = "10 times probability"},
			{description = "×20", data = 20, hover = "20 times probability"},
			{description = "×50", data = 50, hover = "50 times probability"},
			{description = "×100", data = 100, hover = "100 times probability"},
		},
		default = 0,
	},
	{--基础科技依赖
		name = "medal_tech_lock",
		label = "Technology Dependence",
		hover = "After closing, the content of making some medals no longer needs science and magic to unlock. \nIt is mainly to the settings added by players in no technology mode. Ordinary players can ignore this option.",
		options =
		{
			{description = "Open", data = false, hover = "Making the content of this mod still needs to unlock the science and magic."},
			{description = "Close", data = true, hover = "Making the content of this mod no longer needs to unlock the science and magic."},
		},
		default = false,
	}
}