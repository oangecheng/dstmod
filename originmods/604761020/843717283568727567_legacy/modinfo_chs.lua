version = "170823.10:40" 
old_version = "161029.06:25"
desc_variant = ("当前版本："..version.."  上个版本："..old_version..
    "\n\n    你会突然发现卵石超难搞定！\n    让一个卵石更耐挖，更多石头供玩家们开采。"..
    "\n  ++ 新增 ++\n    增加了一条配置选项——黄金概率\n    已挖尽的卵石可再生（默认关闭）\n       如不想再生？用铲子挖掉即可！")
description = desc_variant
author = "Shang"
forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = true
reign_of_giants_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_only_mod = true
icon_atlas = "rocksmodicon.xml"
icon = "rocksmodicon.tex"

lssza = "\n避免出现漏洞\n不建议设置太过于久"
lsszb = " 天后卵石立即生长"
lsszc = "\n（注：卵石永不删除）"
wjcsa = "卵石将会更加耐挖"
bsgla = " x 默认几率"

configuration_options = 
{
    {
        name = "wajuecishu",
        label = "打击次数",
        hover = "开采完一个卵石的稿数",
        options =
        {
            {description = "33", data = 1, hover = "使卵石更容易开采完"},
            {description = "66", data = 2, hover = "默认"},
            {description = "99", data = 3, hover = "使卵石更难开采完"},
            {description = "132", data = 4, hover = wjcsa},
            {description = "165", data = 5, hover = wjcsa},
            {description = "198", data = 6, hover = wjcsa}
        },
        default = 2,
    },
    {
        name = "shishengzhang",
        label = "生长卵石",
        hover = "让卵石会生长而永不消失（无长时间开服测试，漏洞存在与否是未知数\n Ps.服务器重启后未生长的卵石直接生长）",
        options =
        {
            {description = "关闭", data = 0, hover = "选择此选项此功能作废"},
            {description = "半天", data = .5, hover = "0.5"..lsszb..lsszc},
            {description = "1 天", data = 1, hover = "1"..lsszb..lsszc},
            {description = "2 天", data = 2, hover = "2"..lsszb..lsszc},
            {description = "3 天", data = 3, hover = "3"..lsszb..lsszc},
            {description = "4 天", data = 4, hover = "4"..lsszb..lsszc},
            {description = "5 天", data = 5, hover = "5"..lsszb..lsszc},
            {description = "6 天", data = 6, hover = "6"..lsszb..lsszc},
            {description = "7 天", data = 7, hover = "7"..lsszb..lsszc},
            {description = "10 天", data = 10, hover = "10"..lsszb..lssza},
            {description = "15 天", data = 15, hover = "15"..lsszb..lssza},
            {description = "20 天", data = 20, hover = "20"..lsszb..lssza}
        },
        default = 0,
    },
    {
        name = "shitoubaolv",
        label = "石头概率",
        hover = "可以调整开采出石头的几率",
        options =
        {
            {description = "无", data = 0, hover = "此选项将不会开采出石头"},
            {description = "困难", data = .3, hover = "更难开采出石头"},
            {description = "减少", data = .6, hover = "较难开采出石头"},
            {description = "默认", data = 1, hover = "这是平衡的\n推荐"},
            {description = "2 倍", data = 2, hover = "较容易开采出石头"},
            {description = "3 倍", data = 3, hover = "容易开采出石头\n不推荐"}
        },
        default = 1,
    },
    {
        name = "huangjinbaolv",
        label = "黄金概率",
        hover = "可以调整开采出黄金的几率",
        options =
        {
            {description = "无", data = 0, hover = "此选项将不会开采出金块"},
            {description = "困难", data = .3, hover = "更难开采出金块"},
            {description = "减少", data = .6, hover = "这是平衡的\n推荐"},
            {description = "默认", data = 1, hover = "较容易开采出金块"},
            {description = "2 倍", data = 2, hover = "较容易开采出金块"},
            {description = "3 倍", data = 3, hover = "容易开采出金块\n不推荐"}
        },
        default = 1,
    },
    {
        name = "baoshibaolv",
        label = "宝石概率",
        hover = "可以调整开采出宝石的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出宝石"},
            {description = "困难", data = .3, hover = "更难开采出宝石"},
            {description = "减少", data = .6, hover = "较难开采出宝石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla},
            {description = "32 倍", data = 32, hover = "32"..bsgla},
            {description = "100 倍", data = 100, hover = "疯了！"}
        },
        default = 1,
    },
    {
        name = "SHENGDANSHI",
        label = "圣诞卵石",
        hover = "卵石随机彩色涂装",
        options =
        {
            {description = "关", data = false, hover = "就当什么也没发生"},
            {description = "开", data = true, hover = "卵石随机彩色涂装"},
        },
        default = false,
    },
    {
        name = "RUOYINXIAN",
        label = "随机透明",
        hover = "卵石随机透明度涂装",
        options =
        {
            {description = "关", data = false, hover = "当我神马也没做"},
            {description = "开", data = true, hover = "卵石将有随机透明度涂装"},
        },
        default = false,
    },

    {
        name = "er_shuoming",
        label = "",
        hover = "",
        options =
        {
            {description = "", data = 0, hover = ""},
        },
        default = 0,
    },
    {
        name = "yi_shuoming",
        label = "宝石",
        hover = "",
        options =
        {
            {description = "单独概率", data = 0, hover = ""},
        },
        default = 0,
    },
    {
        name = "blue_baoshi",
        label = "蓝宝石",
        hover = "单独调整蓝宝石的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出蓝宝石"},
            {description = "困难", data = .3, hover = "更难开采出蓝宝石"},
            {description = "减少", data = .6, hover = "较难开采出蓝宝石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "6 倍", data = 6, hover = "6"..bsgla},
            {description = "10 倍", data = 10, hover = "10"..bsgla}
        },
        default = 1,
    },
    {
        name = "red_baoshi",
        label = "红宝石",
        hover = "单独调整红宝石的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出红宝石"},
            {description = "困难", data = .3, hover = "更难开采出红宝石"},
            {description = "减少", data = .6, hover = "较难开采出红宝石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
    {
        name = "orange_baoshi",
        label = "橙宝石",
        hover = "单独调整橙宝石的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出橙宝石"},
            {description = "困难", data = .3, hover = "更难开采出橙宝石"},
            {description = "减少", data = .6, hover = "较难开采出橙宝石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
    {
        name = "yellow_baoshi",
        label = "黄宝石",
        hover = "单独调整黄宝石的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出黄宝石"},
            {description = "困难", data = .3, hover = "更难开采出黄宝石"},
            {description = "减少", data = .6, hover = "较难开采出黄宝石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "12 倍", data = 12, hover = "12"..bsgla}
        },
        default = 1,
    },
    {
        name = "green_baoshi",
        label = "绿宝石",
        hover = "单独调整绿宝石的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出绿宝石"},
            {description = "困难", data = .3, hover = "更难开采出绿宝石"},
            {description = "减少", data = .6, hover = "较难开采出绿宝石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
    {
        name = "purple_baoshi",
        label = "紫宝石",
        hover = "单独调整紫宝石的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出紫宝石"},
            {description = "困难", data = .3, hover = "更难开采出紫宝石"},
            {description = "减少", data = .6, hover = "较难开采出紫宝石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "12 倍", data = 12, hover = "12"..bsgla}
        },
        default = 1,
    },
    {
        name = "thulecite_xiukuang",
        label = "铥矿石",
        hover = "是铥矿哦，不是碎片",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出铥矿石"},
            {description = "困难", data = .3, hover = "更难开采出铥矿石"},
            {description = "减少", data = .6, hover = "较难开采出铥矿石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla},
            {description = "32 倍", data = 32, hover = "32"..bsgla}
        },
        default = 1,
    },
    {
        name = "marble_suipian",
        label = "大理石和铥矿碎片",
        hover = "大理石和铥矿碎片的几率",
        options =
        {
            {description = "无", data = 0, hover = "不会开采出铥矿石"},
            {description = "困难", data = .3, hover = "更难开采出铥矿石"},
            {description = "减少", data = .6, hover = "较难开采出铥矿石"},
            {description = "默认", data = 1, hover = "默认的几率"},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
}