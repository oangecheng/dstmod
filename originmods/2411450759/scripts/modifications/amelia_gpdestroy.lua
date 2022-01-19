local function getDamageMult(inst)
    return inst.components.combat and inst.components.combat.externaldamagemultipliers:Get() * inst.components.combat.damagemultiplier
end

local function HurtTarget(self,target)
    local weapon = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    local basedamage = 5
    if weapon and weapon.components.weapon then
        -- basedamage = weapon.components.weapon.damage
        basedamage = (type(weapon.components.weapon.damage) == "function" 
            and weapon.components.weapon.damage(weapon.inst, weapon.components.inventoryitem.owner, target))
            or weapon.components.weapon.damage
    end
    if  target.components.combat then
        target.components.combat:GetAttacked(self.inst, self.groundpounddamagemult * basedamage * getDamageMult(self.inst),weapon or self.inst)
    else
        target.components.health:DoDelta(self.groundpounddamagemult * basedamage * getDamageMult(self.inst), nil,self.inst.prefab, nil, self.inst)
    end
end
local scale = 1
local WALKABLEPLATFORM_TAGS = {"walkableplatform"}
local function DestroyPoints(self,points, breakobjects, dodamage, pushplatforms)
    local getEnts = breakobjects or dodamage
    local map = TheWorld.Map
    if dodamage then
        self.inst.components.combat:EnableAreaDamage(false)
    end
    for k, v in pairs(points) do
        if getEnts then
            local ents = TheSim:FindEntities(v.x, v.y, v.z, self.gprange, nil, self.noTags)
            if #ents > 0 then
                if breakobjects then
                    for i, v2 in ipairs(ents) do
                        if v2 ~= self.inst and v2:IsValid() then
                            if self.destroyer and
                                v2.components.workable ~= nil and
                                v2.components.workable:CanBeWorked() and
                                v2.components.workable.action ~= ACTIONS.NET then
                                v2.components.workable:Destroy(self.inst)
                            end
                            if v2:IsValid() and
                                not v2:IsInLimbo() and
                                self.burner and
                                v2.components.fueled == nil and
                                v2.components.burnable ~= nil and
                                not v2.components.burnable:IsBurning() and
                                not v2:HasTag("burnt") then
                                v2.components.burnable:Ignite()
                            end
                        end
                    end
                end
                if dodamage then
                    for i, v2 in ipairs(ents) do
                        if v2 ~= self.inst and
                            --[[v2:IsValid() and]]
                            v2.components.health ~= nil and
                            not v2.components.health:IsDead() then
                            if v2 and not ( v2.components.follower 
                            and v2.components.follower.leader 
                            and v2.components.follower.leader == self.inst.entity) 
                            and TheNet:GetPVPEnabled()then
                                HurtTarget(self,v2)
                            elseif v2 and not ( v2.components.follower 
                            and v2.components.follower.leader 
                            and v2.components.follower.leader:HasTag("player"))
                            and not TheNet:GetPVPEnabled()
                            and not v2:HasTag("player") then
                                HurtTarget(self,v2)
                            end
                        end
                    end
                end
            end
        end

        if pushplatforms then
            local platform_ents = TheSim:FindEntities(v.x, v.y, v.z, self.gprange + TUNING.MAX_WALKABLE_PLATFORM_RADIUS, WALKABLEPLATFORM_TAGS, self.noTags)
            for i, p_ent in ipairs(platform_ents) do
                if p_ent ~= self.inst and p_ent:IsValid() and p_ent.Transform ~= nil and p_ent.components.boatphysics ~= nil then
                    local v2x, v2y, v2z = p_ent.Transform:GetWorldPosition()
                    local mx, mz = v2x - v.x, v2z - v.z
                    if mx ~= 0 or mz ~= 0 then
                        local normalx, normalz = VecUtil_Normalize(mx, mz)
                        p_ent.components.boatphysics:ApplyForce(normalx, normalz, 5)
                    end
                end
            end
        end

        if map:IsPassableAtPoint(v:Get()) then
            local groundpoundfx  =  SpawnPrefab(self.groundpoundfx)
            groundpoundfx.Transform:SetPosition(v.x, 0, v.z)
            groundpoundfx.Transform:SetScale(scale,scale,scale)
        end
    end
    if dodamage then
        self.inst.components.combat:EnableAreaDamage(true)
    end
end
return DestroyPoints