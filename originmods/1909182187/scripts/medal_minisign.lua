local minisign_show_list = {
	"multivariate_certificate",--融合勋章
	"medium_multivariate_certificate",--中级融合勋章
	"large_multivariate_certificate",--高级融合勋章
	"medal_box1",--勋章盒(关闭)
	"medal_box2",--勋章盒(打开)
	"spices_box",--调料盒
	"medal_ammo_box",--弹药盒
	"medal_fishbones",--鱼骨
	"marbleaxe",--大理石斧头
	"marblepickaxe",--大理石镐子
	"medal_farm_plow_item",--高效耕地机
	"medal_waterpump_item",--深井泵套件
	"medal_rain_bomb",--催雨弹
	"medal_clear_up_bomb",--放晴弹
	"toil_money",--血汗钱
	"mandrake_seeds",--曼德拉种子(曼德拉果在弹药里已添加)
	"medal_moonglass_bugnet",--月光玻璃网
	"medal_moonglass_hammer",--月光玻璃锤
	"medal_moonglass_shovel",--月光玻璃铲
	"bottled_moonlight",--瓶装月光
	"bottled_soul",--瓶装灵魂
	"lureplant_rod",--食人花手杖
	"medal_goathat",--羊角帽
	"xinhua_dictionary",--新华字典
	"immortal_essence",--不朽精华
	"immortal_fruit",--不朽果实
	"immortal_gem",--不朽宝石
	"devour_staff",--吞噬法杖
	"immortal_staff",--不朽法杖
	"meteor_staff",--流星法杖
	"medal_krampus_chest_item1",--坎普斯宝匣(关闭)
	"medal_krampus_chest_item2",--坎普斯宝匣(打开)
	"medal_monster_essence",--怪物精华
	"medal_naughtybell",--淘气铃铛
	"down_filled_coat",--羽绒服
	"hat_blue_crystal",--蓝晶帽
	"medal_tentaclespike",--活性触手尖刺
	"trap_bat",--蝙蝠陷阱
	"sanityrock_mace",--方尖锏
	"sanityrock_fragment",--方尖碑碎片
	"lavaeel",--熔岩鳗鱼
	"medal_obsidian",--黑曜石
	"medal_blue_obsidian",--蓝曜石
	"armor_medal_obsidian",--黑曜石甲
	"armor_blue_crystal",--蓝曜石甲
	"medal_treasure_map",--藏宝图
	"medal_withered_heart",--凋零之心
	"medal_bee_larva",--育王蜂种
	"medal_resonator_item",--宝藏探测仪
	"medal_treasure_map_scraps1",--藏宝图碎片·日出
	"medal_treasure_map_scraps2",--藏宝图碎片·黄昏
	"medal_treasure_map_scraps3",--藏宝图碎片·夜晚
	"medal_fishingrod",--玻璃钓竿
	"medal_time_slider",--时空碎片
	"medal_space_gem",--时空宝石
	"immortal_fruit_oversized",--巨型不朽果实
	"immortal_fruit_seed",--不朽种子
}
--勋章
for k, v in pairs(require("medal_defs/functional_medal_defs").MEDAL_DEFS) do
	table.insert(minisign_show_list, k)
	table.insert(minisign_show_list, "copy_"..k)--拷贝的勋章
end
--接穗
for k, v in pairs(require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS) do
	if v.switch then
		table.insert(minisign_show_list, v.name.."_scion")
	end
end
--调料
for k, v in pairs(require("medal_defs/medal_spice_defs")) do
	table.insert(minisign_show_list, k)
end
--非原生移植植株
for k, v in pairs(require("medal_defs/medal_plantable_defs")) do
	table.insert(minisign_show_list, v.name)
end
--弹药
for k, v in pairs(require("medal_defs/medal_slingshotammo_defs")) do
	if v.switch then
		table.insert(minisign_show_list, k)
	end
end
--勋章书籍
for k, v in pairs(require("medal_defs/medal_book_defs")) do
	table.insert(minisign_show_list, v.name)
end

--兼容小木牌显示
local function draw(inst)
	if inst.components.drawable then
		local oldondrawnfn = inst.components.drawable.ondrawnfn or nil
		inst.components.drawable.ondrawnfn = function(inst, image, src, atlas, bgimagename, bgatlasname)
			if oldondrawnfn ~= nil then
				oldondrawnfn(inst, image, src, atlas, bgimagename, bgatlasname)
			end
			-- print(image,atlas)
			if image ~= nil and table.contains(minisign_show_list,image) then --是我的物品
				if atlas==nil then
					atlas="images/"..image..".xml"
				end
				local atlas_path=resolvefilepath_soft(atlas)
				if atlas_path then
					inst.AnimState:OverrideSymbol("SWAP_SIGN", atlas_path, image..".tex")
				end
			end
		end
	end
end

AddPrefabPostInit("minisign", draw)
AddPrefabPostInit("minisign_drawn", draw)