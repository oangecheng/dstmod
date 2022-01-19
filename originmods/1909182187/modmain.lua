GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

TUNING.FUNCTIONAL_MEDAL_IS_OPEN=true--勋章Mod已开启，方便其他Mod读取
TUNING.MEDAL_LANGUAGE=GetModConfigData("language_switch")--语言
TUNING.IS_LOW_COST=GetModConfigData("difficulty_switch")--是否为简易模式
TUNING.TRANSPLANT_OPEN=GetModConfigData("transplant_switch")--移植功能开关
TUNING.ADD_MEDAL_EQUIPSLOTS=GetModConfigData("medalequipslots_switch")--是否加入勋章栏
TUNING.MEDAL_INV_SWITCH=GetModConfigData("medal_inv_switch")--融合勋章栏是否自动贴边
TUNING.MEDAL_CONTAINERDRAG_SWITCH=GetModConfigData("containerdrag_switch")--容器拖拽
TUNING.MEDAL_ALL_CONTAINERDRAG_SWITCH=GetModConfigData("all_containerdrag_switch")--所有容器可拖拽
TUNING.HAS_MEDAL_PAGE_ICON=GetModConfigData("medalpage_switch")--勋章介绍页显示
TUNING.SHOW_MEDAL_INFO=GetModConfigData("medal_info_switch")--是否显示勋章详情
TUNING.SHOW_MEDAL_FX=GetModConfigData("show_medal_fx")--是否显示特效
TUNING.MEDAL_NEW_CRAFTTABS_SWITCH=GetModConfigData("medal_new_crafttabs_switch")--多列制作栏
TUNING.MEDAL_TIPS_SWITCH=GetModConfigData("medal_tips_switch")--飘字提示
TUNING.MEDAL_GOODMID_RESOURCES_MULTIPLE=GetModConfigData("medal_goodmid_resources_multiple")--高级风滚草资源倍率
TUNING.MEDAL_GOODMAX_RESOURCES_MULTIPLE=GetModConfigData("medal_goodmax_resources_multiple")--稀有风滚草资源倍率
TUNING.MEDAL_TECH_LOCK=GetModConfigData("medal_tech_lock")--科技依赖

require("tuning_medal")

PrefabFiles = {
	"bearger_chest",--熊皮宝箱
	"lureplant_rod",--食人花手杖
	"marbleaxe",--大理石斧头
	"marblepickaxe",--大理石镐
	"xinhua_dictionary",--新华字典
	"immortal_fruit",--不朽果实
	"functional_medals",--能力勋章
	"down_filled_coat",--羽绒服
	"medal_plantables",--可种植植株
	"medal_box",--勋章盒等各种盒子
	"medal_books",--书籍
	"trap_bat",--蝙蝠陷阱
	"medal_goathat",--羊角帽
	"medal_buffs",--闪电buff
	"multivariate_certificate",--融合勋章
	"medal_naughtybell",--淘气铃铛
	"medal_spices",--主厨调料
	"medal_preparedfoods",--主厨调味料理
	"medal_reticule",--范围显示
	"medal_obsidianfirefire",--黑曜石火
	"medal_firepit_obsidian",--黑曜石火坑
	"armor_blue_crystal",--蓝曜石甲
	"medal_fish",--勋章的鱼(熔岩鳗鱼)
	-- "medal_balloon",--气球
	"krampus_soul",--坎普斯之灵
	"bottled_soul",--瓶装灵魂
	"medal_seapond",--船上钓鱼池
	"hat_blue_crystal",--蓝晶帽
	"armor_medal_obsidian",--黑曜甲
	"medal_bundle",--包裹
	"medal_livingroot_chest",--树根宝箱
	"livingroot_chest_extinguish_fx",--暗影之手灭火特效
	"medal_moonglass_shovel",--月光玻璃铲
	"bottled_moonlight",--瓶装月光
	"medal_rage_krampus",--暗夜坎普斯
	"medal_delivery_classified",--传送塔classified
	"medal_moonglass_hammer",--月光玻璃锤
	"mandrake_berry",--曼德拉果植株
	"mandrakeberry",--曼德拉果
	"medal_staff",--各种法杖
	"medal_statues",--各种雕像
	"medal_fruit_tree",--各种果树
	"sanityrock_mace",--方尖锏
	"medal_moonglass_bugnet",--月光玻璃网、月亮孢子
	"medal_cookpot",--远古锅
	"medal_wormwood_flower",--虫木花、埋着的绿宝石
	"medal_farm_plow",--高效耕地机
	"medal_rain_bomb",--天气弹
	"medal_tips",--飘字
	"medal_toy_chest",--玩具箱
	"medal_treasure_map",--藏宝图
	"medal_tentaclespike",--活性触手尖刺
	"medal_slingshotammo",--勋章特制弹药
	"medal_fx",--勋章新增特效
	"medal_moonglass_potion",--月亮药水
	"medal_waterpump",--手摇深井泵
	"medal_krampus_chest",--坎普斯之匣
	"medal_ice_machine",--蓝曜石制冰机
	"medal_show_range",--范围圈
	"medal_beequeen",--凋零之蜂
	"medal_honey_trail",--毒蜜小径
	"medal_beeguard",--凋零守卫
	"medal_withered_heart",--凋零之心
	"medal_rose_terrace",--蔷薇花台
	"medal_beequeenhive",--凋零蜂巢
	"medal_nitrify_tree",--硝化树
	"medal_beebox",--育王蜂箱
	"medal_bee",--育王蜂
	"medal_resonator",--宝藏探测仪
	"medal_fishingrod",--玻璃钓竿
	"medal_common_items",--常规预置物
}

Assets =
{
	Asset("SOUND", "sound/quagmire.fsb"),
	Asset("ATLAS", "images/medal_equip_slot.xml"),
	Asset("IMAGE", "images/medal_equip_slot.tex"),
    Asset("ANIM", "anim/player_transform_merm.zip"),
	Asset("IMAGE", "images/medal_equipslots.tex"),
    Asset("ATLAS", "images/medal_equipslots.xml"),
    Asset("IMAGE", "images/medal_page_icon.tex"),
    Asset("ATLAS", "images/medal_page_icon.xml"),
    Asset("ANIM", "anim/ui_medalcontainer_4x4.zip"),
    Asset("ANIM", "anim/ui_medalcontainer_5x5.zip"),
    Asset("ANIM", "anim/ui_medalcontainer_5x10.zip"),
    Asset("ANIM", "anim/ui_medalcontainer_1x1.zip"),
    Asset("ANIM", "anim/medal_blood_honey_goo.zip"),
	Asset("IMAGE", "images/medal_injured.tex"),
	Asset("ATLAS", "images/medal_injured.xml"),
	Asset("ANIM", "anim/player_spooked.zip"),
}

AddMinimapAtlas("minimap/bearger_chest.xml")
AddMinimapAtlas("minimap/trap_bat.xml")
AddMinimapAtlas("minimap/medal_firepit_obsidian.xml")
AddMinimapAtlas("minimap/medal_coldfirepit_obsidian.xml")
AddMinimapAtlas("minimap/medal_livingroot_chest.xml")
AddMinimapAtlas("minimap/medal_fruit_tree.xml")
AddMinimapAtlas("minimap/medal_childishness_chest.xml")
AddMinimapAtlas("minimap/medal_cookpot.xml")
AddMinimapAtlas("minimap/medal_krampus_chest_item.xml")
AddMinimapAtlas("minimap/medal_ice_machine.xml")
AddMinimapAtlas("minimap/medal_beebox.xml")
AddMinimapAtlas("minimap/medal_beequeenhivegrown.xml")
AddMinimapAtlas("minimap/medal_beequeenhive.xml")
AddMinimapAtlas("minimap/medal_rose_terrace.xml")
AddMinimapAtlas("minimap/medal_nitrify_tree.xml")

RegisterInventoryItemAtlas("images/immortal_fruit.xml", "immortal_fruit.tex")
RegisterInventoryItemAtlas("images/immortal_fruit_seed.xml","immortal_fruit_seed.tex")

--语言
if TUNING.MEDAL_LANGUAGE =="ch" then 
	require "lang/medal_strings_ch"
else
	require "lang/medal_strings_eng"
end

AddReplicableComponent("medal_delivery")--添加传送组件的replica

GLOBAL.TOOLACTIONS["MEDALTRANSPLANT"] = true--定义月光移植动作
GLOBAL.TOOLACTIONS["MEDALNORMALTRANSPLANT"] = true--定义普通移植动作
GLOBAL.TOOLACTIONS["MEDALHAMMER"] = true--定义月光锤动作
GLOBAL.CONSTRUCTION_PLANS["medal_rose_terrace"]={ Ingredient("sewing_tape", 6),Ingredient("reviver", 1),Ingredient("honeycomb", 3),Ingredient("royal_jelly", 6)}--凋零蜂巢升级材料
modimport("scripts/farm_plant_immortal_fruit_defs.lua")--不朽果实
modimport("scripts/medal_moretags.lua")--降低标签溢出的可能性
modimport("scripts/medal_globalfn.lua")--全局函数
modimport("scripts/medal_modframework.lua")--框架，集成合成栏、动作等
modimport("scripts/medal_hook.lua")--机制修改
modimport("scripts/medal_ui.lua")--UI、容器等
modimport("scripts/medal_sg.lua")--新增、修改sg
modimport("scripts/medal_brain.lua")--修改大脑/行为树
modimport("scripts/medal_rpc.lua")--RPC
modimport("scripts/medal_wipebutt.lua")--帮官方擦屁股系列
modimport("scripts/medal_minisign.lua")--兼容小木牌

require("medal_debugcommands")--调试用指令