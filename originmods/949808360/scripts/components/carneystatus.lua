local function oncurrentlevel(self,level) self.inst.clevel:set(level) end
local function oncurrentexp(self,exp) self.inst.cexp:set(exp) end
local function oncurrentmiss(self,miss) self.inst.cmiss:set(miss) end
local function oncurrentmissactioning(self,missactioning) self.inst.cmissactioning:set(missactioning) end

local carneystatus = Class(function(self, inst)
    self.inst = inst
    self.level = 0
    self.exp = 0
    self.expold = 0
    self.expmod = 1
    self.maxexp = 0
    self.miss = 0
    self.missactioning = 0
    self.power = 0
    self.spelling = 0
    self.damagemod = 1
    self.speedwalk = TUNING.WILSON_WALK_SPEED * 1.25
    self.speedrun = TUNING.WILSON_RUN_SPEED * 1.25
    self.chunger = 100
    self.csanity = 100
    self.chealth = 100
end,
nil,
{
    level = oncurrentlevel,
    exp = oncurrentexp,
    miss = oncurrentmiss,
    missactioning = oncurrentmissactioning,
})

function carneystatus:OnSave()
    local data = {
        level = self.level,
        exp = self.exp,
        chunger = math.ceil(self.inst.components.hunger.current),
        csanity = math.ceil(self.inst.components.sanity.current),
        chealth = math.ceil(self.inst.components.health.currenthealth),
    }
    return data
end

function carneystatus:OnLoad(data)
    self.level = data.level or 0
    self.exp = data.exp or 0
    self.chunger = data.chunger or 100
    self.csanity = data.csanity or 100
    self.chealth = data.chealth or 100
    self.inst.components.hunger.max = 100 + self.level*2
    self.inst.components.sanity.max = 100 + self.level*1
    self.inst.components.health.maxhealth = 100 + self.level*1
    self.inst.components.hunger:SetPercent(self.chunger / self.inst.components.hunger.max)
    self.inst.components.sanity:SetPercent(self.csanity / self.inst.components.sanity.max)
    self.inst.components.health:SetPercent(self.chealth / self.inst.components.health.maxhealth)
end

function carneystatus:DoDeltaExp(delta)
    if delta > 0 then
        self.expold = self.exp
        self.exp = self.exp + delta*self.expmod
    else
        self.expold = self.exp
        self.exp = self.exp + delta
    end
    self.inst:PushEvent("DoDeltaExpCARNEY")
end

function carneystatus:powerready()
	self.inst:PushEvent("powerready")
end

function carneystatus:spelldone()
	self.inst:PushEvent("spelldone")
end

return carneystatus