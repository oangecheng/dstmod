local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-----------------------------------公用函数---------------------------------

--是否是游戏原生基础料理(料理名,是否是大厨料理)
function IsNativeCookingProduct(name,ismaster)
	--普通料理
	if not ismaster then
		for k, v in pairs(require("preparedfoods")) do
			if name==v.name then
				return true
			end
		end
	end
	--大厨料理
	for k, v in pairs(require("preparedfoods_warly")) do
		if name==v.name then
			return true
		end
	end
    return false
end
--添加临时标签
function AddMedalTag(owner,tag)
	--标签计数
	owner.medal_tag=owner.medal_tag or {}
	owner.medal_tag[tag]=owner.medal_tag[tag] and owner.medal_tag[tag]+1 or 1
	if not owner:HasTag(tag) then
		owner:AddTag(tag)
		--临时标签组
		owner.medal_t_tag=owner.medal_t_tag or {}
		owner.medal_t_tag[tag]=true
	end
end
--移除临时标签
function RemoveMedalTag(owner,tag)
	if owner.medal_tag and owner.medal_tag[tag] then
		owner.medal_tag[tag]=owner.medal_tag[tag]>1 and owner.medal_tag[tag]-1 or nil
		if not owner.medal_tag[tag] and owner.medal_t_tag and owner.medal_t_tag[tag] then
			owner:RemoveTag(tag)
			owner.medal_t_tag[tag]=nil
		end
	end
end
--添加临时组件
function AddMedalComponent(owner,com)
	--组件计数
	owner.medal_com=owner.medal_com or {}
	owner.medal_com[com]=owner.medal_com[com] and owner.medal_com[com]+1 or 1
	if not owner.components[com] then
		owner:AddComponent(com)
		--临时组件组
		owner.medal_t_com=owner.medal_t_com or {}
		owner.medal_t_com[com]=true
	end
end
--移除临时组件
function RemoveMedalComponent(owner,com)
	if owner.medal_com and owner.medal_com[com] then
		owner.medal_com[com]=owner.medal_com[com]>1 and owner.medal_com[com]-1 or nil
		if not owner.medal_com[com] and owner.medal_t_com and owner.medal_t_com[com] then
			owner:RemoveComponent(com)
			owner.medal_t_com[com]=nil
		end
	end
end

--生成弹幕提示(玩家,数值,提示类型)
function SpawnMedalTips(player,consume,tiptype)
	if TUNING.MEDAL_TIPS_SWITCH and consume and consume>0 and player then
		local medal_tips=SpawnPrefab("medal_tips")
		medal_tips.Transform:SetPosition(player.Transform:GetWorldPosition())
		if medal_tips.medal_d_value then
			medal_tips.medal_d_value:set(consume+1000*tiptype)
		end
	end
end

----------------------------------------------生成暗夜坎普斯-------------------------------------------


--[[
local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end
]]

--获取生成点
local function GetSpawnPoint(pt)
    local SPAWN_DIST = 25--生成距离
	if not TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) then
        pt = FindNearbyLand(pt, 1) or pt
    end
    local offset = FindWalkableOffset(pt, math.random() * 2 * PI, SPAWN_DIST, 12, true, true, function(pt) return not TheWorld.Map:IsPointNearHole(pt) end)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
end

--给玩家生成一个暗夜坎普斯
function MakeRageKrampusForPlayer(player)
    local pt = player:GetPosition()
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        
		local kramp = SpawnPrefab("medal_rage_krampus")
		--播放警告的声音
		SpawnPrefab("krampuswarning_lvl3").Transform:SetPosition(player.Transform:GetWorldPosition())
        kramp.Physics:Teleport(spawn_pt:Get())
        kramp:FacePoint(pt)
        kramp.spawnedforplayer = player
        kramp:ListenForEvent("onremove", function() kramp.spawnedforplayer = nil end, player)
		if kramp.components.combat then
			kramp.components.combat:SetTarget(player)
		end
        return kramp
    end
end

--特殊掉落
local bundle_loot1={
	immortal_book = 10,--不朽之谜
	monster_book = 8,--怪物图鉴
	unsolved_book = 12,--未解之谜
	medal_moonglass_potion = 9,--月光药水
	book_gardening = 1,--应用园艺学
}
--普通掉落
local bundle_loot2={
	"thulecite",--铥矿
	"thulecite_pieces",--铥矿碎片
	"fossil_piece",--化石碎片
	"livinglog",--活木
	"nitre",--硝石
	"marblebean",--大理石豆
	"glommerfuel",--格罗姆黏液
	-- "mosquitosack",--蚊子血囊
	"townportaltalisman",--砂之石
	"moonrocknugget",--月岩
}
--惊喜掉落
local surprise_loot={
	"butterfly",--蝴蝶
	"killerbee",--杀人蜂
	"bee",--蜜蜂
	"fireflies",--萤火虫
	"moonbutterfly",--月蛾
}
--掉落遗失包裹
function DropBundle(target,player,pos)
	local bundleitems = {}
	--惊喜掉落(招蜂引蝶、采花大盗)
	if math.random()<=TUNING_MEDAL.SURPRISE_DROP_RATE then
		local petals=math.random()<.5 and "petals" or nil
		for i=1,4 do
			local surpriseItem=SpawnPrefab(petals and petals or GetRandomItem(surprise_loot))
			if surpriseItem.components.stackable then
				surpriseItem.components.stackable.stacksize = math.random(20)
			end
			table.insert(bundleitems, surpriseItem)
		end
	else--普通掉落
		if math.random() < TUNING_MEDAL.LOST_BAG_GOOD_DROP_RATE then
			local blankchance= player and player:HasTag("traditionalbearer3") and 0 or 0.5--空白勋章掉率
			local copy_bundle_loot1=shallowcopy(bundle_loot1)--浅拷贝一份，方便调整概率
			--新月未解之谜权重翻倍
			if TheWorld.state.isnewmoon and copy_bundle_loot1.unsolved_book then
				copy_bundle_loot1.unsolved_book=copy_bundle_loot1.unsolved_book*2
			end
			--玩家没学过怪物精华蓝图则加入怪物精华蓝图
			if player and player.components.builder and not player.components.builder:KnowsRecipe("medal_monster_essence") then
				copy_bundle_loot1["medal_monster_essence_blueprint"]=10
			end
			table.insert(bundleitems, SpawnPrefab(math.random()<blankchance and "blank_certificate" or weighted_random_choice(copy_bundle_loot1)))
		end
		for i = 1, math.random(1, 3-#bundleitems) do
			table.insert(bundleitems, SpawnPrefab(GetRandomItem(bundle_loot2)))
		end
		for i=#bundleitems,3 do
			table.insert(bundleitems, SpawnPrefab("goldnugget"))
		end
	end
    local bundle = SpawnPrefab(math.random()<0.33 and "bundle" or "gift")
    bundle.components.unwrappable:WrapItems(bundleitems)
    for i, v in ipairs(bundleitems) do
        v:Remove()
    end
	if pos then
		bundle.Transform:SetPosition(pos:Get())
	elseif target then
		if target.components.lootdropper then
			target.components.lootdropper:FlingItem(bundle)
		else
			bundle.Transform:SetPosition(target.Transform:GetWorldPosition())
		end
	elseif player and player.components.inventory then
		player.components.inventory:GiveItem(bundle)
	end
end

--生成遗失包裹
function DropLossBundle(target,player,num)
	local spawnNum= num or 1
	for i=1,spawnNum do
		DropBundle(target,player)
	end
end

--获取local函数
function MedalGetLocalFn(fn,fname)
	local idx=1--索引
	local maxidx = 20--最大尝试次数
	while (idx>0 and idx<maxidx) do
		local name,val=debug.getupvalue(fn,idx)
		if name and name==fname then
			if val and type(val)=="function" then
				return val
			end
			idx=-1
		end
		idx=idx+1
	end
end

--根据权重获取随机物品(权重表,随机值)--表格式{{key="a",weight=1},{key="b",weight=1}}
function GetMedalRandomItem(loot,rand)
	local function weighted_total(loot)
		local total = 0
		for i, v in ipairs(loot) do
			total = total + v.weight
		end
		return total
	end
	local random_num=rand or math.random()
	local threshold = random_num * weighted_total(loot)

	local last_choice
	for i, v in ipairs(loot) do
		threshold = threshold - v.weight
		if threshold <= 0 then return v.key end
		last_choice = v.key
	end

	return last_choice
end

GLOBAL.IsNativeCookingProduct=IsNativeCookingProduct
GLOBAL.AddMedalTag=AddMedalTag
GLOBAL.RemoveMedalTag=RemoveMedalTag
GLOBAL.AddMedalComponent=AddMedalComponent
GLOBAL.RemoveMedalComponent=RemoveMedalComponent
GLOBAL.SpawnMedalTips=SpawnMedalTips
GLOBAL.MakeRageKrampusForPlayer=MakeRageKrampusForPlayer
GLOBAL.DropBundle=DropBundle
GLOBAL.DropLossBundle=DropLossBundle
GLOBAL.MedalGetLocalFn=MedalGetLocalFn
GLOBAL.GetMedalRandomItem=GetMedalRandomItem