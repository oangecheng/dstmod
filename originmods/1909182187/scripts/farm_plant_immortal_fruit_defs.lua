local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

local function MakeGrowTimes(germination_min, germination_max, full_grow_min, full_grow_max)
	local grow_time = {}

	-- germination time
	grow_time.seed		= {germination_min, germination_max}

	-- grow time
	grow_time.sprout	= {full_grow_min * 0.5, full_grow_max * 0.5}
	grow_time.small		= {full_grow_min * 0.3, full_grow_max * 0.3}
	grow_time.med		= {full_grow_min * 0.2, full_grow_max * 0.2}

	-- harvestable perish time
	grow_time.full		= 4 * TUNING.TOTAL_DAY_TIME
	grow_time.oversized	= 6 * TUNING.TOTAL_DAY_TIME
	grow_time.regrow	= {4 * TUNING.TOTAL_DAY_TIME, 5 * TUNING.TOTAL_DAY_TIME} -- min, max

	return grow_time
end

--潮湿度
local drink_low = TUNING.FARM_PLANT_DRINK_LOW
local drink_med = TUNING.FARM_PLANT_DRINK_MED
local drink_high = TUNING.FARM_PLANT_DRINK_HIGH

--肥料需求
local S = TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW
local M = TUNING.FARM_PLANT_CONSUME_NUTRIENT_MED
local L = TUNING.FARM_PLANT_CONSUME_NUTRIENT_HIGH

PLANT_DEFS.immortal_fruit	= {
	build = "farm_plant_immortal_fruit", 
	bank = "farm_plant_pumpkin",
	--生长时间
	grow_time = MakeGrowTimes(12 * TUNING.SEG_TIME, 16 * TUNING.SEG_TIME, 4 * TUNING.TOTAL_DAY_TIME, 7 * TUNING.TOTAL_DAY_TIME),
	--潮湿度
	moisture = {drink_rate = drink_high,	min_percent = TUNING.FARM_PLANT_DROUGHT_TOLERANCE},
	--肥料需求
	-- nutrient_consumption = {S, 0, S},
	nutrient_consumption = {L, L, 0},
	--肥料产出
	nutrient_restoration = {nil, nil, true},
	--杂草容忍度
	max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE,
	--生长季节(冬)
	good_seasons	= { winter = true},
	--重量数据		min	 	max		sigmoid%
	weight_data = { 384.59, 662.77, .18 },
	--音效
	sounds = {
		grow_oversized = "farming/common/farm/potato/grow_oversized",
		grow_full = "farming/common/farm/grow_full",
		grow_rot = "farming/common/farm/rot",
	},
	--农作物代码
	prefab = "farm_plant_immortal_fruit",
	--果实
	product = "immortal_fruit",
	--巨型果实
	product_oversized = "immortal_fruit_oversized",
	--种子
	seed = "immortal_fruit_seed",
	--作物标签
	plant_type_tag = "farm_plant_immortal_fruit",
	--巨型腐烂果实产出
	loot_oversized_rot = {"immortal_essence", "immortal_essence", "immortal_essence", "fruitfly", "fruitfly", "fruitfly"},
	--同种植物需求数量
	family_min_count = TUNING.FARM_PLANT_SAME_FAMILY_MIN,
	--同种植物检索距离
	family_check_dist = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS,
	--农作物状态标签对应网络变量类型
	stage_netvar = net_tinybyte,
	--防火
	fireproof = true,
	--生长状态信息
	plantregistryinfo = {
		{
			text = "seed",
			anim = "crop_seed",
			grow_anim = "grow_seed",
			learnseed = true,
			growing = true,
		},
		{
			text = "sprout",
			anim = "crop_sprout",
			grow_anim = "grow_sprout",
			growing = true,
		},
		{
			text = "small",
			anim = "crop_small",
			grow_anim = "grow_small",
			growing = true,
		},
		{
			text = "medium",
			anim = "crop_med",
			grow_anim = "grow_med",
			growing = true,
		},
		{
			text = "grown",
			anim = "crop_full",
			grow_anim = "grow_full",
			revealplantname = true,
			fullgrown = true,
		},
		{
			text = "oversized",
			anim = "crop_oversized",
			grow_anim = "grow_oversized",
			revealplantname = true,
			fullgrown = true,
			hidden = true,
		},
		{
			text = "rotting",
			anim = "crop_rot",
			grow_anim = "grow_rot",
			stagepriority = -100,
			is_rotten = true,
			hidden = true,
		},
		{
			text = "oversized_rotting",
			anim = "crop_rot_oversized",
			grow_anim = "grow_rot_oversized",
			stagepriority = -100,
			is_rotten = true,
			hidden = true,
		},
	},
	plantregistrywidget = "widgets/redux/farmplantpage",
	plantregistrysummarywidget = "widgets/redux/farmplantsummarywidget",
	--合影动画
	pictureframeanim = {anim = "emoteXL_loop_dance0", time = 7*FRAMES},
	--特别照顾棱镜作物
	fn_server = function(inst)
		if inst.components.lootdropper then
			inst.components.lootdropper.lootsetupfn = function(lootdropper)
				local inst = lootdropper.inst
				if inst.components.perennialcrop and inst.components.perennialcrop.ishuge then
					lootdropper:SetLoot({"fruitfly","fruitfly","fruitfly","fruitfly","fruitfly","fruitfly"})
				else
					lootdropper:SetLoot({"fruitfly","fruitfly","fruitfly"})
				end
			end
		end
	end,
}