local _G=GLOBAL


AddPlayerPostInit(function(inst)
if not inst.components.aipc_flyer_sc then
inst:AddComponent("aipc_flyer_sc")
end
end)



AddPrefabPostInit("player_classified",function(inst)
inst.aip_fly_picker=_G.net_string(inst.GUID,"aip_fly_picker","aip_fly_picker_dirty")


inst:ListenForEvent("aip_fly_picker_dirty",function()
local flyTotemId=_G.aipSplit(inst.aip_fly_picker:value(),"|")[2]

if _G.ThePlayer~=nil and inst==_G.ThePlayer.player_classified and flyTotemId~="" then
_G.ThePlayer.HUD:OpenAIPDestination(inst,flyTotemId)
end
end)
end)


local split="_AIP_FLY_TOTEM_"


env.AddModRPCHandler(env.modname,"aipGetFlyTotemNames",function(player)

local totemNames={ _G.os.time() }

for i,totem in ipairs(_G.TheWorld.components.world_common_store.flyTotems) do
local text=totem.components.writeable:GetText()


table.insert(totemNames,text or _G.STRINGS.CHARACTERS.GENERIC.DESCRIBE.AIP_FLY_TOTEM_UNNAMED)
table.insert(totemNames,totem.aipId)
end


local strs=table.concat(totemNames,split)
player.player_classified.aip_fly_totem_names:set(strs)
end)


AddPrefabPostInit("player_classified",function(inst)

inst.aip_fly_totem_names=_G.net_string(inst.GUID,"aip_fly_totem_names","aip_fly_totem_names_dirty")


inst:ListenForEvent("aip_fly_totem_names_dirty",function(inst)
local totemNames=_G.aipSplit(inst.aip_fly_totem_names:value(),split)


if _G.ThePlayer and _G.ThePlayer.player_classified==inst and _G.ThePlayer.aipOnTotemFetch then

local nameAndIds=_G.aipTableSlice(totemNames,2,#totemNames)
local names={}
local ids={}


for i,str in ipairs(nameAndIds) do
if math.mod(i,2)==1 then
table.insert(names,str)
else
table.insert(ids,str)
end
end

_G.ThePlayer.aipOnTotemFetch(names,ids)
end
end)
end)


local function findTotem(aipId)
local totems=_G.aipFilterTable(_G.TheWorld.components.world_common_store.flyTotems,function(t)
return t.aipId==aipId
end)

return totems[1]
end


local function flyToTotem(player,triggerId,targetId)
local triggerTotem=findTotem(triggerId)
local targetTotem=findTotem(targetId)

if triggerTotem~=nil and targetTotem~=nil then
triggerTotem.aipStartSpell(triggerTotem,targetTotem)
end
end

env.AddModRPCHandler(env.modname,"aipFlyToTotem",function(player,triggerId,targetId)
flyToTotem(player,triggerId,targetId)
end)








local function normalize(angle)
while angle > 360 do
angle=angle-360
end
while angle < 0 do
angle=angle+360
end
return angle
end


AddClassPostConstruct("cameras/followcamera",function(inst)
local dist=32

function inst:SetFlyView(flying)
if flying then

self.mindist=dist
self.maxdist=dist+20
self.pangain=999999

self._aipOriginHeadingtarget=self.headingtarget
else
self.headingtarget=self._aipOriginHeadingtarget
self:SetDefault()
end

self._aipFlying=flying
end

local OriginUpdate=inst.Update
function inst:Update(dt,...)

if self._aipFlying then
self.distance=self.distance*0.75+dist*0.25
self.headingtarget=normalize(180-_G.ThePlayer:GetRotation())
end

return OriginUpdate(self,dt,_G.unpack(arg))
end
end)
