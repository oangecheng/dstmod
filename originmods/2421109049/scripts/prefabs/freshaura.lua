local assets = {}
local prefabs = {}

local function DoAreaSpoil(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, inst.components.aura.radius, nil, { "small_livestock" }, { "fresh", "stale", "spoiled" })
    for i, v in ipairs(ents) do
        if v:IsInLimbo() then
	        local owner = v.components.inventoryitem ~= nil and v.components.inventoryitem.owner or nil
	        if owner == nil or
	            (   owner.components.container ~= nil and
	                not owner.components.container:IsOpen() and
	                owner:HasTag("chest")   ) then
	            --in limbo but not inventory or container?
	            --or in a closed chest
	            return
	        end
	    end
	    v.components.perishable:ReducePercent(-.007)
    end
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("aura")
    inst.components.aura.radius = TUNING.TOADSTOOL_SPORECLOUD_RADIUS
    inst.components.aura.tickperiod = TUNING.TOADSTOOL_SPORECLOUD_TICK
    local AURA_EXCLUDE_TAGS = { "toadstool", "playerghost", "ghost", "shadow", "shadowminion", "noauradamage", "INLIMBO" }
    inst.components.aura.auraexcludetags = AURA_EXCLUDE_TAGS
    inst.components.aura:Enable(true)
    inst._spoiltask = inst:DoPeriodicTask(inst.components.aura.tickperiod, DoAreaSpoil, inst.components.aura.tickperiod * .5)

    return inst
end

return Prefab("freshaura", fn, assets, prefabs)