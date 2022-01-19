
-- Allow Ancient FuelWeaver spawn, code by Ptr & Hekkaryk
local G = GLOBAL
if G.TheNet:GetIsServer() then
    local ATRIUM_RANGE = 8.5
    
    local function ActiveStargate(gate)
        return gate:IsWaitingForStalker()
    end
    
    local function IsNearAtrium(inst, other)
        local stargate = inst.components.entitytracker:GetEntity("stargate")
        return stargate ~= nil and stargate:HasTag("intense")
    end
    
    AddPrefabPostInit("fossil_stalker", function(inst)
        local function ItemTradeTest(inst, item, giver)
            if item == nil or item.prefab ~= "shadowheart" or giver == nil or giver.components.areaaware == nil then
                return false
            elseif inst.form ~= 1 then
                return false, "WRONGSHADOWFORM"
            elseif giver.components.areaaware:CurrentlyInTag("Atrium") and (G.FindEntity(inst, ATRIUM_RANGE, ActiveStargate, {"stargate"}) == nil or G.GetClosestInstWithTag("stalker", inst, 40) ~= nil) then
                return false, "CANTSHADOWREVIVE"
            end
            return true
        end
        
        local function OnAccept(inst, giver, item)
            if item.prefab == "shadowheart" then
                local stalker
                local stargate = G.FindEntity(inst, ATRIUM_RANGE, ActiveStargate, {"stargate"})
                if stargate ~= nil then
                    stalker = G.SpawnPrefab("stalker_atrium")
                    stalker.components.entitytracker:TrackEntity("stargate", stargate)
                    stargate:TrackStalker(stalker)
                else
                    stalker = G.SpawnPrefab("stalker")
                end
                local x, y, z = inst.Transform:GetWorldPosition()
                local rot = inst.Transform:GetRotation()
                inst:Remove()
                
                stalker.Transform:SetPosition(x, y, z)
                stalker.Transform:SetRotation(rot)
                stalker.sg:GoToState("resurrect")
                
                giver.components.sanity:DoDelta(TUNING.REVIVE_SHADOW_SANITY_PENALTY)
            end
        end
        inst.components.trader.onaccept = OnAccept
        inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    end)
end
