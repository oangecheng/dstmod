
local assets=
{
Asset("ANIM","anim/staff_projectile.zip"),
}

function fn()
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()

MakeInventoryPhysics(inst)
RemovePhysicsColliders(inst)

inst.entity:SetPristine()

if not TheWorld.ismastersim then
return inst
end

inst.persists=false


inst.OnLoad=function()
inst:Remove()
end

return inst
end

return Prefab("aip_vest",fn,assets)