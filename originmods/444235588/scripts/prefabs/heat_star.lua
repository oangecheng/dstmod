require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/heat_star.zip"),
	Asset("ANIM", "anim/heat_star_flame.zip"),
}

local prefabs =
{
    "heat_star_flame",
}    

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	if heatStar_starsSpawnHounds == "yes" then
		inst.components.lootdropper:SpawnLootPrefab("firehound")
		inst.components.talker:Say("STOP!!! I don't want to die... HOUND PROTECT ME!!!")
	else
		inst.components.talker:Say("STOP!!! I don't want to die...")
	end
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function onignite(inst)
    if not inst.components.cooker then
        inst:AddComponent("cooker")
    end
end

local function onextinguish(inst, addLootItems)
    if inst.components.cooker then
        inst:RemoveComponent("cooker")
    end
    if inst.components.fueled then
        inst.components.fueled:InitializeFuelLevel(0)
    end

	if heatStarDropLoot == "yes" then
		if addLootItems == 1 then -- flame max level 10
			if heatStar_starsSpawnHounds == "yes" then
				inst.components.lootdropper:SpawnLootPrefab("firehound")
				inst.components.lootdropper:SpawnLootPrefab("firehound")
				inst.components.lootdropper:SpawnLootPrefab("firehound")
				inst.components.lootdropper:SpawnLootPrefab("firehound")
			end
			inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
			inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
			inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
			inst.components.lootdropper:SpawnLootPrefab("redgem")
		elseif addLootItems == 2 then -- flame max level 9
			if heatStar_starsSpawnHounds == "yes" then
				inst.components.lootdropper:SpawnLootPrefab("firehound")
				inst.components.lootdropper:SpawnLootPrefab("firehound")
				inst.components.lootdropper:SpawnLootPrefab("firehound")
			end
			inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
			inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
		elseif addLootItems == 3 then -- flame max level 6
			if heatStar_starsSpawnHounds == "yes" then
				inst.components.lootdropper:SpawnLootPrefab("firehound")
				inst.components.lootdropper:SpawnLootPrefab("firehound")
			end
			inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
	   end
	end
end

local function ontakefuel(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function updatefuelrate(inst)
    inst.components.fueled.rate = TheWorld.state.israining and heatStarBurnRate or heatStarBurnRate
end

local function onupdatefueled(inst)
    if inst.components.burnable ~= nil and inst.components.fueled ~= nil then
        updatefuelrate(inst)
        inst.components.burnable:SetFXLevel(inst.components.fueled:GetCurrentSection(), inst.components.fueled:GetSectionPercent())
    end
end


local function getstatus(inst)
    local sec = inst.components.fueled:GetCurrentSection()
    if sec == 0 then 
        return "OUT"
	elseif sec <= 10 then
		local t = {"EMBERS","EMBERS","LOW","LOW","NORMAL","NORMAL","NORMAL","NORMAL","HIGH","HIGH"}
        return t[sec]
    end
end

local function fn()
	local flameFullyLoaded = "false"
	local addLootItems = 0
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst.MiniMapEntity:SetIcon("heat_star.tex")
    inst.MiniMapEntity:SetPriority(1)

    inst.AnimState:SetBank("heat_star")
    inst.AnimState:SetBuild("heat_star")
    inst.AnimState:PlayAnimation("idle",false)
    inst:AddTag("campfire")
    inst:AddTag("structure")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    -----------------------
    inst:AddComponent("burnable")
    --inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:AddBurnFX("heat_star_flame", Vector3(0, 0, 0))
	inst:ListenForEvent("onextinguish", function() onextinguish(inst,addLootItems) end)
    inst:ListenForEvent("onignite", onignite)
    
    -------------------------
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)    

    -------------------------

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_HUGE


    inst:AddComponent("talker")
    inst.components.talker.colour = Vector3(215/255, 48/255, 3/255)
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.fontsize = 28
    inst.components.talker.offset = Vector3(0,-520,0)


    inst:ListenForEvent("donetalking", function() inst.SoundEmitter:KillSound("talk") end)
    inst:ListenForEvent("ontalk", function() 
		if not inst.SoundEmitter:PlayingSound("special") then
			inst.SoundEmitter:PlaySound("dontstarve/characters/wolfgang/talk_LP", "talk") 
		end
	end)

    -------------------------
    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = TUNING.FIREPIT_FUEL_MAX
    inst.components.fueled.accepting = true
    inst.components.fueled.secondaryfueltype = "CHEMICAL"
    
    inst.components.fueled:SetSections(10)
    inst.components.fueled.bonusmult = TUNING.FIREPIT_BONUS_MULT * 2
    inst.components.fueled.ontakefuelfn = ontakefuel
    inst.components.fueled:SetUpdateFn(onupdatefueled)
    inst.components.fueled:SetSectionCallback( function(section, oldSection)
	--inst.AnimState:SetAddColour(0, 1, 1 ,.4)
	
		if section == 0 then
            inst.components.burnable:Extinguish(inst, addLootItems)
			addLootItems = 0
			inst.components.fueled.accepting = true 
		else
			--addLootItems = false
            if not inst.components.burnable:IsBurning() then
                inst.components.burnable:Ignite()
            end
            
            inst.components.burnable:SetFXLevel(section, inst.components.fueled:GetSectionPercent())

			if section == 10 then
				inst.components.talker:Say("I feel like a Supernova!!!")
				addLootItems = 1
				inst.components.fueled.accepting = false 
			elseif section == 9 then
				if addLootItems ~= 1 then
					addLootItems = 2
				end
				inst.components.fueled.accepting = true 
			elseif section <= 6 and section > 0 then
				if addLootItems ~= 1 and addLootItems ~= 2 then
					addLootItems = 3
				end
				inst.components.fueled.accepting = true 
			end
           		--print("section",section, inst)

        end

		if section > 8 then
			inst.components.sanityaura.aura = TUNING.SANITYAURA_LARGE
			--print("sanityaura - SANITYAURA_LARGE",inst.components.sanityaura.aura, inst)
		elseif section <= 8  and section > 3 then
			inst.components.sanityaura.aura = TUNING.SANITYAURA_MED
			--print("sanityaura - SANITYAURA_MED",inst.components.sanityaura.aura, inst)
		elseif section <= 3 and section > 0 then
			inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
			--print("sanityaura - SANITYAURA_SMALL",inst.components.sanityaura.aura, inst)
		else
			inst.components.sanityaura.aura = 0
			--print("sanityaura - 0",inst.components.sanityaura.aura, inst)
		end



		if (section == 1 and section < oldSection) and addLootItems > 0 and heatStar_starsSpawnHounds == "yes" then 
			inst.components.talker:Say("I'm fading... fuel me NOW or feel my wrath! My HOUNDS will protect me!!")
		elseif (section == 1 and section < oldSection) and addLootItems > 0 then 
			inst.components.talker:Say("I'm fading... I don't want to be extinguished!")
		elseif (section == 1 and section > oldSection) and addLootItems > 0 then 
			inst.components.talker:Say("Bless you for awakening my weakened spirit... I need a bit more fuel")
		elseif (section == 2 and section < oldSection) and addLootItems > 0  and heatStar_starsSpawnHounds == "yes" then 
			inst.components.talker:Say("You'll be sorry if you let me go out... I will leave a nasty suprise to HOUND you!!")
		elseif (section == 2 and section < oldSection) and addLootItems > 0 then 
			inst.components.talker:Say("I beg you not to let my spirit die...")
		elseif (section >= 3  and section < 6 and section > oldSection) and addLootItems > 0 then 
			inst.components.talker:Say("More... More... MORE!!!")
		elseif (section == 4 and section < oldSection) and addLootItems > 0 then 
			inst.components.talker:Say("I'm starting to feel weak... FEED ME NOW!!!")
		elseif (section == 6 and section > oldSection) and addLootItems > 0 then 
			inst.components.talker:Say("My Spirit is burning bright!")
		elseif (section == 8 and oldSection < section) and addLootItems > 0 then 
			inst.components.talker:Say("I feel alive again!!")
		end

		oldSection = section
	end)
        
    inst.components.fueled:InitializeFuelLevel(TUNING.FIREPIT_FUEL_START+(TUNING.FIREPIT_FUEL_START/3)) -- Add a third more starting fuel

    -----------------------------

    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_HUGE
    inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
        local ret = false
        if math.random() <= TUNING.HAUNT_CHANCE_RARE then
            if inst.components.fueled and not inst.components.fueled:IsEmpty() then
                local fuel = SpawnPrefab("petals")
                if fuel then 
                    inst.components.fueled:TakeFuelItem(fuel)
                    inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
                    ret = true
                end
            end
        end
        if math.random() <= TUNING.HAUNT_CHANCE_HALF then
            if inst.components.workable and inst.components.workable.workleft > 0 then
                inst.components.workable:WorkedBy(haunter, 1)
                inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
                ret = true
            end
        end
        return ret
    end)
    
    -----------------------------
    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus
    
    inst:ListenForEvent( "onbuilt", function()
		inst.AnimState:PlayAnimation("build")
		inst.AnimState:PushAnimation("idle", false)
		inst.components.talker:Say("I am the Spirit of Anchiale - Fear my awesome POWER!!!")
        inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
		addLootItems = 3 -- initialise loot on build
    end)
    
    return inst
end

return Prefab( "common/objects/heat_star", fn, assets, prefabs),
		MakePlacer( "common/heat_star_placer", "heat_star", "heat_star", "idle" ) 
