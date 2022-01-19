
local Transfer=Class(function(self,inst)
self.inst=inst
self.sanityCost=TUNING.SANITY_MED
self.target=nil
self.aura=nil
self.onToggle=nil

self.prefabName=net_string(inst.GUID,"aipc_shadow_transfer_prefab","aipc_shadow_transfer_prefab_dirty")


self.inst:ListenForEvent("aipc_shadow_transfer_prefab_dirty",function()
self.inst.overridedeployplacername=self.prefabName:value().."_placer"
end)
end)

function Transfer:CanMark(target)
if not target or not target.Physics then
return false
end

if self.inst:HasTag("aip_marked") then
return false
end


if not target:HasTag("structure") then
return false
end


if not IsRecipeValid(target.prefab) then
return false
end

return true
end

function Transfer:Mark(target,doer)
if self.target then
return
end

aipSpawnPrefab(target,"aip_shadow_wrapper").DoShow()

self.inst:AddTag("aip_marked")
self.aura=SpawnPrefab("aip_aura_transfer")
self.target=target

target:AddTag("aipc_transfer_marked")
target:AddChild(self.aura)

if self.onToggle~=nil then
self.onToggle(self.inst,true)
end

self.prefabName:set(target.prefab)


if doer.components.sanity then
doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
end
end

function Transfer:MoveTo(pt,doer)
if not self.target then
return
end


self.target.Physics:Teleport(pt.x,pt.y,pt.z)
aipSpawnPrefab(self.target,"aip_shadow_wrapper").DoShow()


local container=self.inst.components.inventoryitem:GetContainer()
if doer~=nil and doer.components.inventory~=nil then
doer.components.inventory:GiveItem(SpawnPrefab("aip_shadow_transfer"))
end


self.target:RemoveTag("aipc_transfer_marked")
self.target:RemoveChild(self.aura)
self.target=nil

self.inst:RemoveTag("aip_marked")
self.aura:Remove()
self.aura=nil

self.inst.overridedeployplacername=nil


if doer.components.sanity then
doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
end

if self.onToggle~=nil then
self.onToggle(self.inst,false)
end
end

return Transfer