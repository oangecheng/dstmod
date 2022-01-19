local function ConcoctionHeal(self, target)
    if not target:HasTag("under_conc_effect") then
        if not (target.components.rider and target.components.rider:IsRiding()) then
            if target.components.health ~= nil then
                target.components.health:DoDelta(self.health, false, self.inst.prefab)
                if self.onhealfn ~= nil then
                    self.onhealfn(self.inst, target)
                end
                if self.inst.components.stackable ~= nil and self.inst.components.stackable:IsStack() then
                    self.inst.components.stackable:Get():Remove()
                else
                    self.inst:Remove()
                end
                return true
            end
        else
            return false
        end
    else
        return false
    end
end

return ConcoctionHeal