--角色升级组件
--角色初始属性都会被替换为三维 100 100 100
--每提升一级全属性 +1
--击杀怪物获得经验进行升级


FOOD_DEF = {
    {"moqueca", 2000},
    {"lobsterdinner", 2000},
    {"surfnturf", 1000},
    {"honeyham", 1000},
    {"turkeydinner", 1000},
    {"bonestew", 1000},
    {"meat_dried", 500},
    {"fish", 500},
    {"smallmeat_dried", 300},
    {"eel", 300},
}


function findFood(inst, food)
    print("==========================="..food.prefab)
    if food == nil or food.prefab == nil then
        return nil
    end

    local name = food.prefab


    local list = FOOD_DEF

    for i=1, #list do
        local temp = string.find(name, list[i][1])
        if temp ~=nil then
            return list[i]
        end
    end

    return nil
end


-- 角色升级
function onRoleLevelUp(inst)
	-- 播放音效
	inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
	inst.components.talker:Say("我变得更强了!")
	
	local lv = inst.components.rolelevel.level
    --饥饿判定
	local hunger_percent = inst.components.hunger:GetPercent()
	inst.components.hunger.max = 100 + lv * 1
	inst.components.hunger:SetPercent(hunger_percent)
	--脑力判定
	local sanity_percent = inst.components.sanity:GetPercent()
	inst.components.sanity.max = 100 + lv * 1
	inst.components.sanity:SetPercent(sanity_percent)
	--血量判定
	local health_percent = inst.components.health:GetPercent()
	inst.components.health.maxhealth = 100 + lv * 1
	inst.components.health:SetPercent(health_percent)
end


-- 获得经验
function onkilledother(inst, data)
    local victim = data.victim
    local maxVictimHealth = 0
    if victim.components.freezable or victim:HasTag("monster") and victim.components.health then
         maxVictimHealth = math.ceil(victim.components.health.maxhealth)
    end

    if maxVictimHealth == 0 then
        return
    end

    onGetExp(inst, maxVictimHealth)
end


function onGetExp(inst, exp)
    local clevel = inst.components.rolelevel
    local maxExp = 200 * clevel.level + 100

    clevel.exp = clevel.exp + exp
    if clevel.exp > maxExp then
        clevel.exp = 0
        clevel.level = clevel.level + 1

        onRoleLevelUp(inst)
        inst.components.health:DoDelta(inst.components.health.maxhealth / 5)
    end
end


function onEatFood(inst, data)
    local target = findFood(inst, data)
    if target ~= nil then
        onGetExp(inst, target[2])
    end
end


function init(inst)

    local clevel = inst.components.rolelevel

    inst.components.hunger.max = 100 + clevel.level * 1
    inst.components.sanity.max = 100 + clevel.level * 1
    inst.components.health.maxhealth = 100 + clevel.level * 1
    inst.components.hunger:SetPercent(clevel.zhunger / inst.components.hunger.max)
    inst.components.sanity:SetPercent(clevel.zsanity / inst.components.sanity.max)
    inst.components.health:SetPercent(clevel.zhealth / inst.components.health.maxhealth)
end


local rolelevel = Class(
    function(self, inst)
        self.inst = inst
        self.level = 0
        self.exp = 0
        self.zhunger = 100
        self.zhealth = 100
        self.zsanity = 100

        inst.components.hunger.max = self.zhunger
        inst.components.health.maxhealth = self.zhealth
        inst.components.sanity.max = self.zsanity
        inst.components.hunger:SetPercent(1)
        inst.components.sanity:SetPercent(1)
        inst.components.health:SetPercent(1)

        -- 监听杀怪事件

        self.inst:ListenForEvent("killed", onkilledother)
        self.inst.components.eater:SetOnEatFn(onEatFood)

    end,
    nil,
    {}
)


function rolelevel:OnSave()
    local data = {
        level = self.level,
        exp = self.exp,
        zhunger = math.ceil(self.inst.components.hunger.current),
        zhealth = math.ceil(self.inst.components.health.currenthealth),
        zsanity = math.ceil(self.inst.components.sanity.current),
    }
    return data
end


function rolelevel:OnLoad(data)
    -- 读取存储的值
    self.level = data.level or 0
    self.exp = data.exp or 0
    self.zhunger = data.zhunger or 100
    self.zhealth = data.zhealth or 100
    self.zsanity = data.zsanity or 100

    -- 角色属性赋值
    init(self.inst)

end


return rolelevel


