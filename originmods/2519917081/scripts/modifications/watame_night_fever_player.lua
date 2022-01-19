local IsDancing = require "modifications.watame_check_dancing"

function GetCurrentAnimation(inst)  -- ! Use with print to debugging current animation, inst --> character's inst
    return string.match(inst.entity:GetDebugString(), "anim: ([^ ]+) ")
end

local function CheckCurrentAnim(inst)
    inst:DoPeriodicTask(1, function(inst) 

        if IsDancing(inst) and TheWorld.state.iscavenight then --and not TheWorld.state.iscaveday and not TheWorld.state.iscavedusk and TheWorld.state.isnight then --0713 Staly's edit add other if
            TheWorld:PushEvent("enabledynamicmusic", false)
            if inst.SoundEmitter then
                inst.SoundEmitter:PlaySound("watame_sounds/watame/watame_night_fever_loop", "wnf_loop") 
            end
            if inst.my_dance_floor == nil then
                inst.my_dance_floor = SpawnPrefab("watame_discofloor")
                if inst.my_dance_floor ~= nil then
                    inst.my_dance_floor.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end
            inst.components.skinner:SetSkinMode("wnf_skin")
        else
            TheWorld:PushEvent("enabledynamicmusic", true)
            if inst.SoundEmitter then
                inst.SoundEmitter:KillSound("wnf_loop")
            end
            if inst.my_dance_floor then
                inst.my_dance_floor:RemoveFloor()
                inst.my_dance_floor = nil
                inst.components.skinner:SetSkinMode("normal_skin")
            end
            --inst.components.skinner:SetSkinMode("normal_skin")
        end
    end)
end

return CheckCurrentAnim