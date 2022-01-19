local function AmeliaInvincibility(inst)
    inst._gp_invincible = net_bool(inst.GUID,"amelia._gp_invincible","_gp_invincible_dirty")

    -- Toggle Invincibility
    inst:ListenForEvent("_gp_invincible_dirty", function (inst)
        if inst.components.health then
            if inst._gp_invincible:value() then
                inst.components.combat.externaldamagetakenmultipliers:SetModifier(inst, 0,"amemor")

                if inst.components.inventory then
                    local chest_armor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
                    local head_armor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                    inst.invul_chest_armor = false
                    inst.invul_head_armor = false
                    if chest_armor and chest_armor.components.armor and not chest_armor.components.armor.indestructible then
                        chest_armor.components.armor.indestructible = true
                    elseif chest_armor and chest_armor.components.armor and chest_armor.components.armor.indestructible then
                        inst.invul_chest_armor = true
                    end
                    if head_armor and head_armor.components.armor and not head_armor.components.armor.indestructible then
                        head_armor.components.armor.indestructible = true
                    elseif head_armor and head_armor.components.armor and head_armor.components.armor.indestructible then
                        inst.invul_head_armor = true
                    end
                end
            else
                inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst,"amemor")

                if  inst.components.inventory then
                    local chest_armor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
                    local head_armor = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                    if chest_armor and chest_armor.components.armor and not inst.invul_chest_armor then
                        chest_armor.components.armor.indestructible = false
                    end
                    if head_armor and head_armor.components.armor and not inst.invul_head_armor then
                        head_armor.components.armor.indestructible = false
                    end
                end
            end
        end
    end)
end

return AmeliaInvincibility