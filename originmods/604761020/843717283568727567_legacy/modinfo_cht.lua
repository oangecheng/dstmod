version = "170823.10:40"
old_version = "161029.06:25"
desc_variant = ("當前版本："..version.."  上個版本："..old_version..
    "\n\n    你會突然發現卵石超難搞定！\n    讓一個卵石更耐挖，更多石頭供玩家開採。"..
    "\n  ++ 新增 ++\n    增加了一條配置選項——黃金概率\n    已挖盡的卵石可再生（默認關閉）\n       如不想再生？用鏟子挖掉即可！ ")
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

lssza = "\n避免出現漏洞\n不建議實質太過於久"
lsszb = " 天后卵石立即生長"
lsszc = "\n（注：卵石永不刪除）"
wjcsa = "卵石將會更加耐挖"
bsgla = " x 默認幾率"

bhkc = "不會開採出"
jnkc = "較難開採出"
gnkc = "更難開採出"

dlsdk = "大理石和铥矿碎片"
sdk = "銩礦石"
slb = "藍寶石"
shb = "紅寶石"
scb = "橙寶石"
syb = "黃寶石"
slb = "綠寶石"
szb = "紫寶石"
sdd = "大理石和銩礦碎片"


hdjcs = "開採完一個卵石的稿數"
hszls = "讓卵石會生長而永不消失（這是個新功能，請大家踴躍測試）\n Ps.伺服器重啟后未生長的卵石會直接生長"
hstgl = "可以調整開采出石頭的幾率"
hhjgl = "可以調整開採出金塊的幾率"
hbsgl = "可以調整開采出寶石的幾率"
hsdls = "卵石隨機彩色塗裝"
hsjtm = "卵石隨機透明度塗裝"


hdt  = "單獨調整"
hjl  = "的幾率"
hlbs = hdt..slb..hjl
hhbs = hdt..shb..hjl
hcbs = hdt..scb..hjl
hybs = hdt..syb..hjl
hlbs = hdt..slb..hjl
hzbs = hdt..szb..hjl
hdks = "是銩礦，不是碎片哦！"
hdls = "大理石和銩礦碎片的幾率"


dtz = "單獨調整"
djl = "的幾率"

skc = "開採出"
sbh = "不會"
sgn = "更難"
sjn = "較難"
smr = "默認的幾率"




configuration_options = 
{
    {
        name = "wajuecishu",
        label = "打擊次數",
        hover = hdjcs,
        options =
        {
            {description = "33", data = 1, hover = "使卵石更容易開採完"},
            {description = "66", data = 2, hover = "默認"},
            {description = "99", data = 3, hover = "使卵石更難開採完"},
            {description = "132", data = 4, hover = wjcsa},
            {description = "165", data = 5, hover = wjcsa},
            {description = "198", data = 6, hover = wjcsa}
        },
        default = 2,
    },
    {
        name = "shishengzhang",
        label = "生長卵石",
        hover = hszls,
        options =
        {
            {description = "關閉", data = 0, hover = "選擇此選項此功能作廢"},
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
        label = "石頭概率",
        hover = hstgl,
        options =
        {
            {description = "無", data = 0, hover = "此選項將不會開採出石頭\n可用於測試"},
            {description = "困難", data = .3, hover = gnkc.."石頭"},
            {description = "減少", data = .6, hover = jnkc.."石頭"},
            {description = "默認", data = 1, hover = "這是平衡的\n推薦"},
            {description = "2 倍", data = 2, hover = "較容易開採出石頭"},
            {description = "3 倍", data = 3, hover = "更容易開採出石頭\n不推薦"}
        },
        default = 1,
    },
    {
        name = "huangjinbaolv",
        label = "黃金概率",
        hover = hhjgl,
        options =
        {
            {description = "無", data = 0, hover = "此選項將不會開採出金塊\n可用於測試"},
            {description = "困難", data = .3, hover = gnkc.."金塊"},
            {description = "減少", data = .6, hover = jnkc.."金塊"},
            {description = "默認", data = 1, hover = "這是平衡的\n推薦"},
            {description = "2 倍", data = 2, hover = "較容易開採出金塊"},
            {description = "3 倍", data = 3, hover = "更容易開採出金塊\n不推薦"}
        },
        default = 1,
    },
    {
        name = "baoshibaolv",
        label = "寶石概率",
        hover = hbsgl,
        options =
        {
            {description = "無", data = 0, hover = bhkc.."寶石"},
            {description = "困難", data = .3, hover = gnkc.."寶石"},
            {description = "減少", data = .6, hover = jnkc.."寶石"},
            {description = "默認", data = 1, hover = smr},
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
        label = "聖誕卵石",
        hover = hsdls,
        options =
        {
            {description = "关", data = false, hover = "就当什么也没发生"},
            {description = "开", data = true, hover = "卵石随机彩色涂装"},
        },
        default = false,
    },
    {
        name = "RUOYINXIAN",
        label = "隨機透明",
        hover = hsjtm,
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
        label = "寶石",
        hover = "",
        options =
        {
            {description = "單獨概率", data = 0, hover = ""},
        },
        default = 0,
    },
    {
        name = "blue_baoshi",
        label = slb,
        hover = hlbs,
        options =
        {
            {description = "無", data = 0, hover = bhkc..slb},
            {description = "困難", data = .3, hover = gnkc..slb},
            {description = "減少", data = .6, hover = jnkc..slb},
            {description = "默認", data = 1, hover = smr},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "6 倍", data = 6, hover = "6"..bsgla},
            {description = "10 倍", data = 10, hover = "10"..bsgla}
        },
        default = 1,
    },
    {
        name = "red_baoshi",
        label = shb,
        hover = hhbs,
        options =
        {
            {description = "無", data = 0, hover = bhkc..shb},
            {description = "困難", data = .3, hover = gnkc..shb},
            {description = "減少", data = .6, hover = jnkc..shb},
            {description = "默認", data = 1, hover = smr},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
    {
        name = "orange_baoshi",
        label = scb,
        hover = hcbs,
        options =
        {
            {description = "無", data = 0, hover = bhkc..scb},
            {description = "困難", data = .3, hover = gnkc..scb},
            {description = "減少", data = .6, hover = jnkc..scb},
            {description = "默認", data = 1, hover = smr},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
    {
        name = "yellow_baoshi",
        label = syb,
        hover = hybs,
        options =
        {
            {description = "無", data = 0, hover = bhkc..syb},
            {description = "困難", data = .3, hover = gnkc..syb},
            {description = "減少", data = .6, hover = jnkc..syb},
            {description = "默認", data = 1, hover = smr},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "12 倍", data = 12, hover = "12"..bsgla}
        },
        default = 1,
    },
    {
        name = "green_baoshi",
        label = slb,
        hover = hlbs,
        options =
        {
            {description = "無", data = 0, hover = bhkc..slb},
            {description = "困難", data = .3, hover = gnkc..slb},
            {description = "減少", data = .6, hover = jnkc..slb},
            {description = "默認", data = 1, hover = smr},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
    {
        name = "purple_baoshi",
        label = szb,
        hover = hzbs,
        options =
        {
            {description = "無", data = 0, hover = bhkc..szb},
            {description = "困難", data = .3, hover = gnkc..szb},
            {description = "減少", data = .6, hover = jnkc..szb},
            {description = "默認", data = 1, hover = smr},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "12 倍", data = 12, hover = "12"..bsgla}
        },
        default = 1,
    },
    {
        name = "thulecite_xiukuang",
        label = sdk,
        hover = hdks,
        options =
        {
            {description = "無", data = 0, hover = bhkc..sdk},
            {description = "困難", data = .3, hover = gnkc..sdk},
            {description = "減少", data = .6, hover = jnkc..sdk},
            {description = "默認", data = 1, hover = smr},
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
        label = sdd,
        hover = hdls,
        options =
        {
            {description = "無", data = 0, hover = bhkc..sdd},
            {description = "困難", data = .3, hover = gnkc..sdd},
            {description = "減少", data = .6, hover = jnkc..sdd},
            {description = "默認", data = 1, hover = smr},
            {description = "2 倍", data = 2, hover = "2"..bsgla},
            {description = "4 倍", data = 4, hover = "4"..bsgla},
            {description = "8 倍", data = 8, hover = "8"..bsgla},
            {description = "16 倍", data = 16, hover = "16"..bsgla}
        },
        default = 1,
    },
}