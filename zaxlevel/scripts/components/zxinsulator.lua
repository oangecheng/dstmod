
local ZX_UTILS = require "scripts/utils/zxutils"

-- 能力解锁
UNLOCK_ITEM_W = "bearger_fur" -- 熊皮解锁保暖
UNLOCK_ITEM_S = "dragon_scales" -- 龙鳞解锁隔热

-- 能力提升
UPGRDADE_ITEM_W = "trunk_winter" -- 冬象鼻提升保暖
UPGRDADE_ITEM_S = "trunk_summer" -- 夏象鼻提升隔热

-- 模式切换
CHAGE_ITEM_W = "bluegem" -- 蓝宝石切换保暖模式
CHAGE_ITEM_S = "redgem" -- 红宝石切换成隔热模式


ZX_UTILS.TryAddTraddablePerfab(UNLOCK_ITEM_W)
ZX_UTILS.TryAddTraddablePerfab(UNLOCK_ITEM_S)


local function acceptTest(inst, item, giver)
    local zxins = inst.components.zxinsulator
    local prefab = item.prefab

    -- 未解锁保暖，必须是解锁物品
    -- 已解锁保暖，必须是提升保暖的物品, 或者是模式切换物品
    if not zxins.zxinsulation_w then
        if prefab == UNLOCK_ITEM_W then
            return true
        end
    elseif prefab == UPGRDADE_ITEM_W then
        return true
    elseif prefab == CHAGE_ITEM_W then
        if not inst.components.insulator:IsType(SEASONS.WINTER) then
            return true
        end
    end

    if not zxins.zxinsulation_s then
        if prefab == UNLOCK_ITEM_S then
            return true
        end
    elseif prefab == UPGRDADE_ITEM_S then
        return true
    elseif prefab == CHAGE_ITEM_S then
        if not inst.components.insulator:IsType(SEASONS.SUMMER) then
            return true
        end
    end

    return false
end


local function onItemGive(inst, giver, item)
    local zxins = inst.components.zxinsulator
    local ins = inst.components.insulator

    if item.prefab == UNLOCK_ITEM_W then
        zxins.zxinsulatorunlock_w = true
    end

    if item.prefab == UPGRDADE_ITEM_W then
        zxins.zxinsulation_w = zxins.zxinsulation_w + 20
        if ins:IsType(SEASONS.WINTER) then
            ins:SetInsulation(zxins.zxinsulation_w)
        end
    end

    if item.prefab == UNLOCK_ITEM_S then
        zxins.zxinsulatorunlock_s = true
    end

    if item.prefab == UPGRDADE_ITEM_S then
        zxins.zxinsulation_s = zxins.zxinsulation_s + 20
        if ins:IsType(SEASONS.SUMMER) then
            ins:SetInsulation(zxins.zxinsulation_s)
        end
    end
end



local ZxInsulator = Class(
    function(self, inst)
        self.inst = inst
        self.zxinsulation_w = 0
        self.zxinsulatorunlock_w = false
        self.zxinsulation_s = 0
        self.zxinsulatorunlock_s = false

        -- 如果已经有保暖组件，附上物品初始的保暖值
        -- 如果没有，加上保暖组件
        local insulator = inst.components.insulator
        if insulator ~= nil then
            -- 保暖初值
            if insulator:IsType(SEASONS.WINTER) then
                self.zxinsulation_w = insulator.insulation
            -- 隔热初值
            else
                self.zxinsulation_s = insulator.insulation
            end
        else
            inst:AddComponent("insulator")
        end

        -- 添加可交易组件
        ZX_UTILS.TryAddTrader(self.inst)
        local trader = inst.components.trader
        trader:SetAbleToAcceptTest(acceptTest)
        trader.onaccept = onItemGive
    end,
    nil,
    {}
)



function ZxInsulator:OnSave()
    local data = {
        zxinsulation_w = self.zxinsulation_w,
        zxinsulatorunlock_w = self.zxinsulatorunlock_w,
        zxinsulation_s = self.zxinsulation_s,
        zxinsulatorunlock_s = self.zxinsulatorunlock_s,
    }
    return data
end



function ZxInsulator:OnLoad(data)
    self.zxinsulation_w = data.zxinsulation_w or 0
    self.zxinsulatorunlock_w = data.zxinsulatorunlock_w or false
    self.zxinsulation_s = data.zxinsulation_s or 0
    self.zxinsulatorunlock_s = data.zxinsulatorunlock_s or false

end



return ZxInsulator