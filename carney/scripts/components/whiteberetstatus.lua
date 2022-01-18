local whiteberetstatus = Class(function(self, inst)
    self.inst = inst
    self.insulator = 0
    self.dapperness = 0
end,
nil,
{
})


function whiteberetstatus:OnSave()
    local data = {
        dapperness = self.dapperness,
        insulator = self.insulator,
    }
    return data
end

function whiteberetstatus:OnLoad(data)
    self.dapperness = data.dapperness or 0
    self.insulator = data.insulator or 0
end

return whiteberetstatus