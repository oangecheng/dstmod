local function OnLevelUp(inst)
	local heath_percent = inst.components.health:GetPercent()
	local maxhealth = inst.components.health.maxhealth
	-- 等级更新时，最大血量增加10%
	inst.components.health.maxhealth = math.floor(maxhealth * (1 + inst.components.level:GetLevel() * 0.1))
	inst.components.health:SetPercent(heath_percent)
end


AddPlayerPostInit(function(inst)
	if not inst.components.level then
		--添加等级组件
		inst.AddComponent("level")
		-- 设置升级回调
		inst.components.level:OnLevelUp(OnLevelUp)
		-- 监听吃饭的事件，吃饭触发升级
		inst:ListenForEvent("oneat", function(inst, data)
			inst.components.level:IncrLevel(1)
			inst.components.talker:Say("level up")
		end)
		-- 监听死亡事件
		inst:ListenForEvent("death", function(inst, data)
			inst.components.level:ResetLevel()
		end)
	end
end)