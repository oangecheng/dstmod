local Ch = locale == "zh" or locale == "zhr"

name =
Ch and
[[ 卡尼猫]] or
[[ Carney]]

description =
Ch and
[[V1.4.7
旅行中的卡尼猫，
拥有灵活的战斗技能，按键RZC
走路和吃鱼类升级，没有极限
就算死了，也不能阻止走路升级
容易获得更多的采集倍率和击杀掉落倍率
可以制作方便实用的帽子、短剑和背包
]] or
[[V 1.4.7
Carney is on her trip
has flexible combat skills
walking and eating fish make her upgrade,
no upper limit
can craft useful hat,dagger and backpack
——Even I died,the Death can't stop me from upgrading
]]

author = "柴柴"
version = "1.4.7"
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

local alpha = 
{
    {description = "B", key = 98},
    {description = "C", key = 99},
    {description = "G", key = 103},
    {description = "J", key = 106},
    {description = "R", key = 114},
    {description = "T", key = 116},
    {description = "V", key = 118},
    {description = "X", key = 120},
    {description = "Z", key = 122},
    {description = "LAlt", key = 308},
    {description = "LCtrl", key = 306},
    {description = "LShift", key = 304},
    {description = "Space", key = 32},
}
local keyslist = {}
for i = 1,#alpha do keyslist[i] = {description = alpha[i].description, data = alpha[i].key} end

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
        default = Ch,
    },
    {
        name = "DodgeKey",
        label = "闪避按键",
        options = keyslist,
        default = 114,
    },
    {
        name = "ChargeKey",
        label = "蓄力按键",
        options = keyslist,
        default = 122,
    },
    {
        name = "IcicleKey",
        label = "冰柱按键",
        options = keyslist,
        default = 99,
    },
    {
        name = "CheckKey",
        label = "自我检查按键",
        options = keyslist,
        default = 106,
    },
    {
        name = "DaggerLimit",
        label = "短剑限制",
        options =   {
                        {description = "有上限", data = true},
                        {description = "无上限", data = false},
                    },
        default = false,
    },
    {
        name = "CrossEdge",
        label = "闪避穿越边缘",
        options =   {
                        {description = "是", data = true},
                        {description = "否", data = false},
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
        default = Ch,
    },
    {
        name = "DodgeKey",
        label = "DodgeKey",
        options = keyslist,
        default = 114,
    },
    {
        name = "ChargeKey",
        label = "ChargeKey",
        options = keyslist,
        default = 122,
    },
    {
        name = "IcicleKey",
        label = "IcicleKey",
        options = keyslist,
        default = 99,
    },
    {
        name = "CheckKey",
        label = "CheckKey",
        options = keyslist,
        default = 106,
    },
    {
        name = "DaggerLimit",
        label = "DaggerLimit",
        options =   {
                        {description = "true", data = true},
                        {description = "false", data = false},
                    },
        default = false,
    },
    {
        name = "CrossEdge",
        label = "CrossEdge",
        options =   {
                        {description = "true", data = true},
                        {description = "false", data = false},
                    },
        default = false,
    },
}

