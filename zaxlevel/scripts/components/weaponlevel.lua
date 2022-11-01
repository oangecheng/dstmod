MAX_DAMAGE = 80
DEF_SPEED = 1.1
MAX_SPEED = 1.5
MAX_USES = 2000

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


local function updateSpeed(inst)
	local weaponlevel = inst.components.weaponlevel
	inst.components.equippable.walkspeedmult = weaponlevel.speed
end


local function updateMaxUses(inst, maxUses)
	local finiteuses = inst.components.finiteuses
	local percent = finiteuses.current / finiteuses.total
	finiteuses:SetMaxUses(maxUses)
	finiteuses:SetPercent(percent)
end


local function onItemGiven(inst, giver, item)
	local weaponlevel = inst.components.weaponlevel

	-- 伤害增强
    local damage = findItemValue(item, DAMAGE_ITEM_DEFS)
	if damage ~= nil then
		weaponlevel.damage = weaponlevel.damage + damage
		inst.components.weapon:SetDamage(weaponlevel.damage)
	end

	-- 速度提升
	local speed = findItemValue(item, SPEED_ITEM_DEFS)
	if speed ~= nil then
		weaponlevel.speed = weaponlevel.speed + speed
		inst.components.equippable.walkspeedmult = weaponlevel.speed
	end

	-- 最大使用次数提升
	local maxUses = findItemValue(item, MAX_USES_ITEM_DEFS) 
	if maxUses ~= nil then
		weaponlevel.maxUses = weaponlevel.maxUses + maxUses
		updateMaxUses(inst, weaponlevel.maxUses)
	end

	-- 恢复耐久
	local uses = findItemValue(item, USES_ITEM_DEFS)
	if uses ~= nil then
		local finiteuses = inst.components.finiteuses
		local percent = math.min(finiteuses:GetPercent() + 0.2, 1)
		finiteuses:SetPercent(percent)
		inst.components.weapon:SetDamage(weaponlevel.damage)
	end

	giver.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end


local function onUseFinished(inst)
	inst.components.finiteuses:SetPercent(0)
	inst.components.weapon:SetDamage(0)
end


local function init(inst)
	inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(itemTradeTest)
    inst.components.trader.onaccept = onItemGiven
    inst.components.finiteuses:SetOnFinished(onUseFinished)
end


local weaponlevel = Class(
	function(self, inst)
		self.inst = inst
		self.damage = inst.components.weapon.damage or 0
		self.maxUses = inst.components.finiteuses.total or 0
		self.speed = DEF_SPEED

		inst.components.finiteuses:SetMaxUses(self.maxUses)
		inst.components.weapon:SetDamage(self.damage)
		inst.components.equippable.walkspeedmult = self.speed
		init(self.inst)
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
	updateSpeed(self.inst)
	updateMaxUses(self.inst, self.maxUses)
end

return weaponlevel

