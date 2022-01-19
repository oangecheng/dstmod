

local hems_container = Class(function(self, inst)
    self.inst = inst
    self.chester = nil
	self.inst:DoTaskInTime(0.2,function()
		self:SpawnChester()
	end)
end)

local function SetChester(self, chester)
	self.chester = chester
	chester.persists = false
	chester.Transform:SetPosition(0,0,0)
	--chester.entity:SetParent(self.inst.entity)
end


function hems_container:SpawnChester()
	if self.chester == nil then
		local chester = SpawnPrefab("hems_lxkd_container")
        SetChester(self, chester)
	end
end

function hems_container:HasChester()
	return self.chester ~= nil 
end

function hems_container:GetChester()
	return self.chester
end

function hems_container:OpenChester(doer)
	if self.chester ~= nil and self.chester.components.container then
		self.chester.Transform:SetPosition(doer.Transform:GetWorldPosition())
		if self.chester.components.container:IsOpenedBy(doer) then
			self.chester.components.container:Close(doer)
		else
			self.chester.components.container:Open(doer)
		end
	end
end

function hems_container:OnSave()
	if self.chester ~= nil then
		return { pack = self.chester:GetSaveRecord()}
	end
end

function hems_container:OnLoad(data)
    if data ~= nil and data.pack ~= nil then
		local chester = SpawnSaveRecord(data.pack)
		SetChester(self, chester)
	end
end

return hems_container
