local function GetTableLength(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

local function SpawnChildFx(inst, prefab)
    local fx = SpawnPrefab(prefab)
    inst:AddChild(fx)
 end

local function OnUpdateHistory(inst, self, period)
	if inst.prefab == "amelia" then
        if not self.history then
            self.history = {}
        end
        table.insert(self.history, { char_pos=inst:GetPosition(), 
                                     health_percent=inst.components.health:GetPercent(), 
                                     hunger_percent=inst.components.hunger:GetPercent(), 
                                     sanity_percent=inst.components.sanity:GetPercent()
        })
        if GetTableLength(self.history) > TUNING.AMELIA_WATCH_TIMELEAP_SECS then
            table.remove(self.history, 1)  -- Remove on first index (oldest record)
        elseif GetTableLength(self.history) == TUNING.AMELIA_WATCH_TIMELEAP_SECS then
            SpawnChildFx(inst, "electricchargedfx")
        end
    end
end

local AmeliaHistory = Class(function(self, inst)
	self.inst = inst  -- owner of history component
	self.history = {}

	if TheWorld.ismastersim then
		local period = 1
		self.inst:DoPeriodicTask(period, OnUpdateHistory, nil, self, period)
	end
end, nil, {})

function AmeliaHistory:OnSave()
    return {
		history = self.history,
	}
end

function AmeliaHistory:OnLoad(data)
    if data.history ~= nil then
        self.history = data.history
    end
end

function AmeliaHistory:GetOldestPos()
    return self.history[1].char_pos
end

function AmeliaHistory:GetOldestHealthPercent()
    return self.history[1].health_percent
end

function AmeliaHistory:GetOldestHungerPercent()
    return self.history[1].hunger_percent
end

function AmeliaHistory:GetOldestSanityPercent()
    return self.history[1].sanity_percent
end

function AmeliaHistory:IsOnCooldown()
    return GetTableLength(self.history) < TUNING.AMELIA_WATCH_TIMELEAP_SECS
end

function AmeliaHistory:ClearHistory()
    self.history = {}
end

return AmeliaHistory