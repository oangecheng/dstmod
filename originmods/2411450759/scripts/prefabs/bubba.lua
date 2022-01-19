local brain = require("brains/bubbabrain")
local BubbaDigItem = require "modifications/bubba_digitem"

local WAKE_TO_FOLLOW_DISTANCE = 6
local SLEEP_NEAR_LEADER_DISTANCE = 5

local HUNGRY_PERISH_PERCENT = 0.5 -- matches stale tag
local STARVING_PERISH_PERCENT = 0.2 -- matches spoiked tag

local function IsLeaderSleeping(inst)
    return inst.components.follower.leader and inst.components.follower.leader:HasTag("sleeping")
end

local function ShouldWakeUp(inst)
    return not IsLeaderSleeping(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    return IsLeaderSleeping(inst) and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE)
end

-------------------------------------------------------------------------------
-- Need to keep GetPeepChance to prevent stategraph crash
local function GetPeepChance(inst)
    -- local hunger_percent = inst.components.hunger:GetPercent()
    -- if hunger_percent <= 0 then
    --     return 0.01
    -- end

    return 0
end

local function IsAffectionate(inst)
    return true
end

local function IsPlayful(inst)
	return true
end

local function IsSuperCute(inst)
	return true
end

local assets =
{
    Asset("ANIM", "anim/bubba_build.zip"),
}

local prefabs = {}

local function LinkToPlayer(inst, player)
    inst._playerlink = player
    inst.components.follower:SetLeader(player)

    inst:ListenForEvent("onremove", inst._onlostplayerlink, player)
end

local function OnPlayerLinkDespawn(inst)
	if inst.components.container ~= nil then
		inst.components.container:Close()
		inst.components.container.canbeopened = false

		if GetGameModeProperty("drop_everything_on_despawn") then
			inst.components.container:DropEverything()
		else
			inst.components.container:DropEverythingWithTag("irreplaceable")
		end
	end

	if inst.components.drownable ~= nil then
		inst.components.drownable.enabled = false
	end

	local fx = SpawnPrefab(inst.spawnfx)
	fx.entity:SetParent(inst.entity)

	inst.components.colourtweener:StartTween({ 0, 0, 0, 1 }, 13 * FRAMES, inst.Remove)

	if not inst.sg:HasStateTag("busy") then
		inst.sg:GoToState("despawn")
	end
end

local function OnOpen(inst)
end

local function OnClose(inst)
end

    -- TODO: For when we want Bubba auto-pick feature (Warning: this is still buggy)
    -- local function PickupItemNearby(inst)		
    --     local SEARCH_RADIUS = 6
    --     local item = FindEntity(inst, SEARCH_RADIUS, function(item) 
    --         return item.components.inventoryitem and item.components.inventoryitem.canbepickedup and item.components.inventoryitem.cangoincontainer	end)		
    --     if item ~= nil then
    --         if not inst.components.container:IsFull() then		
    --             --inst.AnimState:PlayAnimation("eat")			
    --             inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/eat")			
    --             inst.components.container:GiveItem(item)			
    --             return		
    --         elseif item.components.stackable then				
    --             local stackable = inst.components.container:FindItem(function(i) 	
    --             return (i.prefab == item.prefab and not i.components.stackable:IsFull()) end)						
    --             if stackable then				
    --                 --inst.AnimState:PlayAnimation("eat")			   
    --                 inst.SoundEmitter:PlaySound("dontstarve/characters/walter/woby/small/eat")				
    --                 inst.components.container:GiveItem(item)				
    --                 return			
    --             end	
    --         end
    --     end	
    -- end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(1, .33)
    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("pupington")
    inst.AnimState:SetBuild("bubba_build")
    inst.AnimState:PlayAnimation("idle_loop")

    MakeCharacterPhysics(inst, 1, .5)

    -- critters dont really go do entitysleep as it triggers a teleport to near the owner, so no point in hitting the physics engine.
	inst.Physics:SetDontRemoveOnSleep(true)

    inst:AddTag("critter")
    inst:AddTag("fedbyall")
    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")
    inst:AddTag("small_livestock")
    inst:AddTag("noabandon")
    inst:AddTag("NOBLOCK")

    inst:AddComponent("spawnfader")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            inst.replica.container:WidgetSetup("chester")
		end
        return inst
    end

    inst.GetPeepChance = GetPeepChance  -- Need to keep this to prevent stategraph crash
    inst.IsAffectionate = IsAffectionate
    inst.IsSuperCute = IsSuperCute
    inst.IsPlayful = IsPlayful
    
	inst.playmatetags = {"critter"}

    inst:AddComponent("inspectable")

    inst:AddComponent("follower")
    inst.components.follower:KeepLeaderOnAttacked()
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true

    inst:AddComponent("knownlocations")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(true)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.softstop = true
    inst.components.locomotor.walkspeed = TUNING.CRITTER_WALK_SPEED

    inst.components.locomotor:SetAllowPlatformHopping(true)

    inst:AddComponent("embarker")
    inst.components.embarker.embark_speed = inst.components.locomotor.walkspeed
    inst:AddComponent("drownable")
    
	inst:AddComponent("colourtweener")

    inst:AddComponent("crittertraits")
    inst:AddComponent("timer")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("chester")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose

    inst:SetBrain(brain)
    inst:SetStateGraph("SGbubba")

    inst.LinkToPlayer = LinkToPlayer
	inst.OnPlayerLinkDespawn = OnPlayerLinkDespawn
	inst._onlostplayerlink = function(player) inst._playerlink = nil end

    inst.persists = false

    inst.spawnfx = "spawn_fx_small"

    inst:ListenForEvent("bubbaUpdateDig", BubbaDigItem)
    --inst:ListenForEvent("bubbaUpdatePickup", PickupItemNearby)

    inst:DoPeriodicTask(1, function ()
        inst:PushEvent("bubbaUpdateDig")
        --inst:PushEvent('bubbaUpdatePickup')
    end)

    return inst
end

return Prefab("bubba", fn, assets, prefabs)