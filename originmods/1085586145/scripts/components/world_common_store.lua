local open_beta=aipGetModConfig("open_beta")=="open"

local dev_mode=aipGetModConfig("dev_mode")=="enabled"

local function findFarAwayOcean(pos)
local ocean_pos=nil
local longestDist=-1

for i=1,30 do
local rndPos=aipFindRandomPointInOcean(20,4)

local dist=(rndPos~=nil and pos~=nil) and aipDist(rndPos,pos) or 0


if dist >=longestDist then
longestDist=dist
ocean_pos=rndPos
end
end


if ocean_pos==nil then
ocean_pos=FindNearbyOcean(Vector3(0,0,0))


else
local ents=aipFindNearEnts(
ocean_pos,
{"seastack","messagebottle","driftwood_log"},
dev_mode and 20 or 5
)
for i,ent in ipairs(ents) do
if ent:IsValid() then
ent:Remove()
end
end
end

return ocean_pos
end

local function onFishShoalAdded(inst)
if TheWorld.components.world_common_store~=nil then
table.insert(
TheWorld.components.world_common_store.fishShoals,
inst
)
end
end

local CommonStore=Class(function(self,inst)
self.inst=inst
self.shadow_follower_count=0


self.chestOpened=false

self.holderChest=nil

self.chests={}


self.douTotem=nil


self.flyTotems={}


self.fishShoals={}


self:PostWorld()

self.inst:ListenForEvent("ms_registerfishshoal",onFishShoalAdded)
end)

function CommonStore:isShadowFollowing()
return self.shadow_follower_count > 0
end


function CommonStore:CreateCoookieKing(pos)

local ent=TheSim:FindFirstEntityWithTag("aip_cookiecutter_king")
if ent~=nil and pos==nil then
return ent
end

local ocean_pos=findFarAwayOcean(pos)

if ocean_pos~=nil then
return aipSpawnPrefab(nil,"aip_cookiecutter_king",ocean_pos.x,ocean_pos.y,ocean_pos.z)
end

return nil
end


function CommonStore:FindDouTotem()
if not self.douTotem then
self.douTotem=TheSim:FindFirstEntityWithTag("aip_dou_totem_final")
end
return self.douTotem
end


function CommonStore:CreateRubik()

local ent=TheSim:FindFirstEntityWithTag("aip_rubik")
if ent~=nil then
return ent
end


local grave=TheSim:FindFirstEntityWithTag("grave")
local pos=nil
if grave~=nil then
pos=grave:GetPosition()
end

if not pos then
pos=aipGetSecretSpawnPoint(Vector3(0,0,0),0,1000)
end

pos=aipGetSecretSpawnPoint(pos,0,50,5)

local rubik=aipSpawnPrefab(nil,"aip_rubik",pos.x,pos.y,pos.z)
rubik.components.fueled:MakeEmpty()

return rubik
end

function CommonStore:CreateSuWuMound(pos)

local ent=TheSim:FindFirstEntityWithTag("aip_suwu_mound")
if ent~=nil and pos==nil then
return ent
end

local ocean_pos=findFarAwayOcean(pos)

if ocean_pos~=nil then
return aipSpawnPrefab(nil,"aip_suwu_mound",ocean_pos.x,ocean_pos.y,ocean_pos.z)
end

return nil
end

function CommonStore:PostWorld()



self.inst:DoTaskInTime(5,function()
local dou_totem=aipFindEnt(
"aip_dou_totem_broken",
"aip_dou_totem_powerless",
"aip_dou_totem",
"aip_dou_totem_cave"
)

if dou_totem==nil then

local fissurePT=aipGetTopologyPoint("lunacyarea","moon_fissure")
if fissurePT then
local tgt=aipGetSecretSpawnPoint(fissurePT,0,50,5)
aipSpawnPrefab(nil,"aip_dou_totem_broken",tgt.x,tgt.y,tgt.z)

else

local targetPrefab=aipFindRandomEnt("rabbithouse")
if targetPrefab~=nil then
local tgt=aipGetSecretSpawnPoint(targetPrefab:GetPosition(),0,50,5)
aipSpawnPrefab(nil,"aip_dou_totem_broken",tgt.x,tgt.y,tgt.z)
end
end
end
end)


self.inst:DoTaskInTime(10,function()
self:CreateCoookieKing()
end)


self.inst:DoTaskInTime(5,function()
self:CreateRubik()
end)



if dev_mode then
self.inst:DoTaskInTime(5,function()




end)
end











































end

return CommonStore









































