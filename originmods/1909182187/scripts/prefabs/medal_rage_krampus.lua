local assets =
{
    Asset("ANIM", "anim/krampus_basic.zip"),
    -- Asset("ANIM", "anim/krampus_build.zip"),
    Asset("ANIM", "anim/medal_rage_krampus.zip"),
    Asset("SOUND", "sound/krampus.fsb"),
}

local prefabs =
{
    "rage_krampus_soul",
    -- "krampus_sack",
    -- "klaus_sack",
    "nightmarefuel",
    "unsolved_book",
    "monstermeat",
}

local brain = require "brains/medalragekrampusbrain"

SetSharedLootTable( 'medal_rage_krampus',
{
    -- {'klaus_sack', 0.5},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'nightmarefuel', 1},
    {'unsolved_book', 1},
    {'monstermeat', 1},
    {'monstermeat', 1},
	{'rage_krampus_soul', 1},
})
--设定新目标
local function NotifyBrainOfTarget(inst, target)
    if inst.brain and inst.brain.SetTarget then
        inst.brain:SetTarget(target)
    end
end
--背包满(目前好像没用到)
local function makebagfull(inst)
    inst.AnimState:Show("SACK")
    inst.AnimState:Hide("ARM")
end
--背包空(目前好像没用到)
local function makebagempty(inst)
    inst.AnimState:Hide("SACK")
    inst.AnimState:Show("ARM")
end
--被攻击时，将攻击者设为目标
local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
	--受到吹箭伤害计数加1
	if data.weapon and data.weapon:HasTag("blowdart") then
		inst.blowdartcount=inst.blowdartcount and inst.blowdartcount+1 or 1--吹箭伤害计数
	else--否则清空计数
		inst.blowdartcount=0
	end
	
	if inst.blowdartcount and inst.blowdartcount>0 and inst.sg and not inst.leaving then
		--有(计数-1)/20的概率会直接逃跑，即第21次必定跑路;否则就是原地嘲讽
		-- print("概率"..(inst.blowdartcount-1)/20)
		if math.random()<(inst.blowdartcount-1)/20 then
			inst.leaving=true
			inst.sg:GoToState("exit")
		else
			inst:DoTaskInTime(0.5,function(inst)
				if inst.sg and not inst.sg:HasStateTag("busy") then
					inst.sg:GoToState("taunt")
				end
			end)
		end
		
	end
	--inst.components.combat:ShareTarget(data.attacker, SEE_DIST, function(dude) return dude:HasTag("hound") and not dude.components.health:IsDead() end, 5)
end
--新的攻击目标
local function OnNewCombatTarget(inst, data)
    NotifyBrainOfTarget(inst, data.target)
end

--发射物品
local function LaunchItem(inst, target, item)
    if item.Physics ~= nil and item.Physics:IsActive() then
        local x, y, z = item.Transform:GetWorldPosition()
        item.Physics:Teleport(x, .1, z)

        x, y, z = inst.Transform:GetWorldPosition()
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        local angle = math.atan2(z1 - z, x1 - x) + (math.random() * 20 - 10) * DEGREES
        local speed = 5 + math.random() * 2
        item.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
    end
end

--攻击效果权重
local effect_list={
	knockback=1,--击飞
	steal=2,--掉落第一个道具
	drop=1,--踢飞武器(小概率踢飞身上全部东西)
}
local effect_fn_list={
	knockback={
		fn=function(inst, other)
			if other:HasTag("player") and other.components.health ~= nil and not other.components.health:IsDead() then
				other:PushEvent("knockback", {knocker = inst, radius = math.random(3,8)})
			end
		end,
	},
	steal={
		fn=function(inst, other)
			inst.components.thief:StealItem(other)
		end,
	},
	drop={
		fn=function(inst, other)
			if other ~= nil and other.components.inventory ~= nil then
				--小概率踢飞身上全部东西
				if math.random()<.95 then
					local equipnum=math.random(3)
					local item = other.components.inventory:GetEquippedItem(equipnum> 1 and (equipnum > 2 and EQUIPSLOTS.HEAD or EQUIPSLOTS.BODY) or EQUIPSLOTS.HANDS)
					if item ~= nil then
						other.components.inventory:DropItem(item)
						LaunchItem(inst, other, item)
					end
				else
					other.components.inventory:DropEverything()
				end
			end
		end,
	},
}

--攻击到生物时执行函数
local function OnHitOther(inst, other, damage)
	--一半的概率触发
	-- if math.random()<.5 then
		local effect_key=weighted_random_choice(effect_list)
		if effect_key and effect_fn_list[effect_key] then
			effect_fn_list[effect_key].fn(inst, other)
		end
	-- end
end

--打乱物品
local function DisruptionItem(v)
	if v.Physics ~= nil and v.Physics:IsActive() then
		local vx, vy, vz = v.Transform:GetWorldPosition()
		local dx, dz = vx - x, vz - z
		local spd = math.sqrt(dx * dx + dz * dz)
		local angle =
			spd > 0 and
			math.atan2(dz / spd, dx / spd) + (math.random() * 20 - 10) * DEGREES or
			math.random() * 2 * PI
		spd = 3 + math.random() * 1.5
		v.Physics:Teleport(vx, 0, vz)
		v.Physics:SetVel(math.cos(angle) * spd, 0, math.sin(angle) * spd)
	end
end

--生成吸收灵魂特效
local function spawnHealFx(inst)
	local fx = SpawnPrefab("wortox_soul_heal_fx")
	fx:AddTag("noragekrampus")
	fx.entity:AddFollower():FollowSymbol(inst.GUID, inst.components.combat.hiteffectsymbol, 0, -50, 0)
	fx:Setup(inst)
end

--黑名单物品
local BLACKLIST={
	fossil_stalker=true,--化石碎片
	endtable=true,--茶几
	table_winters_feast=true,--冬季盛宴桌子
	-- lureplant=true,--食人花
	homesign=true,--木牌
	arrowsign_post=true--方向牌
}

--嘲讽敌人
local function OnTaunt(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
	local devour_health=0--吸收血量
	local treatmultiple=0--治疗倍数
	local taunt_must_tags={"_combat","_health","trap","structure","burnt","explosive"}
	local ents=TheSim:FindEntities(x, y, z, 10 ,nil , {"INLIMBO", "NOCLICK", "catchable", "notdevourable"},taunt_must_tags)
	if #ents>0 then
		for i,v in ipairs(ents) do
			--是玩家，则吸血
			if v:HasTag("player") then 
				treatmultiple=treatmultiple+1--治疗倍数+1
				if v.components.health and v.components.health.currenthealth>=2 then
					--玩家吃了血糖则减少吸血量
					local losshealthvalue=math.random(10,30)*(v.components.health.ningxuebuff and 0.5 or 1)--v.immunetaunt and math.random(5) or math.random(10,30)
					local losshealth=math.min(math.floor(v.components.health.currenthealth-1),losshealthvalue)
					v.components.health:DoDelta(-losshealth)
					devour_health=devour_health+losshealth
					--灵魂被抽走的特效
					local vx,vy,vz=v.Transform:GetWorldPosition()
					SpawnPrefab("ghostflower_spirit1_fx").Transform:SetPosition(vx,vy+2,vz)
				elseif v.components.hunger then
					local losshunger=math.random(5,20)
					v.components.hunger:DoDelta(-losshunger)
				end
				--击飞玩家手中的武器
				if math.random()<.5 then
					effect_fn_list.drop.fn(inst,v)
				end
				-- if v.components.inventory and math.random()<.5 then
					-- local item = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					-- if item ~= nil then
						-- v.components.inventory:DropItem(item)
						-- LaunchItem(inst, v, item)
					-- end
				-- end
			--火药
			elseif v.prefab=="gunpowder" then
				local ash=SpawnPrefab("ash")
				if ash then
					v:Remove()
					ash.Transform:SetPosition(v.Transform:GetWorldPosition())
					if ash.components.disappears then
						ash.components.disappears:Disappear()
					end
				end
			--食人花
			elseif v.prefab=="lureplant" then -- or v.prefab=="tentacle" then
				if v.components.health and not v.components.health:IsDead() then
					local losshealth=v.components.health.currenthealth
					v.components.health:DoDelta(-losshealth)
					devour_health=devour_health+losshealth
				end
			--触手
			-- elseif v.prefab=="tentacle" then
				-- if v.components.health and not v.components.health:IsDead() then
					-- local losshealth=math.min(math.clamp(v.components.health.maxhealth/10, 20, 50),v.components.health.currenthealth)
						-- v.components.health:DoDelta(-losshealth)
						-- devour_health=devour_health+losshealth
				-- end
			--是陷阱，则破坏陷阱
			elseif v:HasTag("trap") then
				if v.components.inventoryitem and v.components.inventoryitem.nobounce then
					v.components.inventoryitem:OnDropped(true)--陷阱失效
				end
			--是烧焦的树，破坏
			elseif v:HasTag("tree") and v:HasTag("burnt") then
				if v.components.workable then
					v.components.workable:Destroy(inst)
				end
			--是建筑或墙
			elseif v:HasTag("structure") or v:HasTag("wall") then
				--有血则吸血
				if v.components.health and not v.components.health:IsDead() then
					--血量小于等于1的直接破坏
					if v.components.health.currenthealth<=1 then
						if v.components.workable then
							v.components.workable:Destroy(inst)
						end
					else--超过1的吸血
						local losshealth=math.min(math.random(v.components.health.maxhealth),v.components.health.currenthealth)
						v.components.health:DoDelta(-losshealth)
						devour_health=devour_health+losshealth
					end
				--黑名单物品则破坏
				elseif BLACKLIST[v.prefab] then
					if v.components.workable then
						v.components.workable:Destroy(inst)
					end
				end
			else
				--目标是自己的生物，则吸血
				if v.components.combat and v.components.combat:TargetIs(inst) then
					if v.components.health and not v.components.health:IsDead() then
						local losshealth=math.min(math.clamp(v.components.health.maxhealth/10, 30, 100),v.components.health.currenthealth)
						v.components.health:DoDelta(-losshealth)
						devour_health=devour_health+losshealth
						treatmultiple=treatmultiple+0.5--治疗倍数+1
					end
				end
			end
		end
	end
	--吞噬的血量大于0，则给自己回血
	if devour_health>0 then
		if inst.components.health then
			inst.components.health:DoDelta(treatmultiple>1 and treatmultiple*devour_health or devour_health)
			spawnHealFx(inst)--生成吸收灵魂特效
		end
	end
end

--生成暗影脚气
local function spawnFootPrint(inst)
	if inst.components.health and inst.components.health:IsDead() then return end
	local x,y,z = inst.Transform:GetWorldPosition()
	local footprint = SpawnPrefab("cane_ancient_fx")
	footprint.Transform:SetPosition(x, y, z)
	local soultarget=0--灵魂回血目标
	local ents=TheSim:FindEntities(x, y, z, 10 ,nil , {"INLIMBO","noragekrampus"},{"FX"})
	if #ents>0 then
		for i,v in ipairs(ents) do
			if v.prefab=="wortox_soul_heal_fx" then
				soultarget=soultarget+1
			end
		end
		if soultarget>0 then
			if inst.components.health then
				local amt = TUNING.HEALING_MED - math.min(8, soultarget) + 1
				inst.components.health:DoDelta(amt*soultarget)
				spawnHealFx(inst)--生成吸收灵魂特效
			end
		end
	end
	--不处于离开状态
	if not inst.leaving then
		--当前坐标和记录坐标相近，则计数+1，否则清空计数
		if inst.lastpos and inst:GetDistanceSqToPoint(inst.lastpos.x,inst.lastpos.y,inst.lastpos.z)<0.5 then
			inst.markingtime=inst.markingtime+1
			-- print("没有位移"..inst.markingtime)
		else
			inst.markingtime=0
		end
		inst.lastpos=Vector3(x, y, z)--记录坐标点
		--计数达到30，跳袋子跑路
		if inst.markingtime>=30 then
			inst.leaving=true
			if inst.sg then
				inst.sg:GoToState("exit")
			end
		--计数大于10，每2.5秒嘲讽一次
		elseif inst.markingtime==10 or inst.markingtime==15 or inst.markingtime==20 then
			if inst.sg then
				inst.sg:GoToState("taunt")
			end
		end
	end
end

local COLLIDETIEMS=30--需要碰撞的次数
--清除碰撞计数
local function ClearRecentlyCharged(inst, other)
    inst.recentlycharged[other] = nil
end
--进行计数并判断计数是否已满
local function recordCharged(inst,other)
	inst.recentlycharged[other] = inst.recentlycharged[other] and inst.recentlycharged[other]+1 or 1
	return inst.recentlycharged[other] and inst.recentlycharged[other]>COLLIDETIEMS
end
--执行碰撞操作
local function onothercollide(inst, other)
	if not other:IsValid() then
	    return
	elseif other:HasTag("smashable") and other.components.health ~= nil then
		if recordCharged(inst,other) then
			ClearRecentlyCharged(inst, other)
			other.components.health:Kill()
		end
	elseif other.components.workable ~= nil
	    and other.components.workable:CanBeWorked()
	    and other.components.workable.action ~= ACTIONS.NET then
		--计数达标后对目标进行破坏
		if recordCharged(inst,other) then
			ClearRecentlyCharged(inst, other)
			SpawnPrefab("collapse_small").Transform:SetPosition(other.Transform:GetWorldPosition())
			other.components.workable:Destroy(inst)
		end
	end
end
--碰撞函数
local function oncollide(inst, other)
    if not (other ~= nil and other:IsValid() and inst:IsValid())
        or (inst.recentlycharged[other] and inst.recentlycharged[other]>COLLIDETIEMS)
        or other:HasTag("player")
        or Vector3(inst.Physics:GetVelocity()):LengthSq() < 42 then
        return
    end
    -- ShakeAllCameras(CAMERASHAKE.SIDE, .5, .05, .1, inst, 40)
    inst:DoTaskInTime(2 * FRAMES, onothercollide, other)
	
	--定时任务，5秒内没发生碰撞清空计数列表
	if inst.cleartask ~= nil then
		inst.cleartask:Cancel()
		inst.cleartask = nil
	end
	inst.cleartask = inst:DoTaskInTime(5, function(i)
		-- print("清空计数")
		inst.recentlycharged = {}
	end)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    MakeCharacterPhysics(inst, 10, .5)

    inst.DynamicShadow:SetSize(3, 1)
    inst.Transform:SetFourFaced()

    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("deergemresistance")
	inst.senior_tentaclemedal=true--不会被触手主动攻击

    inst.AnimState:Hide("ARM")
    inst.AnimState:SetBank("krampus")
    inst.AnimState:SetBuild("medal_rage_krampus")
    inst.AnimState:PlayAnimation("run_loop", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.recentlycharged = {}--撞击记录
	inst.markingtime=0--原地踏步计数
	inst.Physics:SetCollisionCallback(oncollide)
	
	inst:AddComponent("inventory")
    inst.components.inventory.ignorescangoincontainer = true

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_SPEED--移动速度
    inst:SetStateGraph("SGkrampus")

    inst:SetBrain(brain)

    MakeLargeBurnableCharacter(inst, "krampus_torso")
    -- MakeLargeFreezableCharacter(inst, "krampus_torso")--可被冰冻

 --[[   inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!--]]

    -- inst:AddComponent("sleeper")--可睡觉
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_HEALTH)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "krampus_torso"
    inst.components.combat:SetDefaultDamage(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_DAMAGE)--伤害
    inst.components.combat:SetAttackPeriod(TUNING_MEDAL.MEDAL_RAGE_KRAMPUS_ATTACK_PERIOD)--攻击频率
	inst.components.combat.onhitotherfn = OnHitOther--攻击到生物时执行函数
	--精神光环
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE
	
	inst:AddComponent("thief")--小偷，踢飞玩家身上东西用

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('medal_rage_krampus')

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("newcombattarget", OnNewCombatTarget)
	inst:ListenForEvent("krampustaunt",OnTaunt)
	
	inst:DoPeriodicTask(.5, spawnFootPrint)--留下脚气

    MakeHauntablePanic(inst)

    return inst
end

return Prefab("medal_rage_krampus", fn, assets, prefabs)
