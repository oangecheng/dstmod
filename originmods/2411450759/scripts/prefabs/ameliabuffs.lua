-------------------------------------------------------------------------
---------------------- Attach and dettach functions ---------------------
-------------------------------------------------------------------------

local buff_fx_inteval = 0.7
local debuff_fx_inteval = 2
local offset = 3.5
local scale = 1.5
local function select_random_buff_debuff_pair()
    local buff_name_table = {
        "atk_buff",
        "def_buff",
        "ms_buff",
        "hp_regen_buff",
        "san_regen_buff",
    }

    local debuff_name_table = {
        "sweat_debuff",
        "stomachache_debuff",
    }

    local buff_name = buff_name_table[math.random(#buff_name_table)]

    if buff_name ~= "hp_regen_buff" then
        table.insert(debuff_name_table, "poison_debuff")
    end
    if buff_name ~= "san_regen_buff" then
        table.insert(debuff_name_table, "mind_split_debuff")
    end
    if buff_name ~= "ms_buff" then
        table.insert(debuff_name_table, "drowsy_debuff")
    end

    local debuff_name = debuff_name_table[math.random(#debuff_name_table)]

    return buff_name, debuff_name
end

local function stomach_ache(user)
    if user.components.health ~= nil then
        user.components.health:DoDelta(-TUNING.WATSON_CONCOCTION_STOMACHACHE_ON_EAT_DAMAGE, 1)
    end
end

local function watson_concoction_buff_attach(inst, user)

    user:AddTag("under_conc_effect")

    if user.SoundEmitter ~= nil then
        user.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_sleep")
    end

    local buff_name, debuff_name = select_random_buff_debuff_pair()

    -- ! BuffS
    if buff_name == "atk_buff" then
        if user.components.combat ~= nil then
            user.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.WATSON_CONCOCTION_ATTACK_MULTIPLIER, "watson_concoction_dmg_mod")

            user.concAtkBuffFxTask = user:DoPeriodicTask(buff_fx_inteval, function()
                local buff_fx = SpawnPrefab("conc_atk_buff_fx")
                buff_fx.entity:SetParent(user.entity)
                buff_fx.Transform:SetPosition(0,offset,0)
                buff_fx.Transform:SetScale(scale,scale,scale)

                user:DoTaskInTime(debuff_fx_inteval, function()
                    buff_fx:Remove()
                end)
            end)
        end
    elseif buff_name == "def_buff" then
        if user.components.health ~= nil then
            user.components.health.externalabsorbmodifiers:SetModifier(inst, TUNING.WATSON_CONCOCTION_ABSORPTION_MODIFIER, "watson_concoction_absorb_mod")

            user.concDefBuffFxTask = user:DoPeriodicTask(buff_fx_inteval, function()
                local buff_fx = SpawnPrefab("conc_def_buff_fx")
                buff_fx.entity:SetParent(user.entity)
                buff_fx.Transform:SetPosition(0,offset,0)
                buff_fx.Transform:SetScale(scale,scale,scale)

                user:DoTaskInTime(debuff_fx_inteval, function()
                    buff_fx:Remove()
                end)
            end)
        end
    elseif buff_name == "ms_buff" then
        if user.components.locomotor ~= nil then
            user.components.locomotor:SetExternalSpeedMultiplier(inst, 'watson_concoction_speed_mod', TUNING.WATSON_CONCOCTION_MS_BUFF)

            user.concMvSpdBuffFxTask = user:DoPeriodicTask(buff_fx_inteval, function()
                local buff_fx = SpawnPrefab("conc_mvspd_buff_fx")
                buff_fx.entity:SetParent(user.entity)
                buff_fx.Transform:SetPosition(0,offset,0)
                buff_fx.Transform:SetScale(scale,scale,scale)

                user:DoTaskInTime(debuff_fx_inteval, function()
                    buff_fx:Remove()
                end)
            end)
        end
    elseif buff_name == "hp_regen_buff" then
        if user.components.health ~= nil then
            user.concHpRegenTask = user:DoPeriodicTask(1, function()
                user.components.health:DoDelta(TUNING.WATSON_CONCOCTION_HEALTH_REGEN_AMOUNT/TUNING.WATSON_CONCOCTION_DURATION, 1)
            end)

            user.concHpRegenFxTask = user:DoPeriodicTask(buff_fx_inteval, function()
                local buff_fx = SpawnPrefab("conc_hp_regen_fx")
                buff_fx.entity:SetParent(user.entity)
                buff_fx.Transform:SetPosition(0,offset,0)
                buff_fx.Transform:SetScale(scale,scale,scale)

                user:DoTaskInTime(debuff_fx_inteval, function()
                    buff_fx:Remove()
                end)
            end)
        end
    elseif buff_name == "san_regen_buff" then
        if user.components.sanity ~= nil then
            user.concSanRegenTask = user:DoPeriodicTask(1, function()
                user.components.sanity:DoDelta(TUNING.WATSON_CONCOCTION_SANITY_REGEN_AMOUNT/TUNING.WATSON_CONCOCTION_DURATION, 1)
            end)

            user.concSanRegenFxTask = user:DoPeriodicTask(buff_fx_inteval, function()
                local buff_fx = SpawnPrefab("conc_san_regen_fx")
                buff_fx.entity:SetParent(user.entity)
                buff_fx.Transform:SetPosition(0,offset,0)
                buff_fx.Transform:SetScale(scale,scale,scale)

                user:DoTaskInTime(debuff_fx_inteval, function()
                    buff_fx:Remove()
                end)
            end)
        end
    end

    -- ! Debuffs
    if debuff_name == "poison_debuff" then

        user:AddTag("poison_debuff")

        if user.components.health ~= nil and user.AnimState ~= nil then
            user.concPoisonTask = user:DoPeriodicTask(1, function()
                user.components.health:DoDelta(-TUNING.WATSON_CONCOCTION_TOTAL_POISON_DPS, 1)
            end)

            local ori_r, ori_g, ori_b = user.AnimState:GetMultColour()
            local poison_r, poison_g, poison_b = 57/255,133/255,120/255
            
            local poison_init_fx = SpawnPrefab("conc_poison_drip_fx")
            poison_init_fx.entity:SetParent(user.entity)
            poison_init_fx.Transform:SetPosition(0,2,0)

            user:DoTaskInTime(debuff_fx_inteval, function()
                poison_init_fx:Remove()
            end)

            user.concPoisonFxTask = user:DoPeriodicTask(debuff_fx_inteval, function()
                local poison_part_fx = SpawnPrefab("conc_poison_particle_fx")
                poison_part_fx.entity:SetParent(user.entity)

                user:DoTaskInTime(debuff_fx_inteval, function()
                    poison_part_fx:Remove()
                end)
            end)

            user.concPoisonColourTask = user:DoPeriodicTask(1, function()
                user.AnimState:SetMultColour(poison_r, poison_g, poison_b, 1)
                user:DoTaskInTime(0.3, function() 
                    user.AnimState:SetMultColour(ori_r, ori_g, ori_b, 1) 
                end)
            end)

            user:DoTaskInTime(TUNING.WATSON_CONCOCTION_DURATION, function()
                user.AnimState:SetMultColour(ori_r, ori_g, ori_b, 1)
            end)
        end

    elseif debuff_name == "mind_split_debuff" then
        if user.components.sanity ~= nil then
            user.components.sanity:DoDelta(-TUNING.WATSON_CONCOCTION_HEADACHE_SANITY_DAMAGE)
            user:AddTag("mind_split_debuff")
        end
    elseif debuff_name == "sweat_debuff" then
        if user.components.moisture ~= nil then
            user:AddTag("conc_sweat_debuff")
            user.sg:GoToState("funnyidle")
            user.concSweatTask = user:DoPeriodicTask(1, function()
                user.components.moisture:DoDelta(TUNING.WATSON_CONCOCTION_SWEAT_MOISTURE_PER_SEC, 1)
            end)
            
            user.concSweatFxTask = user:DoPeriodicTask(debuff_fx_inteval, function()
                local sweat_fx = SpawnPrefab("conc_sweat_fx")
                sweat_fx.entity:SetParent(user.entity)
                sweat_fx.Transform:SetPosition(0,2,0)

                user:DoTaskInTime(debuff_fx_inteval, function()
                    sweat_fx:Remove()
                end)
            end)
        end
    elseif debuff_name == "stomachache_debuff" then
        if user.components.hunger ~= nil then
            user.components.hunger:DoDelta(-TUNING.WATSON_CONCOCTION_STOMACHACHE_HUNGER_DAMAGE, 1)
            user:AddTag("stomachache_debuff")
            user.AnimState:PlayAnimation("hungry")
            user.SoundEmitter:PlaySound("dontstarve/wilson/hungry")

            user:ListenForEvent("oneat", stomach_ache)
        end
    elseif debuff_name == "drowsy_debuff" then
        user:AddTag("drowsy_debuff")
        if TUNING.WATSON_CONCOCTION_DROWSINESS_ENABLE then
            if user.components.grogginess ~= nil then
                user.components.grogginess:AddGrogginess(2, 0)
            end

            -- Reapply grogginess
            user.concSleepyTask = user:DoPeriodicTask(7, function()  -- ! The perfect time for reapply should be 7 seconds
                user.components.grogginess:AddGrogginess(2, 0)
            end)
        end
    end
end

local function watson_concoction_buff_detach_all(inst, user)

    user:RemoveTag("under_conc_effect")
    user:AddTag("remove_cc")
    user:RemoveTag("poison_debuff")
    user:RemoveTag("mind_split_debuff")
    user:RemoveTag("conc_sweat_debuff")
    user:RemoveTag("stomachache_debuff")
    user:RemoveTag("drowsy_debuff")

    user.AnimState:SetAddColour(0, 0, 0, 1)

    -- ! Health related
    if user.components.health ~= nil then
        user.components.health.externalabsorbmodifiers:RemoveModifier(inst, "watson_concoction_absorb_mod")

        if user.concDefBuffFxTask ~= nil then
            user.concDefBuffFxTask:Cancel()
        end

        if user.concHpRegenTask ~= nil then
            user.concHpRegenTask:Cancel()
        end
        if user.concHpRegenFxTask ~= nil then
            user.concHpRegenFxTask:Cancel()
        end
        
        if user.concPoisonTask ~= nil then
            user.concPoisonTask:Cancel()
        end
        if user.concPoisonFxTask ~= nil then
            user.concPoisonFxTask:Cancel()
        end
        if user.concPoisonColourTask ~= nil then
            user.concPoisonColourTask:Cancel()
        end
    end

    -- ! Hunger related
    if user.components.hunger ~= nil then
        user:RemoveEventCallback("oneat", stomach_ache)
    end
    
    -- ! Sanity related
    if user.components.sanity ~= nil then
        if user.concSanRegenTask ~= nil then
            user.concSanRegenTask:Cancel()
        end
        if user.concSanRegenFxTask ~= nil then
            user.concSanRegenFxTask:Cancel()
        end
    end

    -- ! Moisture related
    if user.components.moisture ~= nil then
        if user.concSweatTask ~= nil then
            user.concSweatTask:Cancel()
        end
        if user.concSweatFxTask ~= nil then
            user.concSweatFxTask:Cancel()
        end
        user:RemoveTag("conc_sweat_debuff")
    end
    
    -- ! Other Components related
    if user.components.combat ~= nil then
        user.components.combat.externaldamagemultipliers:RemoveModifier(inst, "watson_concoction_dmg_mod")

        if user.concAtkBuffFxTask ~= nil then
            user.concAtkBuffFxTask:Cancel()
        end
    end
    
    if user.components.locomotor ~= nil then
        user.components.locomotor:RemoveExternalSpeedMultiplier(inst, 'watson_concoction_speed_mod')
        
        if user.concMvSpdBuffFxTask ~= nil then
            user.concMvSpdBuffFxTask:Cancel()
        end
    end

    if user.concSleepyTask ~= nil then
        user.concSleepyTask:Cancel()
    end
    if user.components.grogginess ~= nil then
        user.components.grogginess:ResetGrogginess()
    end
end
-------------------------------------------------------------------------
----------------------- Prefab building functions -----------------------
-------------------------------------------------------------------------

local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
    end
end

local function MakeBuff(name, onattachedfn, onextendedfn, ondetachedfn, duration, priority, prefabs) -- prefabs is table of special effect (fx) names
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)

        target:PushEvent("ameliabuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onattachedfn ~= nil then
            onattachedfn(inst, target)
        end
    end

    local function OnExtended(inst, target)
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", duration)

        target:PushEvent("ameliabuffattached", { buff = "ANNOUNCE_ATTACH_BUFF_"..string.upper(name), priority = priority })
        if onextendedfn ~= nil then
            onextendedfn(inst, target)
        end
    end

    local function OnDetached(inst, target)
        if ondetachedfn ~= nil then
            ondetachedfn(inst, target)
        end

        target:PushEvent("ameliabuffdetached", { buff = "ANNOUNCE_DETACH_BUFF_"..string.upper(name), priority = priority })
        inst:Remove()
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)
            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", duration)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab("buff_"..name, fn, nil, prefabs)
end

return MakeBuff("watsonconcoctioneffect", watson_concoction_buff_attach, nil, watson_concoction_buff_detach_all, TUNING.WATSON_CONCOCTION_DURATION, 1)