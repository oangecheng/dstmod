local _G=GLOBAL
local language=_G.aipGetModConfig("language")

env.AddReplicableComponent("aipc_buffer")



local function triggerComponentAction(player,item,target,targetPoint)
if item.components.aipc_action~=nil then

if target~=nil then
item.components.aipc_action:DoTargetAction(player,target)
elseif targetPoint~=nil then
item.components.aipc_action:DoPointAction(player,targetPoint)
else
item.components.aipc_action:DoAction(player)
end
end
end

env.AddModRPCHandler(env.modname,"aipComponentAction",function(player,item,target,targetPoint)
triggerComponentAction(player,item,target,targetPoint)
end)


local LANG_MAP={
english={
GIVE="Give",
FUEL="Fuel",
USE="Use",
CAST="Cast",
READ="Read",
EAT="Eat",
},
chinese={
GIVE="给予",
FUEL="充能",
USE="使用",
CAST="释放",
READ="阅读",
EAT="吃",
},
}
local LANG=LANG_MAP[language] or LANG_MAP.english

_G.STRINGS.ACTIONS.AIP_USE=LANG.USE


local AIPC_ACTION=env.AddAction("AIPC_ACTION",LANG.GIVE,function(act)
local doer=act.doer
local item=act.invobject
local target=act.target

if _G.TheNet:GetIsServer() then

triggerComponentAction(doer,item,target,nil)
else

_G.aipRPC("aipComponentAction",item,target,nil)
end

return true
end)
AIPC_ACTION.priority=1

AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_ACTION,"dolongaction"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_ACTION,"dolongaction"))


env.AddComponentAction("USEITEM","aipc_action_client",function(inst,doer,target,actions,right)
if not inst or not target then
return
end

if inst.components.aipc_action_client:CanActOn(doer,target) then
table.insert(actions,_G.ACTIONS.AIPC_ACTION)
end
end)


local AIPC_FUEL_ACTION=env.AddAction("AIPC_FUEL_ACTION",LANG.FUEL,function(act)
local doer=act.doer
local item=act.invobject
local target=act.target

if doer~=nil and item~=nil and target~=nil and target.components.aipc_fueled~=nil then
return target.components.aipc_fueled:TakeFuel(item,player)
end

return false
end)

AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_FUEL_ACTION,"dolongaction"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_FUEL_ACTION,"dolongaction"))


env.AddComponentAction("USEITEM","aipc_fuel",function(inst,doer,target,actions,right)
if not inst or not target then
return
end

if target.components.aipc_fueled~=nil and target.components.aipc_fueled:CanUse(inst,doer) then
table.insert(actions,_G.ACTIONS.AIPC_FUEL_ACTION)
end
end)


local function beAction(act)
local doer=act.doer
local item=act.invobject
local target=act.target

local mergedTarget=target or item

if _G.TheNet:GetIsServer() then

triggerComponentAction(doer,mergedTarget,nil,nil)
else

_G.aipRPC("aipComponentAction",mergedTarget,nil,nil)
end

return true
end

local AIPC_BE_ACTION=env.AddAction("AIPC_BE_ACTION",LANG.USE,beAction)
local AIPC_BE_CAST_ACTION=env.AddAction("AIPC_BE_CAST_ACTION",LANG.CAST,beAction)
AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_BE_ACTION,"doshortaction"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_BE_ACTION,"doshortaction"))
AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_BE_CAST_ACTION,"quicktele"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_BE_CAST_ACTION,"quicktele"))


env.AddComponentAction("SCENE","aipc_action_client",function(inst,doer,actions,right)
if not inst or not right then
return
end

if inst.components.aipc_action_client:CanBeActOn(doer) then
table.insert(actions,_G.ACTIONS.AIPC_BE_ACTION)
end
end)


local AIPC_EAT_ACTION=env.AddAction("AIPC_EAT_ACTION",LANG.EAT,function(act)
local doer=act.doer
local item=act.invobject
local target=act.target

if _G.TheNet:GetIsServer() then

triggerComponentAction(doer,item,target,nil)
else

_G.aipRPC("aipComponentAction",item,target,nil)
end

return true
end)

AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_EAT_ACTION,"eat"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_EAT_ACTION,"eat"))


local AIPC_READ_ACTION=env.AddAction("AIPC_READ_ACTION",LANG.READ,function(act)
local doer=act.doer
local item=act.invobject
local target=act.target

if _G.TheNet:GetIsServer() then

triggerComponentAction(doer,item,target,nil)
else

_G.aipRPC("aipComponentAction",item,target,nil)
end

return true
end)

AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_READ_ACTION,"book"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_READ_ACTION,"book"))


env.AddComponentAction("INVENTORY","aipc_action_client",function(inst,doer,actions,right)
if inst.components.aipc_action_client:CanBeActOn(doer) then
table.insert(actions,_G.ACTIONS.AIPC_BE_ACTION)
end

if inst.components.aipc_action_client:CanBeCastOn(doer) then
table.insert(actions,_G.ACTIONS.AIPC_BE_CAST_ACTION)
end

if inst.components.aipc_action_client:CanBeRead(doer) then
table.insert(actions,_G.ACTIONS.AIPC_READ_ACTION)
end

if inst.components.aipc_action_client:CanBeEat(doer) then
table.insert(actions,_G.ACTIONS.AIPC_EAT_ACTION)
end
end)



local function doCastAction(act)
local doer=act.doer

local pos=act.pos
local target=act.target
local item=_G.aipGetActionableItem(doer)

if _G.TheNet:GetIsServer() then

triggerComponentAction(doer,item,target,pos~=nil and act:GetActionPoint())
else

_G.aipRPC("aipComponentAction",item,target,pos)
end

return true
end


local AIPC_CASTER_ACTION=env.AddAction("AIPC_CASTER_ACTION",LANG.CAST,doCastAction)
AIPC_CASTER_ACTION.distance=10

AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_CASTER_ACTION,"quicktele"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_CASTER_ACTION,"quicktele"))


local AIPC_GRID_CASTER_ACTION=env.AddAction("AIPC_GRID_CASTER_ACTION",LANG.CAST,function(act)
local doer=act.doer

local pos=act.pos
local target=act.target
local item=_G.aipGetActionableItem(doer)

if _G.TheNet:GetIsServer() then

triggerComponentAction(doer,item,target,pos~=nil and act:GetActionPoint())
else

SendModRPCToServer(MOD_RPC[env.modname]["aipComponentAction"],doer,item,target,pos)
end

return true
end)
AIPC_GRID_CASTER_ACTION.tile_placer="aip_xinyue_gridplacer"
AIPC_GRID_CASTER_ACTION.theme_music="farming"
AIPC_GRID_CASTER_ACTION.customarrivecheck=function(doer,dest)
local doer_pos=doer:GetPosition()
local target_pos=_G.Vector3(dest:GetPoint())

local tile_x,tile_y,tile_z=_G.TheWorld.Map:GetTileCenterPoint(target_pos.x,0,target_pos.z)
local dist=_G.TILE_SCALE*0.5
if math.abs(tile_x-doer_pos.x) <=dist and math.abs(tile_z-doer_pos.z) <=dist then
return true
end
end

AddStategraphActionHandler("wilson",_G.ActionHandler(AIPC_GRID_CASTER_ACTION,"quicktele"))
AddStategraphActionHandler("wilson_client",_G.ActionHandler(AIPC_GRID_CASTER_ACTION,"quicktele"))


env.AddComponentAction("POINT","aipc_action_client",function(inst,doer,pos,actions,right)
if not inst or not pos or not right then
return
end

if inst.components.aipc_action_client:CanActOnPoint(doer,pos) then
if inst.components.aipc_action_client.gridplacer then
table.insert(actions,_G.ACTIONS.AIPC_GRID_CASTER_ACTION)
else
table.insert(actions,_G.ACTIONS.AIPC_CASTER_ACTION)
end
end
end)


env.AddComponentAction("SCENE","combat",function(inst,doer,actions,right)
if not inst or not right then
return
end

local item=_G.aipGetActionableItem(doer)

if item~=nil and item.components.aipc_action_client:CanActOn(doer,inst) then
table.insert(actions,_G.ACTIONS.AIPC_CASTER_ACTION)
end
end)



AddComponentPostInit("health",function(self)

local originDoDelta=self.DoDelta

function self:DoDelta(amount,overtime,cause,ignore_invincible,afflicter,ignore_absorb,...)

if _G.hasBuffer(self.inst,"healthCost") and amount < 0 then
amount=amount*2
end

local data={ amount=amount }
self.inst:PushEvent("aip_healthdelta",data)

return originDoDelta(
self,data.amount,overtime,cause,ignore_invincible,afflicter,ignore_absorb,...
)
end


function self:LockInvincible(val)
self.aipLockInvincible=val
end


local originSetInvincible=self.SetInvincible
function self:SetInvincible(val,...)
if self.aipLockInvincible~=true then
return originSetInvincible(self,val,...)
end
end

end)


AddComponentPostInit("writeable",function(self)
local originEndWriting=self.EndWriting

function self:EndWriting(...)
if self.onAipEndWriting~=nil then
self.onAipEndWriting()
end

originEndWriting(self,...)
end
end)


AddComponentPostInit("healer",function(self)
local originHeal=self.Heal

function self:Heal(target,...)
if self.onHealTarget~=nil then
self.onHealTarget(self.inst,target)
end

return originHeal(self,target,...)
end
end)
