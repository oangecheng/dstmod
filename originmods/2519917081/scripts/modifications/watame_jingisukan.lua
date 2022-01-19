--成吉思汗烤肉(身上著火時死了掉熟肉)
local function SetJingisukan(inst)
	if inst.components.burnable:IsBurning() then
		if inst.components.health:GetPenaltyPercent() >= TUNING.REVIVE_HEALTH_PENALTY * 3 then
			return
		else
			inst.components.lootdropper:SpawnLootPrefab("cookedmeat")
		end
	else
		if inst.components.health:GetPenaltyPercent() >= TUNING.REVIVE_HEALTH_PENALTY * 3 then
			return
		else
			inst.components.lootdropper:SpawnLootPrefab("meat")
		end
	end
end

return SetJingisukan

