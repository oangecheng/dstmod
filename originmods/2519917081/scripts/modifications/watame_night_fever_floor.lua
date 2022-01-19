local IsDancing = require "modifications.watame_check_dancing"

--0712 Staly's edit (跳舞時周圍角色包含自己持續回復HP)
--0718  CoolChilli's edit (Check both Watame and other players, move code to dance floor itself instead of Watame)
local function CheckPlayerOnDanceFloor(inst)
    inst:DoPeriodicTask(5, function() 
        local x, y, z = inst.Transform:GetWorldPosition()--獲得位置
        local ents = TheSim:FindEntities(x, y, z, 15)  -- TODO: Set radius to appropriate size of dance floor
        for k,v in pairs(ents) do
            if v:HasTag("player") 
            and v.components.health
            and not v.components.health:IsDead()
            and v.components.hunger
            -- and v.components.sanity
            -- and (TheNet:GetPVPEnabled() or v:HasTag("player")) -- TODO: Not need this maybe?
            then
                if IsDancing(v) then 
                    v.components.health:DoDelta(10)
                    v.components.hunger:DoDelta(-5)
                    -- v.components.sanity:DoDelta(3)
                else
                    v.components.health:DoDelta(5)
                    -- v.components.sanity:DoDelta(2)
                end
            end
        end
    end)
end

--0713 Staly's edit
-- CheckPlayerOnDanceFloor(inst) -- TODO: Move to watame_discofloor.lua then attach it to floor every 3 seconds instead

return CheckPlayerOnDanceFloor