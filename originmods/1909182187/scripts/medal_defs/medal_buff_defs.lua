-- name--buff名
-- onattachedfn--添加buff函数
-- onextendedfn--延长buff函数
-- ondetachedfn--解除buff函数
-- duration--buff持续时间
-- priority--buff对话优先级(说优先级高的感叹词),不填则不提示
-- prefabs--prefabs列表


--Buff列表
local buff_defs={}

-------------------------------------蓄电buff-------------------------------------------------
buff_defs.buff_medal_electricattack={
	name="buff_medal_electricattack",
	duration=TUNING_MEDAL.MEDAL_BUFF_ELECTRICATTACK_DURATION,
	priority=2,
	prefabs={ "electrichitsparks", "electricchargedfx" },
	onattachedfn=function(inst, target)
		if target.components.electricattacks == nil then
			target:AddComponent("electricattacks")
		end
		target.components.electricattacks:AddSource(inst)
		if inst._onattackother == nil then
			inst._onattackother = function(attacker, data)
				if data.weapon ~= nil then
					if data.projectile == nil then
						--投掷类武器不加特效
						if data.weapon.components.projectile ~= nil then
							return
						elseif data.weapon.components.complexprojectile ~= nil then
							return
						elseif data.weapon.components.weapon:CanRangedAttack() then
							return
						end
					end
					if data.weapon.components.weapon ~= nil and data.weapon.components.weapon.stimuli == "electric" then
						--武器自身已经有电特效了，也不需要加特效
						return
					end
				end
				if data.target ~= nil and data.target:IsValid() and attacker:IsValid() then
					SpawnPrefab("electrichitsparks"):AlignToTarget(data.target, data.projectile ~= nil and data.projectile:IsValid() and data.projectile or attacker, true)
				end
			end
			inst:ListenForEvent("onattackother", inst._onattackother, target)
		end
		SpawnPrefab("electricchargedfx"):SetTarget(target)
		if target.components.locomotor ~= nil then
			target.components.locomotor:SetExternalSpeedMultiplier(inst, "medal_goathat", TUNING_MEDAL.GOATHAT_SPEED_MULTIPLE)
		end
	end,
	onextendedfn=function(inst, target)
		SpawnPrefab("electricchargedfx"):SetTarget(target)
	end,
	ondetachedfn=function(inst, target)
		if target.components.electricattacks ~= nil then
			target.components.electricattacks:RemoveSource(inst)
		end
		--移除时判断玩家有木有戴羊角帽，没有并且非月圆则电击
		if target.components.playerlightningtarget and not target:HasTag("lightninggoat_friend") then
			if target.components.playercontroller~=nil and target.components.playercontroller.classified~=nil and not TheWorld.state.isfullmoon then
				target.components.playerlightningtarget:DoStrike()
			end
		end
		target:PushEvent("stop_buff_medal_electricattack")
		if inst._onattackother ~= nil then
			inst:RemoveEventCallback("onattackother", inst._onattackother, target)
			inst._onattackother = nil
		end
		if target.components.locomotor ~= nil then
			target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "medal_goathat")
		end
	end,
}

-------------------------------------加速buff-------------------------------------------------
buff_defs.buff_medal_quicklocomotor={
	name="buff_medal_quicklocomotor",
	duration=TUNING_MEDAL.MEDAL_BUFF_QUICKLOCOMOTOR_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target.components.locomotor ~= nil then
			target.components.locomotor:SetExternalSpeedMultiplier(inst, "spice_cactus_flower", TUNING_MEDAL.QUICKLOCOMOTOR_MULTIPLE)
		end
	end,
	ondetachedfn=function(inst, target)
		if target.components.locomotor ~= nil then
			target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "spice_cactus_flower")
		end
	end,
}

-------------------------------------san值保护buff-------------------------------------------------
buff_defs.buff_medal_sanityregen={
	name="buff_medal_sanityregen",
	duration=TUNING_MEDAL.MEDAL_BUFF_SANITYREGEN_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target and target.components.sanity then
			target.components.sanity.yueshubuff=true--san值保护标记
		end
	end,
	ondetachedfn=function(inst, target)
		if target and target.components.sanity and target.components.sanity.yueshubuff then
			target.components.sanity.yueshubuff=nil
		end
	end,
}
	
-------------------------------------吸血buff-------------------------------------------------
--是否是有效攻击对象
local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall") or
                victim:HasTag("balloon") or
                victim:HasTag("groundspike") or
                victim:HasTag("smashable") or
                victim:HasTag("companion"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end
local BATTLEBORN_STORE_TIME = 3--战斗收益存储时间
local BATTLEBORN_DECAY_TIME = 5--战斗收益衰减时间
local BATTLEBORN_TRIGGER_THRESHOLD = 1--战斗收益阈值
--战斗收益
local function medal_battleborn_onattack(inst, data)
    local victim = data.target--获取攻击目标
	local weapon = data.weapon--获取武器
	local conversion_rate = .25--收益转换率
	--如果玩家没死并且攻击目标有效并且玩家用的是战斗长矛
    if not inst.components.health:IsDead() and IsValidVictim(victim) then
		local total_health = victim.components.health:GetMaxWithPenalty()--获取攻击目标最大血量
        local damage = data.weapon ~= nil and data.weapon.components.weapon.damage or inst.components.combat.defaultdamage--获取伤害值，取武器伤害或玩家基础伤害
        local percent = (damage <= 0 and 0)--收益百分比，伤害小于等于0取0
                    or (total_health <= 0 and math.huge)--血量小于等于0就取无穷大
                    or damage / total_health--伤害/血量
		-- if weapon and weapon.prefab=="spear_wathgrithr" then
		-- 	conversion_rate=conversion_rate*2
		-- end
		--战斗收益加成=攻击目标基础伤害*收益转换率*收益百分比，0.33~2
        local delta = math.clamp(victim.components.combat.defaultdamage * conversion_rate * percent, .33, 2)
		
		--战斗收益衰减
        if inst.medal_battleborn > 0 then
            --攻击间隔时间大于8，战斗收益归零；0<时间间隔<5,战斗收益=战斗收益*(1-(时间间隔/战斗收益衰减时间)^2)
			local dt = GetTime() - inst.medal_battleborn_time - BATTLEBORN_STORE_TIME
            if dt >= BATTLEBORN_DECAY_TIME then
                inst.medal_battleborn = 0
            elseif dt > 0 then
                local k = dt / BATTLEBORN_DECAY_TIME
                inst.medal_battleborn = Lerp(inst.medal_battleborn, 0, k * k)
            end
        end

        inst.medal_battleborn = inst.medal_battleborn + delta--战斗收益+=收益加成
        inst.medal_battleborn_time = GetTime()--战斗收益时间戳

		--战斗收益>收益阈值则给玩家增加相应值的血量，战斗收益归零
        if inst.medal_battleborn > BATTLEBORN_TRIGGER_THRESHOLD then
            inst.components.health:DoDelta(inst.medal_battleborn, false, "medal_battleborn")
            -- inst.components.sanity:DoDelta(inst.medal_battleborn)
            inst.medal_battleborn = 0
        end
    end
end

buff_defs.buff_medal_suckingblood={
	name="buff_medal_suckingblood",
	duration=TUNING_MEDAL.MEDAL_BUFF_SUCKINGBLOOD_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target.medal_battleborn then
			target.medal_battleborn = 0
			target.medal_battleborn_time = 0
			target:ListenForEvent("onattackother", medal_battleborn_onattack)
		end
	end,
	ondetachedfn=function(inst, target)
		target.medal_battleborn = nil
		target.medal_battleborn_time = nil
		target:RemoveEventCallback("onattackother", medal_battleborn_onattack)
	end,
}

-------------------------------------凝血buff-------------------------------------------------
buff_defs.buff_medal_bloodsucking={
	name="buff_medal_bloodsucking",
	duration=TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		--添加凝血标记
		if target and target.components.health then
			target.components.health.ningxuebuff=true--凝血buff标记
		end
	end,
	ondetachedfn=function(inst, target)
		--去除凝血标记
		if target and target.components.health and target.components.health.ningxuebuff then
			target.components.health.ningxuebuff=nil
		end
	end,
}

-------------------------------------灵魂跳跃buff-------------------------------------------------
buff_defs.buff_medal_freeblink={
	name="buff_medal_freeblink",
	duration=TUNING_MEDAL.MEDAL_BUFF_FREEBLINK_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target:HasTag("freeblinker") then
			target:AddTag("freeblinker")
		end
		--伍迪变身回来玩家跳跃函数会被挪掉，需要重设
		if target.prefab=="woodie" and target.medalblinkable then
			if target.medalblinkable:value() then
				target.medalblinkable:set_local(false)
				target.medalblinkable:set(true)
			else
				target.medalblinkable:set(true)
			end
		end
	end,
	ondetachedfn=function(inst, target)
		if target:HasTag("freeblinker") then
			target:RemoveTag("freeblinker")
		end
	end,
}

-------------------------------------移植buff-------------------------------------------------
buff_defs.buff_medal_transplantable={
	name="buff_medal_transplantable",
	duration=TUNING_MEDAL.MEDAL_BUFF_TRANSPLANTABLE_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target:HasTag("inmoonlight") then
			target:AddTag("inmoonlight")
			target:PushEvent("changetransplantstate")
			target:PushEvent("changehammerstate")
		end
	end,
	ondetachedfn=function(inst, target)
		if target:HasTag("inmoonlight") then
			target:RemoveTag("inmoonlight")
			target:PushEvent("changetransplantstate")
			target:PushEvent("changehammerstate")
		end
	end,
}
	
-------------------------------------饱腹buff-------------------------------------------------
buff_defs.buff_medal_assuagehunger={
	name="buff_medal_assuagehunger",
	duration=TUNING_MEDAL.MEDAL_BUFF_ASSUAGEHUNGER_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target.components.hunger ~= nil then
		    target.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.ASSUAGEHUNGER_MULTIPLE,"assuagehunger_buff")
		end
	end,
	ondetachedfn=function(inst, target)
		if target.components.hunger ~= nil then
		    target.components.hunger.burnratemodifiers:RemoveModifier(inst,"assuagehunger_buff")
		end
	end,
}

-------------------------------------吃屎buff-------------------------------------------------
buff_defs.buff_medal_poopfood={
	name="buff_medal_poopfood",
	duration=TUNING_MEDAL.MEDAL_BUFF_POOPFOOD_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if target.components.eater ~= nil then
		    target.components.eater:SetAbsorptionModifiers(1, 1, 1)
		end
	end,
	ondetachedfn=function(inst, target)
		if target.components.eater ~= nil then
		    target.components.eater:SetAbsorptionModifiers(0, 1, 1)
		end
	end,
}
	
-------------------------------------开胃buff-------------------------------------------------
buff_defs.buff_medal_upappetite={
	name="buff_medal_upappetite",
	duration=TUNING_MEDAL.MEDAL_BUFF_UPAPPETITE_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		--铁胃,吃东西不受新鲜度影响
		if target.components.eater ~= nil and not target.components.eater.ignoresspoilage then
			target.components.eater.ignoresspoilage = true
			target.isupappetite=true
		end
	end,
	ondetachedfn=function(inst, target)
		--移除铁胃标签
		if target.isupappetite then
			target.isupappetite=nil
			if target.components.eater.ignoresspoilage then
				target.components.eater.ignoresspoilage = false
			end
		end
	end,
}
	
-------------------------------------霸体buff(免疫僵直)-------------------------------------------------
buff_defs.buff_medal_nostiff={
	name="buff_medal_nostiff",
	duration=TUNING_MEDAL.MEDAL_BUFF_NOSTIFF_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if not target:HasTag("nostiff") then
			target:AddTag("nostiff")
		end
	end,
	ondetachedfn=function(inst, target)
		if target:HasTag("nostiff") then
			target:RemoveTag("nostiff")
		end
	end,
}

-------------------------------------群伤buff-------------------------------------------------
--设置aoe伤害(攻击者,伤害继承倍率)
local function setAoeDamage(target,mult)
	if target.components.combat and (target.components.combat.areahitrange==nil or target.medal_aoecombat) then
		target.components.combat:SetAreaDamage(TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_DIST,mult,function(victim,player)
			if IsValidVictim(victim) then
				-- SpawnPrefab("shadowstrike_slash2_fx").Transform:SetPosition(victim.Transform:GetWorldPosition())
				SpawnPrefab("disease_puff").Transform:SetPosition(victim.Transform:GetWorldPosition())
				return true
			end
		end)--aoe范围伤害
		target.medal_aoecombat=true--aoe伤害标记
	end
end
--更换aoe伤害
local function changeAoeDamage(target,data)
	if target.medal_aoecombat then
		--戴着蜂王勋章正常倍率，没戴勋章倍率降低
		if target.isbeeking then
			setAoeDamage(target,TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_MULT)
		else
			setAoeDamage(target,TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_LESS_MULT)
		end
	end
end

buff_defs.buff_medal_aoecombat={
	name="buff_medal_aoecombat",
	duration=TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		setAoeDamage(target,TUNING_MEDAL.MEDAL_BUFF_AOECOMBAT_MULT)
		target:ListenForEvent("beeking_change",changeAoeDamage)
	end,
	ondetachedfn=function(inst, target)
		--取消aoe伤害
		if target.medal_aoecombat then
			target.medal_aoecombat=nil
			if target.components.combat then
				target.components.combat:SetAreaDamage(nil)
			end
		end
		target:RemoveEventCallback("beeking_change",changeAoeDamage)
	end,
}

-------------------------------------持续掉血debuff-------------------------------------------------
local function OnTickInjured(inst,target)
	if target.components.health ~= nil and
	    not target.components.health:IsDead() and
	    not target:HasTag("playerghost") then
		target.components.health:DoDelta((target.injured_damage or 1)*TUNING_MEDAL.MEDAL_BUFF_INJURED_DAMAGE, nil, "medal_beequeen",nil,nil,true)--无视防御
		--中毒效果界面
		if target.player_classified then
			target.player_classified.medal_injured:set_local(false)
			target.player_classified.medal_injured:set(true)
		end
	    -- target.components.health:DoDelta(TUNING_MEDAL.MEDAL_BUFF_INJURED_DAMAGE, nil, "medal_beequeen",nil,nil,true)--无视防御
	else
		 inst.components.debuff:Stop()
	end
end

buff_defs.buff_medal_injured={
	name="buff_medal_injured",
	duration=TUNING_MEDAL.MEDAL_BUFF_INJURED_DURATION,
	priority=2,
	onattachedfn=function(inst, target)
		if inst.injured_task then
			inst.injured_task:Cancel()
			inst.injured_task = nil
		end
		if target ~= nil and target:IsValid() and target.components.health ~= nil then
			if not target.components.health:IsDead() then
				target.injured_damage = math.min(target.injured_damage and target.injured_damage+1 or 1,TUNING_MEDAL.MEDAL_BUFF_INJURED_MAX)--叠毒
				inst.injured_task = inst:DoPeriodicTask(1, OnTickInjured, nil, target)
			end
		end
	end,
	onextendedfn=function(inst, target)
		if inst.injured_task then
			inst.injured_task:Cancel()
			inst.injured_task = nil
		end
		if target ~= nil and target:IsValid() and target.components.health ~= nil then
			if not target.components.health:IsDead() then
				target.injured_damage = math.min(target.injured_damage and target.injured_damage+1 or 1,TUNING_MEDAL.MEDAL_BUFF_INJURED_MAX)--叠毒
				inst.injured_task = inst:DoPeriodicTask(1, OnTickInjured, nil, target)
			end
		end
	end,
	ondetachedfn=function(inst, target)
		if inst.injured_task then
			inst.injured_task:Cancel()
			inst.injured_task = nil
		end
		target.injured_damage = nil--毒性移除
	end,
}

-------------------------------------虚弱debuff(怪物用)-------------------------------------------------
--苍蝇特效
local function OnTick(inst, target)
    if target.components.health ~= nil and
        not target.components.health:IsDead() and
        not target:HasTag("playerghost") then
        SpawnPrefab("disease_puff").Transform:SetPosition(target.Transform:GetWorldPosition())
    elseif target.medal_weak_task ~= nil then
		target.medal_weak_task:Cancel()
		target.medal_weak_task = nil
    end
end

buff_defs.buff_medal_weak={
	name="buff_medal_weak",
	duration=TUNING_MEDAL.MEDAL_BUFF_WEAK_DURATION,
	onattachedfn=function(inst, target)
		if target ~= nil and target:IsValid() and not target.inlimbo and target.components.combat ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
			target.components.combat.externaldamagetakenmultipliers:SetModifier("buff_medal_weak", TUNING_MEDAL.MEDAL_BUFF_WEAK_MULTIPLE)
			target.medal_weak_task = target:DoPeriodicTask(1, OnTick, nil, target)
		end
	end,
	ondetachedfn=function(inst, target)
		if target ~= nil and target:IsValid() and target.components.combat ~= nil then
			target.components.combat.externaldamagetakenmultipliers:RemoveModifier("buff_medal_weak")
		end
		if target.medal_weak_task ~= nil then
			target.medal_weak_task:Cancel()
			target.medal_weak_task = nil
		end
	end,
}

return buff_defs