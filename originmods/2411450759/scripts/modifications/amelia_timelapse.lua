-- local EventHandler = GLOBAL.EventHandler
-- local FRAMES = GLOBAL.FRAMES
-- local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

-- Dialogues to pick randomly when Amelia uses timeleap
local timeleap_dialogues = {
    "I'm zooming!", 
    "YAW YAW YAW YAW!",
    "REEEEEEEEEEEEEEE!!",
    "Watch this!",
    "See ya."
}

local function SpawnChildFx(inst,prefab)
    local fx = SpawnPrefab(prefab)
    inst:AddChild(fx)
 end

local function TimeLapse(inst)
    local timelapse_duration = 15 * FRAMES

    if inst.components.inventoryitem then
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner.components.ameliahistory then
            if owner.components.ameliahistory and owner.components.ameliahistory:IsOnCooldown() then
                owner.components.talker:Say("I can't use my watch yet")
            -- elseif not (owner.components.sanity.current >= TUNING.AMELIA_WATCH_SANITY_COST) then
            --     owner.components.talker:Say("I'm going insane if I use it now")
            elseif owner.components.rider and  owner.components.rider:IsRiding() then
                owner.components.talker:Say("Better not use this while riding.")
            else
                inst:DoTaskInTime(0,function ()
                    owner.components.talker:Say(timeleap_dialogues[math.random(#timeleap_dialogues)])
                    owner.AnimState:PlayAnimation("action_uniqueitem_pre")
                    owner.AnimState:PushAnimation("pocket_scale_weigh", false)
                    owner.AnimState:OverrideSymbol("swap_pocket_scale_body", "amelia_watch", "pocket_scale_body")
                    owner.AnimState:Hide("ARM_carry")
                    owner.AnimState:Show("ARM_normal")
                end)
                inst:DoTaskInTime(timelapse_duration,function ()
                    SpawnChildFx(owner,"electricchargedfx")
                    SpawnChildFx(owner,"sleepbomb_burst")
                    SpawnChildFx(owner,"mastupgrade_lightningrod_fx")

                    owner.SoundEmitter:PlaySound("dontstarve/common/staffteleport")

                    -- if owner.components.sanity ~= nil then
                    --     owner.components.sanity:DoDelta(-TUNING.AMELIA_WATCH_SANITY_COST)
                    -- end
                    
                    local past_char_pos = owner.components.ameliahistory:GetOldestPos()
                    local past_health_percent = owner.components.ameliahistory:GetOldestHealthPercent()
                    local past_hunger_percent = owner.components.ameliahistory:GetOldestHungerPercent()
                    local past_sanity_percent = owner.components.ameliahistory:GetOldestSanityPercent()
                    
                    if owner.components.health ~= nil and owner.components.health:IsDead() ~= true then
                        if owner.components.health ~= nil then
                            owner.components.health:SetPercent(past_health_percent)
                        end
                        if owner.components.hunger ~= nil then
                            owner.components.hunger:SetPercent(past_hunger_percent)
                        end
                        if owner.components.sanity ~= nil then
                            owner.components.sanity:SetPercent(past_sanity_percent)
                        end
                        
                        owner.Transform:SetPosition(past_char_pos.x,past_char_pos.y,past_char_pos.z)
                        owner.components.ameliahistory:ClearHistory()
                    end

                    if owner.components.inventory then
                        if owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                            owner.AnimState:Show("ARM_carry")
                            owner.AnimState:Hide("ARM_normal")
                            -- if inst.components.finiteuses.current == 0 then
                            --     inst:Remove()
                            -- end
                        end
                    end
                end)
                inst:DoTaskInTime(30 * FRAMES, function ()
                    owner.AnimState:PlayAnimation("action_uniqueitem_pre")
                    if inst.components.finiteuses then
                        inst.components.finiteuses:Use(1)
                    end
                end)
            end
        end
    end
end
return TimeLapse