
local function oncanuse(self, canuse)
	if canuse then
		self.inst:AddTag("canuseininv_hems")
	else
		self.inst:RemoveTag("canuseininv_hems")
	end
end

local hems_use_inventory = Class(function(self, inst)
	self.inst = inst
	self.canuse = true
	self.onusefn = nil
end,
nil,
{
	canuse = oncanuse,
}
)

function hems_use_inventory:SetOnUseFn(fn)
	self.onusefn = fn
end

function hems_use_inventory:OnUse(doer)
	if self.onusefn then
		return self.onusefn(self.inst,doer)
	end
	return true
end

return hems_use_inventory