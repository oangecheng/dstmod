
local mypopup = Class(function(self, inst)
    self.inst = inst
	self.warned = true
end)


function mypopup:OnSave()
    return
    {
        warned = self.warned,
    }
end

function mypopup:OnLoad(data)

	self.warned = data.warned

end

return mypopup