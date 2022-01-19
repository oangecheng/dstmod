local FRAMES = GLOBAL.FRAMES
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

local function WatameStates(sg,client)

    local hit = sg.states["hit"]  -- hit state is only on server version of states (none in client version)
    if hit and not client then
        local old_hit_onenter = hit.onenter
        hit.onenter = function(inst, frozen)
            if inst:HasTag("watame_shogun_kabuto") then

                if frozen == "noimpactsound" then
                    frozen = nil
                else
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                end
                -- DoHurtSound(inst)

                local stun_frames = 0
                if inst.components.playercontroller ~= nil then
                    --Specify min frames of pause since "busy" tag may be
                    --removed too fast for our network update interval.
                    inst.components.playercontroller:RemotePausePrediction(stun_frames <= 7 and stun_frames or nil)
                end
                inst.sg:SetTimeout(stun_frames * FRAMES)
            else
                old_hit_onenter(inst, frozen)
            end
        end
    end
end

-- Server
AddStategraphPostInit("wilson", function(sg)
    WatameStates(sg,false)    
end)