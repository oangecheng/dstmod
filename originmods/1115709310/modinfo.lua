local Ch = locale == "zh" or locale == "zhr"

name =
Ch and
[[ 简单经济学]] or
[[ Simple Economy]]

description =
Ch and
[[V1.4.2
新增一个交易系统，可以在游戏内赚钱用钱了。
使用专属道具来赚取金币。
点击左上角的图标打开商品交易面板，使用金币换取需要的东西。
珍贵品每3天的早上会刷新。
不同的季节商品的价格不一样。
]] or
[[V1.4.2
Implemented a new shopping system, where players can now earn gold in game.
Use dedicated items to earn gold.
Click on the icon at the top left corner to open the shop interface, and use gold to buy items.
Rare items will be reshuffled every 3 days in the morning.
Prices will vary seasonally.
]]

author = "柴柴"
version = "1.4.2"
forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {}

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
        name = "Disintegrate",
        label = "允许点金分解",
        options =   {
                        {description = "否", data = false, hover = "不允许使用点金杖分解任何掉落物; 点金杖仅可用来击杀低血量怪物以换取金币; 选此选项后以点金杖攻击低血量生物可100%几率击杀"},
                        {description = "是", data = true, hover = "允许使用点金杖分解任何掉落物; 选此选项后以点金杖攻击低血量生物仅可25%几率击杀"},
                    },
        default = true,
    },
    {
        name = "Dig",
        label = "挖掘机当铲子",
        options =   {
                        {description = "否", data = false},
                        {description = "是", data = true},
                    },
        default = false,
    },
    {
        name = "Hammer",
        label = "挖掘机当锤子",
        options =   {
                        {description = "否", data = false},
                        {description = "是", data = true},
                    },
        default = false,
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
        name = "Disintegrate",
        label = "Disintegrate",
        options =   {
                        {description = "No", data = false, hover = "Not allow to use Midas Wand to disintegrate something; It can only gain gold by killing a mob with low health"},
                        {description = "Yes", data = true, hover = "Allow to use Midas Wand to disintegration something"},
                    },
        default = true,
    },
    {
        name = "Dig",
        label = "Use the stealer as a shovel",
        options =   {
                        {description = "No", data = false},
                        {description = "Yes", data = true},
                    },
        default = false,
    },
    {
        name = "Hammer",
        label = "Use the stealer as a hammer",
        options =   {
                        {description = "No", data = false},
                        {description = "Yes", data = true},
                    },
        default = false,
    },
}