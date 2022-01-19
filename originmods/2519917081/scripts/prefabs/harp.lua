-- this is a table of assets we will reference in this file
local assets = { 
	Asset("ANIM", "anim/swap_harp.zip"), -- look when being held in hand
    Asset("ANIM", "anim/harp.zip"), -- look when dropped on the ground
    
    Asset("ATLAS", "images/inventoryimages/harp.xml"),    
	Asset("IMAGE", "images/inventoryimages/harp.tex"),    
}


--白羽豎琴回血效果
local function healing(inst)
    local x, y, z = inst.Transform:GetWorldPosition()--獲得位置
    local ents = TheSim:FindEntities(x, y, z, 1)
    for k,v in pairs(ents) do
		if v:HasTag("player") and v.components.health and not v.components.health:IsDead() and
                        (TheNet:GetPVPEnabled() or v:HasTag("player"))
		then
		v.components.health:DoDelta(40)
		v.components.sanity:DoDelta(10)
		end
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("flute")

    inst.AnimState:SetBank("harp")
    inst.AnimState:SetBuild("harp")
    inst.AnimState:PlayAnimation("idle")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    MakeInventoryFloatable(inst, "small", 0.05, 0.8)
    inst.AnimState:AddOverrideBuild("pan_flute_water")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("instrument")
    inst.components.instrument.range = TUNING.PANFLUTE_SLEEPRANGE
    --inst.components.instrument:SetOnHeardFn(HearPanFlute)
	inst.components.instrument:SetOnHeardFn(healing)


    inst:AddComponent("tool")--"可使用的道具"設置
    inst.components.tool:SetAction(ACTIONS.PLAY)

    inst:AddComponent("finiteuses")--道具耐久度設置
    inst.components.finiteuses:SetMaxUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)

    inst:AddComponent("inventoryitem")--讓這東西可被撿起可被收入箱子內
	inst.components.inventoryitem.imagename = "harp" -- name of the image file we'll use for the inventory icon
	inst.components.inventoryitem.atlasname = "images/inventoryimages/harp.xml" -- path to it's atlas

    MakeHauntableLaunch(inst)

    inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("float") end)
    inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)

    return inst
end
 
-- this give the game our tools name, how to make it, and the assets to make it
--           ("common/inventory/axe") (fn)(assets)
return Prefab( "common/inventory/harp", fn, assets)