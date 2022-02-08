require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/foreverlight.zip"),
		
}


local function LightsOn(inst)
    if not inst.broken then
		inst.Light:Enable(true)
		
		inst.AnimState:PlayAnimation("idle_on")
		inst.lightson = true
		
		
	
		
	end
end


local function LightsOff(inst)
    if not inst.broken then
    	
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle_off")
        inst.lightson = false
        
	end
end



local function onoccupiedlighttask(inst)
	
		if	TheWorld.state.phase == "day" and inst.lightson then
			inst:DoTaskInTime(3.0,LightsOff)
			
			
		elseif	TheWorld.state.phase == "dusk" and inst.lightson then
			LightsOff(inst)
		elseif TheWorld.state.isfullmoon and inst.lightson then
			LightsOff(inst)
		elseif not inst.lightson and TheWorld.state.phase == "night" and not TheWorld.state.isfullmoon then
			LightsOn(inst)
		end
	
end


local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
	
	inst.AnimState:PushAnimation("idle_off", true)
end

local function onbuilt(inst)
    
  
    inst.AnimState:PlayAnimation("idle_off")
end


local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif item.prefab == "walrushat" then
        return true
    elseif item.prefab == "silk" then
        return true
    elseif item.prefab == "pigskin" then
        return true
    end
    return false
end

local function OnGemGiven(inst, giver, item)
    inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .1)

    inst.MiniMapEntity:SetIcon("foreverlight.tex")

	inst.entity:AddLight()
	inst.Light:SetRadius(8)
    inst.Light:SetFalloff(.8)
    inst.Light:SetIntensity(.8)
    inst.Light:SetColour(180/255,180/255,180/255)
	inst.Light:Enable(false)

    inst.AnimState:SetBank("foreverlight")
    inst.AnimState:SetBuild("foreverlight")
    inst.AnimState:PlayAnimation("idle_off", true)

    inst:AddTag("structure")

	MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10,13)
    

	inst:AddComponent("talker")
    inst.components.talker.fontsize = 21
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(0.7, 0.85, 1, 1)
    inst.components.talker.offset = Vector3(0,-550,0)
    inst.components.talker.symbol = "swap_object"

     -- 添加给予组件
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven


	

    inst:AddComponent("inspectable")

    inst:ListenForEvent("onbuilt", onbuilt)

	inst:ListenForEvent("clocktick", function() onoccupiedlighttask(inst) end, TheWorld)

	

	MakeHauntableWork(inst)

    return inst
end

return Prefab("foreverlight", fn, assets),
    MakePlacer("foreverlight_placer", "foreverlight", "foreverlight", "idle_off")

