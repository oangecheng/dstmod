local assets =
{
	Asset("ANIM", "anim/medal_naughtybell.zip"),
	Asset("ATLAS", "images/medal_naughtybell.xml"),
	Asset("ATLAS_BUILD", "images/medal_naughtybell.xml",256),
}
--判断是不是在月岛
local function IsOnLunarIsland(player)
    return player.components.areaaware ~= nil
        and player.components.areaaware:CurrentlyInTag("lunacyarea")
end

--演奏
local function OnPlayed(inst, musician)
	
	local thiefNum=math.random(TUNING_MEDAL.BELL_THIEFNUM_NOMAL)--小偷数量
	local sanityLoss=TUNING_MEDAL.BELL_SANITYLOSS_NORMAL--精神损失
	local needSay=STRINGS.NAUGHTYBELLSPEECH.ONPLAYED
	
	--装备淘气铃铛小偷数量加成
	if musician:HasTag("naughtymedal") then
		--小概率惹怒小偷
		if math.random() < TUNING_MEDAL.BELL_PROVOKE_THIEF_CHANCE then
			thiefNum=TUNING_MEDAL.BELL_THIEFNUM_MAX
			sanityLoss=TUNING_MEDAL.BELL_SANITYLOSS_MAX
			needSay=STRINGS.NAUGHTYBELLSPEECH.MAKETROUBLE
		else
			thiefNum=thiefNum+TUNING_MEDAL.BELL_THIEFNUM_MEDAL_ADDITION
			sanityLoss=TUNING_MEDAL.BELL_SANITYLOSS_MORE
		end
	end
	
	if musician and musician.components.sanity then
		
		--在月岛就加启蒙值，否则扣精神
		if IsOnLunarIsland(musician) then
			sanityLoss=-sanityLoss
			needSay=STRINGS.NAUGHTYBELLSPEECH.ONLUNARISLAND
		end
		musician.components.sanity:DoDelta(thiefNum*sanityLoss)
		
		--如果精神值为空或者为满，都会额外扣除一定血量
		if musician.components.sanity:GetPercent()<=0 or musician.components.sanity:GetPercent()>=1 then
			musician.components.health:DoDelta(TUNING_MEDAL.NAUGHTYBELL_HEALTH_LOSE*thiefNum)
		end
	end
	--感叹词
	if musician.components.talker and not musician:HasTag("mime") then
		musician.components.talker:Say(needSay)
	end
	--召唤小偷
	TheWorld:PushEvent("ms_forcenaughtiness", { player = musician, numspawns = thiefNum })
end
--闪光
local function shine(inst)
    inst.task = nil
    inst.AnimState:PlayAnimation("sparkle")
    inst.AnimState:PushAnimation("idle")
    inst.task = inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
end
--被小偷和鼹鼠偷走时如果附近有玩家则召唤一只暗夜坎普斯
local function OnPutInInv(inst, owner)
    if owner.prefab == "mole" or owner.prefab == "krampus" then
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/glommer_bell")
        -- OnPlayed(inst, owner)
		local x, y, z = owner.Transform:GetWorldPosition()
		local closestplayer=FindClosestPlayerInRange(x,y,z,30,true)
		if closestplayer then
			if math.random()<.2 then
				MakeRageKrampusForPlayer(closestplayer)
			else
				TheWorld:PushEvent("ms_forcenaughtiness", { player = closestplayer, numspawns = 3 })
			end
			inst:Remove()
		end
		-- if inst.components.finiteuses then inst.components.finiteuses:Use() end
    end
end
--耐久用完
local function OnFinished(inst)
	if inst.components.instrument~=nil then
		inst:RemoveComponent("instrument")
	end
end
--添加演奏组件
local function setInstrument(inst)
	inst:AddComponent("instrument")
	inst.components.instrument:SetOnPlayedFn(OnPlayed)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("medal_naughtybell")
	inst.AnimState:SetBuild("medal_naughtybell")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("bell")
	inst:AddTag("molebait")--鼹鼠诱饵
	
	MakeInventoryFloatable(inst, "med", nil, 0.75)
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_naughtybell"
	inst.components.inventoryitem.atlasname = "images/medal_naughtybell.xml"
    --被偷走
    inst:ListenForEvent( "onstolen", function(inst, data) 
        if data.thief.components.inventory then
            data.thief.components.inventory:GiveItem(inst)
        end 
    end)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInv)
    
    setInstrument(inst)
	
	-- inst.OnPlayedBellFn=OnPlayed

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.NAUGHTYBELL_MAX_USETIME)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.NAUGHTYBELL_MAX_USETIME)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)
	inst.components.finiteuses:SetOnFinished(OnFinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)
	inst:ListenForEvent("percentusedchange", function(inst,data)
		if data and data.percent then
			--耐久用完后补充耐久
			if data.percent>0 and inst.components.instrument==nil then
				setInstrument(inst)
			end
		end
	end)
    shine(inst)
	
	MakeHauntableLaunch(inst)
	return inst
end

return Prefab("medal_naughtybell", fn, assets)