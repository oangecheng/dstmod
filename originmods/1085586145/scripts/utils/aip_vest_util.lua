
function createClientVest(bank,build,animate,sound)
local inst=CreateEntity()

inst:AddTag("FX")
inst:AddTag("NOCLICK")

inst.entity:SetCanSleep(false)
inst.persists=false

inst.entity:AddTransform()
inst.entity:AddAnimState()

if sound~=nil then
inst.entity:AddSoundEmitter()
end

MakeProjectilePhysics(inst)

inst.Physics:ClearCollisionMask()

inst.AnimState:SetBank(bank)
inst.AnimState:SetBuild(build)
inst.AnimState:PlayAnimation(animate)

return inst
end


function createEffectVest(bank,build,animate,sound)
local inst=createClientVest(bank,build,animate,sound)


inst:ListenForEvent("animover",inst.Remove)

if sound~=nil then
inst.SoundEmitter:PlaySound(sound)
end

return inst
end


function createGroudVest(bank,build,animate,loop)
local inst=CreateEntity()

inst:AddTag("FX")
inst:AddTag("NOCLICK")

inst.entity:SetCanSleep(false)
inst.persists=false

inst.entity:AddTransform()
inst.entity:AddAnimState()

MakeCharacterPhysics(inst,1,.1)
RemovePhysicsColliders(inst)

inst.AnimState:SetBank(bank)
inst.AnimState:SetBuild(build)

inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
inst.AnimState:SetSortOrder(2)

if loop==true then
inst.AnimState:PlayAnimation(animate,true)
else
inst.AnimState:PlayAnimation(animate)
inst:ListenForEvent("animover",inst.Remove)
end


return inst
end


function createProjectile(source,target,fn,color,speed,scale)
local proj=aipSpawnPrefab(source,"aip_projectile")


if color~=nil then
proj.components.aipc_info_client:SetByteArray(
"aip_projectile_color",color
)
end

if speed~=nil then
proj.components.aipc_projectile.speed=10
end

if scale~=nil then
proj.Transform:SetScale(scale,scale,scale)
end

if target~=nil and target.prefab~=nil then
proj.components.aipc_projectile:GoToTarget(target,fn)
else
proj.components.aipc_projectile:GoToPoint(target,fn)
end

return proj
end

return {
createClientVest=createClientVest,
createEffectVest=createEffectVest,
createGroudVest=createGroudVest,
createProjectile=createProjectile,
}