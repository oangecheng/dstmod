MAX_DAMAGE = 80 -- 最大攻击力
DEF_SPEED = 1.1 -- 默认移速
MAX_SPEED = 1.5 -- 最大移速加成
MAX_USES = 2000 -- 最大使用次数上限

-- 可以提升攻击力的物品
DAMAGE_ITEM_DEFS = {
	{"ruins_bat", 0.5}, --铥矿棒
	{"tentaclespike", 0.02}, --触手尖刺
}
-- 可提升移动速度的物品
SPEED_ITEM_DEFS = {
	{"walrus_tusk", 0.01}, --海象牙
}
--扩充最大使用次数物品定义
MAX_USES_ITEM_DEFS = {
	{"dragon_scales", 100}, --龙鳞
}
--补充耐久物品
USES_ITEM_DEFS = {
	{"goldnugget", 0.2}, -- 金块
}


ALL_ITEMS = {} -- 所有物品
for i=1, #DAMAGE_ITEM_DEFS do
	table.insert(items, DAMAGE_ITEM_DEFS[i][1])
end
for i=1, #SPEED_ITEM_DEFS do
	table.insert(items, SPEED_ITEM_DEFS[i][1])
end
for i=1, #MAX_USES_ITEM_DEFS do
	table.insert(items, MAX_USES_ITEM_DEFS[i][1])
end
for i=1, #USES_ITEM_DEFS do
	table.insert(items, USES_ITEM_DEFS[i][1])
end



-- 给所有物品添加 tradable 组件
if GLOBAL.TheNet:GetIsServer() then
	local items = ALL_ITEMS
	-- 没有添加可交易组件的物品，添加上
	for i=1, #items do
		AddPrefabPostInit(items[i], function(inst) 
			if inst.components.tradable == nil then
				inst:AddComponent("tradable")
			end
		end)
	end
end


-- 查找对应列表中物品的属性值
local function findItemValue(item, items)
	if item==nil or item.prefab==nil then
		return nil
	end

	for i=1, #items do
		if item.prefab == items[i][1] then
			return items[i][2]
		end
	end

	return nil

end


-- 判断物品是否可以给予
local function itemTradeTest(inst, item)
	local finiteuses = inst.components.finiteuses
	local level = inst.components.weaponlevel
	
	local ret = false

	if level.damage < MAX_DAMAGE then ret = true
	elseif level.speed < MAX_SPEED then ret = true
	elseif level.maxUses < MAX_USES then ret = true
	elseif finiteuses:GetPercent() < 1 then ret = true 
	end

	if ret then 
		for i=1, #ALL_ITEMS do
			if item.prefab == ALL_ITEMS[i] then
				return true
			end
		end
	end

	return false
end


local function updateMaxUses(inst, maxUses)
	local finiteuses = inst.components.finiteuses
	local percent = finiteuses.current / finiteuses.total
	finiteuses:SetMaxUses(maxUses)
	finiteuses:SetPercent(percent)
end


-- 伤害增强
local function damageItem(inst, item)
	local wl = inst.components.weaponlevel
	local damage = findItemValue(item, DAMAGE_ITEM_DEFS)
	if damage ~= nil then
		wl.damage = wl.damage + damage
		inst.components.weapon:SetDamage(wl.damage)
	end
end


-- 速度提升
local function speedItem(inst, item)
	local wl = inst.components.weaponlevel
	local speed = findItemValue(item, SPEED_ITEM_DEFS)
	if speed ~= nil then
		wl.speed = wl.speed + speed
		inst.components.equippable.walkspeedmult = wl.speed
	end
end


-- 最大使用次数提升
local function enlargeMaxUses(inst, item)
	local wl = inst.components.weaponlevel
	local maxUses = findItemValue(item, MAX_USES_ITEM_DEFS) 
	if maxUses ~= nil then
		wl.maxUses = wl.maxUses + maxUses
		updateMaxUses(inst, wl.maxUses)
	end
end


-- 恢复耐久
local function recoverUses(inst, item)
	local wl = inst.components.weaponlevel
	local uses = findItemValue(item, USES_ITEM_DEFS)
	if uses ~= nil then
		local finiteuses = inst.components.finiteuses
		local percent = math.max(100/wl.maxUses, 0.2)
		percent = math.min(finiteuses:GetPercent() + percent, 1)
		finiteuses:SetPercent(percent)
		-- 恢复攻击力
		inst.components.weapon:SetDamage(wl.damage)
	end
end


-- 给予物品
-- 提升攻击力/移速加成/最大使用次数/恢复耐久
local function onItemGiven(inst, giver, item)
	damageItem(inst, item)
	speedItem(inst, item)
	enlargeMaxUses(inst, item)
	recoverUses(inst, item)
	giver.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end


-- 耐久为0不消失
-- 攻击力变为0
local function onUseFinished(inst)
	inst.components.finiteuses:SetPercent(0)
	inst.components.weapon:SetDamage(0)
end



local weaponlevel = Class(
	function(self, inst)
		self.inst = inst
		self.damage = inst.components.weapon.damage or 0
		self.maxUses = inst.components.finiteuses.total or 0
		self.speed = DEF_SPEED

		-- 属性赋初值
		inst.components.finiteuses:SetMaxUses(self.maxUses)
		inst.components.weapon:SetDamage(self.damage)
		inst.components.equippable.walkspeedmult = self.speed
		
		-- 添加可交易组件
		inst:AddComponent("trader")
		inst.components.trader:SetAbleToAcceptTest(itemTradeTest)
		inst.components.trader.onaccept = onItemGiven
		inst.components.finiteuses:SetOnFinished(onUseFinished)
	end,
	nil,
	{}
)


function weaponlevel:OnSave()
	local data = {
		damage = self.damage,
		speed = self.speed,
		maxUses = self.maxUses,
	}
	return data
end



function weaponlevel:OnLoad(data)
	self.damage = data.damage or 0
	self.speed = data.speed or DEF_SPEED
	self.maxUses = data.maxUses or 0
	self.inst.components.equippable.walkspeedmult = weaponlevel.speed
	updateMaxUses(self.inst, self.maxUses)
end

return weaponlevel

