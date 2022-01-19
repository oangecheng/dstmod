local function SayCountDownFrom(inst, num)
    local auto_respawn_line = "Respawn in："

    if TUNING.WATAME_LANGUAGE == "JP" then  -- TODO This condition seems not working
        auto_respawn_line = "リスポーンまで後："  
    elseif TUNING.WATAME_LANGUAGE == "CN" then
        auto_respawn_line = "自動重生還需："  -- Waiting for CN translation
    end

    if inst
    and inst.components.talker
    and num > 0
    then
        for i = 0, num do
            inst:DoTaskInTime(i, function()
                inst.components.talker:Say(auto_respawn_line..tostring(num-i))
            end)
        end
    end
end

local function SetAutoRespawn(inst)

    --開場擁有8秒重新技能
    -- inst.spawnskill = true
    if inst.deathcounts == nil then
      inst.deathcounts = 1
    end

    inst:ListenForEvent("death", function(inst, data)
        inst.deathcounts = inst.deathcounts - 1
    end)

    --8秒重生(並且下一次死亡必須以正常方式復活才能再度獲得8秒重生)
    inst:ListenForEvent("ms_becameghost", function(inst, data)
        if inst.deathcounts <= 0 and TUNING.ENABLE_WATAME_AUTO_RESPAWN == true then
            SayCountDownFrom(inst, TUNING.WATAME_AUTO_RESPAWN_DELAY)
            inst:DoTaskInTime(TUNING.WATAME_AUTO_RESPAWN_DELAY, function()
                if inst:HasTag("playerghost") then
                    inst:PushEvent("respawnfromghost")
                    inst.components.health:DeltaPenalty(TUNING.REVIVE_HEALTH_PENALTY)
                    inst.deathcounts = TUNING.WATAME_AUTO_RESPAWN_FREQUENCY
                end
            end)
        end
    end)
end

return SetAutoRespawn