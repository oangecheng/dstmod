local prefabs =
{
    "honey",
	"honeycomb",
}

local assets =
{
    Asset("ANIM", "anim/medal_rose_terrace.zip"),
    Asset("SOUND", "sound/bee.fsb"), --replace with wasp
	Asset("ATLAS", "minimap/medal_rose_terrace.xml"),
}

local function OnKilled(inst)
    inst.AnimState:PlayAnimation("cocoon_dead", true)
    RemovePhysicsColliders(inst)
    inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_destroy") --replace with wasp
    inst.components.lootdropper:DropLoot(inst:GetPosition()) --any loot drops?
end

local function onhitbyplayer(inst, attacker, damage)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function OnConstructed(inst, doer)
	local concluded = true
	for i, v in ipairs(CONSTRUCTION_PLANS[inst.prefab] or {}) do
		if inst.components.constructionsite:GetMaterialCount(v.type) < v.amount then
			concluded = false
			break
		end
	end

	if concluded then
		SpawnPrefab("lucy_ground_transform_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
		ReplacePrefab(inst, "medal_beequeenhive")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.5)

    inst.MiniMapEntity:SetIcon("medal_rose_terrace.tex")

    inst.AnimState:SetBank("medal_rose_terrace")
    inst.AnimState:SetBuild("medal_rose_terrace")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("structure")
    inst:AddTag("hive")
    inst:AddTag("WORM_DANGER")
	inst:AddTag("medal_beequeen")--凋零之蜂标签(用来确认世界唯一性)

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(250)
	
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "honey", "honey", "honey", "honeycomb" })
	
	inst:AddComponent("constructionsite")
	inst.components.constructionsite:SetConstructionPrefab("construction_container")
	inst.components.constructionsite:SetOnConstructedFn(OnConstructed)
	
    MakeLargeBurnable(inst)
    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(onhitbyplayer)
    inst:ListenForEvent("death", OnKilled)
	
    MakeMediumPropagator(inst)
    MakeSnowCovered(inst)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_MEDIUM)

    return inst
end

return Prefab("medal_rose_terrace", fn, assets, prefabs)
