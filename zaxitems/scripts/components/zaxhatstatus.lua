local zaxhatstatus = Class(function(self, inst)
    self.inst = inst
    self.insulator = 0
    self.dapperness = 0
    self.waterproofer = 0
end,
nil,
{
})


function zaxhatstatus:OnSave()
    local data = {
        dapperness = self.dapperness,
        insulator = self.insulator,
        waterproofer = self.waterproofer,
    }
    return data
end

function zaxhatstatus:OnLoad(data)
    self.dapperness = data.dapperness or 0
    self.insulator = data.insulator or 0
    self.waterproofer = data.waterproofer or 0
end

return zaxhatstatus