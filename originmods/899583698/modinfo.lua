local Ch = locale == "zh" or locale == "zhr"

name =
Ch and
[[ [DST]托托莉]] or
[[ [DST]Totooria]]

description =
Ch and
[[V2.4.8
托托莉.赫尔蒙德  阿兰德的炼金术师
初始智商高，血量低，攻击力低
做各种事情可以升级，吃曼德拉草洗点
不同的等级能自动学到不同的生存特技
可以读书，可以制造更多的物品
自带托托莉的法杖，可以升级
高级的法杖能有更多的用处
]] or
[[V2.4.8
Totooria Helmold, Alchemist of Arland
High sanity, low health, low damage
Can level up by doing anything.
Eating Mandrake will reset skill points with penalty.
Able to read, able to make multiple items.
Starts the game with Totooria's Wand (upgradable).
Upgraded Totooria's Wand will have more functions.
]]

author = "柴柴"
version = "2.4.8"
forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
	"character",
}

configuration_options =
Ch and
{
    {
        name = "Language",
        label = "语言",
        options =   {
                        {description = "English", data = false},
                        {description = "简体中文", data = true},
                    },
        default = true,
    },

    {
        name = "GameMode",
        label = "游戏模式",
        options =   {
                        {description = "平衡", data = true, hover = "平衡益智，适合专注型玩家"},
                        {description = "休闲", data = false, hover = "休闲轻松，适合娱乐型玩家"},
                    },
        default = true,
    },

    {
        name = "Sound",
        label = "托托莉声音",
        options =   {
                        {description = "Wendy", data = false},
                        {description = "Willow", data = true},
                    },
        default = true,
    },
    
    {
        name = "TotooriaSpeech",
        label = "托托莉对话",
        options =   {
                        {description = "Wilson", data = 1},
                        {description = "Willow", data = 2},
                        {description = "Wigfrid", data = 3},
                        {description = "Wickerbottom", data = 4},
                    },
        default = 1,
    },
    
    {
        name = "Dig",
        label = "法杖当铲子",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = false,
    },
    
    {
        name = "Hammer",
        label = "法杖当锤子",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = false,
    },

    {
        name = "UIHeight",
        label = "信息栏高度",
        options =   {
                        {description = "默认", data = 80},
                        {description = "略高", data = 120},
                        {description = "超高", data = 160},
                    },
        default = 80,
    },

    {
        name = "UIScale",
        label = "信息栏缩放",
        options =   {
                        {description = "默认", data = .75},
                        {description = "较大", data = 1},
                        {description = "较小", data = .5},
                    },
        default = .75,
    },

    {
        name = "TotooriaAnim",
        label = "托托莉贴图",
        options =   {
                        {description = "新版(默认)", data = "totooria"},
                        {description = "旧版", data = "totooriaold"},
                    },
        default = "totooria",
    },
} or
{
    {
        name = "Language",
        label = "Language",
        options =   {
                        {description = "English", data = false},
                        {description = "Chinese", data = true},
                    },
        default = false,
    },

    {
        name = "GameMode",
        label = "GameMode",
        options =   {
                        {description = "Balance", data = true, hover = ""},
                        {description = "Easy", data = false, hover = ""},
                    },
        default = true,
    },

    {
        name = "Sound",
        label = "Totooria Sound",
        options =   {
                        {description = "Wendy", data = false},
                        {description = "Willow", data = true},
                    },
        default = true,
    },
	
	{
        name = "TotooriaSpeech",
        label = "Totooria Speech",
        options =   {
                        {description = "Wilson", data = 1},
                        {description = "Willow", data = 2},
						{description = "Wigfrid", data = 3},
						{description = "Wickerbottom", data = 4},
                    },
        default = 1,
    },
	
	{
        name = "Dig",
        label = "Use the staff as a shovel",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = false,
    },
	
	{
        name = "Hammer",
        label = "Use the staff as a hammer",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = false,
    },

    {
        name = "UIHeight",
        label = "UI Height",
        options =   {
                        {description = "Default", data = 80},
                        {description = "High", data = 120},
                        {description = "Super High", data = 160},
                    },
        default = 80,
    },

    {
        name = "UIScale",
        label = "UI Scale",
        options =   {
                        {description = "Default", data = .75},
                        {description = "Large", data = 1},
                        {description = "Small", data = .5},
                    },
        default = .75,
    },

    {
        name = "TotooriaAnim",
        label = "Totooria Anim",
        options =   {
                        {description = "New Ver.", data = "totooria"},
                        {description = "Old Ver.", data = "totooriaold"},
                    },
        default = "totooria",
    },
}

